
---@diagnostic disable : lowercase-global


do

    ---@generic TResult
    ---@generic TDelegateResult
    ---@class Luva.Delegate
    ---@field private _Funcs (fun(...: any[]): TDelegateResult)[]
    ---@field private _Resulter fun(...: any[]): TResult
    local __Delegate = { }

end


---@generic TResult
---@generic TDelegateResult
---@param resulter fun(...: any[]): TResult
---@param ... (fun(...: any[]): TDelegateResult)[]
---@return Luva.Delegate
---@nodiscard
local function _newDelg(resulter, ...)
    local newd = {
        _Funcs = Luva.Utils.Copy { ... },
        _Resulter = resulter
    }

    setmetatable(newd, _MetaDelg)
    return newd
end


---@type metatable
_MetaDelg = {
    __add = function (self, right)
        local newd = _newDelg(right._Resulter, right._Funcs)
        table.insert(newd._Funcs, right)    ---@diagnostic disable-line : invisible
        return newd
    end,

    __call = function (self, ...)
        local results = { }

        for _, func in ipairs(self._Funcs) do
            table.insert(results, func(...))
        end

        return self._Resulter(table.unpack(results))
    end,
}


--- Creates a new delegate
--- ## Example:
--- ```lua
--- function sum(a, b) return a + b end
--- function multiply(a, b) return a * b end
--- 
--- avg = delegate(function (...)
---     local sum, args = 0, { ... }
---     for _, v in ipairs(args) do sum = sum + v end
---     return sum / #args
--- end)
--- avg = avg + sum + multiply
--- print(avg(2, 2)) -- Average: 4
--- ```
---@generic TDelegateResult
---@generic TResult
---@param resulter fun(...: any[]): TResult
---@param ... (fun(...: any[]): TDelegateResult)[]
---@return Luva.Delegate
---@nodiscard
function delegate(resulter, ...)
    return _newDelg(resulter, ...)
end



return delegate