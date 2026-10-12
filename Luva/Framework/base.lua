
---@alias Luva.Path string As `folderA.folderB.fileName`
---@alias Luva.LuaObject table<string, any>
---@alias Luva.LuaArray any[]
---@alias Luva.Keyword table<nil, nil>

do
    ---@alias Luva.ConfigSingleton.Globalization.Behaviours.Debugs
    ---| "error" Throws an error and stops the program. `Action` defaults to `nil`
    ---| "warn" Prints a warning and proceeds with `Action` (cannot be nil)
    ---| "silent" Does nothing

    ---@alias Luva.ConfigSingleton.Globalization.Behaviours.Actions
    ---| nil Only when `Debug = "error"`
    ---| "skip" Skips (global will not change)
    ---| "replace" Replaces the global with new component


    ---@class Luva.ConfigSingleton.Globalization.AmbigousBehaviour
    ---@field public Debug Luva.ConfigSingleton.Globalization.Behaviours.Debugs
    ---@field public Action Luva.ConfigSingleton.Globalization.Behaviours.Actions
    local __Behaviour = { }

    ---@class Luva.ConfigSingleton.Globalization
    ---@field public Enabled boolean If `true`, it will enable `using` function
    ---@field public AmbigousBehaviour Luva.ConfigSingleton.Globalization.AmbigousBehaviour
    local __ConfigSingletonGlobalization = { }

    ---@class Luva.ConfigSingleton
    ---@field public Globalization Luva.ConfigSingleton.Globalization `using` function behaviour
    local __ConfigSingleton = { }
end


Luva = { }


return Luva