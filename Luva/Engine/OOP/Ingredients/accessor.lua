

do
    ---@generic TChild : Luva.Object
    ---@generic TField
    ---@class Luva.Lang.Accessor : Luva.Lang.StrictKind
    ---@field public get nil|fun(self: TChild): TField
    ---@field public set nil|fun(self: TChild, value: TField)
    local __accessor
end