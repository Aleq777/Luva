


do

    ---@class Luva.Type
    ---@field private _Meta metatable
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
        ['*']  = "",
        ['/']  = "",
        ['^']  = "",
        ['+-'] = "",
        ['//'] = "",
        ['&']  = "",
        ['|']  = "",
        ['~']  = "",
        ['!']  = "",
        ['<<'] = "",
        ['>>'] = "",
        ['=='] = "",
        ['<']  = "",
        ['<='] = "",
        ['>']  = "",
        ['>='] = "",
        ['..'] = "",
        ['#']  = "",
        ['.']  = "",
        ['=']  = "",
        ['()'] = ""
    })
end

setmetatable({}, {
    __
})


--- Creates a `class` (like metatable or class/struct in C/C++/C#/Java/...)
---@param members any
---@return Luva.Type
---@nodiscard
function class(members)

    ---@type metatable
    local meta = { }

    for k, v in pairs(members) do
        meta[k] = v
    end

    local resultClass = {
        _Meta = meta
    }

    ---@type Luva.Type
    return resultClass
end

---@type Luva.Type
Array = class({
    [operator('+')] = function ()

    end,
})
x = Array._Meta


return class