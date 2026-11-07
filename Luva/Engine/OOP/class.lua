
---@diagnostic disable : lowercase-global
---@module "Luva.Engine.SecuredObject"
_, _LUVA = dofile ("Luva/Engine/SecuredObject.lua")
---@module "Luva.Engine.OOP.Ingredients.prototype"
_SetupPrototype = dofile ("Luva/Engine/OOP/Ingredients/prototype.lua")
---@module "Luva.Engine.OOP.Ingredients.Constructors.default"
_SetupDefaultConstructorAndMaybeCaller = dofile ("Luva/Engine/OOP/Ingredients/Constructors/default.lua")
---@module "Luva.Engine.OOP.Ingredients.luvatype"

do
    ---@class Luva.Lang.ClassBuilder
    ---@field public prototype Luva.Lang.PrototypeBuilder|nil
    ---@field public default Luva.Lang.PostDefaultConstructorCaller|nil
    ---@field public constructor Luva.Lang.ConstructorBuilder|nil
    ---@field public destructor Luva.Lang.DestructorBuilder|nil
    local __classBuilder
end





--- Creates a class
---@param classBuilder Luva.Lang.ClassBuilder
---@return Luva.Type
---@nodiscard
class = function (classBuilder)

    ---@type Luva.Type
    local resultClass = { }     ---@diagnostic disable-line : missing-fields

    _LUVA.SecuredObject.Secure(resultClass)
    resultClass.__Kind = "Luva.Type"    ---@diagnostic disable-line : invisible

    if classBuilder.prototype then
        _SetupPrototype(resultClass, classBuilder.prototype)

        _SetupDefaultConstructorAndMaybeCaller(resultClass, classBuilder.default)
        _SetupBuildConstructor(resultClass, classBuilder.prototype)
        
        if classBuilder.constructor then
            _SetupConstructor(resultClass, classBuilder.constructor)
        end
    end

    return resultClass
end



return class