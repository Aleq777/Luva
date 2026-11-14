


---@alias Luva.Lang.Identifier string name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable



--- Luva things to use publicly
local Luva = { }

--- Luva engine ingredients
local _LUVA = {

    ---@type table<Luva.Lang.Identifier, string>
    Errors = { },
    Modules = { },
}

--- Smart importing. It's like `dofile`, but it saves modules and doesn't re-import them.
--- It prevents redeclarations, unwanted resets and heavy code repeat
---@param path string A path to the file
---@return any
import = import or function (path)
    path = path:tolower():trim()
    
    local imp = _LUVA.Modules[path]
    if imp then
        return imp
    end
    
    imp = dofile (path)
    return imp
end


return Luva, _LUVA