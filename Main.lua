

import "Luva.Engine.OOP.class"


do
    ---@class HumanT : Luva.Type
    ---@field X integer
    ---@field Greet function
    ---@field Y integer
    ---@operator call(): Human
    local __humanT
end



---@class Human : Luva.Object
---@field Name string
---@field Age integer
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
}




local mooseMan = Human() {
    Name = "moose man2",
    Age = 20
}

-- _LUVA.Utils.Entries(mooseMan)
print(mooseMan)
