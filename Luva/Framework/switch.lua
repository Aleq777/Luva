
---@diagnostic disable : lowercase-global

---@alias Luva.DefaultExpression Luva.Keyword

---@type Luva.DefaultExpression
default = { }

--- Works like switch in other languages
--- ## Example:
--- ```lua
--- local input = 100
--- local output = switch(input, {
---     [50] = function () return "small" end,
---     [100] = function () return "big" end,
---     [default] = function () return "idk" end
--- }) -- returns "big"
--- ```
---@generic T
---@param value T
---@param cases table<T|Luva.DefaultExpression, fun(): any|nil?>
---@return any|nil? # Returns only if `case` or `default` function returns a value
function switch(value, cases)

    for case, exec in pairs(cases) do
        if case == value then
            return exec()
        end
    end

    if cases[default] then
        return cases[default]()
    end
end


return switch, default