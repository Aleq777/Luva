


List = class {
    [template] = function (typeT)
        generic ("T", typeT)
    end,

    [extends] = Array,

    [implements] = { IComparable[genericof().T] },

    [prototype] = {
        Values = Array[genericof().T](),
        Length = field {
            get = function (self)
                return #self.Values
            end,
            set = function (self, value)

            end
        },

        Push = function (self, element)

        end,
    },

    [default] = function (setPrototype)
        setPrototype {
            Values = { }
        }
    end,

    [constructor] = function (setPrototype, count)
        setPrototype {
            Length = count
        }

        List.CreatedCount = List.CreatedCount + 1
    end,


    CreatedCount = 1,

    [operator("[]")] = function (self, index)
        return self.Values[index]
    end,

    [Array] = function (self)

    end,
    



}