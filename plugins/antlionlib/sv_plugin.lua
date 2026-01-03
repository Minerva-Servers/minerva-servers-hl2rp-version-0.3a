local PLUGIN = PLUGIN

local hunterNoises = {
    "npc/antlion/idle1.wav",
    "npc/antlion/idle2.wav",
    "npc/antlion/idle3.wav",
    "npc/antlion/idle4.wav",
    "npc/antlion/idle5.wav",
}
function PLUGIN:PlayerTick(ply)
    if not ( ply:IsAntlion() ) then
        return
    end

    if not ( ( ply.nextAntlionNoise or 0 ) > CurTime() ) then
        ply:EmitSound(table.Random(hunterNoises), 80, math.random(90, 110), 0.3)

        ply.nextAntlionNoise = CurTime() + math.random(3, 7)
    end
    
    local trace = util.TraceLine({
        start = ply:GetPos(),
        endpos = ply:GetPos() - Vector(0, 0, 10000),
        filter = function(ent)
            return true
        end,
    })

    local hitpos = trace.HitPos
    local distance = ply:GetPos():Distance(hitpos)

    if not ( ply:OnGround() ) then
        if ( distance >= 64 ) then
            if not ( ply.antlionFlyingNoise ) then
                ply:EmitSound("npc/antlion/fly1.wav")
                ply.antlionFlyingNoise = true
            end
        else
            if ( ply.antlionFlyingNoise ) then
                ply:EmitSound("npc/antlion/land1.wav")
                ply:StopSound("npc/antlion/fly1.wav")
                ply.antlionFlyingNoise = nil
            end
        end
    end
end

function PLUGIN:PlayerUse(ply)
    if ( ply:IsAntlion() ) then
        return false
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, speaker)
    if ( listener:IsAntlion() ) then
        return false
    end
end

function PLUGIN:CanPlayerEquipItem(ply, item)
    if ( ply:IsAntlion() ) then
        ply:Notify("You cannot equip this item as an Antlion!")
        
        return false
    end
end

function PLUGIN:CanPlayerTakeItem(ply, item)
    if ( ply:IsAntlion() ) then
        ply:Notify("You cannot take this item as an Antlion!")
        
        return false
    end
end

function PLUGIN:GetFallDamage(ply)
    if ( ply:IsAntlion() ) then
        return false
    end
end