
---@diagnostic disable : lowercase-global


_LUVA.SecuredObject = { }
import "Luva.Engine.utils"
import "Luva.Engine.Security.SecuredObject.SecuredObjectMetatables"
import "Luva.Engine.Security.luvatemplatetype"
import "Luva.Engine.Security.SecuredObject.MetatableTemplateClass"
import "Luva.Engine.Security.SecuredObject.MetatableStaticClass"
import "Luva.Engine.Security.SecuredObject.MetatableInstanceClass"
import "Luva.Engine.Security.SecuredObject.MetatableInstanceBase"



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
    ---| "_call" user defined ()

    ---@class Luva.Lang.PseudoMetatable : metatable
    ---@field public _index nil|fun(self: table, index: any): any
    ---@field public _newindex nil|fun(self: table, index: any, value: any)
    local __pseudo

    ---@class Luva.Lang.SecuredObject : Luva.Lang.StrictKind
    ---@field protected __AddConstant     fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, constant: Luva.Dynamic)
    ---@field protected __AddField        fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, _field: Luva.Dynamic)
    ---@field protected __AddMethod       fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, method: function)
    ---@field protected __AddAccessor     fun(self: Luva.Lang.SecuredObject, name: Luva.Lang.Identifier, accessor: Luva.Lang.Accessor<Luva.Object>)
    ---@field protected __SetConstants    fun(self: Luva.Lang.SecuredObject, constants: table<Luva.Lang.Identifier, Luva.Dynamic>)
    ---@field protected __SetFields       fun(self: Luva.Lang.SecuredObject, fields: table<Luva.Lang.Identifier, Luva.Dynamic>)
    ---@field protected __SetMethods      fun(self: Luva.Lang.SecuredObject, methods: table<Luva.Lang.Identifier, function>)
    ---@field protected __SetAccessors    fun(self: Luva.Lang.SecuredObject, accessors: table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>)
    ---@field protected __SetGenerics fun(self: Luva.Lang.SecuredObject, generics: table<Luva.Lang.Identifier, Luva.Type|nil>)
    ---@
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
_LUVA.Errors.ASSIGNED_NIL = "Tried to assign nil (remove property). Use \"empty\" instead. If the error persists, ensure that you have imported \"empty\" correctly."
_LUVA.Errors.TRIED_MODIFY_CONSTANT= "Tried to modify a constant or read-only value"
_LUVA.Errors.TRIED_MODIFY_METHOD = "Tried to modify a method (which is read-only)"
_LUVA.Errors.NO_GET_OR_SET = "This accessor doesn't have a defined get or set method (it's read-only or write only)"
_LUVA.Errors.TEMPLATE_NOT_ENOUGH_TYPES = "Provided types count didn't match the required by the template/generic"
_LUVA.Errors.MISSING_INSTANCE_S_CLASS = "Tried to secure an instance of a class while not providing any class"





---@param obj Luva.Lang.SecuredObject
---@param identifier Luva.Lang.Identifier
---@return boolean
---@nodiscard
local function _doesIdentifierExist(obj, identifier)
    for tableName, tableContent in pairs(obj) do
        if type(tableContent) ~= "function" then
            if tableContent[identifier] ~= nil then
                return true
            end
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

---@alias Luva.Lang.TypesMetatableNames "TemplateClass"|"StaticClass"|"InstanceClass"|"InstanceBase"

--- Secures an object
---@param obj table
---@param metatableName Luva.Lang.TypesMetatableNames Which metatable use
---@param modifyMetatable metatable|nil Modifying (coping and changing) metatable. For `"InstanceBase"` it acts like a ready table to refer to
function _LUVA.SecuredObject.Secure(obj, metatableName, modifyMetatable)
    ---@type metatable
    local metatable
    if metatableName == "InstanceBase" then
        if modifyMetatable == nil then
            error (_LUVA.Errors.MISSING_INSTANCE_S_CLASS)
        end

        metatable = modifyMetatable

        -- metatable = _LUVA.Utils.SafeInjectRef(
        --     _LUVA.Utils.Copy(_LUVA.SecuredObject.Metatables.InstanceBase),
        --     modifyMetatable
        -- ) --[[@as metatable]]
    else
        metatable = _LUVA.SecuredObject.Metatables[metatableName]
    end

    _LUVA.Utils.SafeInjectRef(obj, {
        __Metatable = metatable,
        __Constants = { },
        __Fields = { },
        __Methods = { },
        __Accessors = { },
        __Generics = { },
        __SetGenerics = function (self, generics)
            self.__Generics = generics  ---@diagnostic disable-line : invisible
        end,

        __SetAccessors = function (self, accessors)
            self.__Accessors = accessors    ---@diagnostic disable-line : invisible
        end,

        __SetConstants = function (self, constants)
            self.__Constants = constants    ---@diagnostic disable-line : invisible
        end,

        __SetFields = function (self, fields)
            self.__Fields = fields  ---@diagnostic disable-line : invisible
        end,

        __SetMethods = function (self, methods)
            self.__Methods = methods    ---@diagnostic disable-line : invisible
        end,

        __AddAccessor = function (self, name, accessor)
            _checkIfNew(self, name)
            self.__Accessors[name] = accessor   ---@diagnostic disable-line : invisible
        end,

        __AddConstant = function (self, name, constant)
            _checkIfNew(self, name)
            self.__Constants[name] = constant   ---@diagnostic disable-line : invisible
        end,

        __AddField = function (self, name, _field)
            _checkIfNew(self, name)
            self.__Fields[name] = _field    ---@diagnostic disable-line : invisible
        end,

        __AddMethod = function (self, name, method)
            _checkIfNew(self, name)
            self.__Methods[name] = method   ---@diagnostic disable-line : invisible
        end,

    } --[[@as Luva.Lang.SecuredObject]])

    setmetatable(obj, metatable)
end