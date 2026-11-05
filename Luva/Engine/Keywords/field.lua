
---@diagnostic disable : lowercase-global
---@module "Luva.Engine.SecuredObject"



--- Creates an accessor field <br />
--- Custom getters and setters
---@generic T
---@param accessorBuilder Luva.Lang.Accessor At least one function required (get and/or set)
---@return Luva.Lang.Accessor<T>
---@nodiscard
field = function (accessorBuilder)
    return accessorBuilder
end



return field