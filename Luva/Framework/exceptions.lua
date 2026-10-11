
---@diagnostic disable : lowercase-global

do

    ---@class Luva.TryExpression
    ---@field public catch fun(self: Luva.TryExpression, funcCatch: fun(err: any, handled?: fun(...: any|nil?): (boolean, any|nil?)): any|nil?): Luva.TryExpression
    ---@field public finally fun(self: Luva.TryExpression, funcFinally: fun()|nil?): any|nil?, ...
    ---@
    ---@field private _Handle fun(returnValue: any|nil?): (boolean, any|nil?)
    ---@field private _IsThrown boolean
    ---@field private _Result any|nil
    ---@field private _Catchers (fun(err: any, handled?: fun(returnValue: any|nil?): (boolean, any|nil?)): any|nil?)[]
    local __TryExpression = { }

end


--- Tries to execute `funcTry` function
--- Use built-in `error` function to throw an error inside the function
---@param funcTry fun(): any|nil?
---@return Luva.TryExpression
---@nodiscard
function try(funcTry)
    local isThrown, result = pcall(funcTry)

    ---@type Luva.TryExpression
    return {
        _IsThrown = isThrown,
        _Result = result,
        _Catchers = { },

        _Handle = function (...)
            return true, ...
        end,

        ---@nodiscard
        catch = function (self, funcCatch)
            ---@diagnostic disable-next-line : invisible
            table.insert(self._Catchers, funcCatch)
            return self
        end,

        finally = function (self, funcFinally)

            (funcFinally or function () end)();

            ---@diagnostic disable-next-line : invisible
            if not self._IsThrown then
                ---@diagnostic disable-next-line : invisible
                return self._Result
            end

            ---@diagnostic disable-next-line : invisible
            for _, catcher in ipairs(self._Catchers) do

                ---@type (boolean|any)[]
                ---@diagnostic disable-next-line : invisible
                local args = { catcher(self._Result, self._Handle) }
                ---@type boolean
                local catched = args[1]
                table.remove(args, 1)

                if catched then
                    ---@diagnostic disable-next-line : invisible
                    return table.unpack(args)
                end
            end

            ---@diagnostic disable-next-line : invisible
            error(self._Result)
        end,
    }
end