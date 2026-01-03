local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Rank NPC Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.rankNPC = ix.rankNPC or {}

local PLAYER = FindMetaTable("Player")

function PLAYER:CanBecomeTeamClass(classID, bNotify)
    local teamData = ix.faction.Get(self:Team())
    local classData = teamData.classes[classID]
    local classPlayers = 0

    if not ( self:Alive() ) then
        return false
    end

    if ( classData.whitelistUID ) and not ( self:ixHasWhitelist(classData.whitelistUID) ) then
        if ( self:IsSuperAdmin() ) then
            self:Notify("You bypassed the whitelist restriction.")
            return true
        end

        local add = classData.whitelistFailMessage or ""
        if ( bNotify ) then
            self:Notify("You must be whitelisted to play as this class. "..add)
        end

        return false
    end

    if ( classData.xp ) and ( classData.xp > self:GetXP() ) then
        if ( self:IsSuperAdmin() ) then
            self:Notify("You bypassed the XP limit.")
            return true
        end

        if ( bNotify ) then
            self:Notify("You don't have the XP required to play as this class.")
        end

        return false
    end

    if ( classData.limit ) then
        local classPlayers = 0 

        for k, v in pairs(team.GetPlayers(self:Team())) do
            if ( v:GetTeamRank() == classID ) then
                classPlayers = classPlayers + 1
            end
        end

        if ( classData.percentLimit ) and ( classData.percentLimit == true ) then
            local percentRank = classPlayers / player.GetCount()

            if ( percentRank ) > ( classData.limit ) then
                if ( bNotify ) then
                    self:Notify(classData.name .. " is full.")
                end

                return false
            end
        else
            if ( classPlayers ) > ( classData.limit ) then
                if ( bNotify ) then
                    self:Notify(classData.name .. " is full.")
                end

                return false
            end
        end
    end

    if ( classData.customCheck ) then
        local results = classData.customCheck(self, classData)

        if ( results == false ) then
            return false
        end
    end

    return true
end

function PLAYER:CanBecomeTeamRank(rankID, bNotify)
    local teamData = ix.faction.Get(self:Team())
    local rankData = teamData.ranks[rankID]
    local rankPlayers = 0

    if not ( self:Alive() ) then
        return false
    end

    if ( rankData.whitelistUID ) and not ( self:ixHasWhitelist(rankData.whitelistUID) ) then
        if ( self:IsSuperAdmin() ) then
            self:Notify("You bypassed the whitelist restriction.")
            return true
        end

        local add = rankData.whitelistFailMessage or ""
        if ( bNotify ) then
            self:Notify("You must be whitelisted to play as this rank. "..add)
        end

        return false
    end

    if ( rankData.xp ) and ( rankData.xp > self:GetXP() ) then
        if ( self:IsSuperAdmin() ) then
            self:Notify("You bypassed the XP limit.")
            return true
        end

        if ( bNotify ) then
            self:Notify("You don't have the XP required to play as this rank.")
        end

        return false
    end

    if ( rankData.limit ) then
        local rankPlayers = 0 

        for k, v in pairs(team.GetPlayers(self:Team())) do
            if ( v:GetTeamRank() == rankID ) then
                rankPlayers = rankPlayers + 1
            end
        end

        if ( rankData.percentLimit ) and ( rankData.percentLimit == true ) then
            local percentRank = rankPlayers / player.GetCount()

            if ( percentRank ) > ( rankData.limit ) then
                if ( bNotify ) then
                    self:Notify(rankData.name .. " is full.")
                end

                return false
            end
        else
            if ( rankPlayers ) > ( rankData.limit ) then
                if ( bNotify ) then
                    self:Notify(rankData.name .. " is full.")
                end

                return false
            end
        end
    end

    if ( rankData.customCheck ) then
        local results = rankData.customCheck(self, rankData.name)

        if ( results == false ) then
            return false
        end
    end

    return true
end

function PLAYER:GetTeamClass()
    return self:GetNetVar("ixClass", 0)
end

function PLAYER:GetTeamClassTable()
    local teamData = ix.faction.Get(self:Team())
    local classData = teamData.classes[self:GetTeamClass()]

    if not ( classData ) then
        return
    end

    return classData
end

function PLAYER:GetTeamRank()
    return self:GetNetVar("ixRank", 0)
end

