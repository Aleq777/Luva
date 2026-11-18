
import "Luva/Config.lua"


if not _LUVA.Config.ForwardCompatibility then
    return
end

if setmetatable == nil or getmetatable == nil or dofile == nil then
    error ("Luva framework environmental requirements haven't met: metatables, dofile")
end

--- In Luva framework, it is unsupported due to lack of forward-compilability.
--- Please, create tables and return them to create a module. Use `dofile` to import
--- or `import` function from Luva framework.
---@param name string
---@param ... any
---@deprecated
module = function (name, ...)
    error ("Lua's module function is unsupported in Luva framework due to lack of forward-compilability")
end


if table.unpack == nil then
    --- Returns the elements from the given `list`. This function is equivalent to
    --- `return list[i], list[i+1], ···, list[j]`
    --- By default, `i` is 1 and `j` is `#list`.
    table.unpack = unpack
end

if table.pack == nil then
    --- Returns a new table with all arguments stored into keys 1, 2, etc. and with a field "n" with the total number of arguments.
    ---@param ... any
    ---@return table
    table.pack = function (...) ---@diagnostic disable-line : duplicate-set-field
        return {
            n = select("#", ...),
            ...
        }
    end
end

if math.log10 == nil then
    --- Returns the base-10 logarithm of x.
    ---@param x number
    ---@return number
    math.log10 = function (x)   ---@diagnostic disable-line : duplicate-set-field
        return math.log(x) / math.log(10)
    end
end

if math.mod == nil then
    math.mod = math.fmod
end

if loadstring == nil then
    loadstring = load
end

if string.gfind == nil then
    string.gfind = string.gmatch
end