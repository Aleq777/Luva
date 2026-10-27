
---@diagnostic disable : lowercase-global

---@module "Luva.Framework.OOP.Helper.identifierProhibition"
_ProhibitUndefinedIndex, _ProhibitNewIndex = dofile ("Luva/Framework/OOP/Helper/identifierProhibition.lua")

---@module "Luva.Framework.OOP.Ingredients.prototype"
prototype, _AppendPrototypeCreator = dofile ("Luva/Framework/OOP/Ingredients/prototype.lua")

---@module "Luva.Framework.OOP.Ingredients.meta"
_AppendMetatable = dofile ("Luva/Framework/OOP/Ingredients/meta.lua")

do

    ---@class Luva.ClassCreator
    ---@field public __Prototype Luva.ClassPrototypeCreator|nil
    ---@field public __Default Luva.DefaultConstructorCreator|nil
    ---@field public __Constructor Luva.BuildConstructorCreator|nil
    ---@field public __Destructor Luva.ClassDestructor|nil
    local __ClassCreator = { }


    ---@class Luva.Type
    ---@field private __Prototype Luva.ClassPrototype|nil
    ---@field private __Constructor Luva.ClassConstructor|nil
    ---@field private __Destructor Luva.ClassDestructor|nil
    ---@field private __Meta metatable|nil Only for instance-classes - individual metatable. Static classes have mutual extern metatable
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

    -- Appends static fields and functions
    _appendStatics(resultClass, classCreator)

    -- Has a prototype? (+ constructors and destructors)
    _AppendPrototypeCreator(resultClass, classCreator)

    return resultClass
end



Human = class {
    [prototype] = {
        Name = "john",
        Age = 10
    }
}

local x = Human {
    Name = "aa",
    Age = 100
}

print(x.Name)


return class, _AppendMetatable