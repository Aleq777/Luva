
---@diagnostic disable : lowercase-global

_ProhibitUndefinedIndex, _ProhibitNewIndex = dofile("Luva/Framework/OOP/identifierProhibition.lua")

prototype, _AppendPrototypeCreator = dofile("Luva/Framework/OOP/prototype.lua")

---@alias Luva.ClassCreator
---| { [Luva.PrototypeExpression]: Luva.ClassPrototypeCreator }
---| { [Luva.DefaultExpression]: Luva.DefaultConstructor }
---| { [Luva.ConstructorExpression]: Luva.BuildConstructor }
---| { [Luva.DestructorExpression]: Luva.Destructor }
---| ...

do

    -- ---@alias Luva.ClassCreator table<Luva.PrototypeExpression, any>




    ---@class Luva.Type
    ---@field private __Prototype Luva.ClassPrototype|nil
    ---@field private __Constructor Luva.ClassConstructor|nil
    ---@field private __Type "Luva.Type"
    local __LuvaType = { }

end



---@type table<string, metatable>
__MetaType = {
    Static = {
        __index = _ProhibitUndefinedIndex,
        __newindex = _ProhibitNewIndex,
    },
    WithPrototype = {
        __index = _ProhibitUndefinedIndex,
        __newindex = _ProhibitNewIndex,
        __call = nil,
    },
}

---@param resultClass Luva.Type
local function _appendMetatable(resultClass)
    local meta
    if resultClass[prototype] then
        meta = __MetaType.WithPrototype
    else
        meta = __MetaType.Static
    end

    setmetatable(resultClass, meta)
end


---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
local function _appendStatics(resultClass, classCreator)
    for k, v in pairs(classCreator) do
        if type (k) == "string" then
            resultClass[k] = v
        end
    end
end


---@generic TResultClass : Luva.Type
---@alias Luva.ClassExpression fun(classCreator: Luva.ClassCreator): TResultClass Creates a class

--- Creates a class
---@generic TResultClass : Luva.Type
---@param classCreator Luva.ClassCreator
---@return TResultClass
---@type Luva.ClassExpression
function class(classCreator)

    ---@type Luva.Type
    local resultClass = {
        __Type = "Luva.Type"
    }

    -- refactor as fields !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- Appends static fields and functions
    _appendStatics(resultClass, classCreator)

    -- Has a prototype? (+ constructors and destructors)
    _AppendPrototypeCreator(resultClass, classCreator)

    _appendMetatable(resultClass)

    return resultClass
end



Master = class {

}




Human = class {
    [prototype] = {
        Name = "john",
        Age = 10,
        Greet = function (self)
            print("Hello, " .. self.Name)
        end
    },
    [default] = function ()
        Human.Count = Human.Count + 1
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