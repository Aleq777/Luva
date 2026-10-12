
---@diagnostic disable : lowercase-global

Luva = {
    Utils = dofile("Luva/Framework/utils.lua")
}

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


























do
    ---@class Luva.ClassBodyCreator
    ---@field public ["prototype"]? fun(...?): table
    ---@field public ["default"]? fun(): table
    local __ClassBody = { }


    ---@generic TInheriting
    ---@class Luva.Type
    ---@field private __Meta metatable
    ---@field private __Prototype? fun(...?): TInheriting
    ---@field private __PrototypeMeta? metatable
    ---@field private __Default? TInheriting
    ---@field private __GetDefault? fun(): TInheriting
    local __Type = { }
end



__CURRENT_PROTOTYPE = nil

---@generic TBody
---@param ...? any|nil?
---@return TBody
---@nodiscard
function prototype(...)
    if __CURRENT_PROTOTYPE == nil then
        error("Cannot use prototype outside of class definition")
    end

    return __CURRENT_PROTOTYPE(...)
end

default = { }


--- Create a class
---@param components Luva.ClassBodyCreator
---@return Luva.Type
---@nodiscard
function class(components)
    ---@type Luva.Type
    local resultClass = {
        __Meta = { }
    }

    -- Does it have a prototype
    if components[prototype] then

        ---@diagnostic disable-next-line : invisible
        resultClass.__Prototype = components[prototype]
        ---@diagnostic disable-next-line : invisible
        __CURRENT_PROTOTYPE = resultClass.__Prototype

        ---@diagnostic disable-next-line : invisible
        resultClass.__PrototypeMeta = { }

        if components[default] then
            ---@diagnostic disable-next-line : invisible
            resultClass.__GetDefault = components[default]
            ---@diagnostic disable-next-line : invisible
            resultClass.__Default = components[default]()
            --- Default constructor
            ---@generic TType
            ---@param self metatable
            ---@return TType
            ---@diagnostic disable-next-line : invisible
            function resultClass.__Meta.__call(self)
                ---@diagnostic disable-next-line : invisible
                local instance = Luva.Utils.Copy(resultClass.__Default)
                ---@diagnostic disable-next-line : invisible
                setmetatable(instance, resultClass.__PrototypeMeta) ---@diagnostic disable-line : param-type-mismatch
                return instance
            end
        else
            --- Manual constructor
            ---@generic TBody : table
            ---@generic TType
            ---@param self metatable
            ---@param prototypeBody TBody
            ---@return TType
            ---@diagnostic disable-next-line : invisible
            function resultClass.__Meta.__call(self, prototypeBody)
                -- empty instance for manual constructor
                ---@diagnostic disable-next-line : invisible
                local instance = resultClass.__Prototype()
    
                for k, v in pairs(prototypeBody) do
                    instance[k] = v
                end
    
                ---@diagnostic disable-next-line : invisible
                setmetatable(instance, resultClass.__PrototypeMeta)
                return instance
            end
        end


        __CURRENT_PROTOTYPE = nil
    end

    ---@diagnostic disable-next-line : invisible
    setmetatable(resultClass, resultClass.__Meta)
    return resultClass
end



-- test
---@class Human : Luva.Type<Human>
---@field public Name string
---@field public Age integer
Human = class {
    [prototype] = function (name, age)
        return {
            Name = name,
            Age = age
        }
    end,
    [default] = function ()
        return prototype("Janusz", 18)
    end,
}

---@type Human
MooseMan = Human("Moose man", 29)

print(MooseMan.Name)


