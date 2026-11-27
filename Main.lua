

Human = class {
    prototype = {
        _Parent = maybe("table"),
        Parent = accessor {
            get = function (self)
                return self._Parent
            end,
            set = function (self, value)
                param (value, Human)
                self._Parent = value
            end
        },
        Name = readonly("string"),
        Age = accessor {
            get = function (self)
                return self._Age
            end,

            set = function (self, value)
                print "I am older!"
                self._Age = value
            end
        },
        _Age = "number",
        Greet = function (self)
            print ("Hello, I am " .. self.Name)
        end,
    },

    constructor = function (setPrototype, name, age, parent)
        setPrototype {
            Name = name,
            Age = age,
            -- Parent = parent
        }
        Human.HumansCreated = Human.HumansCreated + 1
    end,

    default = function ()
        Human.HumansCreated = Human.HumansCreated + 1
        print "Human created"
    end,

    static = {
        HumansCreated = 0,
        WhoIsOlder = function (humanA, humanB)
            if humanA.Age > humanB.Age then
                print (humanA.Name .. " is older")
            elseif humanA.Age < humanB.Age then
                print (humanB.Age .. " is older")
            else
                print("Same age")
            end
        end
    },

    ["number"] = function (self)
        return self.Age
    end,

    __add = function (self, h2)
        return self.Age + h2.Age
    end
}



local moose = Human("moose", 20)
local aleq = Human("aleq", 20)

-- moose.RealName = ""

print(moose + aleq)

