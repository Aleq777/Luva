

---@generic TInstance : Luva.Object
---@alias Luva.Lang.PostDefaultConstructorCaller fun(self: TInstance)

---@generic TInstance : Luva.Object
---@alias Luva.Lang.DefaultConstructor fun(_class: Luva.Type): TInstance

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassConstructors
    ---@field public DefaultCaller fun(self: TInstance)
    ---@field public DefaultConstructor fun(_class: Luva.Type): TInstance
    ---@field public CustomConstructor nil|fun(_class: Luva.Type, ...: any[]): TInstance
    local __constructors
end

---@param _class Luva.Type
---@param ... any[]
---@return Luva.Object
---@nodiscard
function _LUVA._GeneralConstructor(_class, ...)

    ---@type Luva.Object
    local instance = { }    ---@diagnostic disable-line : missing-fields

    local proto = _class.__Prototype --[[@as Luva.Lang.ClassPrototype]] ---@diagnostic disable-line : invisible


    -- _LUVA.SecuredObject.Secure(instance, "InstanceBase", proto.PrototypeMetatable)
    _LUVA.SecuredObject.SecureInstance(instance, proto.PrototypeMetatable)

    _LUVA.Utils.SafeInjectRef(instance.__Methods, { ---@diagnostic disable-line : invisible
    })

    _LUVA.Utils.SafeInjectRef(instance.__Constants, {   ---@diagnostic disable-line : invisible
        -- __Type = _LUVA._ParseConstant(_class)
        __Type = {
            __Kind = "const",
            Value = _class,
            Type = "table",
            IsByRef = true
        } --[[@as Luva.Lang.Field]]
    })

    for identifier, content in pairs(proto.Fields) do
        instance.__Fields[identifier] = _LUVA.Utils.Copy(content)   ---@diagnostic disable-line : invisible
    end

    -- for identifier, content in pairs(proto.Readonlys) do
    --     instance.__Fields[identifier] = _LUVA.Utils.Copy(content)    ---@diagnostic disable-line : invisible
    -- end

    -- by ref
    instance.__Methods = proto.Methods  ---@diagnostic disable-line : invisible
    -- by ref
    instance.__Accessors = proto.Accessors  ---@diagnostic disable-line : invisible

    return instance
end

---@generic TInstance : Luva.Object
---@param constructorsRef Luva.Lang.ClassConstructors<TInstance>
---@param func fun(setPrototype: fun(obj: table), ...: any[])
function _LUVA._SetupConstructor(constructorsRef, func)
    constructorsRef.CustomConstructor = function (_class, ...)
        local instance = _LUVA._GeneralConstructor(_class)
        func(function (obj)
            for k, v in pairs(obj) do
                instance[k] = v
            end
        end, ...)

        return instance
    end
end



---@generic TInstance : Luva.Object
---@param constructors Luva.Lang.ClassConstructors<TInstance> Reference to class'es constructors
---@param defaultCaller fun(self: TInstance)|nil
function _LUVA._SetupDefaultConstructorAndMaybeCaller(constructors, defaultCaller)
    constructors.DefaultCaller = defaultCaller or function (instance) end

    ---@type Luva.Lang.DefaultConstructor    
    constructors.DefaultConstructor = function (_class)
        local instance = _LUVA._GeneralConstructor(_class)
        _class.__Constructors.DefaultCaller(instance)   ---@diagnostic disable-line : invisible
        return instance
    end
end

---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
function _LUVA._SetupConstructorBase(resultClass)
    rawset(resultClass, "__Constructors", {
        DefaultConstructor = nil, ---@diagnostic disable-line : assign-type-mismatch
        DefaultCaller = nil,    ---@diagnostic disable-line : assign-type-mismatch
        CustomConstructor = nil
    } --[[@as Luva.Lang.ClassConstructors]])
end