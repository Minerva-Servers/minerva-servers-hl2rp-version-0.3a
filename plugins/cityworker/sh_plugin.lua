local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers City Worker"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

CITYWORKER = CITYWORKER or {}

ix.util.Include("cl_cityworker.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("sv_cityworker.lua")
