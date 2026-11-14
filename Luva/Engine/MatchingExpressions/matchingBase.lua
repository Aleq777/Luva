
---@diagnostic disable : lowercase-global
---@module "Luva.base"
local _, _LUVA = dofile ("Luva/base.lua")

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
local function _switch_match(value, builder, action)
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


return _switch_match