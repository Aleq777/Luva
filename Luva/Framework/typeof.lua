
---@diagnostic disable : lowercase-global

---@module "TypeKinds.class"
class = dofile("Luva/Framework/OOP/TypeKinds/class.lua")

--- Gets the type (scalar or Luva.Type's)
--- Warning - using typeof() on a Luva class will return "Luva.Type"
---@param any any
---@return type|Luva.Type|Luva.ClassExpression
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