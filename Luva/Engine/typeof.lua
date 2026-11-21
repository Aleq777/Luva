
---@diagnostic disable : lowercase-global

import "Luva.Engine.matching_expr"

--- A reference representation of `function` type by Luva. <br />
---@see typeof
---@type Luva.Lang.Keyword
functionT = {
    __Kind = "scalar_lua_ref"
}

--- A reference representation of `number` type by Luva. <br />
---@see typeof
---@type Luva.Lang.Keyword
numberT = {
    __Kind = "scalar_lua_ref"
}

--- A reference representation of `boolean` type by Luva. <br />
---@see typeof
---@type Luva.Lang.Keyword
booleanT = {
    __Kind = "scalar_lua_ref"
}

--- A reference representation of `nil` type by Luva. <br />
---@see typeof
---@type Luva.Lang.Keyword
nilT = {
    __Kind = "scalar_lua_ref"
}


---@param expr Luva.Object|table
---@return Luva.Type|table
---@nodiscard
local function _getTableType(expr)
    if not expr.__Kind or expr.__Kind ~= "instance" then    ---@diagnostic disable-line : invisible
        return table
    end

    ---@cast expr Luva.Object
    return expr.__Type  ---@diagnostic disable-line : invisible
end

--- Returns the reference to the
--- type of `expr`.
---@param expr any
---@return Luva.Type|table type # In case of scalars, returns `table`, `string` or special reference representations
---@nodiscard
typeof = function (expr)
    local t = type (expr)

    return match (t, {
        ["string"] = string,
        ["function"] = functionT,
        ["number"] = numberT,
        ["boolean"] = booleanT,
        ["nil"] = nilT,
        default = _getTableType(expr)
    } --[[@as Luva.Lang.MatchingBaseBuilder<type>]])
end