

---@generic TInstance : Luva.Object
---@param constructorsRef Luva.Lang.ClassConstructors<TInstance>
---@param func fun(setPrototype: fun(obj: table), ...: any[])
function _LUVA._SetupConstructor(constructorsRef, func)
    constructorsRef.CustomConstructor = function (_class, ...)
        
        ---@type Luva.Object
        local instance = {  ---@diagnostic disable-line : missing-fields
            __Type = _class
        }

        local proto = _class.__Prototype    ---@diagnostic disable-line : invisible
        ---@cast proto -nil
        
        _LUVA.SecuredObject.Secure(instance, "InstanceBase", proto.PrototypeMetatable)

        _LUVA.Utils.SafeInjectRef(instance.__Methods, {
            Equals = function (self, v)
                if
                    type (v) ~= "table"
                    or not v.__Type
                    or self.__Type ~= v.__Type  ---@diagnostic disable-line : invisible
                then
                    return false
                end

                return _LUVA.Utils.IsSameByValue(self, v, true)
            end,

            ToString = function (self)
                local result = "Luva.Object {"

                -- for k, v in pairs(self) do
                --     -- is hidden
                --     if string.sub(k, 1, 2) ~= "__" then
                --         result = result .. "\n\t" .. tostring(k) .. ":\t" .. tostring(v)
                --     end
                --     -- if not _LUVA.Utils.Has(_LUVA.Utils.ProhibitedIndexes, k) then
                --     -- end
                -- end
                _LUVA.Utils.Entries(self, function (index, value)
                    result = result .. "\n\t" .. tostring(index) .. ":\t" .. tostring(value)
                end)

                result = result .. "\n}"

                return result
            end,

            Extends = function (self, t)
                -- All Luva Objects do inherit Luva.Object
                if t == Luva.Object then
                    return true
                end

                ---@type Luva.Type
                local temp = self.__Type.__Extends  ---@diagnostic disable-line : invisible

                while temp ~= Luva.Object do
                    if temp == t then -- found - the type is inheriting `t`
                        return true
                    end

                    -- dig deeper
                    temp = temp.__Extends   ---@diagnostic disable-line : invisible
                end

                -- At Luva.Object, there is nothing to dig deeper
                return false
            end,

            Implements = function (self, i)
                ---@type Luva.Type
                local t = self.__Type   ---@diagnostic disable-line : invisible

                return _LUVA.Utils.Has(t.__Implements, i)   ---@diagnostic disable-line : invisible
            end,
        })

        
        for identifier, content in pairs(proto.Fields) do
            instance.__Fields[identifier] = content ---@diagnostic disable-line : invisible
        end

        for identifier, content in pairs(proto.Readonlys) do
            instance.__Constants[identifier] = content  ---@diagnostic disable-line : invisible
        end

        for identifier, content in pairs(proto.Methods) do
            instance.__Methods[identifier] = content    ---@diagnostic disable-line : invisible
        end
        
        for identifier, content in pairs(proto.Accessors) do
            instance.__Accessors[identifier] = content  ---@diagnostic disable-line : invisible
        end


        -- Parser: from inline args to obj (user-defined-side), and inject to instance (engine)
        func(function (obj)
            for k, v in pairs(obj) do
                instance[k] = v
            end
        end, ...)

        return instance
    end
end