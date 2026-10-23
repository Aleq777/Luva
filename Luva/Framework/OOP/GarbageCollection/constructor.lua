
---@diagnostic disable : lowercase-global

---@module "Luva.Framework.OOP.GarbageCollection.default"
default = dofile ("Luva/Framework/OOP/GarbageCollection/default.lua")

do

    ---@alias Luva.DefaultConstructor fun()

    ---@generic TResultClass
    ---@alias Luva.BuildConstructor fun(setPrototype: fun(proto: TResultClass), ...: any[])



    ---@generic TResultClass
    ---@class Luva.ClassConstructor
    ---@field public __BuildConstructor Luva.BuildConstructor<TResultClass>
    ---@field public __DefaultConstructor Luva.DefaultConstructor
    local __ClassConstructor = { }
end




---@alias Luva.ConstructorExpression "__Constructor"
---@type Luva.ConstructorExpression
constructor = "__Constructor"


---@param resultClass Luva.Type
local function _appendDefault(resultClass)

    ---@type fun()
    local def = resultClass[default]
    if def == nil then
        return
    end

    resultClass.__Constructor.__DefaultConstructor = def    ---@diagnostic disable-line : invisible
end




---@param resultClass Luva.Type
---@param proto Luva.ClassPrototypeCreator
local function _construct(resultClass, proto, ...)
    local instance = Luva.Utils.Copy( resultClass.__Prototype.__PrototypeMethods )  ---@diagnostic disable-line : invisible

    for fieldName, fieldRecord in pairs( resultClass.__Prototype.__PrototypeFields ) do ---@diagnostic disable-line : invisible
        if proto[fieldName] then
            instance[fieldName] = proto[fieldName]
        else
            instance[fieldName] = Luva.Utils.Copy(fieldRecord.__DefaultValue)
        end
    end

    setmetatable(instance, resultClass.__Prototype.__MetaPrototype) ---@diagnostic disable-line : invisible
    return instance
end




---@param resultClass Luva.Type
local function _appendBuild(resultClass)

    local constr = resultClass[constructor]
    local constrResult

    -- Real constructor
    if constr then

        constrResult = function (...)
            local proto
            constr(function (protoObject)
                proto = protoObject
            end)

            return _construct(resultClass, proto, ...)
        end

    else -- Manual build

        constrResult = function (proto)
            _construct(resultClass, proto)
        end

    end

    resultClass.__Constructor.__BuildConstructor = constrResult   ---@diagnostic disable-line : invisible
end



---@param resultClass Luva.Type
function _AppendConstructorCreator(resultClass)
    _appendDefault(resultClass)
    _appendBuild(resultClass)
end


return constructor, _AppendConstructorCreator