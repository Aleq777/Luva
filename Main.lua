

import "Luva.Engine.OOP.class"
import "Luva.Engine.empty"
import "Luva.Engine.OOP.Ingredients.readonly"



Human = class {
    prototype = {
        Name = readonly(string)
    }
}

local moose = Human() {
    Name = "h"
}

print(moose.Name)