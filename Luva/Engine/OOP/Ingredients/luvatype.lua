
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"

do
    -- -@field private __Prototype Luva.Lang.ClassPrototype
    -- -@field private __TypeMetatable metatable Joined with SecuredMetatable
    -- -@field private __Prototype table<string, any>
    ---@generic TInstance : Luva.Object
    ---@class Luva.Type : Luva.Lang.SecuredObject
    ---@field private __Prototype Luva.Lang.ClassPrototype Static class' data
    ---@field private __Constructors Luva.Lang.ClassConstructors<TInstance>
    ---@field private __InvokeConstructor fun(self: Luva.Type<TInstance>, ...: any[]): TInstance
    ---@field private __Destructor fun(self: TInstance)
    local __luvatype
end