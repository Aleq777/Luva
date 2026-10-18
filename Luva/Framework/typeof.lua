
---@diagnostic disable : lowercase-global


--- Gets the type (scalar or Luva.Type's)
--- Warning - using typeof() on a Luva class will return "Luva.Type"
---@param any any
---@return type|Luva.Type
---@nodiscard
function typeof(any)
    local scalar = type (any)

    if scalar == "table" then
        if any.__Type == "Luva.Type" then
            return class
        elseif any.__Type ~= nil then
            return any.__Type
        else
            return "table"
        end
    end

    return scalar
end


return typeof