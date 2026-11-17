

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
            result[k] = _LUVA.Utils.Copy(v)
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
            error(_LUVA.Errors.INJECTION_FAILED_DUPLICATE, 4)
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

    --- Does table `tab` have `value` (value)?
    ---@param tab table
    ---@param value any
    ---@return boolean
    ---@nodiscard
    Has = function (tab, value)
        for _, v in pairs(tab) do
            if v == value then
                return true
            end
        end

        return false
    end,

    ---Compares `objA` and `objB` by values
    ---@param objA any
    ---@param objB any
    ---@param ignoreFunctions boolean|nil `Default: false` It won't check functions (they may have different reference)
    ---@return boolean
    ---@nodiscard
    IsSameByValue = function (objA, objB, ignoreFunctions)
        local t = type (objA)

        if t ~= type (objB) then
            return false
        end

        if ignoreFunctions and t == "function" then
            return true
        end

        if t ~= "table" then
            return objA == objB
        end

        local checkedIndexes = { }

        for k, v in pairs(objA) do
            local same = _LUVA.Utils.IsSameByValue(v, objB[k], ignoreFunctions)

            if not same then
                return false
            end

            table.insert(checkedIndexes, k)
        end

        for k, _ in pairs(objB) do
            if not _LUVA.Utils.Has(checkedIndexes, k) then
                return false
            end
        end

        return true
    end,

    --- Iterates through Luva.Object fields
    ---@generic T : Luva.Object
    ---@param obj T
    ---@param func fun(index: string, value: any)
    Entries = function (obj, func)
        for _, propName in ipairs { "__Methods", "__Constants", "__Fields", "__Accessors" } do
            for k, v in pairs(obj[propName]) do
                func(k, v)
            end
        end
    end,

    MetamethodsNames = {
        "__add",
        "__sub",
        "__mul",
        "__div",
        "__unm",
        "__mod",
        "__pow",
        "__eq",
        "__lt",
        "__le",
        "__concat",
        "__len",
        "__index",
        "__newindex",
        "__call",
    },

    --- Index names, that cannot be used (they are a part of Luva). Use rawset, rawget and raweq instead.
    ProhibitedIndexes = {
        "__Constants",
        "__Fields",
        "__Methods",
        "__Accessors",
        "__Generics",
        "__Metatable",
        "__AddConstant",
        "__AddField",
        "__AddMethod",
        "__AddAccessor",
        "__SetConstants",
        "__SetFields",
        "__SetMethods",
        "__SetAccessors",
        "__SetGenerics",
        "__Type"
    },
}