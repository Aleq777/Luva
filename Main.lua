

import "Luva.Engine.OOP.class"

---@class Human : Luva.Object
---@field public X integer
---@type Luva.Type|{X: integer,__call: function}
Human = class {
    const = {
        X = 3
    }
}

---@type Human
-- local w = Human()
-- Human.X = empty

Human.X = 4


print(Human.X)