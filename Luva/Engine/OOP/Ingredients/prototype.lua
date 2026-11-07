
---@diagnostic disable : lowercase-global

---@module "Luva.base"
---@module "Luva.Engine.OOP.Ingredients.readonly"
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.MatchingExpressions.switch"
switch = dofile ("Luva/Engine/MatchingExpressions/switch.lua")
---@module "Luva.Engine.kind"
kindof = dofile ("Luva/Engine/kind.lua")


do
    ---@alias Luva.Lang.PrototypeBuilder table<Luva.Lang.Identifier, any>
    
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

    rawset(resultClass, "__Prototype", {
        Fields = { },
        Methods = { },
        Accessors = { },
        Readonlys = { },
    })

    local prototype = resultClass.__Prototype   ---@diagnostic disable-line : invisible

    for identifier, content in pairs(prototypeBuilder) do
        switch (type (content), {
            ["table"] = function ()
                ---@cast content table
                local kind = kindof (content)

                switch (kind, {
                    ["accessor"] = function ()
                        ---@cast content Luva.Lang.Accessor<Luva.Object, any>
                        prototype.Accessors[identifier] = content
                    end,

                    ["readonly"] = function ()
                        ---@cast content Luva.Lang.Readonly<any>
                        prototype.Readonlys[identifier] = content
                    end,

                    default = function ()
                        prototype.Fields[identifier] = content
                    end
                })

            end,

            ["function"] = function ()
                ---@cast content function
                prototype.Methods[identifier] = content
            end,

            default = function ()
                prototype.Fields[identifier] = content
            end

        } --[[@as table<type, function>]])
    end

end


return _SetupPrototype