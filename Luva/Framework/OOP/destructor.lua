
---@diagnostic disable : lowercase-global

---@alias Luva.Destructor fun()

---@alias Luva.DestructorExpression Luva.Keyword<"destructor">

---@type Luva.DestructorExpression
destructor = { }



---@param resultClass Luva.Type
function _AppendDestructorCreator(resultClass)
    local destr = resultClass[destructor]
    if not destr then
        return
    end

    resultClass.__Prototype.__MetaPrototype.__gc = destr    ---@diagnostic disable-line : invisible
end


return destructor, _AppendDestructorCreator