local PLUGIN = PLUGIN

function PLUGIN:PlayerTick(ply)
    if not ( ply:IsNecrotic() ) then
        return
    end

    if not ( ( ply.nextNecroticNoise or 0 ) > CurTime() ) then
        if ( ply:GetTeamClass() == CLASS_NECROTIC_SOLDIER ) then
            ply:EmitSound("npc/zombine/zombine_idle"..math.random(1, 4)..".wav", 80, math.random(90, 110), 0.1)
        elseif ( ply:GetTeamClass() == CLASS_NECROTIC_FAST ) then
            ply:EmitSound("npc/fast_zombie/idle"..math.random(1, 3)..".wav", 80, math.random(90, 110), 0.1)
        else
            ply:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav", 80, math.random(90, 110), 0.1)
        end

        ply.nextNecroticNoise = CurTime() + math.random(3, 15)
    end
end

function PLUGIN:KeyPress(ply, key)
    if not ( ply:IsNecrotic() and ply:GetTeamClass() == CLASS_NECROTIC_FAST ) then
        return
    end

    if ( key == IN_JUMP and ply:IsOnGround() ) then
        ply:ViewPunch(Angle(-1, 0, 0))
        ply:EmitSound("npc/fast_zombie/leap1.wav", 80, math.random(90, 110))
        ply:EmitSound("npc/fast_zombie/gurgle_loop1.wav", 60, math.random(90, 110), 0.1)
    end
end

function Schema:OnPlayerHitGround(ply)
    ply:StopSound("npc/fast_zombie/gurgle_loop1.wav")
end

function PLUGIN:PlayerUse(ply)
    if ( ply:IsNecrotic() ) then
        return false
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, speaker)
    if ( speaker:IsNecrotic() ) then
        return false
    end

    if ( speaker:IsNecrotic() and listener:IsNecrotic() ) then
        return true
    end
end

function PLUGIN:CanPlayerEquipItem(ply, item)
    if ( ply:IsNecrotic() ) then
        ply:Notify("You cannot equip this item as a Zombie!")
        
        return false
    end
end

function PLUGIN:CanPlayerTakeItem(ply, item)
    if ( ply:IsNecrotic() ) then
        ply:Notify("You cannot take this item as a Zombie!")
        
        return false
    end
end

function PLUGIN:Move(ply, mv)
    if not ( ply:IsNecrotic() ) then
        return
    end

    local vel = mv:GetVelocity()
    if ( vel:Length() > 0 and ply:GetMoveType() == MOVETYPE_WALK ) then
        if not ( ( ply.nextNecroticStep or 0 ) > CurTime() ) then
            ply:EmitSound("npc/zombie/foot"..math.random(1, 3)..".wav", 70, math.random(90, 110), 0.8)
            timer.Simple(0.1, function()
                ply:EmitSound("npc/zombie/foot_slide"..math.random(1, 3)..".wav", 60, math.random(90, 110), 0.4)
            end)

            ply.nextNecroticStep = CurTime() + 1.5
        end
    end
end