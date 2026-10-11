
---@diagnostic disable : lowercase-global


do

    ---@class Luva.WhereExpression
    ---@field public where fun(this, expr): Luva.WhereExpression
    ---@field public get fun(this)
    ---@
    ---@field private _Properties string[]
    local __WhereExpression = { }

    ---@class Luva.SelectExpression
    ---@field public from fun(self, array): Luva.WhereExpression
    ---@
    ---@field private _Properties string[]
    local __SelectExpression = { }
end



--- Select like MySQL `SELECT`
--- Creates subarray which satisfies given arguments
---@param ... string[]
---@return Luva.SelectExpression
---@nodiscard
function select(...)
    local properties = Luva.Utils.FlattenArray { ... }

    ---@type Luva.SelectExpression
    return {
        _Properties = properties,

        from = function (self, array)
            ---@type Luva.WhereExpression
            return {
                _Properties = self._Properties,
                where = function (this, expr)
                    

                    return this
                end,

                get = function (this)
                    
                end
            }
        end
    }
end