function PLAYER:GetTeamRankTable()
    local teamData = ix.faction.Get(self:Team())
    local rankData = teamData.ranks[self:GetTeamRank()]

    if not ( rankData ) then
        return
    end

    return rankData
end

local availableWhitelists = {}
for k, v in pairs(ix.faction.Get(FACTION_CP).ranks) do
    if ( v.whitelistUID ) then
        availableWhitelists[#availableWhitelists + 1] = v.whitelistUID
    end
end

for k, v in pairs(ix.faction.Get(FACTION_CP).classes) do
    if ( v.whitelistUID ) then
        availableWhitelists[#availableWhitelists + 1] = v.whitelistUID
    end
end

for k, v in pairs(ix.faction.Get(FACTION_OW).ranks) do
    if ( v.whitelistUID ) then
        availableWhitelists[#availableWhitelists + 1] = v.whitelistUID
    end
end

for k, v in pairs(ix.faction.Get(FACTION_OW).classes) do
    if ( v.whitelistUID ) then
        availableWhitelists[#availableWhitelists + 1] = v.whitelistUID
    end
end

if ( SERVER ) then
    local PLAYER = FindMetaTable("Player")
    function PLAYER:ixGiveWhitelist(uid)
        file.CreateDir("helix/"..Schema.folder.."/whitelists")
        file.CreateDir("helix/"..Schema.folder.."/whitelists/"..uid)
        ix.data.Set("whitelists/"..uid.."/"..self:SteamID64(), true, false, true)
    end

    function PLAYER:ixTakeWhitelist(uid)
        file.CreateDir("helix/"..Schema.folder.."/whitelists")
        file.CreateDir("helix/"..Schema.folder.."/whitelists/"..uid)
        ix.data.Set("whitelists/"..uid.."/"..self:SteamID64(), false, false, true)
    end

    function PLAYER:ixHasWhitelist(uid)
        file.CreateDir("helix/"..Schema.folder.."/whitelists")
        file.CreateDir("helix/"..Schema.folder.."/whitelists/"..uid)
        return tobool(ix.data.Get("whitelists/"..uid.."/"..self:SteamID64(), false, false, true))
    end
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("GiveWhitelist", {
    description = "Give a player a whitelist.",
    superAdminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.text,
    },
    OnRun = function(self, ply, target, whitelistType)
        if not ( target ) then
            ply:Notify("No player selected.")
            return
        end

        if not ( whitelistType ) then
            ply:Notify("No whitelist type selected.")
            return
        end

        if not ( table.HasValue(availableWhitelists, whitelistType) ) then
            ply:Notify("Invalid whitelist type, available whitelists: "..table.concat(availableWhitelists, ", "))
            return
        end

        if ( target:ixHasWhitelist(whitelistType) ) then
            ply:Notify(target:Name() .. " already has a whitelist of type " .. whitelistType .. ".")
            return
        end

        target:ixGiveWhitelist(whitelistType)
        target:Notify("You have been given a whitelist for "..whitelistType..".")
        ply:Notify("You have given "..ply:Nick().." a whitelist for "..whitelistType..".")
    end,
})

ix.command.Add("TakeWhitelist", {
    description = "Take a player's whitelist.",
    superAdminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.text,
    },
    OnRun = function(self, ply, target, whitelistType)
        if not ( target ) then
            ply:Notify("No player selected.")
            return
        end

        if not ( whitelistType ) then
            ply:Notify("No whitelist type selected.")
            return
        end

        if not ( table.HasValue(availableWhitelists, whitelistType) ) then
            ply:Notify("Invalid whitelist type, available whitelists: "..table.concat(availableWhitelists, ", "))
            return
        end

        if not ( target:ixHasWhitelist(whitelistType) ) then
            ply:Notify("This player does not have a whitelist for "..whitelistType..".")
            return
        end

        target:ixTakeWhitelist(whitelistType)
        target:Notify("Your whitelist for "..whitelistType.." has been taken.")
        ply:Notify("You have taken "..ply:Nick().."'s whitelist for "..whitelistType..".")
    end,
})

ix.command.Add("ForceClassRank", {
    description = "",
    superAdminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number,
        bit.bor(ix.type.number, ix.type.optional),
        bit.bor(ix.type.bool, ix.type.optional),
    },
    OnRun = function(self, ply, target, classID, rankID, bShouldBypass)
        if ( IsValid(target) ) then
            ix.rankNPC.Become(target, classID, rankID, bShouldBypass)
        end
    end,
})
