
---@diagnostic disable : lowercase-global


---@alias Luva.Lang.PrototypeBuilder table<Luva.Lang.Identifier, any>

do
    ---@class Luva.Lang.ClassPrototype
    ---@field public PrototypeMetatable Luva.Lang.PseudoMetatable
    -- ---@field public Readonlys table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field public Fields table<Luva.Lang.Identifier, Luva.Lang.Field<any>>
    ---@field public Methods table<Luva.Lang.Identifier, function>
    ---@field public Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>
    local __prototype
end

-- local ERR_NO_FIELD_FOUND_PROTOTYPE = "Haven't found a field corresponding to GetByIdentifier's argument"



---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
---@param prototypeBuilder Luva.Lang.PrototypeBuilder
function _LUVA._SetupPrototype(resultClass, prototypeBuilder)

    rawset(resultClass, "__Prototype", {
        PrototypeMetatable = { },
        -- Readonlys = { },
        Fields = { },
        Methods = {
            Equals = function (self, v)
                if
                    type (v) ~= "table"
                    or not v.__Type
                    or self.__Type ~= v.__Type  ---@diagnostic disable-line : invisible
                then
                    return false
                end

                return _LUVA.Utils.IsSameByValue(self, v, true)
            end,

            ToString = function (self)
                local result = "Luva.Object {"

                _LUVA.Utils.Entries(self, function (index, value)
                    if kindof (value) == "field" then
                        result = result .. "\n\t" .. tostring(index) .. ":\t" .. tostring(value.Value)
                    else
                        result = result .. "\n\t" .. tostring(index) .. ":\t" .. tostring(value)
                    end
                end)

                result = result .. "\n}"

                return result
            end,

            Extends = function (self, t)
                -- All Luva Objects do inherit Luva.Object
                if t == Luva.Object then
                    return true
                end

                ---@type Luva.Type
                local temp = self.__Type.__Extends  ---@diagnostic disable-line : invisible

                while temp ~= Luva.Object do
                    if temp == t then -- found - the type is inheriting `t`
                        return true
                    end

                    -- dig deeper
                    temp = temp.__Extends   ---@diagnostic disable-line : invisible
                end

                -- At Luva.Object, there is nothing to dig deeper
                return false
            end,

            -- Implements = function (self, i)
            --     ---@type Luva.Type
            --     local t = self.__Type   ---@diagnostic disable-line : invisible

            --     return _LUVA.Utils.Has(t.__Implements, i)   ---@diagnostic disable-line : invisible
            -- end,

        },
        Accessors = { },
    } --[[@as Luva.Lang.ClassPrototype]])

    local prototype = resultClass.__Prototype   ---@diagnostic disable-line : invisible
    prototype.PrototypeMetatable = _LUVA.Utils.Copy(_LUVA.SecuredObject.Metatables.InstanceBase)

    for identifier, content in pairs(prototypeBuilder) do
        ---@cast prototype -nil
        switch (type (content), {
            ["table"] = function ()
                ---@cast content table
                local subKind = subkindof (content)

                switch (subKind, {
                    ["accessor"] = function ()
                        ---@cast content Luva.Lang.Accessor<Luva.Object, any>
                        prototype.Accessors[identifier] = content
                    end,

                    ["readonly"] = function ()
                        ---@cast content Luva.Lang.Field
                        -- prototype.Readonlys[identifier] = content
                        prototype.Fields[identifier] = content
                    end,

                    ["ref"] = function ()
                        ---@cast content Luva.Lang.Field
                        prototype.Fields[identifier] = content
                    end,

                    ["maybe"] = function ()
                        ---@cast content Luva.Lang.Field
                        prototype.Fields[identifier] = content
                    end,

                    ["const"] = function ()
                        error ("Constants should be defined as static or use 'maybe'!")
                    end,

                    -- Reference to the type or just a table
                    default = function ()
                        local isLuvaType = kindof (content) == "luva_type"
                        ---@type (Luva.Type|type), (any)
                        local _t, _v

                        if isLuvaType then
                            ---@cast content Luva.Type
                            _t = content
                            _v = nil
                        else
                            ---@cast content type
                            _t = "table"
                            _v = content
                        end

                        prototype.Fields[identifier] = {
                            __Kind = "field",
                            Type     = _t,
                            Value    = _v
                        } --[[@as Luva.Lang.Field]]
                    end
                })

            end,

            ["function"] = function ()
                ---@cast content function
                prototype.Methods[identifier] = content
            end,

            default = function ()
                -- scalar type or value
                prototype.Fields[identifier] = _LUVA._ParseField(content)
            end

        } --[[@as Luva.Lang.MatchingBaseBuilder<type, fun()>]])
    end
end