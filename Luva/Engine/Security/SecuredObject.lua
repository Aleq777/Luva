
---@diagnostic disable : lowercase-global

---@module "Luva.base"
local _, _LUVA = dofile ("Luva/base.lua")
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.kind"
---@module "Luva.Engine.utils"
_LUVA.Utils = dofile ("Luva/Engine/utils.lua")
---@module "Luva.Engine.Security.luvatemplatetype"
local _GenerateFromTemplate = dofile ("Luva/Engine/Security/luvatemplatetype.lua")
---@module "Luva.Engine.varargs"
dofile ("Luva/Engine/varargs.lua")

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

    ---@class Luva.Lang.SecuredObject : Luva.Lang.StrictKind
    ---@field private __Metatable Luva.Lang.PseudoMetatable
    ---@field private __Constants table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field private __Fields table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field private __Methods table<Luva.Lang.Identifier, function>
    ---@field private __Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>
    ---@field private __Generics nil|table<Luva.Lang.Identifier, Luva.Type|nil>
    ---@field private __Externs nil|table<Luva.Lang.Identifier, Luva.Dynamic>[]
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



---@param obj Luva.Lang.SecuredObject
---@param index Luva.Dynamic
---@return any
---@nodiscard
local function _secureGet(obj, index)
    local constant = obj.__Constants[index] ---@diagnostic disable-line : invisible
    if constant then
        return constant
    end

    local _field = obj.__Fields[index]  ---@diagnostic disable-line : invisible
    if _field then
        return _field
    end

    local method = obj.__Methods[index]    ---@diagnostic disable-line : invisible
    ---@cast method function
    if method then
        return method
    end

    local accessor = obj.__Accessors[index]    ---@diagnostic disable-line : invisible
    ---@cast accessor Luva.Lang.Accessor<Luva.Object>
    if accessor then
        if accessor.get then
            return accessor:get()
        else
            error(_LUVA.Errors.NO_GET_OR_SET)
        end
    end

    local generics = obj.__Generics    ---@diagnostic disable-line : invisible
    if generics then
        local generic = generics[index]

        if generic then
            return generic
        end
    end

    local externs = obj.__Externs  ---@diagnostic disable-line : invisible
    if externs then
        for _, v in ipairs(externs) do
            for identifier, value in pairs(v) do
                if index == identifier then
                    return value
                end
            end
        end
    end

    local userDef = obj.__Metatable._index ---@diagnostic disable-line : invisible
    if userDef then
        return userDef(obj, index)
    end

    error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
end


---@param obj Luva.Lang.SecuredObject
---@param index Luva.Dynamic
---@param value Luva.Dynamic
local function _secureSet(obj, index, value)
    if obj.__Constants[index] then ---@diagnostic disable-line : invisible
        error(_LUVA.Errors.TRIED_MODIFY_CONSTANT)
    elseif obj.__Methods[index] then   ---@diagnostic disable-line : invisible
        error(_LUVA.Errors.TRIED_MODIFY_METHOD)
    elseif obj.__Generics and obj.__Generics[index] then  ---@diagnostic disable-line : invisible
        error(_LUVA.Errors.TRIED_MODIFY_CONSTANT)
    end

    local fields = obj.__Fields  ---@diagnostic disable-line : invisible
    if fields[index] ~= nil then
        fields[index] = value
        return
    end

    ---@type Luva.Lang.Accessor<Luva.Object>
    local accessor = obj.__Accessors[index]    ---@diagnostic disable-line : invisible
    if accessor then
        if accessor.set then
            accessor:set(value)
            return
        else
            error(_LUVA.Errors.NO_GET_OR_SET)
        end
    end

    local externs = obj.__Externs  ---@diagnostic disable-line : invisible
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

    local userDef = obj.__Metatable._newindex  ---@diagnostic disable-line : invisible
    if userDef then
        userDef(obj, index, value)
        return
    end

    error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
end


_LUVA.SecuredObject = {

    ---@type table<string, metatable>
    Metatables = {
        TemplateClass = {
            ---@param self Luva.TemplateClass
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
                local generatedClass = _GenerateFromTemplate(filledTemplate)
                generatedClasses[filledTemplate] = generatedClass

                return generatedClass
            end
        },
        
        StaticClass = {
            ---@param self Luva.Lang.SecuredObject
            ---@param index Luva.Dynamic
            __index = function (self, index)
                return _secureGet(self, index)
            end,

            ---@param self Luva.Lang.SecuredObject
            ---@param index Luva.Dynamic
            ---@param value Luva.Dynamic
            __newindex = function (self, index, value)
                _secureSet(self, index, value)
            end
        },

        InstanceClass = {
            ---@param self Luva.Type
            ---@param index Luva.Dynamic
            __index = function (self, index)
                return _secureGet(self, index)
            end,

            ---@param self Luva.Type
            ---@param index Luva.Dynamic
            ---@param value Luva.Dynamic
            __newindex = function (self, index, value)
                _secureSet(self, index, value)
            end,

            ---@param self Luva.Type
            ---@param ... any[]
            ---@return Luva.Object
            __call = function (self, ...)
                local args = varargs (...)
                local argsCount = #args
                local instance = nil

                local function customConstr()
                    instance = self.__Constructors.CustomConstructor(self, unpack(args))
                end

                switch (argsCount, {
                    [0] = function ()
                        instance = self.__Constructors.DefaultConstructor(self)
                    end,

                    [1] = function ()
                        local arg = args[1]
                        -- build constructor
                        if type (arg) == "table" then
                            instance = self.__Constructors.BuildConstructor(self, arg)
                        else -- same as default
                            customConstr()
                        end
                    end,

                    default = function ()
                        customConstr()
                    end
                })
            end
        },

        -- MUST be copied by class, referenced by instance
        InstanceBase = {

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

return _LUVA.SecuredObject