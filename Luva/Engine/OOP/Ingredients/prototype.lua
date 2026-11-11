
---@diagnostic disable : lowercase-global

---@module "Luva.base"
local _, _LUVA = dofile ("Luva/base.lua")
---@module "Luva.Engine.OOP.Ingredients.readonly"
---@module "Luva.Engine.OOP.Ingredients.accessor"
---@module "Luva.Engine.OOP.Ingredients.luvatype"
---@module "Luva.Engine.MatchingExpressions.switch"
import ("Luva/Engine/MatchingExpressions/switch.lua")
---@module "Luva.Engine.kind"
import ("Luva/Engine/kind.lua")


do
    ---@alias Luva.Lang.PrototypeBuilder table<Luva.Lang.Identifier, any>


    ---@class Luva.Lang.ClassPrototype
    ---@field public PrototypeMetatable Luva.Lang.PseudoMetatable
    ---@field public Constants table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field public Fields table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field public Methods table<Luva.Lang.Identifier, function>
    ---@field public Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>
    ---@field public Generics table<Luva.Lang.Identifier, Luva.Type> -- idk if needed
    ---@field public Externs table<Luva.Lang.Identifier, Luva.Dynamic>[] -- idk if needed
    local __prototype
end

_LUVA.Errors.NO_FIELD_FOUND_PROTOTYPE = "Haven't found a field corresponding to GetByIdentifier's argument"



---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
---@param prototypeBuilder Luva.Lang.PrototypeBuilder
local function _SetupPrototype(resultClass, prototypeBuilder)

    rawset(resultClass, "__Prototype", {
        PrototypeMetatable = { },
        Constants = { },
        Fields = { },
        Methods = { },
        Accessors = { },
        Generics = { },
        Externs = { },
    } --[[@as Luva.Lang.ClassPrototype]])

    local prototype = resultClass.__Prototype --[[@as Luva.Lang.ClassPrototype]]   ---@diagnostic disable-line : invisible

    for identifier, content in pairs(prototypeBuilder) do
        switch (type (content), {
            ["table"] = function ()
                ---@cast content table
                local kind = kindof (content)

                switch (kind, {
                    ["accessor"] = function ()
                        ---@cast content Luva.Lang.Accessor<Luva.Object, any>
                        resultClass.__Prototype.Accessors[identifier] = content ---@diagnostic disable-line : invisible
                    end,

                    ["readonly"] = function ()
                        ---@cast content Luva.Lang.Readonly<any>
                        resultClass.__Prototype.Readonlys[identifier] = content ---@diagnostic disable-line : invisible
                    end,

                    default = function ()
                        prototype.Fields[identifier] = content
                    end
                })

            end,

            ["function"] = function ()
                ---@cast content function
                resultClass.__Prototype.Accessors[identifier] = _MethodToAccessor(content)  ---@diagnostic disable-line : invisible
            end,

            default = function ()
                prototype.Fields[identifier] = content
            end

        } --[[@as Luva.Lang.MatchingBaseBuilder<type, fun()>]])
    end

end


return _SetupPrototype