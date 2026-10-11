
---@diagnostic disable : lowercase-global


--- `a xor b`
--- Xor is like or, but only 1 of 2 values must be true
---@param a boolean|nil
---@param b? boolean|nil?
---@return boolean
---@nodiscard
function xor(a, b)
    return (a or false) and not (b or false)
end


return xor