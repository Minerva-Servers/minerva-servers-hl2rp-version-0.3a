local PLUGIN = PLUGIN

function PLUGIN:SaveAPCTerminals()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_apcspawner")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel()}
    end

    ix.data.Set("apcTerminals", data)
end

function PLUGIN:LoadAPCTerminals()
    for _, v in ipairs(ix.data.Get("apcTerminals") or {}) do
        local apcTerminals = ents.Create("ix_apcspawner")

        apcTerminals:SetPos(v[1])
        apcTerminals:SetAngles(v[2])
        apcTerminals:SetModel(v[3])
        apcTerminals:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveAPCTerminals()
end

function PLUGIN:LoadData()
    self:LoadAPCTerminals()
end

util.AddNetworkString("ixAPCSpawn")
    
net.Receive("ixAPCSpawn", function(len, ply)
    if not ( PLUGIN.maps[game.GetMap()] ) then
        return
    end
    
    if not ( ply:Team() == FACTION_CP and ply:GetTeamRank() >= RANK_CP_SQL and ply:GetTeamClass() == CLASS_CP_TECHNICIAN ) then
        ply:Notify("You are not allowed to spawn an APC.")
        return 
    end
    
    if ( IsValid(CurActiveAPC) ) then
        ply:Notify("You are not allowed to spawn another APC.")
        
        Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." attempted to spawn an APC but there is one active.\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, team.GetColor(ply:Team()))
        return
    end
    
    if ( ( APCDelay or 0 ) > CurTime() ) then
        ply:Notify("You are not allowed to spawn an APC at this time. ("..string.ToMinutesSeconds(APCDelay - CurTime())..")")
        
        Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." attempted to spawn an APC but there's delay ("..string.ToMinutesSeconds(APCDelay - CurTime())..")\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, team.GetColor(ply:Team()))
        return
    end
    
    CurActiveAPC = simfphys.SpawnVehicle(ply, PLUGIN.maps[game.GetMap()][1], PLUGIN.maps[game.GetMap()][2], "models/combine_apc.mdl", "gmod_sent_vehicle_fphysics_base", "sim_fphys_combineapc_armed", list.Get("simfphys_vehicles")["sim_fphys_combineapc_armed"])
    
    ply:Notify("You have spawned an APC.")
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has spawned an APC.\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, team.GetColor(ply:Team()))
    
    APCDelay = CurTime() + 2700 -- 45 minutes
end) 