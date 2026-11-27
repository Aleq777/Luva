[![Static badge](https://img.shields.io/badge/language-English-blue)](README.md)
[![Static badge](https://img.shields.io/badge/language-Polski-red)](README.pl-PL.md)\
:uk:/:us: English

<h6>Current version: -</h6>

# Introduction

## Lua
[**Lua**](https://www.lua.org/) is a simple, yet powerful scripting language
commonly used among many apps, games and environments.
It is very good for simple projects and small mods.\
But some of us want to create a big, complex and safe scripts,
that significantly modify the addon: big mods, advanced scripts etc.\
That is why I have created **__Luva__**.

## About Luva framework

**__Luva__** is a powerful Lua framework that introduces:
- many new behaviours
- strict typing
- advanced object-oriented programming
- forward version compatibility (Lua 5.1 - 5.5)

Luva's purpose is to make creating complex projects more unite,
readable, manageable and safe, while still being able to run
on standard `.lua` files without the need to translate nor compile it.\
It is written ENTIRELY with **Lua** itself.\
No AI used.\
I'm just autistic af lol

## Main principles

### 1. Safe coding
Types, objects etc. have to be ensured as fast as possible.
Luva shall provide information about any possible error cause.

### 2. Inter-environmental versatility
Luva has been created mainly for [Teardown scripts]().
But because Lua is commonly used, it should be universal in any environment.\
(sorry Stormworks scripters, maybe there will be a branch without metatables)

### 3. Lua forward-compatibility
Lua's versioning isn't meeting the [semantic versioning](https://semver.org/) principles, so it was
confusing for many, when another minor version removed a function and made it
incompatible.\
Luva will try to be compatible by defining more universally built-in functions
and prohibit from using deprecated ones.

Examples:
- Lua 5.1 has `pack` and `unpack`, but newer versions moved them to `table.pack/unpack`. Luva unites them by just moving them to `table.pack/unpack` for Lua 5.1
- Lua 5.1 has `getfenv` and `setfenv` removed in later versions. Because of complexity, Luva prohibits from using them
- Many functions were later joined into one (`loadstring` and `load`, `gfind` and `gmatch` etc.)

### 4. Provide useful keyword-like functions
for example: [switch](), [typeof](), [class](), ...

Main purpose is to shorten the code and make it a little more readable.

### 5. Unite different scripts
Luva framework's projects shall be usable between them (if [`Config.lua`](./Luva/Config.lua) has the same properties).

## Requirements
- **Lua** version: 5.1 - newest (check [**SECURITY.md**](./SECURITY.md) for current compatibility)
- Environment: **metatables**, `dofile` function

> [!TIP]
> [LuaLS](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) is recommended for intelisense and highlighting
### Recommended

# Creating a project
Shortly: download the repo, set `Program.lua` as an entry point in your environment
and write the code in `Main.lua`, additional files and packages import in `Main.lua` (or `Program.lua`)

More detailed:
## Configure your environment

### Visual Studio Code
> [!NOTE]
> You will find here an instruction only for Visual Studio Code.
> If you use other editors/IDEs and know how to implement Luva in them,
> you can commit to the [README](./README.md) or [wiki]()

1. Clone the repo
2. Install [LuaLS](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
3. In extension's settings, choose:
    - Lua version
    - Add requiring function as `import`
4. In your environment, set `Program.lua` as entry point (for example, in Teardown, place there main functions, set the file as main in config or change the file's name)

## Multiple files

You can add new files and import them with `import` function.

## Adding packages

Place installed packages in a named folder (just like Luva is in `Luva` folder).
Import from the project your needed file.

## Debugging

Personally, I use [Lua debugger for VSC]()

# Media
- [Documentation]()
- Report an issue [here]()
- [Discord]() ... coming soon
