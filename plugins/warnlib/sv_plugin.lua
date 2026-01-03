local PLUGIN = PLUGIN

file.CreateDir("helix/"..Schema.folder.."/warnings")

util.AddNetworkString("ixWarnSend")
util.AddNetworkString("ixWarnSendAll")
util.AddNetworkString("ixWarnGetAll")
util.AddNetworkString("ixWarnListAll")
util.AddNetworkString("ixWarnSync")

function PLUGIN:PlayerInitialSpawn(ply)
    ply.warnings = ix.data.Get("warnings/"..ply:SteamID64(), {}, false, true)

    net.Start("ixWarnSync")
        net.WriteTable(ply.warnings or {})
    net.Send(ply)
end

function ix.warn.GiveWarning(ply, reason)
    ply.warnings[#ply.warnings + 1] = reason

    ix.data.Set("warnings/"..ply:SteamID64(), ply.warnings, false, true)

    net.Start("ixWarnSend")
        net.WriteString(reason)
    net.Send(ply)

    net.Start("ixWarnSendAll")
        net.WriteString(ply:SteamName())
        net.WriteString(reason)
    net.Broadcast()
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has been warned.\nReason: "..reason.."\nTotal Warnings: "..#ply:GetWarnings().."\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, Color(255, 0, 0))
end

function ix.warn.RemoveWarning(ply, id)
    table.remove(ply.warnings, id)

    ix.data.Set("warnings/"..ply:SteamID64(), ply.warnings, false, true)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GiveWarning(reason)
    ix.warn.GiveWarning(self, reason)
end

function PLAYER:RemoveWarning(id)
    ix.warn.RemoveWarning(self, id)
end