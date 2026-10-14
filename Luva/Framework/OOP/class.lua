
---@diagnostic disable : lowercase-global

_ProhibitUndefinedIndex, _ProhibitNewIndex = dofile("Luva/Framework/OOP/identifierProhibition.lua")

prototype, _AppendPrototypeCreator = dofile("Luva/Framework/OOP/prototype.lua")


do

    ---@alias Luva.ClassCreator table<Luva.PrototypeExpression, any>



    ---@class Luva.Type
    ---@field private __MetaClass metatable
    ---@field private __Prototype Luva.ClassPrototype|nil
    ---@field private __Constructor Luva.ClassConstructor|nil
    ---@field private __Type "Luva.Type"
    local __LuvaType = { }

end



---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
function _AppendStatics(resultClass, classCreator)
    for k, v in pairs(classCreator) do
        if type (k) == "string" then
            resultClass[k] = v
        end
    end
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

    -- refactor as fields !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- Appends static fields and functions
    _AppendStatics(resultClass, classCreator)

    -- Has a prototype? (+ constructors and destructors)
    _AppendPrototypeCreator(resultClass, classCreator)

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
    },
    [default] = function (setPrototype)
        Human.Count = Human.Count + 1
        setPrototype { }
    end,
    [constructor] = function (setPrototype, name, age)
        setPrototype {
            Name = name,
            Age = age
        }
    end,
    Count = 0,
    Greet = function (human)
        
    end
}

MooseMan = Human {
    Name = "moose man",
    Age = 17,
}


return class