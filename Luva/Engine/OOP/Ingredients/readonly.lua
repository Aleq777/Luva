
---@diagnostic disable : lowercase-global

--- Assign field in a custom type as a read-only. <br />
--- | difference | const | readonly |
--- | --- | --- | --- |
--- | Must assign instantly | ✅ | ❌ |
--- | Can be assigned in constructor | ❌ | ✅ |
--- | Mutable | ❌ | ❌ |
---@param _type type|Luva.Type Cannot be empty
---@return Luva.Lang.Field
---@nodiscard
readonly = function (_type)
    local t = _LUVA.Utils.ParseType(_type)

    ---@type Luva.Lang.Field
    return {
        __Kind = "readonly",
        Type = t,
        Value = nil
    }
end