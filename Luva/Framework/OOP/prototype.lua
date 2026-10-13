
---@diagnostic disable : lowercase-global


constructor, __AppendConstructor = constructor or dofile("Luva/Framework/OOP/constructor.lua")  ---@diagnostic disable-line : unbalanced-assignments



do
    ---@alias Luva.ClassPrototypeCreator fun(...: any|nil): Luva.ClassPrototype

    ---@generic TNewClass
    ---@class Luva.ClassPrototype
    ---@field public __PrototypeFields table<string, any>
    ---@field public __PrototypeMethods table<string, fun(self: TNewClass, ...): any|nil>
    ---@field public __PrototypeCreator Luva.ClassPrototypeCreator
    ---@field public __MetaPrototype metatable
    local __ClassPrototype = { }

end



---@alias Luva.PrototypeExpression Luva.Keyword

---@type Luva.PrototypeExpression
prototype = { }


---@generic T
---@param self T
---@param identifier string
function _ProhibitUndefinedIndex(self, identifier)
    error("Undefined field: " .. identifier)
end



---@generic T
---@param self T
---@param identifier string
---@param value any
function _ProhibitNewIndex(self, identifier, value)
    error("Cannot define a new field outside of type's definition: " .. identifier)
end




---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
function __AppendPrototypeCreator(resultClass, classCreator)
    ---@type Luva.ClassPrototypeCreator
    local prototypeCreator = classCreator[prototype]

    if not prototypeCreator then
        return
    end


    resultClass.__Prototype = {                 ---@diagnostic disable-line : invisible
        __PrototypeFields = { },
        __PrototypeMethods = { },
        __PrototypeCreator = prototypeCreator,
        __MetaPrototype = {
            __index = _ProhibitUndefinedIndex,
            __newindex = _ProhibitNewIndex
        }
    }

    -- Does it have a constructor?
    __AppendConstructor(resultClass, classCreator)
end



return prototype, __AppendPrototypeCreator, _ProhibitUndefinedIndex, _ProhibitNewIndex