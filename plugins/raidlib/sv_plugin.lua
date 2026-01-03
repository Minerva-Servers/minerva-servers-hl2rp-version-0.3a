local PLUGIN = PLUGIN

local weps = {
    ["ix_crowbar"] = true,
    ["ix_stunstick"] = true,
    ["ix_grenade"] = true,
    ["ix_vortbeam"] = true,
    ["ix_molotov"] = true,
    ["ix_ied"] = true
}

function PLUGIN:OnPlayerAreaChanged(ply, oldID, newID)
    if not ( ply:GetArea() ) then
        return
    end
    
    if not ( string.lower(newID):find("plaza") or string.lower(newID):find("nexus") ) then
        return
    end
    
    if ( ply:IsCombine() ) then
        return
    end
    
    if ( ply:Team() == FACTION_CWU and ply:GetTeamClass() == CLASS_CWU_ICT ) then -- since they're allowed weps
        return
    end
    
    if ( GetGlobalBool("RaidAllowed", false) ) then
        return
    end
    
    if not ( IsValid(ply:GetActiveWeapon()) ) then
        return
    end
    
    local wep = ply:GetActiveWeapon()
    
    if not ( weps[wep:GetClass()] ) then
        return
    end
    
    for k, v in ipairs(player.GetAll()) do
        if not ( v:IsAdmin() ) then
            return
        end
        
        v:Notify("Possibly ongoing Unauthorized Raid, please check Plaza and Nexus.")
    end
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." suspected for possible Unauthorized Nexus/Plaza Raid.\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, Color(255, 0, 0))
end

function PLUGIN:PlayerSwitchWeapon(ply, old, new)
    if not ( ply:GetArea() ) then
        return
    end
    
    if not ( string.lower(ply:GetArea()):find("plaza") or string.lower(ply:GetArea()):find("nexus") ) then
        return
    end
    
    if ( ply:IsCombine() ) then
        return
    end
    
    if ( ply:Team() == FACTION_CWU and ply:GetTeamClass() == CLASS_CWU_ICT ) then -- since they're allowed weps
        return
    end
    
    if ( GetGlobalBool("RaidAllowed", false) ) then
        return
    end
    
    if not ( new:GetClass():find("arccw_") or weps[new:GetClass()] ) then
        return
    end
    
    for k, v in ipairs(player.GetAll()) do
        if not ( v:IsAdmin() ) then
            return
        end
        
        v:Notify("Possibly ongoing Unauthorized Raid, please check Plaza and Nexus.")
    end
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." suspected for possible Unauthorized Nexus/Plaza Raid.\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, Color(255, 0, 0))
end