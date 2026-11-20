


_LUVA.Config = {
    --- Modifies the language so it is usable in later versions (5.1->5.4 etc.)
    ---@module "Luva.ForwardCompatibility"
    ---@type boolean
    ForwardCompatibility = true,

    --- Requires Luva to check each time for type-to-type compitability
    --- It slowers the execution, but ensures that you will code faster
    --- (no miss-assigned types etc.) <br />
    --- Default: `true`
    ---@type boolean
    FullTypeChecking = true,

    --- Selects which function should Luva use to import modules
    ---@type Luva.Lang.Config.ImportingEnum
    ImportingFunction = "luva",

    --- Configs for each environment
    Environments = {
        --- Teardown game
        Teardown = {

            --- How Luva should search for your mod
            ---@type Luva.Lang.Config.Teardown.FetchMethodEnum
            FetchMethod = "distinct_file",

            --- Value for FetchMethod
            ---@type string
            ModID = "",

            --- Value for FetchMethod
            ---@type string
            DistinctFileName = "",
        },
    },
}