

local Luva, _LUVA = dofile "Luva/base.lua"

import "Luva/Engine/MatchingExpressions/match.lua"

x = 20
print (match (x, {
    [20] = "A",
    default = "C"
}))