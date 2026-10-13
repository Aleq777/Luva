
---@diagnostic disable : lowercase-global

_ProhibitUndefinedIndex, _ProhibitNewIndex = dofile("Luva/Framework/OOP/identifierProhibition.lua")


do

    ---@class Luva.ClassPrototype.FieldType
    ---@field public __Type Luva.Type|type
    ---@field public __DefaultValue any|nil
    local __FieldType = { }


    ---@generic TNewClassInstance
    ---@alias Luva.ClassPrototypeCreator table<string, Luva.Type|type|any|fun(self: TNewClassInstance, ...: any[]): any|nil, ...>

    ---@generic TNewClassInstance
    ---@class Luva.ClassPrototype
    ---@field public __PrototypeFields table<string, Luva.ClassPrototype.FieldType>
    ---@field public __PrototypeMethods table<string, fun(self: TNewClassInstance, ...: any[]): any|nil, ...>
    ---@field public __MetaPrototype metatable
    local __ClassPrototype = { }

end

---@alias Luva.PrototypeExpression Luva.Keyword<"prototype">

---@type Luva.PrototypeExpression
prototype = { }



---@param classProto Luva.ClassPrototype
---@param prototypeCreator Luva.ClassPrototypeCreator
local function _appendFieldsAndMethods(classProto, prototypeCreator)
    for fieldName, fieldTypeOrFunc in pairs(prototypeCreator) do
        if type (fieldTypeOrFunc) == "function" then
            classProto.__PrototypeMethods[fieldName] = fieldTypeOrFunc
        elseif type (fieldTypeOrFunc) == "table" then
            ---@diagnostic disable : invisible
            if fieldTypeOrFunc.__Type == "Luva.Type" then
                -- no prototype - static class
                if fieldTypeOrFunc.__Prototype == nil then
                    error("Cannot use a static class as a field type! Field: " .. fieldName)
                end

                classProto.__PrototypeFields[fieldName] = {
                    __Type = fieldTypeOrFunc, -- Luva class
                    __DefaultValue = fieldTypeOrFunc() -- Luva class'es default
                }
            ---@diagnostic enable : invisible
            else
                classProto.__PrototypeFields[fieldName] = {
                    __Type = "table",
                    __DefaultValue = fieldTypeOrFunc -- reference to the table (will be copied from now on)
                }
            end
        elseif type (fieldTypeOrFunc) == "thread" or type (fieldTypeOrFunc) == "userdata" then
            error("Unsupported type (thread or userdata) for field: " .. fieldName)
        else
            classProto.__PrototypeFields[fieldName] = {
                __Type = type (fieldTypeOrFunc), -- Lua type
                __DefaultValue = fieldTypeOrFunc -- Lua scalar value
            }
        end
    end
end



---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
function __AppendPrototypeCreator(resultClass, classCreator)

    ---@type Luva.ClassPrototypeCreator
    local prototypeCreator = classCreator[prototype]
    if not prototypeCreator then
        return
    end

    resultClass.__Prototype = { ---@diagnostic disable-line : invisible
        __PrototypeFields = { },
        __PrototypeMethods = { },
        __MetaPrototype = {
            __index = _ProhibitUndefinedIndex,
            __newindex = _ProhibitNewIndex
        }
    }

    ---@type Luva.ClassPrototype
    local classProto = resultClass.__Prototype ---@diagnostic disable-line : invisible


    _appendFieldsAndMethods(classProto, prototypeCreator)

end


return prototype, __AppendPrototypeCreator