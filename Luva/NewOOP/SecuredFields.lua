
_LUVA = { }


do
    

    ---@class Luva.SecuredFields
    local __securedFields = { }
end

--- Secured fields are not physically existing fields, that are handled
--- by __index and __newindex operators and prohibit any other indexes
--- (like in C#/Java/C++, you cannot add a new field or read not defined one)
---@param object table
---@param securedFields table
---@return Luva.SecuredFields
---@nodiscard
function _LUVA.SecuredFields(object, securedFields)

end