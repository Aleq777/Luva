
---@diagnostic disable : lowercase-global

import "Luva.Engine.utils"

---@enum Luva.KindsEnum
Luva.KindsEnum = {
    Class = "class",
    AbstractClass = "abstract_class",
    Struct = "struct",
    Record = "record",
    Interface = "interface",
    Singleton = "singleton",
    LuvaType = "luva_type",
    Readonly = "readonly",
    Reference = "ref",
    Constant = "const",
    Accessor = "accessor",
    Field = "field",
    -- Empty = "empty",
    Maybe = "maybe",
    Instance = "instance",
    ScalarLua = "scalar_lua",
    ScalarLuaAsRef = "scalar_lua_ref"
}

do
    --- It tells what kind of expression is that.
    --- Types are data-interpretation
    ---@class Luva.Lang.StrictKind
    ---@field private __Kind Luva.KindsEnum
    local __strictType

    ---@alias Luva.Lang.Keyword Luva.Lang.StrictKind
end

local typesKindsList = { "class", "struct", "record", "abstract_class", "interface", "singleton" }

--- Returns the kind of an expression
---@param expr any
---@return Luva.KindsEnum
---@nodiscard
kindof = function (expr)
    local t = type (expr)

    if t == "string" and _LUVA.Utils.Has(typesKindsList, expr) then
        return "luva_type"
    elseif t ~= "table" or expr.__Kind == nil then
        return "scalar_lua"
    end

    return expr.__Kind
end