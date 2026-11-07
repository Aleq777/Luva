
---@diagnostic disable # only examples here


Human = class {
    extends = Animal,
    -- generic version
    extends = Animal[genericof().T], -- genericof() is current class, genericof(className) is className class


    implements = { IIntelligent, IIdiot },

    -- On prototype you assing field default values
    -- Types you should assign with LuaLS annotations
    -- Here you can define accessors fields with `field`
    -- And object's methods (functions with self)
    prototype = {
        Name = "John",
        LastName = "Kowalski",
        Age = 0,

        FullName = field {
            get = function (self)
                return self.Name .. ' ' .. self.LastName
            end,

            set = function (self, value)
                self.Name = value[1]
                self.LastName = value[2]
            end
        },

        ID = readonly,

        Greet = function (self)
            print("Hello, I am " .. self.FullName)
        end
    },

    -- Constructor using setPrototype function
    constructor = function (setPrototype, name, lastName, age)
        Human.Count = Human.Count + 1
        

        setPrototype {
            Name = name,
            LastName = lastName,
            Age = age,
            ID = Human.Count
        }
    end,

    -- Default constructor. It activates, when user
    -- uses object-like constructor and not the function-like constructor
    default = function ()
        Human.Count = Human.Count + 1
    end,

    -- Activates on data destructing
    destructor = function (self)
        print ("I'm dying :(")
    end,

    -- Generics
    -- generic function adds a generic for the class
    -- Access by genericof().T -- example
    -- Use outside with Human[string] -- array index-like
    template = function (generic, typeT)
        generic ("T", typeT)
    end,

    -- Static class' fields
    static = {
        Count = 1,
    },

    -- override operator
    -- metamethod names work too
    [operator('+')] = function (left, right)
        local result = left.Age + right.Age
        return result
    end,

    -- type conversion is by a reference to the type
    -- or scalar table
    [string] = function (self)
        return self.FullName
    end,

    -- Immutable constants
    const = {
        Type = "Homo sapiens sapiens"
    }
}