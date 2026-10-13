
---@diagnostic disable : lowercase-global

_ProhibitUndefinedIndex, _ProhibitNewIndex = dofile("Luva/Framework/OOP/identifierProhibition.lua")

prototype, __AppendPrototypeCreator = dofile("Luva/Framework/OOP/prototype.lua")


do

    ---@class Luva.ClassCreator
    local __ClassCreator = { }


    ---@class Luva.Type
    ---@field private __MetaClass metatable
    ---@field private __Prototype Luva.ClassPrototype|nil
    ---@field private __Type "Luva.Type"
    local __LuvaType = { }

end


--- Creates a class
---@generic TResultClass : Luva.Type
---@param classCreator Luva.ClassCreator
---@return TResultClass
function class(classCreator)

    ---@type Luva.Type
    local resultClass = {
        __MetaClass = {
            __index = _ProhibitUndefinedIndex,
            __newindex = _ProhibitNewIndex
        },
        __Type = "Luva.Type"
    }

    -- Has a prototype? (+ constructors and destructors)
    __AppendPrototypeCreator(resultClass, classCreator)

    setmetatable(resultClass, resultClass.__MetaClass)      ---@diagnostic disable-line : invisible
    return resultClass
end

Master = class { }

Human = class {
    [prototype] = {
        Name = "john",
        Age = 10,
        Greet = function (self)
            print("Hello, " .. self.Name)
        end
    }
}

MooseMan = Human {
    Name = "moose man",
    Age = 17,
}

print(MooseMan.Name)


return class