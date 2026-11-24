


Human = class {
    prototype = {
        Name = readonly ("string"),
        Age = maybe("number"),
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
    },

    ["string"] = function (instance)
        return tostring(instance)
    end
}

local moose = Human()
moose.Age = 10
moose.Age = nil

print(moose.Age)
-- param (Human, Human)
-- print(as(moose, "string"))
-- print(moose)
-- moose {
--     Name = 20,
--     Age = "x"
-- }

-- print(moose.Age)
