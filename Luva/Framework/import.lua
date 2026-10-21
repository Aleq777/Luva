
---@diagnostic disable : lowercase-global

Luva = {
    Utils = dofile("Luva/Framework/utils.lua")
}


do

    ---@class Luva.ImportExpression
    ---@field public import fun(self: Luva.ImportExpression, ...: string[]): table Imports full namespace (empty), selected components (array of names as strings) or one self-component (single name as string)
    ---@
    ---@field private _Path Luva.Path
    local __ImportExpression = { }
end




--- Selects path of the Lua's file and prepare it for import
---@param path Luva.Path `folderA.folderB.fileName`
---@return Luva.ImportExpression
---@nodiscard
function from(path)
    path = string.gsub(path, "%.", "/") .. ".lua"
    ---@type Luva.ImportExpression
    return {
        _Path = path,

        ---@overload fun(self: Luva.ImportExpression): table
        ---@overload fun(self: Luva.ImportExpression, element: string): table
        import = function (self, ...)
            ---@type string[]
            local args = Luva.Utils.FlattenArray { ... }

            ---@diagnostic disable-next-line : invisible
            local all = dofile(self._Path)

            if #args == 0 then return all          end
            if #args == 1 then return all[args[1]] end

            local final = { }

            for k, v in pairs(all) do
                for _, component in ipairs(args) do
                    if k == component then
                        final[k] = v
                        goto continue
                    end
                end

                ::continue::
            end

            return final
        end
    }
end


--- Attaches to a namespace
---@param toNamespace table
---@param name string
---@param component any
function export(toNamespace, name, component)
    assert(toNamespace ~= nil, "Given namespace doesn't exist, cannot export " .. name)

    toNamespace[name] = component
end


return from, export