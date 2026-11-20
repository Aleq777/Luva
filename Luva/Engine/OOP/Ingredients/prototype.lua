
---@diagnostic disable : lowercase-global

import "Luva.Engine.kind"
import "Luva.Engine.matching_expr"

---@alias Luva.Lang.PrototypeBuilder table<Luva.Lang.Identifier, any>

do
    ---@class Luva.Lang.ClassPrototype
    ---@field public PrototypeMetatable Luva.Lang.PseudoMetatable
    ---@field public Readonlys table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field public Fields table<Luva.Lang.Identifier, Luva.Dynamic>
    ---@field public Methods table<Luva.Lang.Identifier, function>
    ---@field public Accessors table<Luva.Lang.Identifier, Luva.Lang.Accessor<Luva.Object>>
    local __prototype
end

local ERR_NO_FIELD_FOUND_PROTOTYPE = "Haven't found a field corresponding to GetByIdentifier's argument"



---@generic TInstance : Luva.Object
---@param resultClass Luva.Type<TInstance>
---@param prototypeBuilder Luva.Lang.PrototypeBuilder
function _LUVA._SetupPrototype(resultClass, prototypeBuilder)

    rawset(resultClass, "__Prototype", {
        PrototypeMetatable = { },
        Readonlys = { },
        Fields = { },
        Methods = { },
        Accessors = { },
    } --[[@as Luva.Lang.ClassPrototype]])

    local prototype = resultClass.__Prototype --[[@as Luva.Lang.ClassPrototype]]   ---@diagnostic disable-line : invisible

    prototype.PrototypeMetatable = _LUVA.Utils.Copy(_LUVA.SecuredObject.Metatables.InstanceBase)

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
                        ---@cast content Luva.Dynamic
                        resultClass.__Prototype.Readonlys[identifier] = content ---@diagnostic disable-line : invisible
                    end,

                    default = function ()
                        prototype.Fields[identifier] = content
                    end
                })

            end,

            ["function"] = function ()
                -- to constant??
                ---@cast content function
                resultClass.__Prototype.Accessors[identifier] = _LUVA._MethodToAccessor(content)  ---@diagnostic disable-line : invisible
            end,

            default = function ()
                prototype.Fields[identifier] = content
            end

        } --[[@as Luva.Lang.MatchingBaseBuilder<type, fun()>]])
    end
end