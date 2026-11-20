

---@diagnostic disable : lowercase-global

import "Luva.Engine.Security.SecuredObject"
import "Luva.Engine.OOP.Ingredients.prototype"
import "Luva.Engine.OOP.Ingredients.template"
import "Luva.Engine.OOP.Ingredients.constructor"
import "Luva.Engine.OOP.Ingredients.destructor"

---@alias Luva.Lang.PropNames "prototype"|"default"|"constructor"|"destructor"|"static"|"const"|"template"|"extends"|"implements"|"static_assert"
---@alias Luva.Lang.PropFuncNames "AddConstant"|"AddField"|"AddMethod"|"AddAccessor"

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassBuilder : metatable
    ---@field public prototype Luva.Lang.PrototypeBuilder|nil
    ---@field public default fun(self: TInstance)|nil
    ---@field public constructor fun(setPrototype: fun(obj: TInstance), ...: any[])|nil
    ---@field public destructor nil|fun(self: TInstance)
    ---@field public static table<string, Luva.Dynamic>|nil
    ---@field public const table<string, Luva.Dynamic>|nil
    ---@field public template fun(...: Luva.Type)|nil
    ---@field public extends Luva.Type|nil
    ---@field public implements Luva.Interface[]|nil
    local __classBuilder
end


---@param classBuilder Luva.Lang.ClassBuilder
---@return Luva.Lang.TypesMetatableNames
---@nodiscard
local function _GetClassMetatable(classBuilder)
    if classBuilder.template then
        return "TemplateClass"
    end

    if classBuilder.prototype then
        return "InstanceClass"
    end

    return "StaticClass"
end


---@param classBuilder Luva.Lang.ClassBuilder
---@param propName Luva.Lang.PropNames
---@param callback fun(index: string, content: any)
local function _tryAddStatic(classBuilder, propName, callback)
    local prop = classBuilder[propName]
    if not prop then
        return
    end

    for index, content in pairs(prop) do
        callback(index, content)
    end
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticFields(resultClass, classBuilder)
    _tryAddStatic(classBuilder, "static", function (index, content)
        if type (content) == "function" then
            ---@cast content function
            resultClass:__AddMethod(index, content)   ---@diagnostic disable-line : invisible
        else
            resultClass:__AddField(index, content)  ---@diagnostic disable-line : invisible
        end
    end)
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticConst(resultClass, classBuilder)
    _tryAddStatic(classBuilder, "const", function (index, content)
        resultClass:__AddConstant(index, content)   ---@diagnostic disable-line : invisible
    end)
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticTemplate(resultClass, classBuilder)
    local template = classBuilder.template
    if not template then
        return
    end

    _LUVA._ImplementTemplate(resultClass, classBuilder, template)
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticExtends(resultClass, classBuilder)
    if not classBuilder.extends then
        classBuilder.extends = Luva.Object
    end

    -- handle extend
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticImplements(resultClass, classBuilder)
    if not classBuilder.implements then
        return
    end

    -- handle implements
end



--- Creates a class
---@param classBuilder Luva.Lang.ClassBuilder
---@return Luva.Type
---@nodiscard
class = function (classBuilder)

    ---@type Luva.Type
    local resultClass = {   ---@diagnostic disable-line : missing-fields
        __Kind = "class"
    }

    _LUVA.SecuredObject.Secure(resultClass, _GetClassMetatable(classBuilder))

    _TryAddStaticTemplate(resultClass, classBuilder)
    _TryAddStaticExtends(resultClass, classBuilder)
    _TryAddStaticImplements(resultClass, classBuilder)
    _TryAddStaticConst(resultClass, classBuilder)
    _TryAddStaticFields(resultClass, classBuilder)


    if classBuilder.prototype then
        _LUVA._SetupPrototype(resultClass, classBuilder.prototype)

        _LUVA._SetupConstructorBase(resultClass)

        local constructors = resultClass.__Constructors ---@diagnostic disable-line : invisible

        _LUVA._SetupDefaultConstructorAndMaybeCaller(constructors, classBuilder.default)

        if classBuilder.constructor then
            _LUVA._SetupConstructor(constructors, classBuilder.constructor)
        end

        _LUVA._SetupDestructor(resultClass, classBuilder.destructor)
    end

    return resultClass
end