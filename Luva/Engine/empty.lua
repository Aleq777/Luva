
---@diagnostic disable : lowercase-global

---@module "Luva.Engine.kind"

do
    ---@class Luva.Empty : Luva.Lang.StrictKind
    local __empty
end


--- Alternative for `nil`, but it doesn't remove
--- values nor keys from tables. It is more precise
--- when you want to use it like `null` in other languages.
--- In Luva, you should use `empty` most of the times.
---@type Luva.Empty
empty = { __Kind = "empty" }

