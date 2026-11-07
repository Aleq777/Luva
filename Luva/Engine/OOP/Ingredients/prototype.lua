
---@module "Luva.base"

do
    ---@class Luva.Lang.PrototypeBuilder
    local __prototypeBuilder

    ---@generic TInstance
    ---@class Luva.Lang.ClassPrototype
    ---@field public Fields     table<Luva.Lang.Identifier, any>
    ---@field public Methods    table<Luva.Lang.Identifier, fun(self: TInstance, ...: nil|any[]): any|nil>
    ---@field public Accessors  table<Luva.Lang.Identifier, Luva.Lang.Accessor>
    ---@field public Readonlys  table<Luva.Lang.Identifier, Luva.Lang.Readonly<any>>
    local __prototype
end


---@param resultClass Luva.Type
---@param prototypeBuilder Luva.Lang.PrototypeBuilder
function _SetupPrototype(resultClass, prototypeBuilder)

    resultClass.__Prototype = { ---@diagnostic disable-line : invisible
        Fields = { },
        Methods = { },
        Accessors = { },
        Readonlys = { },
    }

end


return _SetupPrototype