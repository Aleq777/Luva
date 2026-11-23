
---@diagnostic disable : lowercase-global


--- Expression that lets you assure that
--- `var` is type of `requiredType`
---@param var any
---@param requiredType Luva.Type|type 
param = function (var, requiredType)
    _LUVA.AssureType(var, requiredType, 3)
end


--- Assures that `var` is type of `requiredType`
---@param var any
---@param requiredType Luva.Type|type 
---@param level integer|nil `Default = 2`
function _LUVA.AssureType(var, requiredType, level)
    level = level or 2
    local type_requiredType = type (requiredType)

    -- Scalar
    if type_requiredType == "string" then
        local type_var = type (var)
        if type_var ~= requiredType then
            error ("The variable's type: " .. type_var .. " couldn't match the required type: " .. requiredType, level)
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