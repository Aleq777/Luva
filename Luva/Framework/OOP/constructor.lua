

---@alias Luva.ConstructorExpression Luva.Keyword


do

    ---@generic TResult
    ---@alias Luva.ClassConstructorCreator fun(...: any): TResult

    ---@generic TResult
    ---@class Luva.ClassConstructor
    ---@field private __DefaultConstructor fun(self: Luva.Type): TResult
    ---@field private __BuildConstructor fun(self: Luva.Type, ...: any): TResult
    local __ClassConstructor
end



---@type Luva.ConstructorExpression
constructor = { }





---@param resultClass Luva.Type
---@param classCreator Luva.ClassCreator
function __AppendConstructor(resultClass, classCreator)

    resultClass.__Constructor = {       ---@diagnostic disable-line : invisible
        __BuildConstructor = nil,
        __DefaultConstructor = nil
    }

    local constr = classCreator[constructor]

    -- not
    resultClass.__Constructor.__BuildConstructor = function (self, prototypeFields) ---@diagnostic disable-line : invisible
        -- inject methods
        local instance = resultClass.__Prototype.__PrototypeMethods                 ---@diagnostic disable-line : invisible
        
        -- Inject fields
        for field, value in pairs(prototypeFields) do
            -- is field correct
            -- if Luva.Utils.Has(resultClass.__Prototype.)
            instance[field] = value
        end
        
        setmetatable(instance, resultClass.__Prototype.__MetaPrototype)     ---@diagnostic disable-line : invisible
        return instance
    end


    resultClass.__MetaClass.__call = function (self, ...)   ---@diagnostic disable-line : invisible
        local args = { ... }

        if #args == 0 then
            return resultClass.__Constructor.__DefaultConstructor(resultClass)  ---@diagnostic disable-line : invisible
        else
            return resultClass.__Constructor.__BuildConstructor(resultClass, ...)   ---@diagnostic disable-line : invisible
        end
    end
end


return constructor, __AppendConstructor