local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Job Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("ForceFaction", {
    description = "",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number,
        bit.bor(ix.type.bool, ix.type.optional),
    },
    OnRun = function(self, ply, target, factionID, noRespawn)
        if ( IsValid(target) ) then
            PLUGIN.FactionBecome(target, factionID, nil, noRespawn or false, true)
        end
    end,
})
