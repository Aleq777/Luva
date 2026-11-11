

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassConstructors
    ---@field public DefaultConstructor Luva.Lang.DefaultConstructor<TInstance>
    ---@field public DefaultCaller Luva.Lang.PostDefaultConstructorCaller<TInstance>
    ---@field public BuildConstructor Luva.Lang.BuildConstructor<TInstance>
    ---@field public CustomConstructor Luva.Lang.CustomConstructor<TInstance>
    local __constructors
end


---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
function _SetupConstructorBase(resultClass)
    rawset(resultClass, "__Constructors", {
        DefaultConstructor = nil,
        DefaultCaller = nil,
        BuildConstructor = nil,
        CustomConstructor = nil
    })
end

return _SetupConstructorBase