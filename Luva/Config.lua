


Config = {
    --- Requires Luva to check each time for type-to-type compitability
    --- It slowers the execution, but ensures that you will code faster
    --- (no miss-assigned types etc.) <br />
    --- Default: `true`
    ---@type boolean
    FullTypeChecking = true,

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

            --- For debugging if you don't want to publish your work.
            --- Enter here the name of your local mod, if you don't want to use LocalFilePath
            ---@type string
            ModNameForLocal = "",

            --- For debugging if you don't want to publish your work.
            --- Enter here the absolute path of your local mod
            ---@type string
            LocalFilePath = "",
        },
    },
}