local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Warn Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.warn = ix.warn or {}

function ix.warn.GetWarnings(ply)
    return ply.warnings or {}
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GetWarnings()
    return ix.warn.GetWarnings(self)
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("GetWarnings", {
    description = "",
    arguments = {
        bit.bor(ix.type.player, ix.type.optional),
    },
    OnRun = function(self, ply, target)
        if ( target and IsValid(target) ) then
            net.Start("ixWarnGetAll")
                net.WriteString(#target:GetWarnings())
            net.Send(ply)
        else
            net.Start("ixWarnGetAll")
                net.WriteString(#ply:GetWarnings())
            net.Send(ply)
        end
    end,
})

ix.command.Add("ListWarnings", {
    description = "",
    arguments = {
        bit.bor(ix.type.player, ix.type.optional),
    },
    OnRun = function(self, ply, target)
        if ( target and IsValid(target) ) then
            net.Start("ixWarnListAll")
                net.WriteTable(target:GetWarnings())
                net.WriteString(target:SteamName())
            net.Send(ply)
        else
            net.Start("ixWarnListAll")
                net.WriteTable(ply:GetWarnings())
                net.WriteString(ply:SteamName())
            net.Send(ply)
        end
    end,
})

ix.command.Add("GiveWarning", {
    description = "",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.text,
    },
    OnRun = function(self, ply, target, reason)
        if ( IsValid(target) ) then
            target:GiveWarning(reason)
        end
    end,
})

ix.command.Add("RemoveWarning", {
    description = "",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number,
    },
    OnRun = function(self, ply, target, id)
        if ( IsValid(target) ) then
            target:RemoveWarning(id)
        end
    end,
})
