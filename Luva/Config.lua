


_LUVA.Config = {
    --- Modifies the language so it is usable in later versions (5.1->5.4 etc.)
    ---@module "Luva.ForwardCompatibility"
    ---@type boolean
    ForwardCompatibility = true,

    --- Requires Luva to check each time for type-to-type compitability
    --- It slowers the execution, but ensures that you will code faster
    --- (no miss-assigned types etc.) <br />
    --- It will also affect the `param` expression. <br />
    --- Default: `true`
    ---@type boolean
    FullTypeChecking = true,
}