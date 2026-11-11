

---@class Luva.Object : Luva.Lang.SecuredObject
---@field private __Type Luva.Type
---@field public Equals fun(self: Luva.Object, v: any): Luva.Boolean
---@field public ToString fun(self: Luva.Object): Luva.String
---@field public Extends fun(self: Luva.Object, t: Luva.Type): Luva.Boolean
---@field public Implements fun(self: Luva.Object, i: Luva.Interface): Luva.Boolean
Object = struct { }