

import "Luva.Engine.OOP.class"


do
    ---@class HumanT : Luva.Type
    ---@field X integer
    ---@field Greet function
    ---@field Y integer
    local __humanT
end



---@class Human : Luva.Object
---@field Name string
---@field Age integer
---@type HumanT|(fun(): Human)|(fun(name: string, age: integer): Human) -- what the fuck LuaLS & intelisense
Human = class { --[[@type HumanT]]---@diagnostic disable-line : assign-type-mismatch
    static = {
        X = 3,
        Greet = function ()
            print "Hi"
        end
    },
    const = {
        Y = 10
    },
    prototype = {
        Name = string,
        Age = 0
    },
    default = function (self)
        Human.Greet()
    end,
    constructor = function (setPrototype, name, age)
        setPrototype {
            Name = name,
            Age = age
        }
        Human.Greet()
    end,
    destructor = function (self)
        print (type (self))
    end
}



local moose1 = Human("moose 1", 20)
local moose2 = Human() {
    Name = "Moose 2",
    Age = 30
}


-- local mooseMan = Human() {
--     Name = "moose man2",
--     Age = 20
-- }



-- _LUVA.Utils.Entries(mooseMan)
print(moose1)
print(moose2)

