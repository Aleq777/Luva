
local _, _LUVA = dofile "Luva/base.lua"

---@param obj Luva.Lang.SecuredObject
---@param index Luva.Dynamic
---@return any
---@nodiscard
local function _secureGet(obj, index)
    local constant = obj.__Constants[index] ---@diagnostic disable-line : invisible
    if constant then
        return constant
    end

    local _field = obj.__Fields[index]  ---@diagnostic disable-line : invisible
    if _field then
        return _field
    end

    local method = obj.__Methods[index]    ---@diagnostic disable-line : invisible
    ---@cast method function
    if method then
        return method
    end

    local accessor = obj.__Accessors[index]    ---@diagnostic disable-line : invisible
    ---@cast accessor Luva.Lang.Accessor<Luva.Object>
    if accessor then
        if accessor.get then
            return accessor:get()
        else
            error(_LUVA.Errors.NO_GET_OR_SET)
        end
    end

    local generics = obj.__Generics    ---@diagnostic disable-line : invisible
    if generics then
        local generic = generics[index]

        if generic then
            return generic
        end
    end

    local userDef = obj.__Metatable._index ---@diagnostic disable-line : invisible
    if userDef then
        return userDef(obj, index)
    end

    error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
end


---@param obj Luva.Lang.SecuredObject
---@param index Luva.Dynamic
---@param value Luva.Dynamic
local function _secureSet(obj, index, value)
    if obj.__Constants[index] then ---@diagnostic disable-line : invisible
        error(_LUVA.Errors.TRIED_MODIFY_CONSTANT)
    elseif obj.__Methods[index] then   ---@diagnostic disable-line : invisible
        error(_LUVA.Errors.TRIED_MODIFY_METHOD)
    elseif obj.__Generics and obj.__Generics[index] then  ---@diagnostic disable-line : invisible
        error(_LUVA.Errors.TRIED_MODIFY_CONSTANT)
    end

    local fields = obj.__Fields  ---@diagnostic disable-line : invisible
    if fields[index] ~= nil then
        fields[index] = value
        return
    end

    ---@type Luva.Lang.Accessor<Luva.Object>
    local accessor = obj.__Accessors[index]    ---@diagnostic disable-line : invisible
    if accessor then
        if accessor.set then
            accessor:set(value)
            return
        else
            error(_LUVA.Errors.NO_GET_OR_SET)
        end
    end

    local userDef = obj.__Metatable._newindex  ---@diagnostic disable-line : invisible
    if userDef then
        userDef(obj, index, value)
        return
    end

    error(_LUVA.Errors.UNDEFINED_FIELD .. ": " .. tostring(index))
end


return _secureGet, _secureSet