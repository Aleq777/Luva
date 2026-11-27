
---@diagnostic disable : lowercase-global

--- Assign field in a custom type as a read-only. <br />
--- | difference | const | readonly |
--- | --- | --- | --- |
--- | Must assign instantly | ✅ | ❌ |
--- | Can be assigned in constructor | ❌ | ✅ |
--- | Mutable | ❌ | ❌ |
---@param _type type|Luva.Type Cannot be empty nor a ready-value
---@return Luva.Lang.Field
---@nodiscard
readonly = function (_type)
    if _LUVA.Utils.IsInstance(_type) then
        error ("Readonlys can have only types as an argument, not nil nor value!", 2)
    end

    local raw = _LUVA._ParseProp(_type)

    raw.IsReadonly = true
    raw.__Kind = "readonly" ---@diagnostic disable-line : invisible

    return raw
end