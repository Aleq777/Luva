
---@diagnostic disable : lowercase-global

---@alias Luva.Path string Path to the file in Simple Notation: `FolderA.FolderB.LuaFile` (instead of slash `/`, use dot `.`, do not include `.lua` file extension)
---@alias Luva.Lang.Identifier string Name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable Not nil

---@alias Luva.Lang.Config.ImportingEnum
---| "luva" # Uses `dofile` with simple module saving
---| "teardown" # Similar to luva, but it searches for mod location

---@alias Luva.Lang.Config.Teardown.FetchMethodEnum
---| "distinct_file" # Filename that exists only in your mod (in case you don't know nor don't want to use mod ID)
---| "mod_id" # Steam workshop mod's ID

--- Luva's usable module
Luva = { }

--- Luva engine ingredients
_LUVA = {
    ---@type table<Luva.Lang.Identifier, string>
    Errors = { },
    ---@package
    Modules = { }
}




---@diagnostic disable : undefined-global
---@param teardown table
---@param prefix string
local function _TD_searchForModId(teardown, prefix)
    for _, v in pairs(ListKeys(prefix)) do
        if HasFile("RAW:" .. GetString(prefix .. '.' .. v .. ".path") .. teardown.DistinctFileName) then
            teardown.ModID = v
            return
        end
    end

    error ("Mod has not been found!", 3)
end
---@diagnostic enable : undefined-global









local _importPrefix = ""
if _LUVA.Config.ImportingFunction == "teardown" then
    local fetchMethod = _LUVA.Config.Environments.Teardown.FetchMethod
    local prefix = "mods.available"
    local teardown = _LUVA.Config.Environments.Teardown

    if fetchMethod == "distinct_file" then
        _TD_searchForModId(teardown, prefix)
    elseif fetchMethod == "mod_id" then
        teardown.ModID = "steam-" .. teardown.ModID
    end

    ---@diagnostic disable-next-line : undefined-global
    _importPrefix = GetString(prefix .. teardown.ModID .. ".path")

end

--- Imports the file with module saving.
--- It won't re-import already imported file.
--- Only imports globals, no locals (nor `return`).
--- If you want to re-import or import locals, use `dofile`.
---@param path Luva.Path Full path in `FolderA.folderB.luaFile` format, without `.lua` extension
import = function (path)
    path = _importPrefix .. path

    if _LUVA.Modules[path] then
        return
    end

    _LUVA.Modules[path] = true

    path = path:gsub("%.", "/") .. ".lua"
    dofile (path)
end