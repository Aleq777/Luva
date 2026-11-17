
do
    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.PostDefaultConstructorCaller fun(self: TInstance)

    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.DefaultConstructor fun(_class: Luva.Type): TInstance
end


---@generic TInstance : Luva.Object
---@param constructors Luva.Lang.ClassConstructors<TInstance> Reference to class'es constructors
---@param defaultCaller fun(self: TInstance)|nil
function _LUVA._SetupDefaultConstructorAndMaybeCaller(constructors, defaultCaller)
    constructors.DefaultCaller = defaultCaller or function (instance) end

    ---@type Luva.Lang.DefaultConstructor    
    constructors.DefaultConstructor = function (_class)
        local instance = _LUVA._GeneralConstructor(_class)
        _class.__Constructors.DefaultCaller(instance)   ---@diagnostic disable-line : invisible
        return instance
    end
end