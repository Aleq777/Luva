
---@diagnostic disable : lowercase-global

dofile "Luva/ForwardCompatibility.lua"


---@alias Luva.Path string Path to the file etc.
---@alias Luva.Lang.Identifier string Name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable Not nil


--- Luva things to use publicly
local Luva = { }

--- Luva engine ingredients
local _LUVA = {

    ---@type table<Luva.Lang.Identifier, string>
    Errors = { },

    Config = dofile ("Luva/Config.lua"),

    Modules = { },
}


--- Handles the globals' import and export.
--- It's required to use when you want globals
--- to not be reset on every import.
---@param self Luva.Dynamic
---@param obj Luva.Dynamic
---@return Luva.Dynamic self-obj
---@nodiscard
export = export or function (self, obj)
    if self == nil then
        return obj
    end

    return self
end


--- Imports the file with module saving.
--- It means that in case of multiple imports,
--- the file content won't execute more than once.
--- No recalls, resets, redeclarations etc.
---@param path Luva.Path
---@return Luva.Dynamic module
import = import or function (path)

    local _module = _LUVA.Modules[path]
    if _module ~= nil then
        return _module
    end

    _module = dofile (path)
    _LUVA.Modules[path] = _module
    return _module
end



return Luva, _LUVA