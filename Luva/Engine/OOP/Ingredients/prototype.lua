
---@diagnostic disable : lowercase-global

import "Luva.Engine.kind"
import "Luva.Engine.matching_expr"
import "Luva.Engine.OOP.Ingredients.field"

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
        Methods = { },
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
                        ---@type (Luva.Type|string), (any)
                        local _t, _v

                        if isLuvaType then
                            ---@cast content Luva.Type
                            _t = content
                            _v = nil
                        else
                            switch (content, {
                                [string] = function ()
                                    _t = "string"
                                    _v = nil
                                end,

                                [table] = function ()
                                    _t = "table"
                                    _v = nil
                                end,

                                default = function ()
                                    _t = "table"
                                    _v = content
                                end
                            })
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