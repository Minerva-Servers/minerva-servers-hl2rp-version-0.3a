local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Item Drops Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN.config = {
    [FACTION_CP] = {
        // guaranteed, items will be dropped from the player no matter what. all items from the table drop.
        ["guaranteed"] = {
            "biolink",
        },

        // random, items have a 50% chance of being dropped. selects random item from the table to drop.
        // random will drop instead of weapon
        ["random"] = {
            "ammo_pistol",
            "ammo_smg",
            // for healthvial have more chance of being dropped
            "healthvial",
            "healthvial",
        },
    },
    [FACTION_OW] = {
        ["guaranteed"] = {
            "biolink",
            "ruinedotavest",
        },
        ["random"] = {
            "ammo_smg",
            "ammo_pulse",
            "healthkit",
            "healthvial",
            "healthvial",
        },
    },
}

ix.util.Include("sv_plugin.lua")
