local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers IED"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN.list = PLUGIN.list or {}
PLUGIN.frequencies = {
    82.4,
    87.9,
    104.4,
    115.4,
    54.2,
    95.2,
    108.4,
    12.9,
}

ix.util.Include("sv_plugin.lua")
