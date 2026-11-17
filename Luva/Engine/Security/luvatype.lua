
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"

do
    ---@class Luva.Type : Luva.Lang.SecuredObject
    ---@field private __TemplateClass Luva.TemplateClass|nil # Refer to the template (List<int> refers to generic List)
    ---@field private __GenericTypes table<Luva.Lang.Identifier, Luva.Type> # "T" -> Luva.Type
    ---@field private __Prototype Luva.Lang.ClassPrototype|nil
    ---@field private __Constructors Luva.Lang.ClassConstructors|nil
    ---@field private __Destructor fun(self: Luva.Object)
    ---@field private __Extends Luva.Type
    ---@field private __Implements Luva.Interface[]
    local __luvatype
end

