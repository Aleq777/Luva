
dofile "Luva/base.lua"

local _secureGet, _secureSet = import "Luva.Engine.Security.SecuredObject._securedGetSet"

---@type metatable
return {
    ---@param self Luva.Lang.SecuredObject
    ---@param index Luva.Dynamic
    ---@return any
    __index = function (self, index)
        return _secureGet(self, index)
    end,

    ---@param self Luva.Lang.SecuredObject
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _secureSet(self, index, value)
    end
}