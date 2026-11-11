
---@diagnostic disable : lowercase-global

---@module "Luva.Engine.kind"

do
    ---@generic T
    ---@class Luva.Lang.Readonly<T> : Luva.Lang.StrictKind
    ---@field private __Value T
    local __readonly
end

---@type Luva.Lang.Keyword
readonly = {
    __Kind = "readonly"
}

return readonly