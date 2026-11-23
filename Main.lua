

import "Luva.Engine.OOP.class"
import "Luva.Engine.OOP.Ingredients.readonly"
import "Luva.Engine.OOP.Ingredients.accessor"


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

print(Human.T)
Human.Tester()

-- local moose = Human()

-- moose.Name = "y"

-- -- moose:Greet()

-- print (moose.Test)
-- moose.Test = 10
-- print (moose.Age)

-- print(typeof (moose).__Prototype)
-- print(moose.__Kind)