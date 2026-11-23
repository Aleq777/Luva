


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

    --- Selected function for importing files.
    --- By default it's `dofile`.
    --- If your environment doesn't support `dofile`,
    --- then use other function (`require`, `include`, `loadfile` etc)
    --- CURRENTLY DOESN'T DO ANYTHING!!!
    ---@deprecated
    ---@type function
    ImportingFunction = dofile,
}