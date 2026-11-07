
---@diagnostic disable : lowercase-global

do
    --- It tells what kind of expression is that.
    --- Types are data-interpretation
    ---@class Luva.Lang.StrictKind
    ---@field private __Kind string
    local __strictType

    ---@alias Luva.Lang.Keyword Luva.Lang.StrictKind
end


--- Returns the kind of expression
---@param expr Luva.Lang.StrictKind
---@return string
---@nodiscard
kindof = function (expr)
    return expr.__Kind  ---@diagnostic disable-line : invisible
end


return kindof