local PLUGIN = PLUGIN

file.CreateDir("helix/"..Schema.folder.."/cbans")

util.AddNetworkString("ixCBanSend")
util.AddNetworkString("ixCBanSendRemove")

function ix.cban.GiveCBan(ply, time)
    if ( ply:HasActiveCBan() ) then
        return    
    end
    
    local tim = os.time() + time * 86400
    ix.data.Set("cbans/"..ply:SteamID64(), tim, false, true)

    net.Start("ixCBanSend")
    net.Send(ply)
    
    hook.Run("PlayerOnCombineBanned", ply)
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has been combine banned.\nRemove Date: "..ply:GetCBanTimeReal().."\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, Color(255, 0, 0))
end

function ix.cban.RemoveCBan(ply)
    if not ( ply:HasActiveCBan() ) then
        return    
    end
    
    file.Delete("helix/"..engine.ActiveGamemode().."/cbans/"..ply:SteamID64()..".txt")

    net.Start("ixCBanSendRemove")
    net.Send(ply)
    
    hook.Run("PlayerOnCombineBannedRemoved", ply)
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().."'s combine ban has been removed.\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, Color(255, 0, 0))
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GiveCBan(time)
    ix.cban.GiveCBan(self, time)
end

function PLAYER:RemoveCBan()
    ix.cban.RemoveCBan(self)
end

function PLUGIN:PlayerOnCombineBanned(ply)
    if ( ply:Team() == FACTION_CP or ply:Team() == FACTION_OW or ply:Team() == FACTION_ADMINISTRATOR ) then
        ix.plugin.list["joblib"].FactionBecome(ply, FACTION_CITIZEN, true)
    end
end

function PLUGIN:PlayerLoadout(ply)
    if not ( ply:HasActiveCBan() ) then
        return
    end
    
    if ( os.time() < ply:GetCBanTime() ) then
        return
    end
    
    ply:RemoveCBan()
    ply:Notify("Your Combine Ban has Expired!")
    ply:SendLua([[surface.PlaySound("buttons/button10.wav")]])
end