
---@diagnostic disable : lowercase-global


do

    ---@class Luva.Procedure
    ---@field private _Funcs fun(...: any[])[]
    local __Procedure = { }
end


---@param ... fun(...: any[])[]
---@return Luva.Procedure
---@nodiscard
local function _newProc(...)
    ---@type Luva.Procedure
    local pr = {
        _Funcs = Luva.Utils.Copy { ... }
    }

    setmetatable(pr, _MetaProc)
    return pr
end

---@type metatable
_MetaProc = {
    ---@param self Luva.Procedure
    ---@param right fun(...: any[])
    ---@return Luva.Procedure
    __add = function (self, right)
        local newProc = _newProc(self._Funcs)   ---@diagnostic disable-line : invisible
        table.insert(newProc, right)
        return newProc
    end,

    ---@param self Luva.Procedure
    ---@param ... any[]
    __call = function (self, ...)
        for _, func in ipairs(self._Funcs) do   ---@diagnostic disable-line : invisible
            func(...)
        end
    end,

}


--- Create a new procedure
--- ## Example
--- ```lua
--- greeter = procedure ()
--- 
--- function foo() print "Hi!" end
--- function bar() print "Hello!" end
--- 
--- greeter = greeter + foo + bar
--- greeter() -- Hi! Hello!
--- ```
---@param ... fun(...: any[])[]
---@return Luva.Procedure
---@nodiscard
function procedure(...)
    return _newProc(...)
end



return procedure