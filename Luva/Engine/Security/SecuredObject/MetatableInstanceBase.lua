
import "Luva.Engine.Security.SecuredObject.securedGetSet"    ---@diagnostic disable-line : assign-type-mismatch # Intelisense not working

_LUVA.Errors.TRIED_TO_CALL_OBJECT = "Tried to call object. Override the operator in it's type or ensure that you have used multi-setter correctly"

---@type metatable
_LUVA.SecuredObject.Metatables.InstanceBase = {
    ---@param self Luva.Object
    ---@param index Luva.Dynamic
    ---@return any
    __index = function (self, index)
        return _LUVA._secureGet(self, index)
    end,

    ---@param self Luva.Object
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _LUVA._secureSet(self, index, value)
    end,

    ---@param self Luva.Object
    ---@return string
    ---@nodiscard
    __tostring = function (self)
        return self:ToString()
    end,

    ---@param self Luva.Object
    ---@param ... table|any[]
    ---@return Luva.Object|any ...
    __call = function (self, ...)
        local userDefined = self.__Type.__Prototype.PrototypeMetatable._index   ---@diagnostic disable-line : invisible
        if userDefined then
            return userDefined(self, ...)
        end

        local argCount = select("#", ...)
        local argFirst = ( select(1, ...) )
        if argCount ~= 1 or type (argFirst) ~= "table" then
            error(_LUVA.Errors.TRIED_TO_CALL_OBJECT, 3)
        end

        for fieldName, fieldContent in pairs(argFirst) do
            self[fieldName] = fieldContent
        end

        return self
    end,

    ---@version >5.1 On version 5.1, it just won't work
    ---@param self Luva.Object
    __gc = function (self)
        self.__Type.__Destructor(self)  ---@diagnostic disable-line : invisible
    end
}