
---@diagnostic disable : lowercase-global

_LUVA.Errors.NO_CASE_MATCHED = "Haven't found a case or default to match value"
_LUVA.Errors.VALUE_AS_DEFAULT_IN_MATCH = "The value is 'default' in matching expression. Use if statement or don't assign to string value of 'default'"

---@generic TCase
---@generic TContent
---@alias Luva.Lang.MatchingBaseBuilder table<"default"|TCase, TContent>




---@generic T
---@param value T
---@param builder Luva.Lang.MatchingBaseBuilder<T, any>
---@param action fun(result: any): any|nil
---@return any|nil
---@nodiscard
function _LUVA._switch_match(value, builder, action)
    if value == "default" then
        error(_LUVA.Errors.VALUE_AS_DEFAULT_IN_MATCH)
    end

    local result = builder[value]
    if result ~= nil then
        return action(result)
    end

    local default = builder.default     ---@diagnostic disable-line : undefined-field
    if default ~= nil then
        return action(default)
    end

    error(_LUVA.Errors.NO_CASE_MATCHED, 3)
end


---@diagnostic disable : lowercase-global

import "Luva.Engine.MatchingExpressions.matchingBase"


---@diagnostic disable : lowercase-global

import "Luva.Engine.MatchingExpressions.matchingBase"


--- Returns another value based on `value`
---@generic T
---@param value T
---@param matchBuilder Luva.Lang.MatchingBaseBuilder<T, any>
match = function (value, matchBuilder)
    return _LUVA._switch_match(value, matchBuilder, function (result)
        return result
    end)
end

--- Executes a function based on `value`
---@generic T
---@param value T
---@param switchBuilder Luva.Lang.MatchingBaseBuilder<T, fun(): any|nil>
---@return any|nil
switch = function (value, switchBuilder)
    return _LUVA._switch_match(value, switchBuilder, function (result)
        return result()
    end)
end