
---@diagnostic disable : lowercase-global


---@module "Config"
---@module "namespaces"
---@module "exceptions"
---@module "switch"
---@module "select"
---@module "xor"
---@module "classes"
---@module "using"


Luva = dofile("Luva/Framework/base.lua")
Luva.Utils = dofile("Luva/Framework/utils.lua")


from, export = dofile("Luva/Framework/namespaces.lua")

try = dofile("Luva/Framework/exceptions.lua")

switch = dofile("Luva/Framework/switch.lua")

select = dofile("Luva/Framework/select.lua")

xor = dofile("Luva/Framework/xor.lua")

class = dofile("Luva/Framework/classes.lua")

using = dofile("Luva/Framework/using.lua")



return Luva, from, class, try, switch, select, xor, using