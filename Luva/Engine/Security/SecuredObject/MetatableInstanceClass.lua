

import "Luva.Engine.Security.SecuredObject.securedGetSet"


---@type metatable
_LUVA.SecuredObject.Metatables.InstanceClass = {
    ---@param self Luva.Type
    ---@param index Luva.Dynamic
    __index = function (self, index)
        return _LUVA._secureGet(self, index)
    end,

    ---@param self Luva.Type
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _LUVA._secureSet(self, index, value)
    end,

    ---@param self Luva.Type
    ---@param ... any[]
    ---@return Luva.Object
    __call = function (self, ...)
        local argsCount = select("#", ...)
        local instance = nil

        if argsCount == 0 then
            instance = self.__Constructors.DefaultConstructor(self) ---@diagnostic disable-line : invisible
        else
            instance = self.__Constructors.CustomConstructor(self, ...)  ---@diagnostic disable-line : invisible
        end

        return instance
    end,
}