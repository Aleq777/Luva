
---@diagnostic disable : lowercase-global

do
    ---@alias Luva.Lang.Template Luva.Lang.Generic[]

    ---@class Luva.Lang.Generic
    ---@field private __Identifier Luva.Lang.Identifier
    ---@field private __Requirement fun(T: Luva.Type): boolean
    local __template

    ---@class Luva.TemplateType : Luva.Lang.StrictKind
    -- -@field private __Metatable metatable
    ---@field private __GeneratedClasses table<Luva.Type[], Luva.Type> # if it finds something here, it will use it instead of creating
    ---@field private __Template Luva.Lang.Template
    ---@field private __Class Luva.Type # Class without defined generics, for TEMPLATE DUHH
    local __templatetype
end

--- Generates a standard class from a generic class
---@param template Luva.TemplateType
---@return Luva.Type
---@nodiscard
function _generateFromTemplate(template)
    -- ta sama funkcja co w SecuredObject będzie tworzyć
    -- na podstawie decyzji, czy zrobić
    -- static class czy instance class
end