
---@diagnostic disable : lowercase-global



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


---@alias Luva.ConstructorExpression Luva.Keyword<"constructor">


---@type Luva.ConstructorExpression
constructor = { }



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
---@param constr Luva.BuildConstructor|nil
---@param proto Luva.ClassPrototypeCreator|nil
local function _construct(resultClass, constr, proto, ...)
    local instance = Luva.Utils.Copy( resultClass.__Prototype.__PrototypeMethods )  ---@diagnostic disable-line : invisible

    if proto == nil and constr ~= nil then
        ---@param protoObject Luva.ClassPrototypeCreator
        constr(function (protoObject)
            proto = protoObject
        end, ...)
    end

    ---@diagnostic disable : need-check-nil
    for fieldName, fieldRecord in pairs( resultClass.__Prototype.__PrototypeFields ) do ---@diagnostic disable-line : invisible
        if proto[fieldName] then
            instance[fieldName] = proto[fieldName]
        else
            instance[fieldName] = Luva.Utils.Copy(fieldRecord.__DefaultValue)
        end
    end
    ---@diagnostic enable : need-check-nil

    setmetatable(instance, resultClass.__Prototype.__MetaPrototype) ---@diagnostic disable-line : invisible
    return instance
end




---@param resultClass Luva.Type
local function _appendBuild(resultClass)

    local constr = resultClass[constructor]
    ---@type Luva.BuildConstructor
    local constrResult

    -- Real constructor
    if constr then
        constrResult = function (...)
            return _construct(resultClass, constr, nil, ...)
        end
    else -- Manual build
        constrResult = function (proto)
            _construct(resultClass, nil, proto)
        end
    end

    resultClass.__Constructor.__BuildConstructor = constrResult   ---@diagnostic disable-line : invisible
end



---@param resultClass Luva.Type
function _AppendConstructorCreator(resultClass)
    _appendDefault(resultClass)
    _appendBuild(resultClass)
end