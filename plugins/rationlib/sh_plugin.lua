local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Ration Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.rations = ix.rations or {}

ix.rations.globalRationsEnabled = ix.rations.globalRationsEnabled or false
ix.rations.globalRationsClaimed = ix.rations.globalRationsClaimed or {}

ix.util.Include("sv_plugin.lua")
