
---@module "Luva.base"
_, _LUVA = dofile ("Luva/base.lua")

--- Injects `fields` into `obj`
---@param obj table
---@param fields table
function _LUVA.Inject(obj, fields)
    for k, v in pairs(fields) do
        obj[k] = v
    end
end

return _LUVA