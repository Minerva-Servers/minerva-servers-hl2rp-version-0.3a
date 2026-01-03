local PLUGIN = PLUGIN

PLUGIN.name = "Ammo Crate"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN.ammo = {
    ["AR2"] = 300,
    ["Pistol"] = 300,
    ["357"] = 300,
    ["Buckshot"] = 300,
    ["SMG1"] = 300,
    ["SniperPenetratedRound"] = 300,
    /*
    ["AR2"] = 300,
    ["Pistol"] = 150,
    ["357"] = 40,
    ["Buckshot"] = 60,
    ["SMG1"] = 500,
    ["SniperPenetratedRound"] = 60,
    */
}

ix.util.Include("sv_plugin.lua")
