

List = class {
    [template] = function (typeT)
        generic ("T", typeT)
    end,
    [extends] = Array[genericof().T],
    [prototype] = {
        Count = field {
            get = function (self)

            end,
            set = function (self, value)

            end
        },
        ForEach = function (self)

        end,
    },

    [constructor] = function ()

    end,
    [destructor] = function ()

    end,

    [default] = function (setPrototype)
        
    end,

    [operator("[]")] = function (self, index)

    end,

    -- explicit conversion
    [Array] = function (self)

    end,

    -- same as tostring()
    [string] = function (self)

    end,

    -- static fields
}