
-- import
dofile ("Luva/Engine/Modules/import.lua")
import ("Luva/ForwardCompatibility.lua")


---@alias Luva.Lang.Identifier string name for fields etc

---@alias Luva.Dynamic boolean|string|number|integer|table|function|metatable



--- Luva things to use publicly
local Luva = { }

--- Luva engine ingredients
local _LUVA = {

    ---@type table<Luva.Lang.Identifier, string>
    Errors = { },

    Config = import ("Luva/Config.lua")
}


return Luva, _LUVA