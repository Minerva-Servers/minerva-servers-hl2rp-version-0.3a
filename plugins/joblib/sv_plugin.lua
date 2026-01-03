local PLUGIN = PLUGIN

// This is just a fix for some bug that sets player's health after they spawn
// This link shows where it sets the health, this just sets the hp back to 100
// when PostPlayerLoadout is called instead.
// https://github.com/NebulousCloud/helix/blob/master/gamemode/core/hooks/sv_hooks.lua#L510
function PLUGIN:PostPlayerLoadout(ply)
    local character = ply:GetCharacter()

    if not ( character ) then
        return
    end

    ply:SetHealth(100)
    ply:SetViewOffset(Vector(0, 0, 66))
    ply:SetViewOffsetDucked(Vector(0, 0, 40))
end

function PLUGIN:PlayerLoadedCharacter(ply)
    if ( ply:Team() != FACTION_CITIZEN ) then
        PLUGIN.FactionBecome(ply, FACTION_CITIZEN)
    else
        PLUGIN.FactionBecome(ply, FACTION_CITIZEN, true)
    end

    ply:AllowFlashlight(true)
end

function PLUGIN:PlayerDeath(ply, inflicter, attacker)
    if ( ply.inJail ) then
        return
    end

    if not ( ply:IsBot() ) then
        timer.Simple(0.1, function()
            PLUGIN.FactionBecome(ply, FACTION_CITIZEN, false, true)
        end)
    end
end

util.AddNetworkString("ixFactionMenuBecome")

function PLUGIN.FactionBecome(ply, factionID, bNoWipeInv, bNoRespawn, bBypass)
    if not ( IsValid(ply) and ply:GetCharacter() ) then
        return
    end

    local char = ply:GetCharacter()

    if not ( char ) then
        return
    end

    local factionTable = ix.faction.Get(factionID)
    
    if not ( factionTable ) then
        return 
    end
    
    if ( factionTable.donatorOnly and !ply:IsDonator() ) then
        return
    end

    if ( factionTable.isDefault == false and ply:HasWhitelist(factionTable.index) == false ) then
        ply:Notify("You are not whitelisted for this faction!")
        return
    end

    if ( factionTable.PreBecome and factionTable.PreBecome(_, ply, char, factionTable) == false and not bBypass ) then
        return
    end

    local model = tostring(table.Random(factionTable.models)) or ply:GetModel()
    if ( string.find(model, "/hl2rp/") ) then
        model = char:GetData("originalModel", table.Random(factionTable.models))
    end

    if ( ply.inJail ) then
        ply:UnJail()
    elseif ( ply:IsArrested() ) then
        ply:UnArrest()
    end

    ply:ResetBodygroups()

    local oldFactionID = char:GetFaction()
    char:SetFaction(factionID)
    char:SetName(char:GetData("originalName", ply:Nick()))
    char:SetModel(model)
    ply:SetSkin(0)
    ply:SetPlayerColor(Vector(1, 1, 1))
    if not ( bNoRespawn ) then
        ply:Spawn()
    end

    if ( factionTable.bodyGroups ) then
        for k, value in pairs(factionTable.bodyGroups) do
            local index = ply:FindBodygroupByName(k)

            if ( index > -1 ) then
                ply:SetBodygroup(index, value)
            end
        end
    end

    if not ( bNoWipeInv ) then
        for k, v in pairs(char:GetInventory():GetItems()) do
            if ( v:GetData("equip") ) then
                v:SetData("equip", nil)
            end
            v:Remove()
        end
    end

    ply.carryWeapons = {}

    ply:StripWeapons()
    ply:StripAmmo()

    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(0)
    ply:SetMaxArmor(0)
    ply:SetJumpPower(150)

    ply:SetModelScale(1)

    for i = 0, 30 do
        ply:SetSubMaterial(i, "")
    end

    for k, v in pairs({"ix_hands", "ix_keys", "weapon_physgun", "gmod_tool"}) do
        ply:Give(v)
    end

    if ( factionTable.weapons ) then
        for k, v in pairs(factionTable.weapons) do
            ply:Give(v)
        end
    end

    ply:SetNetVar("ixClass", nil)
    ply:SetNetVar("ixRank", nil)
    char:SetBol(false)
    char:SetBolReason(nil)
    char:SetDefunct(false)
    char:SetInformant(false)

    ply:SetupHands()
    ply:AllowFlashlight(true)
    
    if ( factionTable.OnBecome ) then
        factionTable.OnBecome(_, ply, char, factionTable)
    end

    ix.log.AddRaw(ply:Nick().." switched from "..ix.faction.Get(oldFactionID).name.." to "..factionTable.name.."!")

    hook.Run("PlayerChangedTeam", ply, oldFactionID, factionID)
    
    local factionDelay = 180

    if ( ply:IsSuperAdmin() ) then
        factionDelay = 3
    elseif ( ply:IsAdmin() ) then
        factionDelay = 30
    elseif ( ply:IsDonator() ) then
        factionDelay = 60
    end
    
    if not ( bBypass ) then
        if ( timer.Exists("ixNextFactionChange."..ply:SteamID64()) ) then
            timer.Remove("ixNextFactionChange."..ply:SteamID64())
        end
    end

    timer.Create("ixNextFactionChange."..ply:SteamID64(), factionDelay, 1, function() end)
end

net.Receive("ixFactionMenuBecome", function(len, ply)
    if not ( IsValid(ply) and ply:Alive() and ply:GetCharacter() ) then
        return
    end

    local char = ply:GetCharacter()

    if not ( char ) then
        return
    end

    if ( timer.Exists("ixNextFactionChange."..ply:SteamID64()) ) then
        ply:Notify("You need to wait "..string.NiceTime(timer.TimeLeft("ixNextFactionChange."..ply:SteamID64())).." before you can change factions!")
        return
    end

    local factionID = net.ReadUInt(8)
    local char = ply:GetCharacter()

    PLUGIN.FactionBecome(ply, factionID)
end)