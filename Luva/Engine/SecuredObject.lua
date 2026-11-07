
---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.kind"
---@module "Luva.Engine.utils"
_LUVA.Utils = dofile ("Luva/Engine/utils.lua")

do
    ---@class Luva.Lang.Security
    ---@field public Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<any>>
    ---@field public IsEnabled boolean
    local __security
    
    ---@class Luva.Lang.SecuredObject : Luva.Lang.StrictKind
    ---@field protected IsSecured fun(self: Luva.Lang.SecuredObject): boolean
    ---@field protected AddMetamethod fun(self: Luva.Lang.SecuredObject, metaname: Luva.Lang.Identifier, metamethod: function)
    ---@field protected UpdateMetatable fun(self: Luva.Lang.SecuredObject)
    ---@field private __Security Luva.Lang.Security
    ---@field private __Metatable metatable
    local __securedObject
end





_LUVA.Errors.UNDEFINED_FIELD = "Tried to access undefined field"
_LUVA.Errors.ASSIGNED_NIL = "Tried to assign nil (remove property). Use empty instead"



---@generic TChild : Luva.Object
---@generic TField
---@param obj Luva.Lang.SecuredObject
---@param index any
---@param value TField
---@param notNil boolean
---@param action fun(field: TField|nil): TField|nil
---@param actionAccessor nil|fun(v: Luva.Lang.Accessor<TChild, TField>): TField|nil
---@return TField|nil
local function _fieldBase(obj, index, value, notNil, action, actionAccessor)
    if notNil then
        if value == nil then
            error(_LUVA.Errors.ASSIGNED_NIL)
        end
    end

    local field = rawget(obj, index)
    if field ~= nil then
        return action(field)
    end

    if actionAccessor then
        for k, v in pairs(obj.__Security.Accessors) do  ---@diagnostic disable-line : invisible
            if index == k then
                return actionAccessor(v)
            end
        end
    end

    error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
end


---@param obj Luva.Lang.SecuredObject
---@param index any
---@param hasAccessor boolean|nil
---@return any
---@nodiscard
local function _fieldGet(obj, index, hasAccessor)
    local acc = nil

    if hasAccessor then
        acc = function (v)
            return v:get()
        end
    end

    return _fieldBase(obj, index, nil, false, function (field)
        return field
    end, acc)
end

---@param obj Luva.Lang.SecuredObject
---@param index any
---@param value any
---@param hasAccessor boolean|nil
local function _fieldSet(obj, index, value, hasAccessor)
    local acc = nil

    if hasAccessor then
        acc = function (v)
            v:set(value)
        end
    end

    _fieldBase(obj, index, value, true, function (field)
        rawset(obj, index, value)
    end, acc)
end




---@param obj table
---@param metatable metatable
local function _secure(obj, metatable)
    _LUVA.Utils.SafeInjectRef(obj, {
        IsSecured = function (self)
            return self.__Security.IsEnabled    ---@diagnostic disable-line : invisible
        end,

        UpdateMetatable = function (self)
            setmetatable(self)
            setmetatable(self, self.__Metatable)    ---@diagnostic disable-line : invisible
        end,

        AddMetamethod = function (self, metaname, metamethod)
            local meta = _LUVA.Utils.Copy(self.__Metatable) ---@diagnostic disable-line : invisible
            _LUVA.Utils.SafeInjectRef(meta, { [metaname] = metamethod })
            self.__Metatable = meta ---@diagnostic disable-line : invisible
            self:UpdateMetatable()  ---@diagnostic disable-line : invisible
        end,

        __Security = {
            Accessors = { },
            IsEnabled = true
        },

        __Metatable = metatable,

        __Kind = "Luva.Lang.SecuredObject"
    } --[[@as Luva.Lang.SecuredObject]])

    ---@cast obj Luva.Lang.SecuredObject
    obj:UpdateMetatable()   ---@diagnostic disable-line : invisible
end




_LUVA.SecuredObject = {

    ---@type table<string, metatable>
    Metatables = {
        Basic = {
            ---@param self Luva.Lang.SecuredObject
            ---@param index any
            ---@return any
            __index = function (self, index)
                return _fieldGet(self, index)
            end,

            ---@param self Luva.Lang.SecuredObject
            ---@param index any
            ---@param value any
            __newindex = function (self, index, value)
                _fieldSet(self, index, value)
            end
        },

        WithAccessors = {
            ---@param self Luva.Lang.SecuredObject
            ---@param index any
            ---@return any
            __index = function (self, index)
                return _fieldGet(self, index, true)
            end,

            ---@param self Luva.Lang.SecuredObject
            ---@param index any
            ---@param value any
            __newindex = function (self, index, value)
                _fieldSet(self, index, value, true)
            end
        },

        -- can have instances
        ClassNonStatic = {
            ---@param self Luva.Lang.SecuredObject
            ---@param index any
            ---@return any
            __index = function (self, index)
                return _fieldGet(self, index)
            end,

            ---@param self Luva.Lang.SecuredObject
            ---@param index any
            ---@param value any
            __newindex = function (self, index, value)
                _fieldSet(self, index, value)
            end,

            ---@generic TChild : Luva.Object
            ---@param self Luva.Type<TChild>
            ---@param ... any[]
            ---@return TChild
            ---@nodiscard
            __call = function (self, ...)
                return self:__InvokeConstructor(...)   ---@diagnostic disable-line : invisible
            end
        },
    },

    --- Overrides `obj` to become a SecuredObject <br />
    --- This means that you cannot use undefined fields <br />
    ---@param obj table
    Secure = function (obj)
        _secure(obj, _LUVA.SecuredObject.Metatables.Basic)
    end,

    --- Overrides `obj` to become a SecuredObject <br />
    --- This means that you cannot use undefined fields <br />
    ---@generic TChild : Luva.Object
    ---@param obj TChild
    ---@param operators metatable
    ---@param accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<TChild, any>>
    SecureInstance = function (obj, operators, accessors)
        local meta = _LUVA.Utils.Copy(_LUVA.SecuredObject.Metatables.WithAccessors)

        _LUVA.Utils.SafeInjectRef(meta, operators)

        -- Zmień:
        -- Ma szukać akcesorów w typie za pomocą typeof(obj).__Prototype.Accessors!!!
        -- Koniec z akcesorami w SecuredObject
        obj.__Security.Accessors = accessors    ---@diagnostic disable-line : invisible

        _secure(obj, meta)
    end,

    --- Overrides `obj` to become a SecuredObject <br />
    --- This means that you cannot use undefined fields <br />
    ---@generic TChild : Luva.Object
    ---@param obj Luva.Type<TChild>
    SecureClassInstanciable = function (obj)
        _secure(obj, _LUVA.SecuredObject.Metatables.ClassNonStatic)
    end,

    --- Lets `func` use self object without Security <br />
    --- <b>USING THIS FUNCTION IS NOT RECOMMENDED - LUVA ALREADY HANDLES EVERYTHING</b>
    ---@param obj Luva.Lang.SecuredObject
    ---@param func fun()
    ---@return any|nil
    Unsafe = function (obj, func)
        obj.__Enabled = false   ---@diagnostic disable-line : invisible
        setmetatable(obj, nil)
            local result = func()
        obj.__Enabled = true    ---@diagnostic disable-line : invisible
        setmetatable(obj, _LUVA.SecuredObject.SecureMetatable)

        return result
    end,
}




return _LUVA