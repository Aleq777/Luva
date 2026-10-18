

---@module "base"
Luva = dofile("Luva/Framework/base.lua")
---@module "OOP.class"
class = dofile("Luva/Framework/OOP/class.lua")


---@class Luva.Exception : Luva.Object
---@field public Message string
Luva.Exception = class {

    [prototype] = {
        Message = "An unhandled exception occured!"
    },

    [constructor] = function (setPrototype, message)
        setPrototype {
            Message = message
        }
    end,

    [operator('==')] = function (self, right)
        
    end,


}