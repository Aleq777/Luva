
---@diagnostic disable : lowercase-global

-- dofile "Luva/ForwardCompatibility.lua"
dofile "Luva/import.lua"
import "Luva.luva"

---@alias Luva.Path string Path to the file in Simple Notation: `FolderA.FolderB.LuaFile` (instead of slash `/`, use dot `.`, do not include `.lua` file extension)
---@alias Luva.Lang.Identifier string Name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable Not nil
