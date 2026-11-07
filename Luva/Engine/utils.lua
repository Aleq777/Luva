
---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")


_LUVA.Errors.INJECTION_FAILED_DUPLICATE = "Failed to inject: duplicate fields (SafeInject)"



---@param obj table
---@param components table
---@param action fun(k: any, v: any)
local function _injectRef(obj, components, action)
    for k, v in pairs(components) do
        if obj[k] ~= nil then
            action(k, v)
        else
            obj[k] = v
        end
    end
end


_LUVA.Utils = {

    --- Deep copy of the object
    ---@param obj any
    ---@return any obj Copy
    ---@nodiscard
    Copy = function (obj)
        if type (obj) ~= "table" then
            return obj
        end

        local result = { }

        for k, v in pairs(obj) do
            result[k] = _LUVA.Copy(v)
        end

        return result
    end,


    --- Injects `components` into `obj` (by reference!)
    --- When same identifiers occur:
    --- throws an error
    ---@param obj table Base object to inject to (reference)
    ---@param components table Components to inject (reference)
    SafeInjectRef = function (obj, components)
        _injectRef(obj, components, function (k, v)
            error(_LUVA.Errors.INJECTION_FAILED_DUPLICATE)
        end)
    end,

    --- Injects `components` into `obj` (by reference!)
    --- When same identifiers occur:
    --- skips the `components`'s one
    ---@param obj table Base object to inject to (reference)
    ---@param components table Components to inject (reference)
    SoftInjectRef = function (obj, components)
        _injectRef(obj, components, function (k, v) end)
    end,

    --- Injects `components` into `obj` (by reference!)
    --- When same identifiers occur:
    --- overrides `obj`'s field by `components` field
    ---@param obj table Base object to inject to (reference)
    ---@param components table Components to inject (reference)
    InjectOverrideRef = function (obj, components)
        _injectRef(obj, components, function (k, v)
            obj[k] = v
        end)
    end,
}


return _LUVA.Utils