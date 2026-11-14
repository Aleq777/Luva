
---@diagnostic disable : lowercase-global

dofile "Luva/base.lua"

--- Returns varargs (`...`) as an array
---@param ... any[]
---@return any[]
---@nodiscard
varargs = export( varargs, function (...)
    return select(1, ...)
end )