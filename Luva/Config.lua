


return {
    --- Requires Luva to check each time for type-to-type compitability
    --- It slowers the execution, but ensures that you will code faster
    --- (no miss-assigned types etc.) <br />
    --- Default: `true`
    ---@type boolean
    FullTypeChecking = true,

    --- If you use Lua 5.1, for environemtns you have `getfenv` and `setfenv`. <br />
    --- As of Lua 5.2+, they are removed which makes forward-compatibility impossible (one of [Luva'a principle](../README.md#3lua-forward-compatibility)).
    --- - If you can, use newer Lua versions for environment management. <br />
    --- - If you have to use Lua 5.1 and need to use environmental functions, change this setting to `false`
    --- Default: `true`
    ---@type boolean
    DisableEarlyEnvironments = true,
}