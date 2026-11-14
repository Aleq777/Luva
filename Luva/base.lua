
---@diagnostic disable : lowercase-global

dofile "Luva/ForwardCompatibility.lua"


---@alias Luva.Path string Path to the file in Simple Notation: `FolderA.FolderB.LuaFile` (instead of slash `/`, use dot `.`, do not include `.lua` file extension)
---@alias Luva.Lang.Identifier string Name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable Not nil


--- Luva things to use publicly
local Luva = { }

--- Luva engine ingredients
local _LUVA = {

    ---@type table<Luva.Lang.Identifier, string>
    Errors = { },

    Config = dofile "Luva/Config.lua",

    Modules = { },
}


---@param _module any
---@return any ...
---@nodiscard
local function _get(_module)
    return type (_module) == "table" and table.unpack(_module) or _module
end

--- Imports the file with module saving.
--- It means that in case of multiple imports,
--- the file content won't execute more than once.
--- No recalls, resets, redeclarations etc.
---@param path Luva.Path
---@return any ...
import = import or function (path)
    ---@cast path string
    path = path:lower():gsub("%.", "/") .. ".lua"

    local _module = _LUVA.Modules[path]
    if _module ~= nil then
        return _get(_module)
    end

    _module = select(1, dofile (path)) or true
    _LUVA.Modules[path] = _module
    return _get(_module)
end



return Luva, _LUVA