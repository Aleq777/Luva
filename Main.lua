

import "Luva.Engine.OOP.class"
import "Luva.Engine.empty"
import "Luva.Engine.OOP.Ingredients.readonly"



Human = class {
    prototype = {
        Name = readonly(string),
        Age = "integer"
    },
}

local moose = Human()

-- moose.Name = "y"

print(moose.Age)