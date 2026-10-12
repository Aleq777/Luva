
---@type Luva.ConfigSingleton
LuvaConfig = dofile("Luva/Config.lua")

---@diagnostic disable : lowercase-global


if LuvaConfig.Globalization.Enabled then

    local ambigous = LuvaConfig.Globalization.AmbigousBehaviour

    local _debug
    if ambigous.Debug == "error" then
        _debug = function (name)
            error("Cannot globalize the namespace beacuse of ambigouity: " .. name)
        end
    elseif ambigous.Debug == "warn" then
        _debug = function (name)
            warn("Found an ambigouty when globalizing the name: " .. name .. ", proceeding with " .. (ambigous.Action or "nil"))
        end
    else
        _debug = function (name) end
    end

    local _action
    if ambigous.Action == nil then
        error("Globalization: If Debug is not 'error', Action shouldn't be nil!")
    elseif ambigous.Action == "replace" then
        _action = function (key, value)
            _G[key] = value
        end
    else
        _action = function (key, value) end
    end


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
                _debug(k)
                _action(k, v)
            end
        end
    end

    return using
end