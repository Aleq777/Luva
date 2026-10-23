
---@diagnostic disable : lowercase-global


---@module "Luva.Framework.PatternMatching.default"
default = dofile ("Luva/Framework/PatternMatching/default.lua")


--- Selects a value to return based on value
--- ## Example:
--- ```lua
--- local input = 2
--- local color = match(input, {
---     [0] = "red",
---     [1] = "green",
---     [default] = "blue"
--- }) -- color == "blue"
--- ```
---@generic T
---@generic U
---@param value T
---@param cases table<T|Luva.DefaultExpression, U>
---@return U
---@nodiscard
function match(value, cases)
    if cases[value] ~= nil then
        return cases[value]
    end

    if cases[default] ~= nil then
        return cases[default]
    end

    error("No case found to match the value " .. value)
end


return match