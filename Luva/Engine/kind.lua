
---@diagnostic disable : lowercase-global

import "Luva.Engine.utils"

local _luva_type, _field = "luva_type", "field"

-- ---@type Luva.Kinds
---@enum Luva.KindsEnum
Luva.KindsEnum = {
    -- subKind -> kind
    ["class"] = _luva_type,
    ["struct"] = _luva_type,
    ["record"] = _luva_type,
    ["interface"] = _luva_type,
    ["singleton"] = _luva_type,

    ["readonly"] = _field,
    ["const"] = _field,
    ["ref"] = _field,
    ["accessor"] = _field,
    ["maybe"] = _field,

    ["instance"] = "instance",
    ["scalar_lua"] = "scalar_lua"
}

--- Returns the general kind of an expression
---@param expr any
---@return Luva.KindsEnum
---@nodiscard
kindof = function (expr)
    local t = type (expr)

    if t == "string" and _LUVA.Utils.Has(_LUVA.Utils.KeysOf(Luva.KindsEnum), expr) then
        return Luva.KindsEnum[expr]
    elseif t ~= "table" or expr.__Kind == nil then
        return Luva.KindsEnum["scalar_lua"]
    end

    local subKind = subkindof (expr)
    return Luva.KindsEnum[subKind]
end

--- Returns the subkind of an expression
---@param expr any
---@return Luva.KindsEnum
---@nodiscard
subkindof = function (expr)
    local t = type (expr)

    -- scalar
    if t ~= "table" or expr.__Kind == nil then
        return Luva.KindsEnum["scalar_lua"]
    end

    -- Luva's
    return expr.__Kind
end