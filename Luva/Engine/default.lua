
---@diagnostic disable : lowercase-global


--- Returns the default value of a type. <br />
--- If it doesn't exist, returns `nil`. <br />
--- On Luva.Object's, it calls the default constructor. <strong>Watch out for uninitialised fields!!!</strong> <br />
--- This function has defined values for all basic scalar Lua types.
---@param _type Luva.Type|type Cannot be empty nor a ready-value
---@return Luva.Object|Luva.Dynamic|nil
---@nodiscard
default = function (_type)
    if type (_type) == "string" then
        if _LUVA.Utils.Has({"userdata", "thread"}--[[@as (type[])]], _type) then
            return nil
        end

        return match (_type, {
            ["string"] = "",
            ["number"] = 0,
            ["boolean"] = false,
            ["table"] = {},
            ["function"] = function () end,
            default = nil
        }--[[@as table<type, any>]])
    end

    return _type()
end