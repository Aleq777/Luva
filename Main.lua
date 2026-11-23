


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
param (3, "number")
