

---@generic T : Luva.Object
---@param resultClass Luva.Type
---@param destructor fun(self: T)|nil
function _LUVA._SetupDestructor(resultClass, destructor)
    rawset(resultClass, "__Destructor", destructor or function (self) end)
end