local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Combine Ban Library"
PLUGIN.description = ""
PLUGIN.author = "eon"

ix.cban = ix.cban or {}

local PLAYER = FindMetaTable("Player")

function PLAYER:HasActiveCBan()
    if not ( ix.data.Get("cbans/"..self:SteamID64(), false, false, true) ) then
        return false
    end
    
    if ( isbool(ix.data.Get("cbans/"..self:SteamID64(), false, false, true)) ) then
        return false
    end
    
    if not ( file.Exists("helix/"..engine.ActiveGamemode().."/cbans/"..self:SteamID64()..".txt", "DATA") ) then
        return false
    end
    
    return true
end

function PLAYER:GetCBanTime()
    if not ( self:HasActiveCBan() ) then
        return false
    end
    
    return ix.data.Get("cbans/"..self:SteamID64(), false, false, true)
end

function PLAYER:GetCBanTimeReal()
    if not ( self:GetCBanTime() ) then
        return false
    end

    return os.date("%x - %X", self:GetCBanTime())
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("CBan", {
    description = "Combine Bans (Second argument is the amount of days !!!)",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number,
    },
    OnRun = function(self, ply, target, days)
        if ( IsValid(target) ) then
            
            if ( target:HasActiveCBan() ) then
                ply:Notify("This player already has an active Combine ban and another one will not be applied.")
                return    
            end
            
            target:GiveCBan(days)
            
            ply:Notify("You have combine banned "..target:SteamName().." until: "..target:GetCBanTimeReal())
        end
    end,
})

ix.command.Add("CBanRemove", {
    description = "Removes a Combine Ban (Second argument is the amount of days !!!)",
    adminOnly = true,
    arguments = {
        ix.type.player
    },
    OnRun = function(self, ply, target)
        if ( IsValid(target) ) then
            
            if not ( target:HasActiveCBan() ) then
                ply:Notify("This player does not hav an active Combine ban.")
                return    
            end
            
            target:RemoveCBan()
            
            ply:Notify("You have removed "..target:SteamName().."'s combine ban")
        end
    end,
})