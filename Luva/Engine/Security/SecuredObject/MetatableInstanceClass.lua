

import "Luva.Engine.Security.SecuredObject.securedGetSet"    ---@diagnostic disable-line : assign-type-mismatch # Intelisense not working


---@type metatable
_LUVA.SecuredObject.Metatables.InstanceClass = {
    ---@param self Luva.Type
    ---@param index Luva.Dynamic
    __index = function (self, index)
        return _LUVA._secureGet(self, index)
    end,

    ---@param self Luva.Type
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _LUVA._secureSet(self, index, value)
    end,

    ---@param self Luva.Type
    ---@param ... any[]
    ---@return Luva.Object
    __call = function (self, ...)
        local argsCount = select("#", ...)
        local args = { ... }
        local first = ( select(1, ...) )
        local instance = nil

        local function customConstr()
            return self.__Constructors.CustomConstructor(self, table.unpack(args))
        end

        switch (argsCount, {
            [0] = function ()
                instance = self.__Constructors.DefaultConstructor(self)
            end,

            [1] = function ()
                -- build constructor
                if type (first) == "table" then
                    ---@cast first table
                    instance = self.__Constructors.BuildConstructor(self, first)
                else -- same as default
                    instance = customConstr()
                end
            end,

            default = function ()
                instance = customConstr()
            end
        })

        -- ---@cast instance Luva.Object
        -- setmetatable(instance, self.__Prototype.PrototypeMetatable)
        return instance
    end
}