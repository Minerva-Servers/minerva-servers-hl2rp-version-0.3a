local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Raiding Library"
PLUGIN.description = ""
PLUGIN.author = "eon"

PLUGIN.raidDelay = 1800

ix.util.Include("sv_plugin.lua")

ix.command.Add("AllowRaid", {
    description = "Allow a Plaza/Nexus Raid",
    adminOnly = true,
    OnRun = function(_, ply)
        if ( GetGlobalBool("RaidAllowed", false) ) then
            ply:Notify("Raids are already allowed.")
            return
        end
        
        SetGlobalBool("RaidAllowed", true)
    end
})

ix.command.Add("DisallowRaid", {
    description = "Allow a Plaza/Nexus Raid",
    adminOnly = true,
    OnRun = function(_, ply)
        if not ( GetGlobalBool("RaidAllowed", false) ) then
            ply:Notify("Raids aren't currently allowed.")
            return
        end
        
        SetGlobalBool("RaidAllowed", false)
    end
})