
---@diagnostic disable : lowercase-global


dofile "Luva/luva.lua"

_LUVA.Modules = { }

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
    path = (path--[[@as string]]):lower():gsub("%.", "/") .. ".lua"

    local _module = _LUVA.Modules[path]
    if _module ~= nil then
        return _get(_module)
    end

    _module = select(1, dofile (path))
    _LUVA.Modules[path] = _module or true
    return _get(_module)
end


--- Lets you export a global with module handling.
--- If the global was defined earlier, it won't
--- be overwritten.
---@param self any
---@param content any
---@return any
export = export or function (self, content)
    if self == nil then
        return content
    end

    return self
end