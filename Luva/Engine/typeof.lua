
---@diagnostic disable : lowercase-global



--- Returns the reference to the
--- type of `expr` or just string for scalar Lua types.
---@param expr any
---@return Luva.Type|type type # In case of scalars, returns `table`, `string` or special reference representations
---@nodiscard
typeof = function (expr)
    local t = type (expr)

    if t ~= "table" then
        return t
    end

    if not expr.__Kind or expr.__Kind ~= "instance" then
        return "table"
    end

    return expr.__Type
end