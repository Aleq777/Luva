

---@diagnostic disable : lowercase-global

local ERR_NO_CASE_MATCHED = "Haven't found a case or default to match value"
local ERR_VALUE_AS_DEFAULT_IN_MATCH = "The value is 'default' in matching expression. Use if statement or don't assign to string value of 'default'"

---@generic TCase
---@generic TContent
---@alias Luva.Lang.MatchingBaseBuilder table<"default"|TCase, TContent>


--- Returns another value based on `value`
---@generic T
---@param value T
---@param matchBuilder Luva.Lang.MatchingBaseBuilder<T, any>
match = function (value, matchBuilder)
    if value == "default" then
        error (ERR_VALUE_AS_DEFAULT_IN_MATCH, 3)
    end
    
    local result = matchBuilder[value]
    if result == nil then
        local dft = matchBuilder.default
        if dft == nil then
            error (ERR_NO_CASE_MATCHED, 3)
        end
        
        return dft
    end
    
    return result
end

--- Executes a function based on `value`
---@generic T
---@param value T
---@param switchBuilder Luva.Lang.MatchingBaseBuilder<T, fun(): any|nil>
---@return any|nil
switch = function (value, switchBuilder)
    return match (value, switchBuilder)()
end