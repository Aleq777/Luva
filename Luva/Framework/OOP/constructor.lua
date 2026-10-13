
---@diagnostic disable : lowercase-global

---@generic TNewInstance
---@alias Luva.Constructor fun(getPrototypeFields: Luva.ClassPrototype.PrototypeGetter, ...: any[]): TNewInstance

---@alias Luva.ConstructorExpression Luva.Keyword<"constructor">


do

    ---@generic TNewInstance
    ---@class Luva.ClassConstructor
    ---@field public __DefaultConstructor fun(): TNewInstance
    ---@field public __BuildConstructor fun(...: Luva.ClassPrototypeFields<TNewInstance>|any[]): TNewInstance
    local __ClassConstructor = { }

end

---@type Luva.ConstructorExpression
constructor = { }


---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
function _AppendConstructorCreator(resultClass, classCreator)

    ---@type Luva.Constructor
    local constr = classCreator[constructor]
    
    -- finish constructors!!!
end

return constructor, _AppendConstructorCreator