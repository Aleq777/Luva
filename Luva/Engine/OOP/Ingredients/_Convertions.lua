


---@param resultClass Luva.Type
---@param classBuilder Luva.Lang.ClassBuilder
function _LUVA._SetupConvertions(resultClass, classBuilder)
    rawset(resultClass, "__Conversions", { })

    local convertions = resultClass.__Conversions   ---@diagnostic disable-line : invisible
    for key, content in pairs(classBuilder) do
        ---@cast content fun(self: Luva.Object): Luva.Object
        -- maybe scalar?
        if type (key) == "string" then
            if key ~= "default" then
                switch (key, {
                    ["string"] = function ()
                        convertions["string"] = content
                    end,
    
                    ["number"] = function ()
                        convertions["number"] = content
                    end,
    
                    ["function"] = function ()
                        convertions["function"] = content
                    end,
    
                    ["table"] = function ()
                        convertions["table"] = content
                    end,
    
                    ["boolean"] = function ()
                        convertions["boolean"] = content
                    end,
    
                    default = function () end
                })
            end
        -- maybe Luva.Object?
        elseif type (key) == "table" then
            convertions[key] = content
        end
    end
end