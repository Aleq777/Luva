
---@diagnostic disable : lowercase-global

---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")
---@module "Luva.Engine.OOP.Ingredients.readonly"
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.OOP.Ingredients.luvatype"
---@module "Luva.Engine.MatchingExpressions.switch"
switch = dofile ("Luva/Engine/MatchingExpressions/switch.lua")
---@module "Luva.Engine.kind"
kindof = dofile ("Luva/Engine/kind.lua")


do
    ---@alias Luva.Lang.PrototypeBuilder table<Luva.Lang.Identifier, any>
    
    ---@generic TInstance : Luva.Object
    ---@class Luva.Lang.ClassPrototype
    ---@field public Fields     table<Luva.Lang.Identifier, any>
    ---@field public Methods    table<Luva.Lang.Identifier, fun(self: TInstance, ...: nil|any[]): any|nil>
    ---@field public Accessors  table<Luva.Lang.Identifier, Luva.Lang.Accessor<TInstance, any>>
    ---@field public Readonlys  table<Luva.Lang.Identifier, Luva.Lang.Readonly<any>>
    ---@field public GetByIdentifier fun(self: Luva.Lang.ClassPrototype<TInstance>, identifier: Luva.Lang.Identifier): any # if none, throws an error
    ---@field public GetTable        fun(self: Luva.Lang.ClassPrototype<TInstance>, identifier: Luva.Lang.Identifier): table<Luva.Lang.Identifier, any> -- one of ClassPrototype.* fields
    local __prototype
end

_LUVA.Errors.NO_FIELD_FOUND_PROTOTYPE = "Haven't found a field corresponding to GetByIdentifier's argument"



---@generic TInstance
---@param classPrototype Luva.Lang.ClassPrototype<TInstance>
---@param identifier Luva.Lang.Identifier
---@param action fun(searchedTable: table<Luva.Lang.Identifier, any>, content: any): any
---@return any
---@nodiscard
local function _searchThroughPrototypeObject(classPrototype, identifier, action)
    for _, searchedTable in pairs(classPrototype) do

        for id, content in pairs(searchedTable) do
            if identifier == id then
                return action(searchedTable, content)
            end
        end

    end

    error(_LUVA.Errors.NO_FIELD_FOUND_PROTOTYPE)
end


---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
---@param prototypeBuilder Luva.Lang.PrototypeBuilder
function _SetupPrototype(resultClass, prototypeBuilder)

    rawset(resultClass, "__Prototype", {
        Fields = { },
        Readonlys = { },
        Methods = { },
        Accessors = { },

        GetByIdentifier = function (self, identifier)
            return _searchThroughPrototypeObject(self, identifier, function (searchedTable, content)
                return content
            end)
        end,

        GetTable = function (self, identifier)
            return _searchThroughPrototypeObject(self, identifier, function (searchTable, content)
                return searchTable
            end)
        end

    } --[[@as Luva.Lang.ClassPrototype<Luva.Object>]])


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

        } --[[@as Luva.Lang.MatchingBaseBuilder<type, fun()>]])
    end

end


return _SetupPrototype