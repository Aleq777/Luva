
---@diagnostic disable : lowercase-global
---@module "Luva.Engine.SecuredObject"
_, _LUVA = dofile ("Luva/Engine/SecuredObject.lua")
---@module "Luva.Engine.OOP.Ingredients.accessor"





_LUVA.Errors.PROHIBITED_ACCESSOR_FUNCTION = "Any other functions than get/set are prohibited inside the accessor"
_LUVA.Errors.EMPTY_ACCESSOR = "Accessor requires at least one function (get and/or set). Provided none"




--- Creates an accessor field <br />
--- Custom getters and setters
---@generic TChild : Luva.Object
---@generic TField
---@param accessorBuilder Luva.Lang.Accessor At least one function required (get and/or set)
---@return Luva.Lang.Accessor<TChild, TField>
---@nodiscard
field = function (accessorBuilder)
    local atLeastOne = false

    for k, _ in pairs(accessorBuilder) do
        if k == "get" or k == "set" then
            atLeastOne = true
        else
            error(_LUVA.Errors.PROHIBITED_ACCESSOR_FUNCTION)
        end
    end

    if atLeastOne then
        accessorBuilder.__Kind = "accessor"    ---@diagnostic disable-line : invisible
        return accessorBuilder
    else
        error(_LUVA.Errors.EMPTY_ACCESSOR)
    end
end






return field