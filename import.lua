
---@diagnostic disable : lowercase-global

---@alias Luva.LuaObject table<string, any>
---@alias Luva.LuaLS_Type type|"integer"|"any"

---@alias Luva.Package table<string, any>
---@alias Luva.Keyword table<nil, nil>
---@alias Luva.DefaultCase Luva.Keyword

do
    ---@class Luva.ImportExpression
    ---@field public import fun(self: Luva.ImportExpression, ...: string): Luva.Package|Luva.LuaObject|any # Imports module (if ... is empty), one component (if #... is 1) or selected components (if #... is more than 1)
    ---@
    ---@field private _Path string # Path to the Lua module
    local __ImportExpression = { }


    ---@class Luva.TryExpression
    ---@field public catch fun(self: Luva.TryExpression, onCatch: fun(err: any): boolean): Luva.TryExpression # return `true` if succesfully catches error
    ---@field public finally fun(self: Luva.TryExpression, finalFunc: (fun(): any|nil?)|nil?): any|nil? # if no errors, returns `try`'s function, else may return `finally`'s function
    ---@
    ---@field private _Thrown any|nil?
    ---@field private _FuncTry fun(throw: fun(err: any)): any|nil?
    ---@field private _Catchers (fun(err: any): boolean)[]
    local __TryExpression = { }


    ---@generic T
    ---@generic U
    ---@class Luva.SelectExpression
    ---@field public from fun(self: Luva.SelectExpression, array: table<T, U>): Luva.WhereExpression
    ---@
    ---@field private _Fields string[]
    local __SelectExpression = { }
    
    
    ---@generic T
    ---@generic U
    ---@class Luva.WhereExpression
    ---@field public where fun(self: Luva.WhereExpression, query: fun(item: U, index?: T): boolean): Luva.WhereExpression
    ---@field public get fun(self: Luva.WhereExpression): table<T, U>
    ---@
    ---@field private _Result table<T, U>
    ---@field private _Fields string[]
    local __WhereExpression = { }
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
            ---@type Luva.LuaObject|any
            ---@diagnostic disable-next-line : invisible
            local all = dofile(self._Path)
            ---@type string[]
            local args = { ... }

            if #args == 0 then return all          end
            if #args == 1 then return all[args[1]] end

            ---@type Luva.LuaObject
            local result = { }

            for _, item in ipairs(args) do
                for k, v in pairs(all --[[@as Luva.Package]]) do
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


--- Attaches a `component` to `package` if it isn't already attached
--- Improved version of `package[name] = component`
---@param package Luva.Package (namespace)
---@param name string should be the same as `component`'s name 
---@param component any
function export(package, name, component)
    if package == nil then
        error("Namespace doesn't exist - cannot export")
    end

    if package[name] ~= nil then
        print("Component hasn't been attached by export because it already exists")
    else
        package[name] = component
    end
end


---@type Luva.DefaultCase
default = { }

--- Works like switches in different languages
--- Example:
--- ```lua
--- switch(3, {
---  [1] = function () print("one") end,
---  [2] = function () print("two") end,
---  [default] = function () print("maybe three") end
--- }) -- output "maybe three"
--- ```
---@generic T
---@generic U
---@param value T
---@param cases table<T|Luva.DefaultCase, fun(): U|nil?>
---@return U|nil?
function switch(value, cases)
    for case, exec in pairs(cases) do
        if case == value then
            return exec()
        end
    end

    if cases[default] ~= nil then
        return cases[default]()
    end

    error("No case found to match the value " .. value)
end



--- Tries the `func` code
---@param funcTry fun(throw: fun(err: any): nil): any|nil?
---@return Luva.TryExpression
---@nodiscard
function try(funcTry)
    ---@type Luva.TryExpression
    return {
        _FuncTry = funcTry,
        _Thrown = nil,
        _Catchers = { },

        ---@nodiscard
        catch = function (self, onCatch)
            ---@diagnostic disable-next-line : invisible
            table.insert(self._Catchers, onCatch)
            return self
        end,

        finally = function (self, finalFunc)
            finalFunc = finalFunc or function () end

            local function throw(err)
                ---@diagnostic disable-next-line : invisible
                self._Thrown = err
                return nil
            end

            ---@diagnostic disable-next-line : invisible
            local tryResult = self._FuncTry(throw)

            ---@diagnostic disable-next-line : invisible
            if self._Thrown ~= nil then

                ---@diagnostic disable-next-line : invisible
                for _, catcher in ipairs(self._Catchers) do
                    ---@diagnostic disable-next-line : invisible
                    if catcher(self._Thrown) then
                        goto catched
                    end
                end

                ---@diagnostic disable-next-line : invisible
                error("Error not catched: " .. self._Thrown)

                ::catched::
                return finalFunc()
            else
                return tryResult
            end
        end,
    }
end



---@param a boolean|nil?
---@param b boolean|nil?
---@return boolean
function xor(a, b)
    return (a or false) and not (b or false)
end


--- Copies by value (perfect for tables)
---@generic T
---@param value T
---@return T
---@nodiscard
function copy(value)
    if type (value) ~= "table" then return value end

    ---@generic T
    ---@type T
    local result = { }

    for k, v in pairs(value) do
        result[k] = copy(v)
    end

    return result
end

--- Selects properties with `where` conditions from an array (like SQL query `SELECT`)
---@param ... string Properties. If empty, selects all
---@return Luva.SelectExpression
---@nodiscard
function select(...)
    local fields = { ... }
    ---@type Luva.SelectExpression
    return {
        _Fields = fields,

        from = function (self, array)
            ---@type Luva.WhereExpression
            return {
                _Result = copy(array),
                ---@diagnostic disable-next-line : invisible
                _Fields = self._Fields,

                where = function (this, query)
                    local result = { }

                    ---@diagnostic disable-next-line : invisible
                    for k, v in pairs(this._Result) do
                        if query(v, k) then
                            result[k] = v
                        end
                    end

                    ---@diagnostic disable-next-line : invisible
                    this._Result = result
                    return this
                end,

                get = function (this)
                    ---@diagnostic disable-next-line : invisible
                    if #this._Fields > 0 then

                        ---@diagnostic disable-next-line : invisible
                        for k in pairs(this._Result) do
                            ---@diagnostic disable-next-line : invisible
                            for _, property in ipairs(this._Fields) do
                                if property == k then
                                    goto continue
                                end
                            end

                            ---@diagnostic disable-next-line : invisible
                            this._Result[k] = nil

                            ::continue::
                        end

                    end

                    ---@diagnostic disable-next-line : invisible
                    return this._Result
                end
            }
        end
    }
end


return from, namespace, export, default, switch, try, xor, copy, select