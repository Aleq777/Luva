
---@diagnostic disable : lowercase-global
---@module "Luva.Engine.MatchingExpressions.matchingBase"
_LUVA, _switch_match = dofile ("Luva/Engine/MatchingExpressions/matchingBase.lua")


--- Executes a function based on `value`
---@generic T
---@param value T
---@param switchBuilder table<"default"|T, fun(): any|nil>
switch = function (value, switchBuilder)
    return _switch_match(value, switchBuilder, function (result)
        return result()
    end)
end



return switch