
---@diagnostic disable : lowercase-global

---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.kind"
---@module "Luva.Engine.utils"
_LUVA.Utils = dofile ("Luva/Engine/utils.lua")

do
    ---@alias Luva.Lang.SafePseudoMetaNames # for Luva.Lang.PseudoMetatable
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
    ---| "_index" user defined []
    ---| "_newindex" user defined []=
    ---| "__call"

    ---@class Luva.Lang.PseudoMetatable : metatable
    ---@field public _index nil|fun(self: table, index: any): any
    ---@field public _newindex nil|fun(self: table, index: any, value: any)
    local __pseudo

    -- -- -@field private __Security Luva.Lang.Security
    -- ---@class Luva.Lang.SecuredObject : Luva.Lang.StrictKind
    -- ---@field protected IsSecured fun(self: Luva.Lang.SecuredObject): boolean
    -- ---@field protected AddMetamethod fun(self: Luva.Lang.SecuredObject, metaname: Luva.Lang.SafePseudoMetaNames, metamethod: function)
    -- ---@field protected AddAccessor fun(self: Luva.Lang.SecuredObject, identifier: Luva.Lang.Identifier, accessor: Luva.Lang.Accessor<Luva.Object, any>)
    -- ---@field protected UpdateMetatable fun(self: Luva.Lang.SecuredObject)
    -- ---@field private __Metatable Luva.Lang.PseudoMetatable
    -- ---@field private __IsEnabled boolean
    -- ---@field private __Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object, any>>
    -- ---@field private __ExternAccessorsRef (table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object, any>>)[]
    -- ---@field private __Readonlys table<Luva.Lang.Identifier, any>
    -- local __securedObject


    ---@class Luva.Lang.SecuredObject : Luva.Lang.StrictKind
    ---@field private __Metatable Luva.Lang.PseudoMetatable
    ---@field private __Constants table<Luva.Lang.Identifier, Luva.Lang.Dynamic>
    ---@field private __Fields table<Luva.Lang.Identifier, Luva.Lang.Dynamic>
    ---@field private __Methods table<Luva.Lang.Identifier, function>
    ---@field private __Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>
    ---@field private __Generics nil|table<Luva.Lang.Identifier, Luva.Type|nil>
    ---@field private __Externs nil|table<Luva.Lang.Identifier, Luva.Lang.Dynamic>[]
    local __securedObject
end

-- Searching for fields
-- 1. Constants
-- 2. Fields
-- 3. Methods
-- 4. Accessors
-- 5. Generics
-- 6. Externs
-- 7. User-defined (__Metatable._index / __Metatable._newindex)


_LUVA.Errors.UNDEFINED_FIELD = "Tried to access undefined field"
_LUVA.Errors.ASSIGNED_NIL = "Tried to assign nil (remove property). Use empty instead"
_LUVA.Errors.TRIED_MODIFY_CONSTANT= "Tried to modify a constant or readonly value"
_LUVA.Errors.TRIED_MODIFY_METHOD = "Tried to modify a method (which is readonly)"
_LUVA.Errors.NO_GET_OR_SET = "This accessor doesn't have a defined get or set method (it's readonly or write only)"
_LUVA.Errors.TEMPLATE_NOT_ENOUGH_TYPES = "Provided types count didn't match the required by the template/generic"



