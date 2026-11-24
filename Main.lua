


Human = class {
    prototype = {
        Name = readonly ("string"),
        Age = "number",
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

function sum(a, b)
    param (a, "number")
    param (b, "number")

    return a + b
end

print(
    sum(
        1, as(true, "number")
    )
)


-- param (Human, Human)
-- print(as(moose, "string"))
-- print(moose)
-- moose {
--     Name = 20,
--     Age = "x"
-- }

-- print(moose.Age)
