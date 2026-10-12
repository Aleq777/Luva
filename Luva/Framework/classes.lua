
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






















---@alias Luva.DefaultExpression Luva.Keyword



do
    ---@class Luva.ClassBodyCreator
    ---@field public ["prototype"]? fun(...?): table
    ---@field public ["default"]? fun(): table
    local __ClassBody = { }


    ---@alias Luva.ClassPrototype table
    
    ---@alias Luva.ClassPrototypeInvoker fun(...?: any|nil?): Luva.ClassPrototype
    
    ---@alias Luva.ClassDefaultInvoker fun(): Luva.ClassPrototype
    
    ---@generic T
    ---@alias Luva.ClassDestructor fun(self: T)

    ---@generic TInheriting
    ---@class Luva.Type
    ---@field private __Meta metatable
    ---@field private __Prototype? fun(...?): TInheriting
    ---@field private __PrototypeMeta? metatable
    ---@field private __Default? TInheriting
    ---@field private __Constructor? fun(...?): TInheriting
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


---@type Luva.DefaultExpression
default = { }

---@type Luva.Keyword
constructor = { }
---@type Luva.Keyword
destructor = { }

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

        ---@type Luva.ClassPrototypeInvoker
        local protoInvoker = components[prototype]

        ---@diagnostic disable-next-line : invisible
        resultClass.__Prototype = protoInvoker
        __CURRENT_PROTOTYPE = protoInvoker

        ---@diagnostic disable-next-line : invisible
        resultClass.__PrototypeMeta = { }


        -- Does it have a default
        ---@type Luva.ClassDefaultInvoker
        local defInvoker = components[default]
        if defInvoker then
            ---@diagnostic disable-next-line : invisible
            resultClass.__Default = defInvoker()
        else -- must have a default
            ---@diagnostic disable-next-line : invisible
            resultClass.__Default = Luva.Utils.Copy(resultClass.__Prototype())
        end




        -- Does it have a constructor
        ---@type Luva.ClassPrototypeInvoker
        local constrInvoker = components[constructor]
        if constrInvoker then
            ---@diagnostic disable-next-line : invisible
            resultClass.__Constructor = constrInvoker
        else -- Manual constructor
            ---@diagnostic disable-next-line : invisible
            resultClass.__Constructor = function (prototypeBody)
                local instance = prototype()

                for k, v in pairs(prototypeBody) do
                    instance[k] = v
                end

                return instance
            end
        end

        -- the real constructor
        ---@diagnostic disable-next-line : invisible
        resultClass.__Meta.__call = function (self, ...)

            ---@diagnostic disable-next-line : invisible
            __CURRENT_PROTOTYPE = resultClass.__Prototype

            local args = { ... }
            local instance
            if #args > 0 then -- automatic or default constructor
                ---@diagnostic disable-next-line : invisible
                instance = resultClass.__Constructor(...)
            else -- manual or real constructor
                ---@diagnostic disable-next-line : invisible
                instance = Luva.Utils.Copy(resultClass.__Default) --[[@as Luva.ClassPrototype]]
            end

            ---@diagnostic disable-next-line : invisible
            setmetatable(instance, resultClass.__PrototypeMeta)

            __CURRENT_PROTOTYPE = nil
            return instance
        end

        -- does it have destructor
        ---@type Luva.ClassDestructor
        local destrInvoker = components[destructor]
        if destrInvoker then
            ---@diagnostic disable-next-line : invisible
            resultClass.__PrototypeMeta.__gc = destrInvoker
        end


        __CURRENT_PROTOTYPE = nil
    end

    ---@diagnostic disable-next-line : invisible
    setmetatable(resultClass, resultClass.__Meta)
    return resultClass
end



-- test
---@class Human : Luva.Type<Human>, { Count: integer }
---@field public Name string
---@field public Age integer
---@field public Greet fun(self: Human)
Human = class {
    [prototype] = function (name, age)
        return {
            Name = name,
            Age = age,

            Greet = function (self)
                print("Hello, my name is " .. self.Name)
            end
        }
    end,
    [default] = function ()
        return prototype("Janusz", 18)
    end,
    [constructor] = function (name, age)
        return prototype(name, age)
    end,
    [destructor] = function (self)
        print("bye bye " .. self.Name)
    end,

    Count = 0,
}

---@type Human
MooseMan = Human("Moose man", 29)

MooseMan:Greet()