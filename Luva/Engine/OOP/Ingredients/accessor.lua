

do
    ---@generic TChild : Luva.Lang.Accessor<any, any>
    ---@generic TField
    ---@class Luva.Lang.Accessor : Luva.Lang.StrictKind
    ---@field public get nil|fun(self: TChild): TField
    ---@field public set nil|fun(self: TChild, value: TField)
    local __accessor
end