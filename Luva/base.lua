

---@alias Luva.Lang.Identifier string name for fields etc

do
    --- It tells what kind of expression is that.
    --- Types are data-interpretation
    ---@class Luva.Lang.StrictKind
    ---@field private __Kind string
    local __strictType
end

--- Luva things to use publicly
Luva = { }

--- Luva engine ingredients
_LUVA = {

    ---@type table<Luva.Lang.Identifier, string>
    Errors = { }
}


return Luva, _LUVA