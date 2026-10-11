
---@alias Luva.LuvaConfigSingleton.Environments
---| "auto"
---| "teardown"
---| "stormworks/lifeboatapi"
---| "fivem"
---| "roblox"
---| nil


---@diagnostic disable : undefined-global
---@enum Luva.LuvaConfigSingleton.Imports
Luva.EnumConfigImports = {
    ["auto"] = "auto",
    ["shared"] = "shared",
    ["require"] = require,
    ["include"] = include,
    ["dofile"] = dofile,
    [nil] = nil
}
---@diagnostic enable : undefined-global

---@alias Luva.LuvaConfigSingleton.ProtectedCalls
---| "auto"
---| "pcall"
---| "custom"
---| nil

---@alias Luva.LuvaConfigSingleton.Classes
---| "auto"
---| "metatable"
---| "custom"
---| nil

do

    ---@class Luva.LuvaConfigSingleton.Globals
    ---@field public Import Luva.LuvaConfigSingleton.Imports
    ---@field public ProtectedCall Luva.LuvaConfigSingleton.ProtectedCalls
    ---@field public Classes Luva.LuvaConfigSingleton.Classes
    local __ConfigGlobals = { }

    ---@class Luva.LuvaConfigSingleton
    ---@field public Environment Luva.LuvaConfigSingleton.Environments
    ---@field public Globals Luva.LuvaConfigSingleton.Globals
    local __Config = { }

end