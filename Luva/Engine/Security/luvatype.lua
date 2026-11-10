
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"

do
    -- ---@generic TInstance : Luva.Object
    -- ---@class Luva.Type : Luva.Lang.SecuredObject
    -- ---@field private __Prototype Luva.Lang.ClassPrototype Static class' data
    -- ---@field private __Constructors Luva.Lang.ClassConstructors<TInstance>
    -- ---@field private __InvokeConstructor fun(self: Luva.Type<TInstance>, ...: any[]): TInstance
    -- ---@field private __Destructor fun(self: TInstance)
    -- local __luvatype


    ---@class Luva.Type : Luva.Lang.SecuredObject
    ---@field private __TemplateClass Luva.TemplateClass|nil # Refer to the template (List<int> refers to generic List)
    ---@field private __GenericTypes table<Luva.Lang.Identifier, Luva.Type> # "T" -> Luva.Type
    local __luvatype
end