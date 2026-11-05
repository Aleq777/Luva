
---@diagnostic disable : lowercase-global


---@alias Luva.ModulePath string

do
    ---@class Luva.Lang.ImportExpression
    ---@field public import fun(self: Luva.Lang.ImportExpression, ...: any[]): table|any
    local __importExpression
end




--- Import Luva modules and packages
---@param path Luva.ModulePath
---@return Luva.Lang.ImportExpression
---@nodiscard
from = function (path)
    path = string.gsub(
        string.sub(path, #path - #".lua"),
        "%/",
        "."
    )


    ---@type Luva.Lang.ImportExpression
    return {
        import = function (self, ...)
            local args = select(1, ...)
            ---@type integer
            local argCount = select("#", ...)


        end
    }
end


return from