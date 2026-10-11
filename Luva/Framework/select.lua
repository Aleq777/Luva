
---@diagnostic disable : lowercase-global


do

    ---@generic T
    ---@generic U
    ---@class Luva.WhereExpression
    ---@field public where fun(this: Luva.WhereExpression, expr: fun(item: T, index: U): boolean): Luva.WhereExpression
    ---@field public get fun(this: Luva.WhereExpression): table<T, U>
    ---@
    ---@field private _Result table<T, U>
    ---@field private _Wheres (fun(item: U, index: T): boolean)[]
    ---@field private _Properties string[]
    local __WhereExpression = { }

    ---@generic T
    ---@generic U
    ---@class Luva.SelectExpression
    ---@field public from fun(self: Luva.SelectExpression, array: table<T, U>): Luva.WhereExpression
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

    ---@type Luva.SelectExpression
    return {
        _Properties = Luva.Utils.FlattenArray { ... },

        from = function (self, array)
            ---@type Luva.WhereExpression
            return {
                _Result = Luva.Utils.Copy(array),
                ---@diagnostic disable-next-line : invisible
                _Properties = self._Properties,
                _Wheres = { },

                where = function (this, expr)
                    ---@diagnostic disable-next-line : invisible
                    table.insert(this._Wheres, expr)
                    return this
                end,

                get = function (this)

                    ---@diagnostic disable-next-line : invisible
                    for _, whereExpr in ipairs(this._Wheres) do

                        ---@generic T
                        ---@generic U
                        ---@type table<T, U>
                        local result = { }

                        ---@diagnostic disable-next-line : invisible
                        for k, v in pairs(this._Result) do
                            if whereExpr(v, k) then
                                result[k] = v
                            end
                        end

                        ---@diagnostic disable-next-line : invisible
                        this._Result = result
                    end


                    ---@diagnostic disable-next-line : invisible
                    if #this._Properties > 0 then
                        ---@diagnostic disable-next-line : invisible
                        for key, _ in pairs(this._Result) do
                            ---@diagnostic disable-next-line : invisible
                            if Luva.Utils.Has(this._Properties, key) then
                                goto continue
                            end

                            ---@diagnostic disable-next-line : invisible
                            this._Result[key] = nil

                            ::continue::
                        end
                    end

                    ---@diagnostic disable-next-line : invisible
                    return this._Result
                end
            }
        end
    }
end