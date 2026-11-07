
---@module "Luva.Engine.OOP.Ingredients.luvatype"
---@module "Luva.Engine.OOP.Ingredients.Constructors.base"

do
    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.PostDefaultConstructorCaller fun(self: TInstance)
    
    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.DefaultConstructor fun(self: Luva.Type): TInstance
end


---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
---@param defaultCaller Luva.Lang.PostDefaultConstructorCaller<TInstance>|nil
function _SetupDefaultConstructorAndMaybeCaller(resultClass, defaultCaller)

end


return _SetupDefaultConstructorAndMaybeCaller