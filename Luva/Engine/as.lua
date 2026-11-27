
---@diagnostic disable : lowercase-global


--- Converts `var` to a `newType` (returns by value). <br />
--- <strong>Warning! The `newType` must have defined conversion!</strong> <br />
--- Back-casting (eg: `Human h`, where `Human extends Object`, operation `as(h, Object)` is implemented by default and you can override it. <br />
--- Scalar Lua basic types have already defined conversions.
---@generic TVar : Luva.Object|Luva.Dynamic
---@generic TNew : Luva.Object|Luva.Dynamic
---@param var TVar
---@param newType Luva.Type|type
---@return TNew var # converted copy
---@nodiscard
as = function (var, newType)
    local conversion = typeof (var).__Conversions[newType]  ---@diagnostic disable-line : invisible

    if not conversion then
        error ("No possible convertion exists", 2)
    end
    
    if type (newType) == "string" and kindof (var) ~= "instance"  then
        -- from scalar to scalar
        if _LUVA.Utils.Has({ "function", "nil", "thread", "userdata" }--[[@as (type[])]], newType) then
            error ("No possible convertion existis", 2)
        end

        return match (newType, {
            ["string"] = tostring(var),
            ["table"] = { var },
            ["number"] = var == false and 0 or (tonumber(var) or 1),
            ["boolean"] = var ~= nil and var ~= false and var ~= 0,
        })
    end
    -- Luva.Object to Luva.Object/scalar

    return conversion(var)
end