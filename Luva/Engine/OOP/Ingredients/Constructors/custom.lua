

---@generic TInstance : Luva.Object
---@param constructorsRef Luva.Lang.ClassConstructors<TInstance>
---@param func fun(setPrototype: fun(obj: table), ...: any[])
function _LUVA._SetupConstructor(constructorsRef, func)
    constructorsRef.CustomConstructor = function (_class, ...)

        local instance = _LUVA._GeneralConstructor(_class)
        func(function (obj)
            for k, v in pairs(obj) do
                instance[k] = v
            end
        end, ...)

        return instance
    end
end