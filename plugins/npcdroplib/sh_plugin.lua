local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers NPC Drops Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN.config = {
    ["npc_zombie"] = {
        rarity = 40,
        randomItems = true,
        items = {
            "cloth",
            "cloth",
            "cloth",
            "glue",
            "glue",
            "gunpowder",
        },
    },
    ["npc_manhack"] = {
        rarity = 0,
        randomItems = true,
        items = {
            "biolink",
            "metalplate",
            "metalplate",
        },
    },
    ["npc_cscanner"] = {
        rarity = 0,
        randomItems = true,
        items = {
            "biolink",
            "refinedmetal",
            "refinedmetal",
        },
    },
}

ix.util.Include("sv_plugin.lua")
