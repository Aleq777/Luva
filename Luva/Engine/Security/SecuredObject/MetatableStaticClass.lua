
import "Luva.Engine.Security.SecuredObject.securedGetSet"

---@type metatable
_LUVA.SecuredObject.Metatables.StaticClass = {
    ---@param self Luva.Lang.SecuredObject
    ---@param index Luva.Dynamic
    ---@return any
    __index = function (self, index)
        return _LUVA._secureGet(self, index)
    end,

    ---@param self Luva.Lang.SecuredObject
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _LUVA._secureSet(self, index, value)
    end
}