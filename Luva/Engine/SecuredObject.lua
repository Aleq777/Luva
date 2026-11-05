
---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")



do
    ---@generic T
    ---@class Luva.Lang.Accessor
    ---@field public get fun(self: Luva.Lang.Accessor<T>): T
    ---@field public set fun(self: Luva.Lang.Accessor<T>, value: T)
    local __accessor
    
    ---@class Luva.Lang.SecuredObject
    ---@field private __Type string
    ---@field private __Accessors table<string, Luva.Lang.Accessor<any>>
    ---@field private __Enabled boolean
    ---@field public IsSecured fun(self: Luva.Lang.SecuredObject): boolean
    local __securedObject
end






_LUVA.SecuredObject = { }

_LUVA.Errors.UNDEFINED_FIELD = "Tried to access undefined field"


---@generic T
---@param obj Luva.Lang.SecuredObject
---@param index any
---@param action fun(field: T, val: T): any|nil
---@param actionAccessor fun(accessor: Luva.Lang.Accessor<T>, val: T): T|nil
---@param value T|nil
---@return any|nil
local function _securedAction(obj, index, action, actionAccessor, value)
    _LUVA.SecuredObject.Unsafe(obj, function ()
        local field = obj[index]
        if field ~= nil then
            return action(field, value)
        end

        local accessor = obj.__Accessors[index] ---@diagnostic disable-line : invisible
        if accessor then
            return actionAccessor(accessor, value)
        end

        error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
    end)
end

---@type metatable
_LUVA.SecuredObject.SecureMetatable = {
    ---@param self Luva.Lang.SecuredObject
    ---@param index any
    ---@return any
    ---@nodiscard
    __index = function (self, index)
        _securedAction(
            self,
            index,
            function (field, val)
                return field
            end,
            function (accessor, val)
                return accessor:get()
            end
        )
    end,

    ---@param self Luva.Lang.SecuredObject
    ---@param index any
    ---@param value any
    __newindex = function (self, index, value)
        _securedAction(
            self,
            index,
            function (field, val)
                self[index] = val
            end,
            function (accessor, val)
                accessor:set(val)
            end,
            value
        )
    end
}

--- Overrides `obj` to become a SecuredObject <br />
--- This means that you cannot use not-defined fields <br />
---@param obj table
---@param accessors table<string, Luva.Lang.Accessor>|nil
---@return Luva.Lang.SecuredObject obj
function _LUVA.SecuredObject.Secure(obj, accessors)
    ---@cast obj Luva.Lang.SecuredObject
    obj.__Type = "Luva.Lang.SecuredObject"  ---@diagnostic disable-line : invisible
    obj.__Accessors = accessors or { }      ---@diagnostic disable-line : invisible
    obj.__Enabled = true                    ---@diagnostic disable-line : invisible
    obj.IsSecured = function (self)
        return self.__Enabled   ---@diagnostic disable-line : invisible
    end

    setmetatable(obj, _LUVA.SecuredObject.SecureMetatable)

    return obj
end


--- Lets `func` use self object without Security
---@param obj Luva.Lang.SecuredObject
---@param func fun()
---@return any|nil
function _LUVA.SecuredObject.Unsafe(obj, func)
    obj.__Enabled = false   ---@diagnostic disable-line : invisible
    setmetatable(obj, nil)
        local result = func()
    obj.__Enabled = true    ---@diagnostic disable-line : invisible
    setmetatable(obj, _LUVA.SecuredObject.SecureMetatable)

    return result
end











return _LUVA