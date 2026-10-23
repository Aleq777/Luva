
---@diagnostic disable : lowercase-global

---@module "OOP.default"
default = dofile ("Luva/Framework/OOP/default.lua")
---@module "OOP.constructor"
constructor, _AppendConstructorCreator = dofile ("Luva/Framework/OOP/constructor.lua")
---@module "OOP.destructor"
destructor, _AppendDestructorCreator = dofile ("Luva/Framework/OOP/destructor.lua")



do

    ---@alias Luva.ClassPrototypeCreator table<string, any>

    ---@generic T
    ---@class Luva.ClassPrototype.FieldRecord
    ---@field public __Type Luva.Type|type
    ---@field public __DefaultValue T
    local __FieldRecord = { }


    ---@generic TInstance : Luva.Object
    ---@class Luva.ClassPrototype
    ---@field public __PrototypeMethods table<string, fun(self: TInstance, ...: any[]): any|nil, ...>
    ---@field public __PrototypeFields table<string, Luva.ClassPrototype.FieldRecord<any>>
    ---@field public __PrototypeFieldsDefault table<string, any>
    ---@field public __MetaPrototype metatable
    local __Prototype = { }

end





-- -@alias Luva.PrototypeExpression Luva.Keyword<"prototype">
---@alias Luva.PrototypeExpression "__Prototype"
---@type Luva.PrototypeExpression
prototype = "__Prototype"






---@generic TInstance : Luva.Object
---@param classPrototype Luva.ClassPrototype<TInstance>
---@param fieldName string
---@param fieldCreatorContent any
local function _appendPrototypeField(classPrototype, fieldName, fieldCreatorContent)

    local fieldCreatorType = type (fieldCreatorContent)
    local prototypeFields = classPrototype.__PrototypeFields

    switch (fieldCreatorType, {

        ["function"] = function ()
            classPrototype.__PrototypeMethods[fieldName] = fieldCreatorContent
        end,

        ["table"] = function ()
            -- Type
            if fieldCreatorContent.__Type == "Luva.Type" then

                prototypeFields[fieldName] = {
                    __Type = fieldCreatorContent,
                    __DefaultValue = fieldCreatorContent()
                } --[[@as Luva.ClassPrototype.FieldRecord<Luva.Object>]]

            else -- Value (copy)

                prototypeFields[fieldName] = {
                    __Type = "table",
                    __DefaultValue = Luva.Utils.Copy(fieldCreatorContent)
                } --[[@as Luva.ClassPrototype.FieldRecord<table>]]

            end
        end,

        ["thread"] = function ()
            error("Unsupported types: thread")
        end,

        ["userdata"] = function ()
            error("Unsupported types: userdata")
        end,

        [default] = function ()
            prototypeFields[fieldName] = {
                __Type = fieldCreatorType,
                __DefaultValue = fieldCreatorContent
            } --[[@as Luva.ClassPrototype.FieldRecord<nil|boolean|integer|number|string>]]
        end

    })
end





---@param classPrototype Luva.ClassPrototype
local function _createPrototypeFieldsDefault(classPrototype)
    local result = { }

    for fieldName, fieldRecord in pairs(classPrototype.__PrototypeFields) do
        result[fieldName] = fieldRecord.__DefaultValue
    end

    classPrototype.__PrototypeFieldsDefault = result
end




---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
function _AppendPrototypeCreator(resultClass, classCreator)

    ---@type Luva.ClassPrototypeCreator
    local proto = classCreator[prototype]   --[[@as Luva.ClassPrototypeCreator]]
    if not proto then
        return
    end

    resultClass.__Prototype = { ---@diagnostic disable-line : invisible
        __PrototypeMethods = {
            ---@type Luva.Type # exception - it is shared between all objects
            __Type = resultClass,

            ---@param self Luva.Object
            ---@return Luva.Type
            GetType = function (self)
                return self.__Type      ---@diagnostic disable-line : invisible
            end,
        },
        __PrototypeFields = { },
        __PrototypeFieldsDefault = nil,
        __MetaPrototype = {
            __index = _ProhibitUndefinedIndex,
            __newindex = _ProhibitNewIndex
        }
    }

    for fieldName, fieldCreatorContent in pairs(proto) do
        _appendPrototypeField(resultClass.__Prototype, fieldName, fieldCreatorContent)  ---@diagnostic disable-line : invisible
    end

    _createPrototypeFieldsDefault(resultClass.__Prototype)  ---@diagnostic disable-line : invisible

    _AppendConstructorCreator(resultClass)
    _AppendDestructorCreator(resultClass)

end




return prototype, _AppendPrototypeCreator