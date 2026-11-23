

---@generic T : Luva.Object
---@param resultClass Luva.Type
---@param destructor fun(self: T)|nil
function _LUVA._SetupDestructor(resultClass, destructor)
    if destructor then
        rawset(resultClass, "__Destructor", destructor)
    end
end