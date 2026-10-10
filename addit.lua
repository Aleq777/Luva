
---@module "import"

---@diagnostic disable : lowercase-global



do
    ---@generic T
    ---@class Luva.StrongTypedVar<T>
    ---@field _Type type|"any"
    ---@field _Value T
    local __strongTypedVar = { }
end





---@generic T
---@param name string
---@param value T
---@param typ Luva.LuaLS_Type
local function _setByType(name, value, typ)
    ---@type table<string, Luva.StrongTypedVar<any>>
    _GLOBAL_VARIABLES = _GLOBAL_VARIABLES or { }

    if _GLOBAL_VARIABLES[name] ~= nil and _GLOBAL_VARIABLES[name]._Type ~= "any" then
        error("Cannot change value of " .. name .. " because it has declared hard type of " .. _GLOBAL_VARIABLES[name]._Type)
    end

    _GLOBAL_VARIABLES[name] = {
        _Type = typ,
        _Value = value
    }
end

--- Creates a destructible variable
---@param name string
---@param value any
function set(name, value)
    _setByType(name, value, "any")
end


---@param name string
---@param value boolean
function setbool(name, value)
    _setByType(name, value, "boolean")
end

---@param name string
---@param value integer
function setint(name, value)
    _setByType(name, value, "integer")
end

---@param name string
---@param value number
function setnum(name, value)
    _setByType(name, value, "number")
end

---@param name string
---@param value string
function setstr(name, value)
    _setByType(name, value, "string")
end

---@param name string
---@param value table
function settable(name, value)
    _setByType(name, value, "table")
end

---@param name string
---@param value function
function setfun(name, value)
    _setByType(name, value, "function")
end


---@generic T
---@param name string
---@param typ Luva.LuaLS_Type
---@return T
---@nodiscard
local function _getByType(name, typ)
    if _GLOBAL_VARIABLES == nil or _GLOBAL_VARIABLES[name] == nil then
        error("Variable " .. name .. " hasn't been initialised")
    end

    if typ ~= "any" and _GLOBAL_VARIABLES[name]._Type ~= typ then
        error("Variable " .. name .. " has a different type than " .. typ)
    end

    return _GLOBAL_VARIABLES[name]
end


--- Gets a destructible variable's value
---@param name string
---@return any
---@nodiscard
function get(name)
    return _getByType(name, "any")
end

---@param name string
---@return boolean
---@nodiscard
function getbool(name)
    return _getByType(name, "boolean")
end

---@param name string
---@return integer
---@nodiscard
function getint(name)
    return _getByType(name, "integer")
end

---@param name string
---@return number
---@nodiscard
function getnum(name)
    return _getByType(name, "number")
end

---@param name string
---@return string
---@nodiscard
function getstr(name)
    return _getByType(name, "string")
end

---@param name string
---@return table
---@nodiscard
function gettable(name)
    return _getByType(name, "table")
end

---@param name string
---@return function
---@nodiscard
function getfun(name)
    return _getByType(name, "function")
end



return
       get, getbool, getint, getnum, getstr, gettable, getfun,
       set, setbool, setint, setnum, setstr, settable, setfun