
---@diagnostic disable : lowercase-global


dofile "Luva/luva.lua"

---@package
_LUVA.Modules = _LUVA.Modules or { }


--- Imports the file with module saving.
--- It won't re-import already imported file.
--- Only imports globals, no locals (nor `return`).
--- If you want to re-import or import locals, use `dofile`.
---@param path Luva.Path Full path in `FolderA.folderB.luaFile` format, without `.lua` extension
import = import or function (path)
    path = (path--[[@as string]]):lower():gsub("%.", "/") .. ".lua"

    if _LUVA.Modules[path] then
        return
    end

    _LUVA.Modules[path] = true
    dofile (path)
end

--- Lets you export a global with module handling.
--- If the global was defined earlier, it won't
--- be overwritten.
---@param self any
---@param content any
---@return any
---@deprecated
export = export or function (self, content)
    if self == nil then
        return content
    end

    return self
end