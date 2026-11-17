

do
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassConstructors
    ---@field public DefaultCaller fun(self: TInstance)
    ---@field public DefaultConstructor fun(_class: Luva.Type): TInstance
    ---@field public CustomConstructor nil|fun(_class: Luva.Type, ...: any[]): TInstance
    local __constructors
end


---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
function _LUVA._SetupConstructorBase(resultClass)
    rawset(resultClass, "__Constructors", {
        DefaultConstructor = nil, ---@diagnostic disable-line : assign-type-mismatch
        DefaultCaller = nil,    ---@diagnostic disable-line : assign-type-mismatch
        CustomConstructor = nil
    } --[[@as Luva.Lang.ClassConstructors]])
end