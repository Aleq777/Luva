
---@diagnostic disable : lowercase-global

---@alias Luva.Path string Path to the file in Simple Notation: `FolderA.FolderB.LuaFile` (instead of slash `/`, use dot `.`, do not include `.lua` file extension)
---@alias Luva.Lang.Identifier string Name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable Not nil


if setmetatable == nil or getmetatable == nil or dofile == nil then
    error ("Luva framework environmental requirements haven't met: metatables, dofile")
end


--- Luva's usable module
Luva = { }

--- Luva engine ingredients
_LUVA = {
    ---@type table<Luva.Lang.Identifier, string>
    ---@package
    Modules = { },

    ---@type string[]
    Modes = { },
}



--- Imports the file with module saving.
--- It won't re-import already imported file.
--- Only imports globals, no locals (nor `return`).
--- If you want to re-import or import locals, use `dofile`.
---@param path Luva.Path Full path in `FolderA.folderB.luaFile` format, without `.lua` extension
import = function (path)
    if _LUVA.Modules[path] then
        return
    end

    _LUVA.Modules[path] = true

    path = path:gsub("%.", "/") .. ".lua"
    dofile (path)
end

import "Luva.Config"
if _LUVA.Config.ForwardCompatibility then
    import "Luva.ForwardCompatibility"
end