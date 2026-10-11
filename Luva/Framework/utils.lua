

Luva = {
    Utils = { }
}


--- Returns any multi-dimensional array as an 1D array
---@param array table<integer, any>
---@return any[]
---@nodiscard
function Luva.Utils.FlattenArray(array)
    ---@type any[]
    local result = { }

    for _, v in ipairs(array) do
        if type (v) == "table" then
            table.insert(result, Luva.Utils.FlattenArray(v))
        else
            table.insert(result, v)
        end
    end

    return result
end