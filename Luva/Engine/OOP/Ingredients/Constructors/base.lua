

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassConstructors
    ---@field public DefaultCaller fun(self: TInstance)
    ---@field public DefaultConstructor fun(_class: Luva.Type): TInstance
    ---@field public CustomConstructor nil|fun(_class: Luva.Type, ...: any[]): TInstance
    local __constructors
end


---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
function _LUVA._SetupConstructorBase(resultClass)
    rawset(resultClass, "__Constructors", {
        DefaultConstructor = nil, ---@diagnostic disable-line : assign-type-mismatch
        DefaultCaller = nil,    ---@diagnostic disable-line : assign-type-mismatch
        CustomConstructor = nil
    } --[[@as Luva.Lang.ClassConstructors]])
end


---@param _class Luva.Type
---@param ... any[]
---@return Luva.Object
---@nodiscard
function _LUVA._GeneralConstructor(_class, ...)

    ---@type Luva.Object
    local instance = { }    ---@diagnostic disable-line : missing-fields

    local proto = _class.__Prototype --[[@as Luva.Lang.ClassPrototype]] ---@diagnostic disable-line : invisible


    _LUVA.SecuredObject.Secure(instance, "InstanceBase", proto.PrototypeMetatable)

    _LUVA.Utils.SafeInjectRef(instance.__Methods, { ---@diagnostic disable-line : invisible
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
                result = result .. "\n\t" .. tostring(index) .. ":\t" .. tostring(value)
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

        Implements = function (self, i)
            ---@type Luva.Type
            local t = self.__Type   ---@diagnostic disable-line : invisible

            return _LUVA.Utils.Has(t.__Implements, i)   ---@diagnostic disable-line : invisible
        end,
    })

    _LUVA.Utils.SafeInjectRef(instance.__Constants, {   ---@diagnostic disable-line : invisible
        __Type = _class
    })

    local propNameToTypeName = {
        __Fields = "Fields",
        __Constants = "Readonlys",
        __Methods = "Methods",
        __Accessors = "Accessors"
    }

    for propName, propTypeName in pairs (propNameToTypeName) do
        for identifier, content in pairs(proto[propTypeName]) do
            instance[propName][identifier] = content
        end
    end

    return instance
end