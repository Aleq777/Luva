

import "Luva.Engine.OOP.class"
import "Luva.Engine.OOP.Ingredients.readonly"
import "Luva.Engine.OOP.Ingredients.accessor"
import "Luva.Engine.param"


Human = class {
    prototype = {
        Name = readonly (string),
        Age = "integer",
        Greet = function (self)
            print("Hello, my name is " .. self.Name)
        end,
        Test = accessor {
            get = function (self)
                return self.Name
            end,

            set = function (self, value)
                self.Age = value
            end
        }
    },

    static = {
        T = 10,
        Tester = function ()
            print "Test"
        end
    }
}

local moose = Human()

-- param (Human, Human)
param ("3", "number")
