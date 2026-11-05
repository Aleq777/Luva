
---@diagnostic disable : lowercase-global
---@module "Luva.Engine.SecuredObject"
_, _LUVA = dofile ("Luva/Engine/SecuredObject.lua")






--- Creates a class
---@param classBuilder Luva.Lang.ClassBuilder
---@return Luva.Type
---@nodiscard
class = function (classBuilder)

    ---@type Luva.Type
    local resultClass = { }     ---@diagnostic disable-line : missing-fields

    _LUVA.SecuredObject.Secure(resultClass)
    resultClass.__Type = "Luva.Type"    ---@diagnostic disable-line : invisible

    return resultClass
end





return class