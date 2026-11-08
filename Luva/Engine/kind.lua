
---@diagnostic disable : lowercase-global

---@module "Luva.Engine.utils"
_LUVA = dofile ("Luva/Engine/utils.lua")
---@module "Luva.Engine.MatchingExpressions.switch"
switch = dofile ("Luva/Engine/MatchingExpressions/switch.lua")

do
    ---@alias Luva.Lang.TypeTypes
    ---| "class"
    ---| "struct"
    ---| "record"
    ---| "interface"


    --- It tells what kind of expression is that.
    --- Types are data-interpretation
    ---@class Luva.Lang.StrictKind
    ---@field private __Kind string
    local __strictType

    ---@alias Luva.Lang.Keyword Luva.Lang.StrictKind
end


--- Returns the kind of an expression
---@param expr any
---@return string
---@nodiscard
kindof = function (expr)
    local basicType = "Lua"
    return switch(type (expr), {
        ["string"] = function ()
            if _LUVA.Utils.Has({ "class", "struct", "record", "interface" }, expr) then
                return "Luva.Type"
            end

            return basicType
        end,
        ["table"] = function ()
            if expr.__Kind ~= nil then
                ---@cast expr Luva.Lang.StrictKind
                return expr.__Kind  ---@diagnostic disable-line : invisible
            end

            return basicType
        end,
        default = function ()
            return basicType
        end
    })
end


return kindof