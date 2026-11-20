
---@diagnostic disable : lowercase-global


_LUVA.SecuredObject = { }
import "Luva.Engine.utils"
import "Luva.Engine.Security.SecuredObject"
import "Luva.Engine.Security.luvatype"



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


local ERR_UNDEFINED_FIELD = "Tried to access undefined field"
local ERR_ASSIGNED_NIL = "Tried to assign nil (remove property). Use \"empty\" instead. If the error persists, ensure that you have imported \"empty\" correctly."
local ERR_TRIED_MODIFY_CONSTANT= "Tried to modify a constant or read-only value"
local ERR_TRIED_MODIFY_METHOD = "Tried to modify a method (which is read-only)"
local ERR_NO_GET_OR_SET = "This accessor doesn't have a defined get or set method (it's read-only or write only)"
local ERR_TEMPLATE_NOT_ENOUGH_TYPES = "Provided types count didn't match the required by the template/generic"
local ERR_MISSING_INSTANCE_S_CLASS = "Tried to secure an instance of a class while not providing any class"





---@param obj Luva.Lang.SecuredObject
---@param identifier Luva.Lang.Identifier
---@return boolean
---@nodiscard
local function _doesIdentifierExist(obj, identifier)
    for _, tableContent in pairs(obj) do
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

local ERR_TRIED_TO_CALL_OBJECT = "Tried to call object. Override the operator in it's type or ensure that you have used multi-setter correctly"

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
            error (ERR_NO_GET_OR_SET)
        end
    end

    local generics = obj.__Generics    ---@diagnostic disable-line : invisible
    if generics then
        local generic = generics[index]

        if generic then
            return generic
        end
    end

    local userDef = obj.__Metatable._index ---@diagnostic disable-line : invisible
    if userDef then
        return userDef(obj, index)
    end

    error (ERR_UNDEFINED_FIELD .. ": " .. tostring(index), 3)
end


---@param obj Luva.Lang.SecuredObject
---@param index Luva.Dynamic
---@param value Luva.Dynamic
local function _secureSet(obj, index, value)
    if obj.__Constants[index] then ---@diagnostic disable-line : invisible
        error (ERR_TRIED_MODIFY_CONSTANT, 3)
    elseif obj.__Methods[index] then   ---@diagnostic disable-line : invisible
        error (ERR_TRIED_MODIFY_METHOD, 3)
    elseif obj.__Generics and obj.__Generics[index] then  ---@diagnostic disable-line : invisible
        error (ERR_TRIED_MODIFY_CONSTANT, 3)
    elseif value == nil then
        error (ERR_ASSIGNED_NIL, 3)
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
            error (ERR_NO_GET_OR_SET)
        end
    end

    local userDef = obj.__Metatable._newindex  ---@diagnostic disable-line : invisible
    if userDef then
        userDef(obj, index, value)
        return
    end

    error (ERR_UNDEFINED_FIELD .. ": " .. tostring(index), 3)
end

---@type table<string, metatable>
_LUVA.SecuredObject.Metatables = {
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
                    error (ERR_TEMPLATE_NOT_ENOUGH_TYPES)
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
            local generatedClass = _LUVA._GenerateFromTemplate(self, filledTemplate)
            generatedClasses[filledTemplate] = generatedClass
    
            return generatedClass
        end
    },

    StaticClass = {
        ---@param self Luva.Lang.SecuredObject
        ---@param index Luva.Dynamic
        ---@return any
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
            local argsCount = select ("#", ...)
            local instance = nil
    
            if argsCount == 0 then
                instance = self.__Constructors.DefaultConstructor(self) ---@diagnostic disable-line : invisible
            else
                instance = self.__Constructors.CustomConstructor(self, ...)  ---@diagnostic disable-line : invisible
            end
    
            return instance
        end,
    },

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

        ---@param self Luva.Object
        ---@return string
        ---@nodiscard
        __tostring = function (self)
            return self:ToString()
        end,

        ---@param self Luva.Object
        ---@param ... table|any[]
        ---@return Luva.Object|any ...
        __call = function (self, ...)
            local userDefined = self.__Type.__Prototype.PrototypeMetatable._index   ---@diagnostic disable-line : invisible
            if userDefined then
                return userDefined(self, ...)
            end
    
            local argCount = select ("#", ...)
            local argFirst = ( select (1, ...) )
            if argCount ~= 1 or type (argFirst) ~= "table" then
                error (ERR_TRIED_TO_CALL_OBJECT, 3)
            end
    
            for fieldName, fieldContent in pairs(argFirst) do
                self[fieldName] = fieldContent
            end
    
            return self
        end,
    
        ---@version >5.1 On version 5.1, it just won't work
        ---@param self Luva.Object
        __gc = function (self)
            self.__Type.__Destructor(self)  ---@diagnostic disable-line : invisible
        end
    },
}







--- Secures an object
---@param obj table
---@param metatableName Luva.Lang.TypesMetatableNames Which metatable use
---@param modifyMetatable metatable|nil Modifying (coping and changing) metatable. For `"InstanceBase"` it acts like a ready table to refer to
function _LUVA.SecuredObject.Secure(obj, metatableName, modifyMetatable)
    ---@type metatable
    local metatable
    if metatableName == "InstanceBase" then
        if modifyMetatable == nil then
            error (ERR_MISSING_INSTANCE_S_CLASS)
        end

        metatable = modifyMetatable
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

    setmetatable (obj, metatable)
end