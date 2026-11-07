
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
function _SetupDefaultConstructorAndMaybeCaller(constructors, defaultCaller)

    constructors.DefaultConstructor = function (class)
        ---@type Luva.Object
        local instance = { }

        
    end

    if defaultCaller then
        constructors.DefaultCaller = defaultCaller
    end
end


return _SetupDefaultConstructorAndMaybeCaller