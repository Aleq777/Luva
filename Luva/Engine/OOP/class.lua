
---@diagnostic disable : lowercase-global
---@module "LUVA.base"
local _, _LUVA = dofile "Luva/base.lua"
---@module "Luva.Engine.Security.SecuredObject"
_LUVA.SecuredObject = import "Luva.Engine.Security.SecuredObject.SecuredObject"
---@module "Luva.Engine.OOP.Ingredients.prototype"
local _SetupPrototype = import "Luva.Engine.OOP.Ingredients.prototype"
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"
local _SetupConstructorBase = import "Luva.Engine.OOP.Ingredients.Constructors.base"
---@module "Luva.Engine.OOP.Ingredients.Constructors.default"
local _SetupDefaultConstructorAndMaybeCaller = import "Luva.Engine.OOP.Ingredients.Constructors.default"
---@module "Luva.Engine.OOP.Ingredients.luvatype"

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassBuilder
    ---@field public prototype Luva.Lang.PrototypeBuilder|nil
    ---@field public default Luva.Lang.PostDefaultConstructorCaller<TInstance>|nil
    ---@field public constructor Luva.Lang.ConstructorBuilder|nil
    ---@field public destructor Luva.Lang.DestructorBuilder|nil
    local __classBuilder
end





--- Creates a class
---@generic TInstance : Luva.Object
---@param classBuilder Luva.Lang.ClassBuilder
---@return Luva.Type<TInstance>
---@nodiscard
class = function (classBuilder)

    ---@generic TInstance : Luva.Object
    ---@type Luva.Type<TInstance>
    local resultClass = { }     ---@diagnostic disable-line : missing-fields

    _LUVA.SecuredObject.Secure(resultClass)

    resultClass.__Kind = "Luva.Type"    ---@diagnostic disable-line : invisible

    if classBuilder.prototype then
        _SetupPrototype(resultClass, classBuilder.prototype)

        _SetupConstructorBase(resultClass)

        local constructors = resultClass.__Constructors ---@diagnostic disable-line : invisible

        _SetupDefaultConstructorAndMaybeCaller(constructors, classBuilder.default)
        _SetupBuildConstructor(constructors, classBuilder.prototype)
        
        if classBuilder.constructor then
            _SetupConstructor(constructors, classBuilder.constructor)
        end
    end

    return resultClass
end



