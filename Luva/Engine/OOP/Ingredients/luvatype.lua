
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Type : Luva.Lang.SecuredObject
    ---@field private __TypeMetatable metatable Joined with SecuredMetatable
    ---@field private __Prototype Luva.Lang.ClassPrototype
    ---@field private __Constructors Luva.Lang.ClassConstructors<TInstance>
    ---@field private __InvokeConstructor fun(self: Luva.Type<TInstance>, ...: any[]): TInstance
    local __luvatype
end