
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


---@diagnostic disable : lowercase-global

import "Luva.Engine.utils"
import "Luva.Engine.Security.SecuredObject"


do
    ---@alias Luva.Lang.Template Luva.Lang.Generic[]

    ---@class Luva.Lang.Generic
    ---@field private __Identifier Luva.Lang.Identifier
    ---@field private __Requirement fun(T: Luva.Type): boolean
    local __template

    ---@class Luva.TemplateClass : Luva.Lang.StrictKind
    ---@field private __GeneratedClasses table<Luva.Type[], Luva.Type> # if it finds something here, it will use it instead of creating
    ---@field private __Template Luva.Lang.Template
    ---@field private __Class Luva.Type # Class without defined generics, for TEMPLATE DUHH
    local __templatetype
end


--- Generates a standard class from a generic class
---@param templateClass Luva.TemplateClass
---@param filledTemplate Luva.Type[]
---@return Luva.Type
---@nodiscard
function _LUVA._GenerateFromTemplate(templateClass, filledTemplate)

    ---@type table<Luva.Lang.Identifier, Luva.Type>
    local genericTypes = { }
    for index, generic in ipairs(templateClass.__Template) do  ---@diagnostic disable-line : invisible
        genericTypes[generic.__Identifier] = filledTemplate[index]  ---@diagnostic disable-line : invisible
    end

    ---@type table<Luva.Lang.Identifier, Luva.Dynamic>
    local constants = { }
    for index, constant in pairs(templateClass.__Class.__Constants) do  ---@diagnostic disable-line : invisible
        constants[index] = _LUVA.Utils.Copy(constant)
    end

    ---@type table<Luva.Lang.Identifier, Luva.Dynamic>
    local fields = { }
    for index, _field in pairs(templateClass.__Class.__Fields) do   ---@diagnostic disable-line : invisible
        fields[index] = _LUVA.Utils.Copy(_field)
    end

    local methods = templateClass.__Class.__Methods ---@diagnostic disable-line : invisible

    local accessors = templateClass.__Class.__Accessors ---@diagnostic disable-line : invisible

    ---@type Luva.Type
    local result = {    ---@diagnostic disable-line : missing-fields
        __GenericTypes = genericTypes,
        __Constants = constants,
        __Fields = fields,
        __Methods = methods,
        __Accessors = accessors
    }

    -- ta sama funkcja co w SecuredObject będzie tworzyć
    -- na podstawie decyzji, czy zrobić
    -- static class czy instance class
    ---@type "InstanceClass"|"StaticClass"
    local classType

    _LUVA.SecuredObject.Secure(result, classType)

    return result
end

