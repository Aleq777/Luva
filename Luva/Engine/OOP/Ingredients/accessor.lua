
---@diagnostic disable : lowercase-global

---@module "Luva.Engine.OOP.Ingredients.field"
dofile ("Luva/Engine/OOP/Ingredients/field.lua")



do
    ---@generic TChild : Luva.Object
    ---@generic TField
    ---@class Luva.Lang.Accessor : Luva.Lang.StrictKind
    ---@field public get nil|fun(self: TChild): TField
    ---@field public set nil|fun(self: TChild, value: TField)
    local __accessor
end



--- Converts `const` to accessor for a class
--- Constants are immutables assigned on declaration
---@generic TChild : Luva.Object
---@generic TValue
---@param value TValue
---@return Luva.Lang.Accessor<TChild, TValue>
---@nodiscard
local function _ConstToAccessor(value)
    return field {
        get = function (self)
            return value
        end
    }
end

--- Converts any method to accessor for a class
--- Thanks to that, methods are immutable
---@generic TChild : Luva.Object
---@param method function
---@return Luva.Lang.Accessor<TChild, function>
local function _MethodToAccessor(method)
    return field {
        get = function (self)
            return method
        end
    }
end

--- Converts readonly to accessor for an instance
--- Readonlys are constants that may be initied later
---@param instance Luva.Object
---@param name Luva.Lang.Identifier
---@return Luva.Lang.Accessor<Luva.Object, any>
---@nodiscard
local function _ReadonlyToAccessor(instance, name)
    return field {
        set = function (self, value)
            -- After first set it rewrites itself to become a constant
            instance.__Security.Accessors[name] = field {   ---@diagnostic disable-line : invisible
                get = function (self)
                    return value
                end
            }
        end
    }
end



return _ConstToAccessor, _MethodToAccessor, _ReadonlyToAccessor