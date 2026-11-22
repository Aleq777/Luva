

do
    ---@generic T
    ---@class Luva.Lang.Field : Luva.Lang.StrictKind
    ---@field public Type Luva.Type|string
    ---@field public Value T|nil Default or current value (depends on context). Nil value depends on: is initialised, .IsNilable
    ---@field public IsNilable boolean Can Value be nil?
    ---@field public IsByRef boolean Should Luva copy and access this as an reference? (defaultly, Luva uses values)
    local __field
end


--- Casts defined field in a prototype builder to an Field type <br />
--- `Name = "John"` -> Field { Type = "string", DefaultValue = "John" } <br />
--- `Age = "integer"` -> Field { Type = "integer", DefaultValue = nil } <br />
--- `Parent = HisParent` -> Field { Type = Human, DefaultValue = HisParent } (watch out for references - everything is copied) <br />
---@generic T
---@param value Luva.Dynamic|type|Luva.Type|Luva.Object Any value/type (scalar types are strings as in `type` Lua function). Nil is prohibited - see maybe()
---@return Luva.Lang.Field<T>
function _LUVA._ParseField(value)
    local t = type (value)
    local _type, _value = nil, nil

    if t == "string" and _LUVA.Utils.Has(_LUVA.Utils.ScalarLuaTypes, value) then
        _type = value
        _value = nil
    else
        _type = "string"
        _value = value
    end

    return {
        __Kind = "field",
        Type = _type,
        Value = _value,
        IsNilable = false,
        IsByRef = false
    }   --[[@as Luva.Lang.Field]]
end