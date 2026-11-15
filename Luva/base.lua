
---@diagnostic disable : lowercase-global

---@alias Luva.Path string Path to the file in Simple Notation: `FolderA.FolderB.LuaFile` (instead of slash `/`, use dot `.`, do not include `.lua` file extension)
---@alias Luva.Lang.Identifier string Name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable Not nil


--- Luva's usable module
Luva = { }

--- Luva engine ingredients
_LUVA = {
    ---@type table<Luva.Lang.Identifier, string>
    Errors = { },
    ---@package
    Modules = { }
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

    path = (path--[[@as string]]):gsub("%.", "/") .. ".lua"
    dofile (path)
end