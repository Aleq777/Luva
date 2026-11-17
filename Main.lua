

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
        print "hi!!"
    end,
    constructor = function (setPrototype, name, age)
        setPrototype {
            Name = name,
            Age = age
        }
    end
}




-- local mooseMan = Human() {
--     Name = "moose man2",
--     Age = 20
-- }



-- _LUVA.Utils.Entries(mooseMan)
print(mooseMan)
