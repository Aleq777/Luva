
---@diagnostic disable : lowercase-global

---@alias LuaObject table<string, any>

---@alias Luva.Package table<string, any>

do
    ---@class Luva.ImportExpression
    ---@field public import fun(self: Luva.ImportExpression, ...: string): LuaObject|any Imports module (if ... is empty), one component (if #... is 1) or selected components (if #... is more than 1)
    ---@
    ---@field private _Path string Path to the Lua module
    local __ImportExpression = { }
end




--- Select a Lua's file path and then import with `:import()`
---@param path string
---@return Luva.ImportExpression
---@nodiscard
function from(path)
    path = string.gsub(path, "%.", "/")
    path = path .. ".lua"

    ---@type Luva.ImportExpression
    return {
        _Path = path,
        import = function (self, ...)
            ---@type LuaObject|any
            ---@diagnostic disable-next-line : invisible
            local all = dofile(self._Path)
            ---@type string[]
            local args = { ... }

            if #args == 0 then return all          end
            if #args == 1 then return all[args[1]] end

            ---@type LuaObject
            local result = { }

            for _, item in ipairs(args) do
                for k, v in pairs(all --[[@as LuaObject]]) do
                    if k == item then
                        result[k] = v
                        goto continue
                    end
                end

                error("Element " .. item .. " doesn't exist in this module")

                ::continue::
            end

            return result
        end,
    }
end


--- Create a namespace/package
---@param self Luva.Package|nil Required, example: `Utils = namespace(Utils)`
---@param content Luva.Package|nil? Content of the package. Not required. If package already exists, it will add content to existing package.
---@return Luva.Package self # Standard
---@nodiscard
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


return from, namespace