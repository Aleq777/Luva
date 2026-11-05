
---@diagnostic disable : lowercase-global
---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")

_LUVA.Errors.NO_CASE_MATCHED = "Haven't found a case or default to match value"
_LUVA.Errors.VALUE_AS_DEFAULT_IN_MATCH = "The value is 'default' in matching expression. Use if statement or don't assign to string value of 'default'"


---@generic T
---@param value T
---@param builder table<"default"|T, any>
---@param action fun(result: any): any|nil
---@return any|nil
---@nodiscard
function _switch_match(value, builder, action)
    if value == "default" then
        error()
    end

    local result = builder[value]
    if result ~= nil then
        return action(result)
    end

    local default = builder.default
    if default ~= nil then
        return action(result)
    end

    error(_LUVA.Errors.NO_CASE_MATCHED)
end

return _LUVA, _switch_match