
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
    

    ---@generic TChild : Luva.Object
    ---@class Luva.Lang.ClassPrototype
    ---@field public Fields table<string, any> All instances copy this
    ---@field public Metatable Luva.Lang.PseudoMetatable All instances refer to this
    ---@field public Accessors table<string, Luva.Lang.Accessor<TChild, any>> All instances refer to this
    ---@field public Readonlys table<string, Luva.Lang.Readonly<any>> All instances copy this and convert to local accessor
    local __prototype
end

_LUVA.Errors.NO_FIELD_FOUND_PROTOTYPE = "Haven't found a field corresponding to GetByIdentifier's argument"



---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
---@param prototypeBuilder Luva.Lang.PrototypeBuilder
function _SetupPrototype(resultClass, prototypeBuilder)

    rawset(resultClass, "__Prototype", {
        Fields = { },
        Metatable = { },
        Accessors = { },
        Readonlys = { }
    } --[[@as Luva.Lang.ClassPrototype]])

    local prototype = resultClass.__Prototype   ---@diagnostic disable-line : invisible

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