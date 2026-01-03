-- Here is where all shared hooks should go.

function Schema:PrePACConfigApply(ply)
    if not ( ply:IsSuperAdmin() ) then
        return false, "PAC3 is restricted to certain users only!"
    end
end

function Schema:PrePACEditorOpen(ply)
    if not ( ply:IsSuperAdmin() ) then
        return false, "PAC3 is restricted to certain users only!"
    end
end

function Schema:CanProperty(ply, property, ent)
    if ( property == "persist" and !ply:IsAdmin() ) then
        return false
    end
end

local function EquippedItem(ply, item)
    local char = ply:GetCharacter()
    return char:GetInventory():HasItem(item, {["equip"] = true})
end

function Schema:PlayerFootstep(ply, position, foot, soundName, volume)
    if ( SERVER ) then
        local extraSoundName = ""

        if ( ply:IsCP() ) then
            extraSoundName = "npc/metropolice/gear"..math.random(1, 6)..".wav"
        elseif ( ply:IsOW() ) then
            extraSoundName = "npc/combine_soldier/gear"..math.random(1, 6)..".wav"
        elseif ( ply.IsHunter and ply:IsHunter() ) then
            soundName = "npc/ministrider/ministrider_footstep"..math.random(1, 5)..".wav"
        elseif ( ply.IsAntlion and ply:IsAntlion() ) then
            extraSoundName = "npc/antlion/foot"..math.random(1, 4)..".wav"
            soundName = "npc/antlion/foot"..math.random(1, 4)..".wav"
        elseif ( EquippedItem(ply, "torso_blue_rebel") or EquippedItem(ply, "torso_gray_rebel") or EquippedItem(ply, "torso_green_rebel") ) then
            extraSoundName = "minerva/hl2rp/footsteps/hardboot_generic"..math.random(1, 9)..".mp3"
        end

        if ( ply:IsRunning() ) then
            if not ( extraSoundName == "" ) then
                ply:EmitSound(extraSoundName, 80, math.random(90, 110))
            end

            ply:EmitSound(soundName, 80, math.random(90, 110))
        else
            ply:EmitSound(soundName, 70, math.random(90, 110))
        end
    end

    return true
end

function Schema:CanPlayerJoinClass()
    return false
end

function Schema:CanDrive()
    return false
end

function Schema:CanPlayerUseBusiness()
    return false
end

function Schema:simfphysPhysicsCollide()
    return true
end

function Schema:CanPlayerThrowPunch(ply)
    if ( ply:IsWepRaised() ) and not ( ply:GetXP() >= 100 ) then
        if ( SERVER and math.random(1, 10) == 1 ) then
            ply:ChatNotify("Don't try to minge.")
        end

        return false
    end
end

function Schema:OnReloaded()
    if ( SERVER ) then
        if ( ( nextserverRefresh or 0 ) <= CurTime() ) then
            ix.log.AddRaw("Server has been refreshed!")

            for k, v in pairs(player.GetAll()) do
                v:ChatNotify("[Minerva] Server has been refreshed!")
                v:ConCommand("stopsound")

                ix.event.PlaySoundGlobal({
                    sound = "minerva/hl2rp/miscellaneous/debugsound.wav",
                    volume = 0.5,
                })
            end

            nextserverRefresh = CurTime() + 1
        end
    end

    if ( CLIENT ) then
        if ( ( nextclientRefresh or 0 ) <= CurTime() ) then
            for k, v in pairs(player.GetAll()) do
                ix.log.AddRaw("Client has been refreshed!")
                v:ChatNotify("[Minerva] Client has been refreshed!")
                RunConsoleCommand("stopsound")
                v:EmitSound("minerva/global/talk.mp3", nil, nil, 0.5)
            end

            nextclientRefresh = CurTime() + 1
        end
    end
end

function Schema:KeyPress(ply, key)
    if ( key == IN_JUMP and ply:IsOnGround() ) then
        ply:ViewPunch(Angle(-1, 0, 0))
    end
end

function Schema:OnPlayerHitGround(ply, inWater, onFloater, speed)
    if not ( inWater ) and ( ply:IsValid() and ply:GetCharacter() ) then
        local punch = ( speed * 0.01 ) * 2 -- math moment
        ply:ViewPunch(Angle(punch, 0, 0))

        if ( SERVER ) then
            if ( punch >= 7 ) then
                ply:EmitSound("npc/combine_soldier/zipline_hitground"..math.random(1,2)..".wav", 60)
            end

            ply:EmitSound("minerva/global/land0"..math.random(1, 4)..".mp3", 60, math.random(80, 120), 0.3)
            ply:EmitSound("minerva/global/defaultland.mp3", 60, math.random(80, 120), 0.4)
        end
    end
end

function Schema:PhysgunPickup(ply, ent)
    if not ( ent:GetClass() == "prop_physics" ) then
        return
    end

    ent:SetRenderMode(16)
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    ent:SetColor(ColorAlpha(ix.config.Get("color"), 200))
end

function Schema:PhysgunDrop(ply, ent)
    if not ( ent:GetClass() == "prop_physics" ) then
        return
    end

    timer.Simple(0, function()
        if ( IsValid(ent) ) then
            ent:SetRenderMode(RENDERMODE_NORMAL)
            ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
            ent:SetColor(color_white)
        end
    end)
end
