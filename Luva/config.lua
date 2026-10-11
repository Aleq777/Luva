

---@type Luva.LuvaConfigSingleton
Luva.Config = {
    Environment = "auto",

    -- Best to leave everything as "auto"
    Globals = {
        Import = Luva.EnumConfigImports.auto,
        ProtectedCall = "auto",
        Classes = "auto"
    }
}

