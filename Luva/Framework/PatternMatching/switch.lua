
---@diagnostic disable : lowercase-global


default = dofile("Luva/Framework/SuperIf/default.lua")



--- Perform an action based on value
--- ## Example:
--- ```lua
--- local input = 100
--- switch(input, {
---     [10] = function () print "too small" end,
---     [200] = function () print "too big" end,
---     [default] = function () print "perfect" end
--- }) -- Prints "perfect"
--- ```
---@generic T
---@param value T
---@param cases table<T|Luva.DefaultExpression, fun()>
function switch(value, cases)
    for case, exec in pairs(cases) do
        if case == value then
            exec()
            return
        end
    end

    local def = cases[default]
    if def then
        def()
        return
    end

    error("No case found to match the value: " .. value)
end


return switch