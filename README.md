# Introduction

[**Lua**]( https://www.lua.org/ ) is a simple, yet powerful scripting language
commonly used among many apps, games and environments.
It is very good for simple projects and small mods.\
But some of us want to create a big, complex and safe scripts,
that significantly modify the addon: big mods, advanced scripts etc.\
That is why I have created **__Luva__**.

# Luva

**__Luva__** is a powerful Lua framework that introduces:
- many new behaviours
- strict typing
- advanced object-oriented programming
- forward version compatibility (Lua 5.1 - 5.5)

Luva's purpose is to make creating complex projects more unite,
readable, managable and safe, while still being able to run
on standard `.lua` files without the need to translate nor compile it.\
It is written ENTIRELY with **Lua** itself.\
No AI used.\
I'm just autistic af lol

## Main principles

### 1. Safe coding
Types, objects etc. have to be ensured as fast as possible.
Luva shall provide information about any possible error cause.

### 2. Inter-environmental versality
Luva has been created mainly for [Teardown scirpts]().
But beacuse Lua is commonly used, it should be universal in any environment.\
(sorry Stormworks scripters, maybe there will be a branch without metatables)

### 3. Lua forward-compatibility
Lua's versioning isn't meeting the [semantic versioning]() principles, so it was
confusing for many, when another minor version removed a function and made it
uncompatible.\
Luva will try to be compatible by defining more universally built-in functions
and prohibit from using deprecated ones.

Examples:
- Lua 5.1 has `pack` and `unpack`, but newer versions moved them to `table.pack/unpack`. Luva unites them by just moving them to `table.pack/unpack` for Lua 5.1
- Lua 5.1 has `getfenv` and `setfenv` removed in later versions. Because of complexity, Luva prohibits from using them
- Many functions were later joined into one (`loadstring` and `load`, `gfind` and `gmatch` etc.)

### 4. Provide useful keyword-like functions
[switch](), [match](), [typeof](), [class]() etc.\
Main purpose is to shorten the code and make it a little more readable.

### 5. Unite different scripts
Luva framework's projects shall be usable between them (if [`Config.lua`]() has the same properties).

# Requirements
- **Lua** version: 5.1 - newest (check [**SECURITY**]() for current compatibility)
- Environment: metatables, `dofile` function

## Recommended
- [**LuaLS**]() extension

# Documentation
- [**GitHub Wiki**]()
- [Google docs]()

# Contact
- [**Discord**]()
- [GitHub discussion]()

# Support
- [**Buy me a Coffe**]() (Pls I need it to stay awake)
