
Luva = {
    ---@module "Luva.Framework.Packages.Utils"
    Utils = dofile ("Luva/Framework/Packages/Utils.lua")
}


---@param resultClass Luva.Type
local function _AppendMetatable(resultClass)

    if resultClass[prototype] then
        resultClass.__Meta = Luva.Utils.Copy(__MetaType.WithPrototype)  ---@diagnostic disable-line : invisible
    else
        resultClass.__Meta = __MetaType.Static  ---@diagnostic disable-line : invisible
    end

end


---@param resultClass Luva.Type
local function _FinalizeMetatable(resultClass)
    setmetatable(resultClass, resultClass.__Meta)   ---@diagnostic disable-line : invisible
end


return _AppendMetatable, _FinalizeMetatable