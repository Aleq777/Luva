
---@diagnostic disable : lowercase-global


import "Luva.Engine.Security.SecuredObject"
import "Luva.Engine.OOP.Ingredients.field"

do
    ---@generic TChild : Luva.Object
    ---@generic TField
    ---@class Luva.Lang.Accessor : Luva.Lang.StrictKind
    ---@field public get nil|fun(self: TChild): TField
    ---@field public set nil|fun(self: TChild, value: TField)
    local __accessor
end





_LUVA.Errors.PROHIBITED_ACCESSOR_FUNCTION = "Any other functions than get/set are prohibited inside the accessor"
_LUVA.Errors.EMPTY_ACCESSOR = "Accessor requires at least one function (get and/or set). Provided none"




--- Creates an accessor field <br />
--- Custom getters and setters
---@generic TChild : Luva.Object
---@generic TField
---@param accessorBuilder Luva.Lang.Accessor At least one function required (get and/or set)
---@return Luva.Lang.Accessor<TChild, TField>
---@nodiscard
accessor = function (accessorBuilder)
    local atLeastOne = false

    for k, _ in pairs(accessorBuilder) do
        if k == "get" or k == "set" then
            atLeastOne = true
        else
            error(_LUVA.Errors.PROHIBITED_ACCESSOR_FUNCTION)
        end
    end

    if atLeastOne then
        accessorBuilder.__Kind = "accessor"    ---@diagnostic disable-line : invisible
        return accessorBuilder
    else
        error(_LUVA.Errors.EMPTY_ACCESSOR)
    end
end


-- --- Converts `const` to accessor for a class
-- --- Constants are immutables assigned on declaration
-- ---@generic TChild : Luva.Object
-- ---@generic TValue
-- ---@param value TValue
-- ---@return Luva.Lang.Accessor<TChild, TValue>
-- ---@nodiscard
-- function _LUVA._ConstToAccessor(value)
--     return field {
--         get = function (self)
--             return value
--         end
--     }
-- end

-- --- Converts any method to accessor for a class
-- --- Thanks to that, methods are immutable
-- ---@generic TChild : Luva.Object
-- ---@param method function
-- ---@return Luva.Lang.Accessor<TChild, function>
-- function _LUVA._MethodToAccessor(method)
--     return field {
--         get = function (self)
--             return method
--         end
--     }
-- end

-- --- Converts readonly to accessor for an instance
-- --- Readonlys are constants that may be initied later
-- ---@param instance Luva.Object
-- ---@param name Luva.Lang.Identifier
-- ---@return Luva.Lang.Accessor<Luva.Object, any>
-- ---@nodiscard
-- function _LUVA._ReadonlyToAccessor(instance, name)
--     return field {
--         set = function (self, value)
--             -- After first set it rewrites itself to become a constant
--             instance.__Security.Accessors[name] = field {   ---@diagnostic disable-line : invisible
--                 get = function (self)
--                     return value
--                 end
--             }
--         end
--     }
-- end