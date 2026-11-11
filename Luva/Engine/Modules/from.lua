
---@diagnostic disable : lowercase-global

---@module "Luva.Engine.MatchingExpressions.switch"
switch = dofile ("Luva/Engine/MatchingExpressions/switch.lua")



---@alias Luva.ModulePath string

do
    ---@class Luva.Lang.ImportExpression
    ---@field public import fun(self: Luva.Lang.ImportExpression, ...: any[]): table|any
    ---@field private _Path string
    local __importExpression
end




--- Import Luva modules and packages
---@param path Luva.ModulePath "FolderA.FolderB.LuaFile"
---@return Luva.Lang.ImportExpression
---@nodiscard
from = function (path)

    path = string.gsub(path, "%.", "/") .. ".lua"

    ---@type Luva.Lang.ImportExpression
    return {
        _Path = path,

        import = function (self, ...)
            local args = select(1, ...)
            ---@type integer
            local argCount = select("#", ...)
            local components = dofile (self._Path)  ---@diagnostic disable-line : invisible

            switch(argCount, {
                [0] = function ()
                    return components
                end,

                [1] = function ()
                    return components[args[1]]
                end,

                default = function ()
                    local result = { }

                    for _, name in ipairs(args) do
                        result[name] = components[name]
                    end

                    return result
                end
            })
        end
    }
end


return from