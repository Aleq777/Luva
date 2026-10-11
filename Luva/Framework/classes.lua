


do

    ---@generic TType
    ---@class Luva.Type
    ---@field public new fun(self: Luva.Type<TType>, ...?: any): TType
    ---@field private _Meta metatable
    ---@field private _Prototype fun(...?: any): TType
    local __Type = { }
end

---@alias Luva.Operator
---| '+' Add
---| '-' Subtract
---| '*' Multiply
---| '/' Divide
---| '^' Power
---| '+-' Change symbol (`-a`)
---| '//' Divide integer
---| '&' and
---| '|' or
---| '~' xor
---| '!' not
---| '<<' Binary left
---| '>>' Binary right
---| '==' Equals (and ~= as not equals)
---| '<' Less than
---| '<=' Less or equals
---| '>' Greater than
---| '>=' Greater or equals
---| '..' Concat strings
---| '#' Length
---| '.' Read missing index (`a.not_defined`)
---| '=' Set missing index (`a.not_defined = defined`)
---| '()' Call (`a()`)

---@alias Luva.OperatorName
---| "__add" +
---| "__sub" -
---| "__mul" *
---| "__div" /
---| "__mod" %
---| "__pow" a^b
---| "__unm" -a
---| "__idiv" //
---| "__band" &
---| "__bor" |
---| "__bxor" a ~ b
---| "__bnot" ~a
---| "__shl" # <<
---| "__shr" >>
---| "__eq" ==, ~=
---| "__lt" # <
---| "__le" # <=
---| "__gt" >
---| "__ge" >=
---| "__concat" ..
---| "__len" \# (length)
---| "__tostring" tostring()
---| "__index" a.x
---| "__newindex" a.x = b
---| "__call" ()
---| "__pairs" pairs()
---| "__ipairs" ipairs()
---| "__gc" destructor
---| "__close" local destructor
---| "__mode"
---| "__metatable"
---| "__name"



---@type Luva.Keyword
static = { }




--- Create an operator adnotation in class
--- Example:
--- ```lua
--- Number = class({
---    [operator('+')] = function (self, numB) return self.Value + numB.Value end
--- })
--- ```
---@param op Luva.Operator
---@return Luva.OperatorName
---@nodiscard
function operator(op)
    return switch(op, {
        ['+']  = "__add",
        ['-']  = "__sub",
        ['*']  = "__mul",
        ['/']  = "__div",
        ['%']  = "__mod",
        ['^']  = "__pow",
        ['+-'] = "__unm",
        ['//'] = "__idiv",
        ['&']  = "__band",
        ['|']  = "__bor",
        ['~']  = "__bxor",
        ['!']  = "__bnot",
        ['<<'] = "__shl",
        ['>>'] = "__shr",
        ['=='] = "__eq",
        ['<']  = "__lt",
        ['<='] = "__le",
        ['>']  = "__gt",
        ['>='] = "__ge",
        ['..'] = "__concat",
        ['#']  = "__len",
        ['.']  = "__index",
        ['=']  = "__newindex",
        ['()'] = "__call",
        [default] = op
    })
end


--- Create a constructor in class
--- Example:
--- ```lua
--- Number = class({
---     [constructor] = function (a, b) return constructor { Value = a + b } end
--- }, function (value) return { Value = value } end)
--- ```
---@generic T : table
---@param propertySet T
---@
function constructor(propertySet)

end


--- Creates a `class` (like metatable or class/struct in C/C++/C#/Java/...)
---@param members any
---@param prototype fun(...): table
---@return Luva.Type
---@nodiscard
function class(members, prototype)

    ---@type metatable
    local meta = { }

    for k, v in pairs(members) do
        
        meta[k] = v
    end

    ---@generic T
    ---@type Luva.Type<T>
    local resultClass = {
        _Meta = meta,
        _Prototype = function (...)
            return { }
        end,
        new = function (self, ...)
            local instance
            if self[constructor] then
                instance = self[constructor](...)
            else
                instance = self._Prototype(...)
            end

            setmetatable (instance, self._Meta)
            return instance
        end
    }

    ---@type Luva.Type
    return resultClass
end

---@type Luva.Type
Array = class({
    [operator('+')] = function (a, b)

    end,
    [constructor] = function (a, b)
        a = a * 2
        b = b * 2
        return { A = a, B = b }
    end
})
x = Array:new()


return class