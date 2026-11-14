
local _, _LUVA = dofile "Luva/base.lua"
local _GenerateFromTemplate = import "Luva.Engine.Security.luvatemplatetype"

---@type metatable
return {
    ---@param self Luva.TemplateClass
    ---@param index Luva.Type|Luva.Type[]
    ---@return Luva.Type
    ---@nodiscard
    __index = function (self, index)
        local templ = self.__Template   ---@diagnostic disable-line : invisible
        ---@type Luva.Type[]
        local filledTemplate = { }

        if #templ == 1 then -- only 1 generic type, accept template[T] and template[{T}]
            -- if array
            if kindof (index) == "lua" then
                index = index[1]
            end

            ---@cast index -Luva.Type[]
            table.insert(filledTemplate, index)
        else -- many generic types, accept only template[{...}]
            -- array
            if kindof (index) == "lua" then
                for _, v in ipairs(index) do
                    table.insert(filledTemplate, v)
                end
            else -- single type - error
                error(_LUVA.Errors.TEMPLATE_NOT_ENOUGH_TYPES)
            end
        end

        -- search for existing
        local generatedClasses = self.__GeneratedClasses    ---@diagnostic disable-line : invisible
        for existingTemplate, existingType in pairs(generatedClasses) do
            if _LUVA.Utils.IsSameByValue(existingTemplate, filledTemplate) then
                return existingType
            end
        end

        -- generate a new type
        local generatedClass = _GenerateFromTemplate(self, filledTemplate)
        generatedClasses[filledTemplate] = generatedClass

        return generatedClass
    end
}