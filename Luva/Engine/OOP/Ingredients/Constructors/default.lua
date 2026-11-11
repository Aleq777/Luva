
---@module "Luva.Engine.OOP.Ingredients.luvatype"
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"

do
    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.PostDefaultConstructorCaller fun(self: TInstance)

    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.DefaultConstructor fun(class: Luva.Type): TInstance
end


---@generic TInstance : Luva.Object
---@param constructors Luva.Lang.ClassConstructors<TInstance>
---@param defaultCaller Luva.Lang.PostDefaultConstructorCaller<TInstance>|nil
local function _SetupDefaultConstructorAndMaybeCaller(constructors, defaultCaller)
    ---@type Luva.Lang.DefaultConstructor
    constructors.DefaultConstructor = function (class)
        ---@type Luva.Object
        local instance = {  ---@diagnostic disable-line : missing-fields
            __Readonlys = { }
        }
        local proto = class.__Prototype ---@diagnostic disable-line : invisible

        for identifier, ro in pairs(proto.Readonlys) do
            _LUVA.Utils.SafeInjectRef(instance.__Readonlys, {   ---@diagnostic disable-line : invisible
                [identifier] = _LUVA.Utils.Copy(ro)
            })
        end

        _LUVA.Utils.SafeInjectRef(instance, _LUVA.Utils.Copy(proto.Fields))

        ---@cast instance Luva.Object
        _LUVA.SecuredObject.Secure(instance, proto.Metatable)

        local caller = class.__Constructors.DefaultCaller   ---@diagnostic disable-line : invisible
        if caller then
            caller(instance)
        end

        return instance
    end

    if defaultCaller then
        constructors.DefaultCaller = defaultCaller
    end
end


return _SetupDefaultConstructorAndMaybeCaller