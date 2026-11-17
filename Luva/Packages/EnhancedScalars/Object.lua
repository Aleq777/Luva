

---@class Luva.Object : Luva.Lang.SecuredObject
---@field private __Type Luva.Type
---@field public Equals fun(self: Luva.Object, v: any): Luva.Boolean Checks by value
---@field public ToString fun(self: Luva.Object): Luva.String
---@field public Extends fun(self: Luva.Object, t: Luva.Type): Luva.Boolean
---@field public Implements fun(self: Luva.Object, i: Luva.Interface): Luva.Boolean
---@operator call(table): Luva.Object If not overriden, it acts like a multiline field modifier-setter
local Object = struct { }