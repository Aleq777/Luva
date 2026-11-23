
---@diagnostic disable : lowercase-global


--- Lets you create a field that can be `nil`
---@param _type type|Luva.Type Cannot be empty nor a ready-value
---@return Luva.Lang.Field
---@nodiscard
maybe = function (_type)
    local raw = _LUVA._ParseProp(_type)
    raw.IsNilable = true
    raw.__Kind = "maybe"    ---@diagnostic disable-line : invisible

    return raw
end