_LUVA.SecuredObject = {

    ---@type table<string, metatable>
    Metatables = {
        StaticClass = {
            ---@param self Luva.Lang.SecuredObject
            ---@param index Luva.Lang.Dynamic
            __index = function (self, index)
                local constant = self.__Constants[index]    ---@diagnostic disable-line : invisible
                if constant then
                    return constant
                end

                local _field = self.__Fields[index]  ---@diagnostic disable-line : invisible
                if _field then
                    return _field
                end

                local method = self.__Methods[index]    ---@diagnostic disable-line : invisible
                ---@cast method function
                if method then
                    return method
                end

                local accessor = self.__Accessors[index]    ---@diagnostic disable-line : invisible
                ---@cast accessor Luva.Lang.Accessor<Luva.Object>
                if accessor then
                    if accessor.get then
                        return accessor:get()
                    else
                        error(_LUVA.Errors.NO_GET_OR_SET)
                    end
                end

                local generics = self.__Generics    ---@diagnostic disable-line : invisible
                if generics then
                    local generic = generics[index]

                    if generic then
                        return generic
                    end
                end

                local externs = self.__Externs  ---@diagnostic disable-line : invisible
                if externs then
                    for _, v in ipairs(externs) do
                        for identifier, value in pairs(v) do
                            if index == identifier then
                                return value
                            end
                        end
                    end
                end

                local userDef = self.__Metatable._index ---@diagnostic disable-line : invisible
                if userDef then
                    return userDef(self, index)
                end

                error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
            end,

            ---@param self Luva.Lang.SecuredObject
            ---@param index Luva.Lang.Dynamic
            ---@param value Luva.Lang.Dynamic
            __newindex = function (self, index, value)
                if self.__Constants[index] then ---@diagnostic disable-line : invisible
                    error(_LUVA.Errors.TRIED_MODIFY_CONSTANT)
                elseif self.__Methods[index] then   ---@diagnostic disable-line : invisible
                    error(_LUVA.Errors.TRIED_MODIFY_METHOD)
                elseif self.__Generics and self.__Generics[index] then  ---@diagnostic disable-line : invisible
                    error(_LUVA.Errors.TRIED_MODIFY_CONSTANT)
                end

                local fields = self.__Fields  ---@diagnostic disable-line : invisible
                if fields[index] ~= nil then
                    fields[index] = value
                    return
                end

                ---@type Luva.Lang.Accessor<Luva.Object>
                local accessor = self.__Accessors[index]    ---@diagnostic disable-line : invisible
                if accessor then
                    if accessor.set then
                        accessor:set(value)
                        return
                    else
                        error(_LUVA.Errors.NO_GET_OR_SET)
                    end
                end

                local externs = self.__Externs  ---@diagnostic disable-line : invisible
                if externs then
                    for _, v in ipairs(externs) do
                        for identifier, _ in pairs(v) do
                            if index == identifier then
                                v[identifier] = value
                                return
                            end
                        end
                    end
                end

                local userDef = self.__Metatable._newindex  ---@diagnostic disable-line : invisible
                if userDef then
                    userDef(self, index, value)
                    return
                end

                error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
            end
        },

        TemplateClass = {
            ---@param self Luva.TemplateType
            ---@param index Luva.Type|Luva.Type[]
            ---@return Luva.Type
            ---@nodiscard
            __index = function (self, index)
                local templ = self.__Template   ---@diagnostic disable-line : invisible
                ---@type Luva.Type[]
                local filledTemplate = { }
                
                if #templ == 1 then -- only 1 generic type, accept template[T] and template[{T}]
                    -- if array
                    if kindof (index) == "lua" then
                        index = index[1]
                    end

                    ---@cast index -Luva.Type[]
                    table.insert(filledTemplate, index)
                else -- many generic types, accept only template[{...}]
                    -- array
                    if kindof (index) == "lua" then
                        for _, v in ipairs(index) do
                            table.insert(filledTemplate, v)
                        end
                    else -- single type - error
                        error(_LUVA.Errors.TEMPLATE_NOT_ENOUGH_TYPES)
                    end
                end

                -- search for existing
                local generatedClasses = self.__GeneratedClasses    ---@diagnostic disable-line : invisible
                for existingTemplate, existingType in pairs(generatedClasses) do
                    if _LUVA.Utils.IsSameByValue(existingTemplate, filledTemplate) then
                        return existingType
                    end
                end

                -- generate a new type
                generatedClasses[filledTemplate] = 
            end
        },

        InstanceClass = {

        },

        Instance = {

        }
    },

    --- Secures an object
    ---@param obj table
    Secure = function (obj)

        _LUVA.Utils.SafeInjectRef(obj, {
            __Metatable = { },
            __Constants = { },
            __Fields = { },
            __Methods = { },
            __Accessors = { },
            __Externs = { },
            __Generics = { }
        } --[[@as Luva.Lang.SecuredObject]])

    end

}


--[[

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
            } --[[@as Luva.Lang.Security]]--[[,

            __Metatable = meta,

            __Kind = "Luva.Lang.SecuredObject"
        } --[[@as Luva.Lang.SecuredObject]]--[[)
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
]]