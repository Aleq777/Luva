
Luva = dofile("Luva/Framework/base.lua")


Luva.Utils = {

    --- Returns any multi-dimensional array as an 1D array
    ---@param array table<integer, any>
    ---@return any[]
    ---@nodiscard
    FlattenArray = function (array)
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
    end,



    --- Copies a `value` by value (deep copy)
    ---@generic T
    ---@param value T
    ---@return T value
    ---@nodiscard
    Copy = function (value)
        if type (value) ~= "table" then return value end

        ---@generic T
        ---@type T
        local result = { }

        for k, v in pairs(value) do
            result[k] = Luva.Utils.Copy(v)
        end

        return result
    end,


    --- Checks, if table `array` has `value`
    ---@generic T
    ---@generic U
    ---@param array table<T, U>
    ---@param value U 
    ---@return boolean
    ---@nodiscard
    Has = function (array, value)
        for _, v in pairs(array) do
            if v == value then
                return true
            end
        end

        return false
    end,

    --- Returns keys of table `array`
    ---@generic T
    ---@param array table<T, any>
    ---@return T[]
    ---@nodiscard
    GetKeys = function (array)
        local result = { }

        for k in pairs(array) do
            table.insert(result, k)
        end

        return result
    end,


    Metamethods = {
        "__add",
        "__sub",
        "__mul",
        "__div",
        "__mod",
        "__pow",
        "__unm",
        "__idiv",
        "__band",
        "__bor",
        "__bxor",
        "__bnot",
        "__shl",
        "__shr",
        "__eq",
        "__lt",
        "__le",
        "__gt",
        "__ge",
        "__concat",
        "__len",
        "__tostring",
        "__index",
        "__newindex",
        "__call",
        "__pairs",
        "__ipairs",
        "__gc",
        "__close",
        "__mode",
        "__metatable",
        "__name",
    },

}






return Luva.Utils