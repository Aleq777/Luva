
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
---@generic U
---@param value T
---@param cases table<T, (fun(): any|nil?)|U>
---@return any|nil? # Returns only if `case` or `default` function returns a value
function switch(value, cases)

    for case, exec in pairs(cases) do
        if case == value then
            if type (exec) == "function" then
                return exec()
            else
                return exec
            end
        end
    end

    local def = cases[default]

    if def then
        if type (def) == "function" then
            return def()
        else
            return def
        end
    end

    error("No case found to match the value " .. value)
end


return switch, default