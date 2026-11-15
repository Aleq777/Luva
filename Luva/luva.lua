
-- globals: data saved between files, mutable
-- locals
--  no return: data only locally
--  with return: data shared between files, immutable unless further return
--- Luva things to use publicly
Luva = Luva or { }

--- Luva engine ingredients
_LUVA = _LUVA or {
    Errors = { },
    Modules = { }
}