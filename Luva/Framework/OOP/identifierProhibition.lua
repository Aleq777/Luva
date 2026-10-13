

---@generic T
---@param self T
---@param identifier string
function _ProhibitUndefinedIndex(self, identifier)
    error("Undefined field: " .. identifier)
end



---@generic T
---@param self T
---@param identifier string
---@param value any
function _ProhibitNewIndex(self, identifier, value)
    error("Cannot define a new field outside of type's definition: " .. identifier)
end


return _ProhibitUndefinedIndex, _ProhibitNewIndex