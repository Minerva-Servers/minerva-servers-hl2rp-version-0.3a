local PLUGIN = PLUGIN

file.CreateDir("helix/"..Schema.folder.."/achievements")

util.AddNetworkString("ixAchievementNotify")

local meta = FindMetaTable("Player")

function meta:GiveAchievement(achievement)
    if ( ix.achievements.list[achievement] and not self:HasAchievement(achievement) ) then
        file.CreateDir("helix/"..Schema.folder.."/achievements/"..self:SteamID64())

        ix.data.Set("achievements/"..self:SteamID64().."/"..tostring(achievement), os.time(), false, true)

        if ( ix.achievements.list[achievement].onAchieve ) then
            ix.achievements.list[achievement].onAchieve(self)
        end

        net.Start("ixAchievementNotify")
            net.WriteString(self:SteamName())
            net.WriteString(achievement)
        net.Broadcast()
    end
end

function meta:TakeAchievement(achievement)
    if ( ix.achievements.list[achievement] and self:HasAchievement(achievement) ) then
        file.Delete("helix/"..engine.ActiveGamemode().."/achievements/"..self:SteamID64().."/"..tostring(achievement)..".txt")
    end
end

function PLUGIN:PlayerLoadout(ply)
    for name, data in pairs( ix.achievements.list ) do
        if ( !ply:HasAchievement( name ) ) then
            continue
        end

        local character = ply:GetCharacter()

        if ( !character ) then
            continue
        end

        if ( !data.customCheck ) then
            continue
        end

        if ( data.customCheck( ply ) ) then
            ply:GiveAchievement( name )
        end
    end
end

function PLUGIN:PlayerInitialSpawn(ply)
    if ( ix.cityCode.GetCurrent() == "jw" ) then
        ply:GiveAchievement("jwjoin")
    end
end

function PLUGIN:PlayerLoadout(ply)
    ply:GiveAchievement("firstjoin") 
end

function PLUGIN:PlayerDeath(ply, ent, attacker)
    attacker = attacker or (((wep:GetClass() or "") == "env_fire") and wep:GetOwner())-- hacky fix for molotov fire

    if not ( IsValid(attacker) ) then
        return
    end

    if ( attacker:IsPlayer() ) then
        if not ( attacker:Alive() ) then
            attacker:GiveAchievement("fromthegrave")
        end
        
        ply:GiveAchievement("firstdeath")
        
        if ( ply:Team() == FACTION_CP ) then
            attacker:GiveAchievement("cpkill")
        end
        
        if ( ply:Team() == FACTION_OW ) then
            attacker:GiveAchievement("owkill") 
        end
        
        if ( ply:SteamID64() == "76561197963057641" ) then
            attacker:GiveAchievement("killriggs")
        end
        
        if ( ( ply:SteamID64() == "76561197963057641" and ply:Team() == FACTION_OW and ply:GetTeamClass() == RANK_OW_CPT ) or ( ply:SteamID() == "STEAM_0:1:435339450" and ply:Team() == FACTION_CP and ply:GetTeamClass() == RANK_CP_CPC ) ) then
            attacker:GiveAchievement("cpcmdkill")
        end
       
        if ( ply:SteamID() == "STEAM_1:1:5736612" ) then
            attacker:GiveAchievement("killdjgaming")
        end
        
        if ( ply:SteamID() == "STEAM_0:1:206522106" ) then
            attacker:GiveAchievement("killeon")
        end
    end
end

function PLUGIN:PlayerChangedTeam(ply, oldID, ID)
    if ( ID == FACTION_CP ) then
        ply:GiveAchievement("cpbecome") 
    end
    
    if ( ID == FACTION_OW ) then
        ply:GiveAchievement("owbecome") 
    end
end

local dancers = {}
function PLUGIN:PlayerShouldTaunt(ply, act)
    if not ( act == 1642 ) then
        return
    end
    
    local pos = table.insert(dancers, ply)

    timer.Simple(12, function()
        dancers[pos] = nil
    end)

    if not ( table.Count(dancers) > 14 ) then
        return
    end
    
    for k, v in pairs(dancers) do
        if not ( IsValid(v) ) then
            continue
        end
        
        v:GiveAchievement("party")
    end

    dancers = {}
end
