local function _newProc(...)
    local pr = {
        _Funcs = Luva.Utils.Copy { ... }
    }
    
    setmetatable(pr, _MetaProc)
    return pr
end


_MetaProc = {
    __add = function (self, right)
        local newProc = _newProc(self._Funcs)
        table.insert(newProc, right)
        return newProc
    end,
    
    __call = function (self, ...)
        for _, func in ipairs(self._Funcs) do
            func(...)
        end
    end,
    
}

function procedure(...)
    return _newProc(...)
end


local function _newDelg(resulter, ...)
    local newd = {
        _Funcs = Luva.Utils.Copy { ... },
        _Resulter = resulter
    }
    
    setmetatable(newd, _MetaDelg)
    return newd
end

_MetaDelg = {
    __add = function (self, right)
        local newd = _newDelg(right._Resulter, right._Funcs)
        table.insert(newd._Funcs, right)
        return newd
    end,
    
    __call = function (self, ...)
        local results = { }
        
        for _, func in ipairs(self._Funcs) do
            table.insert(results, func(...))
        end
        
        return self._Resulter(table.unpack(results))
    end,
}


function delegate(resulter, ...)
    return _newDelg(resulter, ...)
end



return procedure, delegate