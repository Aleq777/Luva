
---@diagnostic disable : lowercase-global

---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.kind"
---@module "Luva.Engine.utils"
_LUVA.Utils = dofile ("Luva/Engine/utils.lua")

do
    ---@generic TChild
    ---@class Luva.Lang.Security
    ---@field public Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<TChild, any>>
    ---@field public IsEnabled boolean
    local __security
    
    ---@alias Luva.Lang.SafeMetaNames # for Luva.Lang.PseudoMetatable
    ---| "__add"
    ---| "__sub"
    ---| "__mul"
    ---| "__div"
    ---| "__unm"
    ---| "__mod"
    ---| "__pow"
    ---| "__eq"
    ---| "__lt"
    ---| "__le"
    ---| "__concat"
    ---| "__len"
    ---| "_index" is a part of __index secured
    ---| "_newindex" is a part of __newindex secured
    ---| "__call"

    ---@class Luva.Lang.PseudoMetatable : metatable
    ---@field public _index nil|fun(self: table, index: any): any
    ---@field public _newindex nil|fun(self: table, index: any, value: any)
    local __pseudo

    ---@generic TChild
    ---@class Luva.Lang.SecuredObject : Luva.Lang.StrictKind
    ---@field protected IsSecured fun(self: Luva.Lang.SecuredObject<TChild>): boolean
    ---@field protected AddMetamethod fun(self: Luva.Lang.SecuredObject<TChild>, metaname: Luva.Lang.SafeMetaNames, metamethod: function)
    ---@field protected AddAccessor fun(self: Luva.Lang.SecuredObject<TChild>, identifier: Luva.Lang.Identifier, accessor: Luva.Lang.Accessor<TChild, any>)
    ---@field protected UpdateMetatable fun(self: Luva.Lang.SecuredObject)
    ---@field private __Security Luva.Lang.Security<TChild, any>
    ---@field private __Metatable Luva.Lang.PseudoMetatable
    local __securedObject
end





_LUVA.Errors.UNDEFINED_FIELD = "Tried to access undefined field"
_LUVA.Errors.ASSIGNED_NIL = "Tried to assign nil (remove property). Use empty instead"


---@generic TChild : Luva.Object
---@param obj Luva.Lang.SecuredObject<TChild>
---@param index any
---@param action fun(field: any): any
---@param actionAcc fun(acc: Luva.Lang.Accessor<TChild, any>): any
---@param pseudoName "_index"|"_newindex"
---@param actionPseudo fun(pseudo: function)
local function _secureBase(obj, index, action, actionAcc, pseudoName, actionPseudo)
    local field = rawget(obj, index)
    if index ~= nil then
        return action(field)
    end

    local acc = obj.__Security.Accessors[index] ---@diagnostic disable-line : invisible
    if acc then
        return actionAcc(acc)
    end

    local pseudo = obj.__Metatable[pseudoName]  ---@diagnostic disable-line : invisible
    if pseudo then
        return actionPseudo(pseudo)
    end

    error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
end



---@generic TChild : Luva.Object
---@param obj Luva.Lang.SecuredObject<TChild>
---@param index any
---@return any
---@nodiscard
local function _secureGet(obj, index)
    return _secureBase(obj, index, function (field)
        return field
    end, function (acc)
        return acc:get()
    end, "_index", function (pseudo)
        pseudo(obj, index)
    end)
end

---@generic TChild : Luva.Object
---@param obj Luva.Lang.SecuredObject<TChild, any>
---@param index any
---@param value any
local function _secureSet(obj, index, value)
    if value == nil then
        error(_LUVA.Errors.ASSIGNED_NIL)
    end

    _secureBase(obj, index, function (field)
        rawset(obj, index, value)
    end, function (acc)
        acc:set(value)
    end, "_newindex", function (pseudo)
        pseudo(obj, index, value)
    end)
end

_LUVA.SecuredObject = {

    --- Creates an secure metatable
    ---@param operators Luva.Lang.PseudoMetatable
    ---@return Luva.Lang.PseudoMetatable
    ---@nodiscard
    GetSecureMetatable = function (operators)
        ---@type Luva.Lang.PseudoMetatable
        local result = {
            ---@generic TChild : Luva.Object
            ---@param self Luva.Lang.SecuredObject<TChild, any>
            ---@param index any
            ---@return any
            __index = function (self, index)
                return _secureGet(self, index)
            end,

            ---@generic TChild : Luva.Object
            ---@param self Luva.Lang.SecuredObject<TChild, any>
            ---@param index any
            ---@param value any
            __newindex = function (self, index, value)
                _secureSet(self, index, value)
            end
        }

        _LUVA.Utils.SafeInjectRef(result, operators)

        return result
    end,

    --- Secures an object
    ---@param obj table
    ---@param operators Luva.Lang.PseudoMetatable
    Secure = function (obj, operators)
        local meta = _LUVA.SecuredObject.GetSecureMetatable(operators)

        ---@cast obj Luva.Lang.SecuredObject<Luva.Object, any>
        _LUVA.Utils.SafeInjectRef(obj, {
            IsSecured = function (self)
                return self.__Security.IsEnabled    ---@diagnostic disable-line : invisible
            end,

            AddMetamethod = function (self, metaname, metamethod)
                _LUVA.Utils.SafeInjectRef(self.__Metatable, {   ---@diagnostic disable-line : invisible
                    [metaname] = metamethod
                })
            end,

            AddAccessor = function (self, identifier, accessor)
                _LUVA.Utils.SafeInjectRef(self.__Security.Accessors, {  ---@diagnostic disable-line : invisible
                    [identifier] = accessor
                })
            end,

            UpdateMetatable = function (self)
                setmetatable(self, nil)
                setmetatable(self, self.__Metatable)    ---@diagnostic disable-line : invisible
            end,

            __Security = {
                Accessors = { },

                IsEnabled = true
            } --[[@as Luva.Lang.Security]],

            __Metatable = meta,

            __Kind = "Luva.Lang.SecuredObject"
        } --[[@as Luva.Lang.SecuredObject]])
        obj:UpdateMetatable()  ---@diagnostic disable-line : invisible
    end,

    --- Lets `func` use self object without Security <br />
    --- <b>USING THIS FUNCTION IS NOT RECOMMENDED - LUVA ALREADY HANDLES EVERYTHING</b>
    ---@param obj Luva.Lang.SecuredObject
    ---@param func fun()
    ---@return any|nil
    Unsafe = function (obj, func)
        local security = obj.__Security ---@diagnostic disable-line : invisible
        setmetatable(obj, nil)
        security.IsEnabled = false
            local result = func()
        setmetatable(obj, obj.__Metatable)  ---@diagnostic disable-line : invisible
        security.IsEnabled = true

        return result
    end,
}


return _LUVA.SecuredObject