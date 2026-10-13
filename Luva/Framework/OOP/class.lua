
---@diagnostic disable : lowercase-global

---@module "Framework.OOP.prototype"
---@module "Framework.OOP.constructor"

prototype, __AppendPrototypeCreator, _ProhibitUndefinedIndex, _ProhibitNewIndex = dofile("Luva/Framework/OOP/prototype.lua")   ---@diagnostic disable-line : unbalanced-assignments
constructor = dofile("Luva/Framework/OOP/constructor.lua")



do


    ---@class Luva.ClassCreator
    ---@field public [Luva.PrototypeExpression] Luva.ClassPrototypeCreator|nil
    ---@field public [Luva.ConstructorExpression] Luva.ClassConstructorCreator|nil
    local __ClassCreator = { }


    ---@class Luva.Type
    ---@field private __MetaClass metatable
    ---@field private __Prototype Luva.ClassPrototype|nil
    ---@field private __Constructor Luva.ClassConstructor|nil
    local __LuvaType = { }

end




--- Create a class
---@param classCreator Luva.ClassCreator
---@return Luva.Type
class = function(classCreator)

    ---@type Luva.Type
    local resultClass = {
        __MetaClass = {
            __index = _ProhibitUndefinedIndex,
            __newindex = _ProhibitNewIndex
        }
    }


    -- Has prototype?
    __AppendPrototypeCreator(resultClass, classCreator)


    setmetatable(resultClass, resultClass.__MetaClass)              ---@diagnostic disable-line : invisible
    return resultClass
end




Human = class {
    [prototype] = function (name, age)
        return {
            Name = name,
            Age = age
        }
    end,
    [constructor] = function (...)
        
    end
}

MooseMan = Human {
    Name = "moose man",
    Age = 17
}
