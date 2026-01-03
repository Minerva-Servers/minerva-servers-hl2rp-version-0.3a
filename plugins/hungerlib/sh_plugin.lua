local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Hunger Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN = PLUGIN or {}

PLUGIN.factionIgnore = {
    [FACTION_OW] = true,
}

if ( ix.faction.Get(FACTION_NECROTIC) ) then
    PLUGIN.factionIgnore[FACTION_NECROTIC] = true
end

if ( ix.faction.Get(FACTION_HUNTER) ) then
    PLUGIN.factionIgnore[FACTION_HUNTER] = true
end

if ( ix.faction.Get(FACTION_ANTLION) ) then
    PLUGIN.factionIgnore[FACTION_ANTLION] = true
end

ix.util.Include("sv_plugin.lua")

ix.config.Add("hungerTime", 120, "How many seconds between each time a player's needs are calculated", nil, {
    data = {min = 60, max = 1800},
    category = PLUGIN.name,
})

ix.char.RegisterVar("hunger", {
    field = "hunger",
    fieldType = ix.type.number,
    default = 100,
    isLocal = true,
    bNoDisplay = true
})

ix.command.Add("CharSetHunger", {
    description = "Set character's hunger",
    adminOnly = true,
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, char, level)
        char:SetHunger(level or 100)
        ply:Notify(char:GetName().."'s hunger was set to "..( level or 100 ))
    end
})

ix.command.Add("SetHunger", {
    description = "Set character's hunger",
    adminOnly = true,
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, char, level)
        char:SetHunger(level or 100)
        ply:Notify(char:GetName().."'s hunger was set to "..( level or 100 ))
    end
})
