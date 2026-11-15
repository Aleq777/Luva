
-- dofile "Luva/base.lua"
-- dofile "Luva/import.lua"

---@module "Luva.Engine.Security.SecuredObject.securedGetSet"
---@type function, function
local _secureGet, _secureSet = import "Luva.Engine.Security.SecuredObject.securedGetSet"    ---@diagnostic disable-line : assign-type-mismatch # Intelisense not working


---@type metatable
return {
    ---@param self Luva.Type
    ---@param index Luva.Dynamic
    __index = function (self, index)
        return _secureGet(self, index)
    end,

    ---@param self Luva.Type
    ---@param index Luva.Dynamic
    ---@param value Luva.Dynamic
    __newindex = function (self, index, value)
        _secureSet(self, index, value)
    end,

    ---@param self Luva.Type
    ---@param ... any[]
    ---@return Luva.Object
    __call = function (self, ...)
        local args = varargs (...)
        local argsCount = #args
        local instance = nil

        local function customConstr()
            instance = self.__Constructors.CustomConstructor(self, unpack(args))
        end

        switch (argsCount, {
            [0] = function ()
                instance = self.__Constructors.DefaultConstructor(self)
            end,

            [1] = function ()
                local arg = args[1]
                -- build constructor
                if type (arg) == "table" then
                    -- instance = self.__Constructors.BuildConstructor(self, arg)
                else -- same as default
                    customConstr()
                end
            end,

            default = function ()
                customConstr()
            end
        })
    end
}