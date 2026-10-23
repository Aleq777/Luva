
---@diagnostic disable : lowercase-global


---@module "Luva.Framework.OOP.GarbageCollection.default"
default = dofile ("Luva/Framework/OOP/GarbageCollection/default.lua")


do
    

    ---@generic TResultInstance : Luva.Object
    ---@alias Luva.ManualConstructor fun(proto: TResultInstance): TResultInstance


    ---@generic TResultInstance : Luva.Object
    ---@alias Luva.RealConstructor fun(...: any[]): TResultInstance

    ---@generic TResultInstance : Luva.Object
    ---@alias Luva.DefaultConstructor fun(): TResultInstance



    ---@generic TResultInstance : Luva.Object
    ---@alias Luva.DefaultConstructorCreator fun(setPrototype: fun(proto: TResultInstance))

    ---@generic TResultInstance : Luva.Object
    ---@alias Luva.BuildConstructorCreator fun(setPrototype: fun(proto: TResultInstance), ...: any[])


    ---@class Luva.ClassConstructor
    ---@field public __ManualConstructor Luva.ManualConstructor|nil
    ---@field public __RealConstructor Luva.RealConstructor|nil
    ---@field public __DefaultConstructor Luva.DefaultConstructor
    local __ClassConstructor = { }

end



---@alias Luva.ConstructorExpression "__Constructor"
---@type Luva.ConstructorExpression
constructor = "__Constructor"


---@generic TResultInstance : Luva.Object
---@param resultClass Luva.Type
---@param proto TResultInstance
---@return TResultInstance
---@nodiscard
local function _construct(resultClass, proto)
    ---@generic TResultInstance : Luva.Object
    ---@type TResultInstance
    local instance = Luva.Utils.Copy( resultClass.__Prototype.__PrototypeMethods )  ---@diagnostic disable-line : invisible

    for fieldName, fieldRecord in pairs( resultClass.__Prototype.__PrototypeFields ) do ---@diagnostic disable-line : invisible
        if proto[fieldName] then
            instance[fieldName] = proto[fieldName]
        else
            instance[fieldName] = Luva.Utils.Copy( fieldRecord.__DefaultValue )
        end
    end

    setmetatable(instance, resultClass.__Prototype.__MetaPrototype) ---@diagnostic disable-line : invisible
    return instance
end


---@param resultClass Luva.Type
---@return Luva.DefaultConstructor
---@nodiscard
local function _getDefault(resultClass)
    ---@type Luva.DefaultConstructorCreator
    local def = resultClass[default]
    ---@type Luva.DefaultConstructor
    local resultDefault
    if def then
        resultDefault = function ()
            local protoResult
            def(function (proto) -- setPrototype()
                protoResult = proto
            end)

            return _construct(resultClass, protoResult)
        end
    else
        resultDefault = function ()
            return _construct(resultClass, { })
        end
    end

    return resultDefault
end


---@generic TResultInstance : Luva.Object
---@param resultClass Luva.Type
---@param hasReal boolean
---@return Luva.ManualConstructor<TResultInstance>|nil
---@nodiscard
local function _getManual(resultClass, hasReal)
    if hasReal then
        return nil
    end

    ---@generic TResultInstance : Luva.Object
    ---@type Luva.ManualConstructor<TResultInstance>
    return function (proto)
        return _construct(resultClass, proto)
    end
end



---@generic TResultInstance : Luva.Object
---@param resultClass Luva.Type
---@param hasReal boolean
---@return Luva.RealConstructor<TResultInstance>|nil
local function _getReal(resultClass, hasReal)
    if not hasReal then
        return nil
    end

    ---@type Luva.BuildConstructorCreator
    local real = resultClass[constructor]

    ---@generic TResultInstance : Luva.Object
    ---@type Luva.RealConstructor<TResultInstance>
    return function (...)
        local protoResult
        real(function (proto) -- setPrototype()
            protoResult = proto
        end, ...)

        return _construct(resultClass, protoResult)
    end
end


---@param resultClass Luva.Type
function _AppendConstructorCreator(resultClass)
    local hasReal = resultClass[constructor] and true or false

    resultClass.__Constructor = {   ---@diagnostic disable-line : invisible
        __DefaultConstructor = _getDefault(resultClass),
        __ManualConstructor = _getManual(resultClass, hasReal),
        __RealConstructor = _getReal(resultClass, hasReal)
    }

    local constr = resultClass.__Constructor --[[@as Luva.ClassConstructor]]    ---@diagnostic disable-line : invisible

    resultClass.__Meta.__call = function (t, ...)   ---@diagnostic disable-line : invisible
        local args = { ... }

        if #args == 0 then
            return constr.__DefaultConstructor()
        end

        if constr.__RealConstructor then
            return constr.__RealConstructor(...)
        else
            return constr.__ManualConstructor(args[0])
        end
    end
end


return constructor, _AppendConstructorCreator