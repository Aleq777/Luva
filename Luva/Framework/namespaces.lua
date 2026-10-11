
---@diagnostic disable : lowercase-global


do

    ---@class Luva.ImportExpression
    ---@field public import fun(self: Luva.ImportExpression, ...: string|string[]): Luva.Namespace Imports full namespace (empty), selected components (array of names as strings) or one self-component (single name as string)
    ---@
    ---@field private _Path Luva.Path
    local __ImportExpression = { }
end



--- Creates a namespace that can be exported/imported.
---@param self Luva.LuaObject|Luva.Namespace|nil Required, example: `Utils = namespace(Utils)` or `namespace(Utils)`
---@param content Luva.LuaObject|Luva.Namespace|nil? Not required. If namespace exists, `content` will be attached (by reference) to existing namespace
---@return Luva.Namespace
function namespace(self, content)
    content = content or { }

    if self == nil then
        self = content
    else
        for k, v in pairs(content) do
            self[k] = v
        end
    end

    return self
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
---@param toNamespace Luva.Namespace
---@param name string
---@param component any
function export(toNamespace, name, component)
    assert(toNamespace ~= nil, "Given namespace doesn't exist, cannot export " .. name)

    toNamespace[name] = component
end