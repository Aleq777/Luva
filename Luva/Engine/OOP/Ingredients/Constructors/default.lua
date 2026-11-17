
do
    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.PostDefaultConstructorCaller fun(self: TInstance)

    ---@generic TInstance : Luva.Object
    ---@alias Luva.Lang.DefaultConstructor fun(_class: Luva.Type): TInstance
end


---@generic TInstance : Luva.Object
---@param constructors Luva.Lang.ClassConstructors<TInstance> Reference to class'es constructors
---@param defaultCaller Luva.Lang.PostDefaultConstructorCaller<TInstance>|nil
function _LUVA._SetupDefaultConstructorAndMaybeCaller(constructors, defaultCaller)
    constructors.DefaultCaller = defaultCaller or function (instance) end

    ---@type Luva.Lang.DefaultConstructor    
    constructors.DefaultConstructor = function (_class)
        ---@type Luva.Object
        local instance = {  ---@diagnostic disable-line : missing-fields
            __Type = _class,
        }

        local proto = _class.__Prototype    ---@diagnostic disable-line : invisible
        ---@cast proto -nil

        _LUVA.SecuredObject.Secure(instance, "InstanceBase", proto.PrototypeMetatable)

        -- Luva.Object
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
        -- instance.__Methods

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

        _class.__Constructors.DefaultCaller()   ---@diagnostic disable-line : invisible

        -- setmetatable(instance, proto.PrototypeMetatable)
        return instance
    end
end