

do
    ---@generic T
    ---@class Luva.Lang.Field : Luva.Lang.StrictKind
    ---@field public Type Luva.Type|string
    ---@field public DefaultValue T|nil
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
        DefaultValue = _value
    }   --[[@as Luva.Lang.Field]]
end