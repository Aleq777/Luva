
---@diagnostic disable : lowercase-global

---@module "Helper.identifierProhibition"
_ProhibitUndefinedIndex, _ProhibitNewIndex = dofile ("Luva/Framework/OOP/identifierProhibition.lua")
sfggfssfgs
---@module "Ingredients.prototype"
prototype, _AppendPrototypeCreator = dofile ("Luva/Framework/OOP/prototype.lua")


do

    ---@class Luva.ClassCreator
    ---@field public __Prototype Luva.ClassPrototypeCreator|nil
    ---@field public __Default Luva.DefaultConstructor|nil
    ---@field public __Constructor Luva.BuildConstructor|nil
    ---@field public __Destructor Luva.Destructor|nil
    local __ClassCreator = { }


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

    -- Appends static fields and functions
    _appendStatics(resultClass, classCreator)

    -- Has a prototype? (+ constructors and destructors)
    _AppendPrototypeCreator(resultClass, classCreator)

    _appendMetatable(resultClass)

    return resultClass
end






return class