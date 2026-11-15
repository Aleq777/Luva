
dofile "Luva/import.lua"

---@module "Luva.Engine.Security.SecuredObject.securedGetSet"
---@type function, function
local _secureGet, _secureSet = import "Luva.Engine.Security.SecuredObject.securedGetSet"    ---@diagnostic disable-line : assign-type-mismatch # Intelisense not working


---@type metatable
return {
    ---@param self Luva.Object
    ---@param index Luva.Dynamic
    ---@return any
    __index = function (self, index)
        return _secureGet(self, index)
    end,

    ---@param self Luva.Object
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _secureSet(self, index, value)
    end,
}