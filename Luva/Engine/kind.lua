
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
    Empty = "empty",
    ScalarLua = "scalar_lua",
}

do
    --- It tells what kind of expression is that.
    --- Types are data-interpretation
    ---@class Luva.Lang.StrictKind
    ---@field private __Kind Luva.KindsEnum
    local __strictType

    ---@alias Luva.Lang.Keyword Luva.Lang.StrictKind
end

--- Returns the kind of an expression
---@param expr any
---@return Luva.KindsEnum
---@nodiscard
kindof = function (expr)
    local t = type (expr)

    if t == "string" and _LUVA.Utils.Has(Luva.KindsEnum, expr) then
        return Luva.KindsEnum.LuvaType
    elseif t ~= "table" or expr.__Kind == nil then
        return Luva.KindsEnum.ScalarLua
    end

    return expr.__Kind
end