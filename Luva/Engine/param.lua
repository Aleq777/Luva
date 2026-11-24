
---@diagnostic disable : lowercase-global


--- Expression that lets you assure that
--- `var` is type of `requiredType`
---@param var any
---@param requiredType Luva.Type|type 
param = function (var, requiredType)
    _LUVA.AssureType(var, requiredType, 4)
end


--- Assures that `var` is type of `requiredType`
---@param var any
---@param requiredType Luva.Type|type 
---@param level integer
---@param fieldName string|nil
function _LUVA.AssureType(var, requiredType, level, fieldName)
    if not _LUVA.Config.FullTypeChecking then
        return
    end

    local type_requiredType = type (requiredType)

    -- Scalar
    if type_requiredType == "string" then
        local type_var = type (var)
        if type_var ~= requiredType then
            if fieldName then
                error ("The field's type: " .. fieldName .. " of type " .. type_var .. " couldn't match the required type: " .. requiredType, level)
            else
                error ("The variable's type: " .. type_var .. " couldn't match the required type: " .. requiredType, level)
            end
        end

        return
    end

    -- Not scalar
    local k = kindof (var)
    if k == Luva.KindsEnum["scalar_lua"] then
        error ("fasfsa", level)
    end

    if typeof (var) ~= requiredType then
        error ("fsasfa", level)
    end

    -- correct
end