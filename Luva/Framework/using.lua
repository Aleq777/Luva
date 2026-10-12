
---@type Luva.ConfigSingleton
LuvaConfig = dofile("Luva/Config.lua")

---@diagnostic disable : lowercase-global


if LuvaConfig.Globalization.Enabled then
    --- Globalize the namespace
    --- Warning - it may collide with LuaLS. It overrides any ambigouity. Use carefully and only when needed.
    --- ## No globalization
    --- ```lua
    --- array = Luva.Utils.Copy({ 1, 2 })
    --- ```
    --- ## Globalization
    --- ```lua
    --- using(Luva.Utils)
    --- array = Copy({ 1, 2 })
    --- ```
    ---@param _namespace table
    function using(_namespace)
        for k, v in pairs(_namespace) do
            if _G[k] ~= nil then
                if LuvaConfig.Globalization.AmbigousBehaviour.Debug == "error" then
                    error("Cannot globalize the namespace beacuse of ambigouity: " .. k)
                elseif LuvaConfig.Globalization.AmbigousBehaviour.Debug == "warning" then
                    warn("Found an ambigouty when globalizing the name: " .. k .. ", proceeding with " .. LuvaConfig.Globalization.AmbigousBehaviour.Action)
                end

                if LuvaConfig.Globalization.AmbigousBehaviour.Action == nil then
                    error("Globalization: If Debug is not 'error', Action shouldn't be nil!")
                elseif LuvaConfig.Globalization.AmbigousBehaviour.Action == "replace" then
                    _G[k] = v
                else
                    -- skip
                end
            end
        end
    end

    return using
end