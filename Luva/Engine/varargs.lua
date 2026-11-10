
---@diagnostic disable : lowercase-global


--- Returns varargs (`...`) as an array
---@param ... any[]
---@return any[]
varargs = function (...)
    return select(1, ...)
end


return varargs