

do
    ---@alias Luva.Template Luva.Generic[]

    ---@class Luva.Generic
    ---@field private __Identifier Luva.Lang.Identifier
    ---@field private __Requirement fun(T: Luva.Type): boolean
    local __template

    ---@class Luva.TemplateType : Luva.Lang.StrictKind
    ---@field private __Metatable metatable
    ---@field private __GeneratedClasses table<Luva.Template, Luva.Type> # if it finds something here, it will use it instead of creating
    ---@field private __Template Luva.Template
    ---@field private __Class Luva.Type # Class without defined generics, for TEMPLATE DUHH
    local __templatetype
end