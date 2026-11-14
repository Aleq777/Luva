
---@diagnostic disable : lowercase-global

---@module "Luva.base"
local _, _LUVA = dofile "Luva/base.lua"
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.kind"
---@module "Luva.Engine.utils"
_LUVA.Utils = import "Luva.Engine.utils"
---@module "Luva.Engine.Security.luvatemplatetype"
local _GenerateFromTemplate = import "Luva.Engine.Security.luvatemplatetype"
---@module "Luva.Engine.varargs"
import "Luva.Engine.varargs"

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
    ---@field protected AddConstant     fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, constant: Luva.Dynamic)
    ---@field protected AddField        fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, _field: Luva.Dynamic)
    ---@field protected AddMethod       fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, method: function)
    ---@field protected AddAccessor     fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, accessor: Luva.Lang.Accessor<Luva.Object>)
    ---@field protected SetConstants    fun(self: Luva.Lang.SecuredObject, constants: table<Luva.Lang.Identifier, Luva.Dynamic>)
    ---@field protected SetFields       fun(self: Luva.Lang.SecuredObject, fields: table<Luva.Lang.Identifier, Luva.Dynamic>)
    ---@field protected SetMethods      fun(self: Luva.Lang.SecuredObject, methods: table<Luva.Lang.Identifier, function>)
    ---@field protected SetAccessors    fun(self: Luva.Lang.SecuredObject, accessors: table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>)
    ---@
    ---@field private SetGenerics fun(self: Luva.Lang.SecuredObject, generics: table<Luva.Lang.Identifier, Luva.Type|nil>)
    ---@field private __Metatable   Luva.Lang.PseudoMetatable
    ---@field private __Constants   table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field private __Fields      table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field private __Methods     table<Luva.Lang.Identifier, function>
    ---@field private __Accessors   table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>
    ---@field private __Generics    table<Luva.Lang.Identifier, Luva.Type|nil>
    local __securedObject
end

-- Searching for fields
-- 1. Constants
-- 2. Fields
-- 3. Methods
-- 4. Accessors
-- 5. Generics
-- 6. User-defined (__Metatable._index / __Metatable._newindex)


_LUVA.Errors.UNDEFINED_FIELD = "Tried to access undefined field"
_LUVA.Errors.ASSIGNED_NIL = "Tried to assign nil (remove property). Use empty instead"
_LUVA.Errors.TRIED_MODIFY_CONSTANT= "Tried to modify a constant or readonly value"
_LUVA.Errors.TRIED_MODIFY_METHOD = "Tried to modify a method (which is readonly)"
_LUVA.Errors.NO_GET_OR_SET = "This accessor doesn't have a defined get or set method (it's readonly or write only)"
_LUVA.Errors.TEMPLATE_NOT_ENOUGH_TYPES = "Provided types count didn't match the required by the template/generic"
_LUVA.Errors.MISSING_INSTANCE_S_CLASS = "Tried to secure an instance of a class while not providing any class"





---@param obj Luva.Lang.SecuredObject
---@param identifier Luva.Lang.Identifier
---@return boolean
---@nodiscard
local function _doesIdentifierExist(obj, identifier)
    for tableName, tableContent in pairs(obj) do
        if tableName == "__Externs" then
            ---@cast tableContent table<Luva.Lang.Identifier, Luva.Dynamic>
            for k, _ in ipairs(tableContent) do
                if k == identifier then
                    return true
                end
            end
        elseif tableContent[identifier] ~= nil then
            return true
        end
    end

    return false
end

---@param obj Luva.Lang.SecuredObject
---@param identifier Luva.Lang.Identifier
local function _checkIfNew(obj, identifier)
    if _doesIdentifierExist(obj, identifier) then
        error ("Identifier \"" .. identifier .. "\" already exists in this SecuredObject")
    end
end



_LUVA.SecuredObject = {

    ---@type table<string, metatable>
    Metatables = {
        TemplateClass = import "Luva/Engine/Security/SecuredObject/MetatableTemplateClass.lua",
        
        StaticClass = import "Luva/Engine/Security/SecuredObject/MetatableStaticClass.lua",

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
                            -- instance = self.__Constructors.BuildConstructor(self, arg)
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
            ---@param self Luva.Object
            ---@param index Luva.Dynamic
            ---@return any
            __index = function (self, index)
                return _secureGet(self, index)
            end,

            ---@param self Luva.Object
            ---@param index Luva.Dynamic
            ---@param value Luva.Dynamic
            __newindex = function (self, index, value)
                _secureSet(self, index, value)
            end,
        }
    },

    --- Secures an object
    ---@param obj table
    ---@param metatableName "TemplateClass"|"StaticClass"|"InstanceClass"|"InstanceBase"
    ---@param modifyMetatable metatable|nil
    Secure = function (obj, metatableName, modifyMetatable)

        local metatable
        if metatableName == "InstanceBase" then
            if modifyMetatable == nil then
                error (_LUVA.Errors.MISSING_INSTANCE_S_CLASS)
            end

            metatable = _LUVA.Utils.SafeInjectRef(
                _LUVA.Utils.Copy(_LUVA.SecuredObject.Metatables[metatableName]),
                modifyMetatable
            )
        else
            metatable = _LUVA.SecuredObject.Metatables[metatableName]
        end

        _LUVA.Utils.SafeInjectRef(obj, {
            __Metatable = metatable,
            __Constants = { },
            __Fields = { },
            __Methods = { },
            __Accessors = { },
            -- __Externs = { },
            __Generics = { },
            SetGenerics = function (self, generics)
                self.__Generics = generics  ---@diagnostic disable-line : invisible
            end,

            SetAccessors = function (self, accessors)
                self.__Accessors = accessors    ---@diagnostic disable-line : invisible
            end,

            SetConstants = function (self, constants)
                self.__Constants = constants    ---@diagnostic disable-line : invisible
            end,

            -- SetExterns = function (self, externs)
            --     self.__Externs = externs    ---@diagnostic disable-line : invisible
            -- end,

            SetFields = function (self, fields)
                self.__Fields = fields  ---@diagnostic disable-line : invisible
            end,

            SetMethods = function (self, methods)
                self.__Methods = methods    ---@diagnostic disable-line : invisible
            end,

            AddAccessor = function (self, name, accessor)
                _checkIfNew(self, name)
                self.__Accessors[name] = accessor   ---@diagnostic disable-line : invisible
            end,

            AddConstant = function (self, name, constant)
                _checkIfNew(self, name)
                self.__Constants[name] = constant   ---@diagnostic disable-line : invisible
            end,

            -- AddExtern = function (self, extern)
            --     local externs = self.__Externs  ---@diagnostic disable-line : invisible

            --     if externs == nil then
            --         externs = { }
            --         self.__Externs = { }    ---@diagnostic disable-line : invisible
            --     end

            --     for index, externRef in ipairs(externs) do
            --         if extern == externRef then
            --             error ("This extern has been already connected to the SecuredObject at index " .. tostring(index))
            --         end
            --     end
            --     table.insert(externs, extern)
            -- end,

            AddField = function (self, name, _field)
                _checkIfNew(self, name)
                self.__Fields[name] = _field    ---@diagnostic disable-line : invisible
            end,

            AddMethod = function (self, name, method)
                _checkIfNew(self, name)
                self.__Methods[name] = method   ---@diagnostic disable-line : invisible
            end,

        } --[[@as Luva.Lang.SecuredObject]])

    end

}

return _LUVA.SecuredObject