
---@diagnostic disable : lowercase-global
---@module "Luva.Engine.MatchingExpressions.matchingBase"
local _switch_match = import "Luva.Engine.MatchingExpressions.matchingBase"


--- Executes a function based on `value`
---@generic T
---@param value T
---@param switchBuilder Luva.Lang.MatchingBaseBuilder<T, fun(): any|nil>
---@return any|nil
switch = export (switch, function (value, switchBuilder)
    return _switch_match(value, switchBuilder, function (result)
        return result()
    end)
end)