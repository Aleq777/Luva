


do
    ---@generic T
    ---@class Luva.Lang.Field : Luva.Lang.StrictKind
    ---@field public Type Luva.Type|string
    ---@field public Value T|nil Default or current value (depends on context). Nil value depends on: is initialised, .IsNilable
    ---@field public IsNilable boolean|nil Can Value be nil?
    ---@field public IsByRef boolean|nil Should Luva copy and access this as an reference? (defaultly, Luva uses values)
    ---@field public IsReadonly boolean|nil Is read-only? Read-only lets you change value from `nil` to any (not nil). It is by then immutable
    local __field
end


---@param value any
---@return Luva.Lang.Field
function _LUVA._ParseProp(value)
    local _type, _value

    if _LUVA.Utils.IsType(value) then
        _type = value
        _value = nil
    else
        _type = typeof (value)
        _value = value
    end

    return {
        __Kind = "field",
        Type = _type,
        Value = _value,
        IsByRef = false,
        IsNilable = false,
        IsReadonly = false
    }   --[[@as Luva.Lang.Field]]
end

--- Casts defined field in a prototype builder to an Field type <br />
--- `Name = "John"` -> Field { Type = "string", DefaultValue = "John" } <br />
--- `Age = "integer"` -> Field { Type = "integer", DefaultValue = nil } <br />
--- `Parent = HisParent` -> Field { Type = Human, DefaultValue = HisParent } (watch out for references - everything is copied) <br />
---@generic T
---@param value Luva.Dynamic|type|Luva.Type|Luva.Object Any value/type (scalar types are strings as in `type` Lua function). Nil is prohibited - see maybe()
---@return Luva.Lang.Field<T>
function _LUVA._ParseField(value)
    return _LUVA._ParseProp(value)
end

-- I am too lazy to do here proper things so it does nearly the same thing as _ParseField.
-- The `const()` expression will handle the rest ;)
function _LUVA._ParseConstant(constant)
    local raw = _LUVA._ParseProp(constant)
    raw.IsByRef = nil
    raw.IsNilable = nil
    raw.IsReadonly = nil
    raw.Value = constant
    raw.__Kind = "const"    ---@diagnostic disable-line : invisible

    return raw
end