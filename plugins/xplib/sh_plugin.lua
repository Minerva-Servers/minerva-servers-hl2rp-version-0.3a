local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers XP Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.xp = ix.xp or {}

ix.config.Add("xpTime", 600, "", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 0,
        min = 60,
        max = 3600,
    },
})

ix.config.Add("normalXPGain", 5, "", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 0,
        min = 0,
        max = 100,
    },
})

ix.config.Add("donatorXPGain", 10, "", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 0,
        min = 0,
        max = 100,
    },
})

local PLAYER = FindMetaTable("Player")

function PLAYER:GetXP()
    return self:GetNWInt("ixXP") or ( SERVER and self:GetPData("ixXP", 0) or 0 )
end

if ( SERVER ) then
    function PLAYER:SetXP(value)
        if not ( tonumber(value) ) then return end
        if ( tonumber(value) < 0 ) then return end

        self:SetPData("ixXP", tonumber(value))
        self:SetNWInt("ixXP", tonumber(value))
    end
end

ix.util.Include("sv_plugin.lua")

ix.command.Add("GetXP", {
    description = "Get's a player's XP",
    arguments = {
        bit.bor(ix.type.player, ix.type.optional),
    },
    OnRun = function(self, ply, target)
        if ( target ) then
            ply:Notify(target:SteamName().." XP count is "..target:GetXP()..".")
        elseif ( !target ) then
            ply:Notify("Your XP count is "..ply:GetXP()..".")
        end
    end,
})

ix.command.Add("SetXP", {
    description = "Set's a player's XP",
    superAdminOnly = true,
    arguments = {
        ix.type.number,
        bit.bor(ix.type.player, ix.type.optional),
    },
    OnRun = function(self, ply, amount, target)
        if ( target and amount ) then
            target:SetXP(amount)
            ply:Notify("You have set "..target:SteamName().."("..target:Nick()..") XP to "..amount)
        elseif ( !target and amount ) then
            ply:SetXP(amount)
            ply:Notify("You have set your own XP to "..amount)
        end
    end,
})
