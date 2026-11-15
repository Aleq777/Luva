
---@diagnostic disable : lowercase-global

import "Luva.Engine.Security.SecuredObject"
import "Luva.Engine.OOP.Ingredients.prototype"
import "Luva.Engine.OOP.Ingredients.Constructors.base"
import "Luva.Engine.OOP.Ingredients.Constructors.default"


---@alias Luva.Lang.PropNames "prototype"|"default"|"constructor"|"destructor"|"static"|"const"|"template"|"extends"|"implements"|"static_assert"
---@alias Luva.Lang.PropFuncNames

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassBuilder : metatable
    ---@field public prototype Luva.Lang.PrototypeBuilder|nil
    ---@field public default Luva.Lang.PostDefaultConstructorCaller<TInstance>|nil
    ---@field public constructor Luva.Lang.ConstructorBuilder|nil
    ---@field public destructor Luva.Lang.DestructorBuilder|nil
    ---@field public static table<string, Luva.Dynamic>|nil
    ---@field public const table<string, Luva.Dynamic>|nil
    ---@field public template fun(...: Luva.Type)|nil
    ---@field public extends Luva.Type|nil
    ---@field public implements Luva.Interface[]|nil
    ---@field public static_assert nil|fun(assertion: fun(): boolean)
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


---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
---@param propName Luva.Lang.PropNames
---@param funcName Luva.Lang.PropFuncNames
local function _tryAddStatic(resultClass, classBuilder, propName, funcName)
    local prop = classBuilder[propName]
    if not prop then
        return
    end

    for index, content in pairs(prop) do
        resultClass[funcName](resultClass, index, content)
    end
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticFields(resultClass, classBuilder)
    local static = classBuilder.static
    if not static then
        return
    end

    for index, content in pairs(static) do
        resultClass:AddField(index, content)  ---@diagnostic disable-line : invisible
    end
end

---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
local function _TryAddStaticConst(resultClass, classBuilder)
    local const = classBuilder.const
    if not const then
        return
    end

    for index, content in pairs(const) do
        resultClass:AddConstant(index, content) ---@diagnostic disable-line : invisible
    end
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
    _TryAddStaticFields(resultClass, classBuilder)

    
    if classBuilder.prototype then
        _LUVA._SetupPrototype(resultClass, classBuilder.prototype)

        _LUVA._SetupConstructorBase(resultClass)

        local constructors = resultClass.__Constructors ---@diagnostic disable-line : invisible

        _LUVA._SetupDefaultConstructorAndMaybeCaller(constructors, classBuilder.default)
        -- _LUVA._SetupBuildConstructor(constructors, classBuilder.prototype)
        
        if classBuilder.constructor then
            _LUVA._SetupConstructor(constructors, classBuilder.constructor)
        end
        -- _LUVA.SecuredObject.Secure(resultClass, "StaticClass")
    end

    return resultClass
end