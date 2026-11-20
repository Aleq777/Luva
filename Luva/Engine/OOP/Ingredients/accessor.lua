
---@diagnostic disable : lowercase-global


import "Luva.Engine.Security.SecuredObject"
import "Luva.Engine.OOP.Ingredients.field"

do
    ---@generic TChild : Luva.Object
    ---@generic TField
    ---@class Luva.Lang.Accessor : Luva.Lang.StrictKind
    ---@field public get nil|fun(self: TChild): TField
    ---@field public set nil|fun(self: TChild, value: TField)
    local __accessor
end





local ERR_PROHIBITED_ACCESSOR_FUNCTION = "Any other functions than get/set are prohibited inside the accessor"
local ERR_EMPTY_ACCESSOR = "Accessor requires at least one function (get and/or set). Provided none"




--- Creates an accessor field <br />
--- Custom getters and setters
---@generic TChild : Luva.Object
---@generic TField
---@param accessorBuilder Luva.Lang.Accessor At least one function required (get and/or set)
---@return Luva.Lang.Accessor<TChild, TField>
---@nodiscard
accessor = function (accessorBuilder)
    local atLeastOne = false

    for k, _ in pairs(accessorBuilder) do
        if k == "get" or k == "set" then
            atLeastOne = true
        else
            error (ERR_PROHIBITED_ACCESSOR_FUNCTION)
        end
    end

    if atLeastOne then
        accessorBuilder.__Kind = "accessor"    ---@diagnostic disable-line : invisible
        return accessorBuilder
    else
        error (ERR_EMPTY_ACCESSOR)
    end
end