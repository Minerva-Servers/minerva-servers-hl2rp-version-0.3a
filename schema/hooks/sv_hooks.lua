-- Here is where all serverside hooks should go.

function Schema:KeyPress(ply, key)
    if not ( ply:IsOnGround() and ply:Alive() ) then
        return
    end

    if ( ply:InVehicle() or ply:GetMoveType() == MOVETYPE_NOCLIP ) then
        return
    end

    if ( key == IN_DUCK ) then
        if not ( ply.ixDucks ) then
            ply.ixDucks = 0
        end

        if ( ply.ixDucks >= 2 ) then
            ply:Freeze(true)
            ply:Notify("Stop spamming crouch...")

            timer.Simple(2, function()
                if ( IsValid(ply) ) then
                    ply:Freeze(false)
                    ply.ixDucks = 0
                end
            end)

            return false
        end

        ply.ixDucks = ply.ixDucks + 1

        if ( timer.Exists("ixDucks"..ply:SteamID()) ) then
            timer.Remove("ixDucks"..ply:SteamID())
        end

        timer.Create("ixDucks"..ply:SteamID(), 2, 1, function()
            if ( IsValid(ply) ) then
                ply.ixDucks = 0
            end
        end)
    end
end

function Schema:PlayerConnect(name, ip)
    Schema:SendDiscordMessage(name, name.." is connecting to the Server!", Schema.discordLogWebhook, Color(0, 255, 0))
    Schema:SendDiscordMessage(name, name.." is connecting to the Server!", Schema.discordLogWebhookPublic, Color(0, 255, 0))
end

function Schema:PlayerDisconnected(ply)
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has disconnected from the Server!\nSteamID: "..ply:SteamID().."\nSteamID64: "..ply:SteamID64().."\nUsergroup: "..ply:GetUserGroup(), Schema.discordLogWebhook, Color(255, 0, 0))
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has disconnected from the Server!", Schema.discordLogWebhookPublic, Color(255, 0, 0))
end

function Schema:PlayerInteractItem(ply, action, item)
    if ( IsValid(ply) ) then
        Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." ran "..action.." on the item "..item.name, Schema.discordLogWebhook, team.GetColor(ply:Team()))
    end
end

function Schema:PostPlayerSay(ply, chatType, message, anonymous)
    if ( chatType == "ic" ) then
        ix.log.Add(ply, "chat", chatType and chatType:utf8upper() or "??", message)
    end
end

function Schema:simfphysUse(ent, ply)
    if ( ent:GetModel():find("combine_apc") ) then
        if ( ply:IsCombine() ) then
            ply:Notify("You bypassed the biolock on the Combine APC.")

            if ( ply:GetTeamClass() != CLASS_CP_TECHNICIAN ) then
                local driver = ent:GetDriver()
                if ( IsValid(driver) and driver == ply ) then
                    driver:ExitVehicle()
                end
            end
        else
            ent:EmitSound("buttons/combine_button_locked.wav", 80)

            return "no"
        end
    end
end

function Schema:PlayerUse(ply, ent)
    if ( ent:GetClass():find("gmod_sent_vehicle_fphysics_*") and ent:GetClass() != "gmod_sent_vehicle_fphysics_base" ) then
        return false
    end
end

function Schema:PostPlayerLoadout(ply)
    ply:SetViewOffset(Vector(0, 0, 66))
    ply:SetViewOffsetDucked(Vector(0, 0, 32))
end

function Schema:CanPlayerSpawnContainer(ply)
    return ply:IsAdmin()
end

local blacklistedDoorNames = {
    "door_airlock_comb_",
    "lift_doors",
    "shutters",
    "elevator",
    "door2floor",
    "citamainofficedoor",
}
function Schema:PlayerUseDoor(ply, door)
    if not ( door:GetClass() == "func_door" ) then
        return
    end

    for k, v in pairs(blacklistedDoorNames) do
        if ( string.find(door:GetName(), v) ) then
            return
        end
    end

    if ( ply:IsCombine() or ply:IsAdministrator() ) then
        if not ( door:HasSpawnFlags(256) and door:HasSpawnFlags(1024) ) then
            door:Fire("open")
            door:EmitSound("buttons/combine_button1.wav")
        end
    elseif ( ply:Team() == FACTION_CWU and ply:GetTeamClass() == CLASS_CWU_RESEARCHER ) then
        if not ( string.find(door:GetName(), "labdoor") ) then
            return
        end

        if not ( door:HasSpawnFlags(256) and door:HasSpawnFlags(1024) ) then
            door:Fire("open")
            door:EmitSound("buttons/combine_button1.wav")
        end
    end
end

function Schema:EntityTakeDamage(ent, dmg)
    if not ( IsValid(ent) ) then
        return
    end

    if ( ent:IsPlayer() and dmg:IsDamageType(DMG_CRUSH) ) then
        if not ( IsValid(ent.ixRagdoll) or ( dmg:GetAttacker() and dmg:GetAttacker():GetClass() == "gmod_sent_vehicle_fphysics_base" ) ) then
            return true
        end
    end
end

function Schema:PlayerHurt(ply, attacker, hpRemaining, amount)
    if ( hpRemaining <= 0 ) then
        return
    end

    local newAmount = math.Clamp(amount / 10, 0.1, 1.5)
    ply:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 10), newAmount, newAmount)

    if ( ply:IsCombine() and ( ply.ixTraumaCooldown or 0 ) < CurTime() ) then
        local sounds = {
            "npc/overwatch/radiovoice/on1.wav",
            "npc/overwatch/radiovoice/attention.wav",
            "npc/overwatch/radiovoice/reportplease.wav",
            "npc/overwatch/radiovoice/off4.wav",
        }

        ix.util.EmitQueuedSounds(ply, sounds, 0.5, 0.2, 50)
        timer.Simple(1.5, function()
            if not ( ply:Alive() ) then
                return
            end

            ix.chat.Send(ply, "dispatchradiopersonnal", "Attention, report please.", false)
        end)

        ply.ixTraumaCooldown = CurTime() + 60
    end
end

function Schema:DoPlayerDeath(ply, attacker, dmgInfo)
    if ( ply:IsCombine() and not ply:GetCharacter():GetDefunct() ) then
        local deathPosition = ply:GetPos()
        local combineName = ply:Nick()
        local location = ply:GetArea()
        if ( location == "" or location == nil ) then
            location = "unknown location"
        end

        local sounds = {
            "npc/overwatch/radiovoice/on3.wav",
            "npc/overwatch/radiovoice/attention.wav",
            "npc/overwatch/radiovoice/lostbiosignalforunit.wav",
            "npc/overwatch/radiovoice/off4.wav",
            "hl1/fvox/_comma.wav",
            "npc/overwatch/radiovoice/on1.wav",
            "npc/overwatch/radiovoice/unitdownat.wav",
            "npc/overwatch/radiovoice/404zone.wav",
            "npc/overwatch/radiovoice/reinforcementteamscode3.wav",
            "npc/overwatch/radiovoice/investigateandreport.wav",
            "npc/overwatch/radiovoice/off2.wav",
        }

        for k, v in pairs(player.GetAll()) do
            if not ( v:IsCombine() ) then
                continue
            end

            ix.util.EmitQueuedSounds(v, sounds, 3, 0.2, 40)
        end

        timer.Simple(4, function()
            ix.chat.Send(ply, "dispatchradio", "Attention, lost biosignal for protection team unit "..combineName..".", false)
            timer.Simple(4, function()
                ix.chat.Send(ply, "dispatchradio", "Unit down at, "..location.." reinforcement teams code 3. Investigate and report.", false)
                Schema:AddWaypoint(deathPosition, "LOST BIO-SIGNAL FOR "..string.upper(combineName).." AT "..string.upper(location).."!", Color(250, 50, 50), 180, ply)
            end)
        end)
    end

    local attackerName = attacker:GetName() ~= "" and attacker:GetName() or attacker:GetClass()
    local attackerWeapon = IsValid(weapon) and " with "..weapon:GetClass() or ""
    Schema:SendDiscordMessage(ply:SteamName(), attackerName.." has killed "..ply:Nick().." "..attackerWeapon.."!", Schema.discordLogWebhook, Color(255, 0, 0))
end

function Schema:GetPlayerPainSound(ply)
    if ( ply:IsOW() ) then
        return "npc/combine_soldier/pain"..math.random(1, 3)..".wav"
    elseif ( ply:IsCP() ) then
        return "npc/metropolice/pain"..math.random(1, 4)..".wav"
    elseif ( ply:IsVortigaunt() ) then
        return table.Random({
            "vo/npc/vortigaunt/vortigese02.wav",
            "vo/npc/vortigaunt/vortigese03.wav",
            "vo/npc/vortigaunt/vortigese04.wav",
            "vo/npc/vortigaunt/vortigese05.wav",
            "vo/npc/vortigaunt/vortigese07.wav",
            "vo/npc/vortigaunt/vortigese08.wav",
            "vo/npc/vortigaunt/vortigese09.wav",
        })
    elseif ( ply.IsNecrotic and ply:IsNecrotic() ) then
        return "npc/zombie/zombie_pain"..math.random(1, 6)..".wav"
    elseif ( ply.IsHunter and ply:IsHunter() ) then
        return table.Random({
            "npc/ministrider/hunter_pain2.wav",
            "npc/ministrider/hunter_pain4.wav",
        })
    elseif ( ply.IsAntlion and ply:IsAntlion() ) then
        return "npc/antlion/pain"..math.random(1, 2)..".wav"
    end
end

function Schema:GetPlayerDeathSound(ply)
    if ( ply:IsOW() ) then
        return "npc/combine_soldier/die"..math.random(1, 3)..".wav"
    elseif ( ply:IsCP() ) then
        return "npc/metropolice/die"..math.random(1, 4)..".wav"
    elseif ( ply:IsVortigaunt() ) then
        return table.Random({
            "vo/npc/vortigaunt/vortigese02.wav",
            "vo/npc/vortigaunt/vortigese03.wav",
            "vo/npc/vortigaunt/vortigese04.wav",
            "vo/npc/vortigaunt/vortigese05.wav",
            "vo/npc/vortigaunt/vortigese07.wav",
            "vo/npc/vortigaunt/vortigese08.wav",
            "vo/npc/vortigaunt/vortigese09.wav",
        })
    elseif ( ply.IsNecrotic and ply:IsNecrotic() ) then
        return "npc/zombie/zombie_die"..math.random(1, 3)..".wav"
    elseif ( ply.IsHunter and ply:IsHunter() ) then
        return "npc/ministrider/hunter_die"..math.random(2, 3)..".wav"
    elseif ( ply.IsAntlion and ply:IsAntlion() ) then
        return "npc/antlion/pain"..math.random(1, 2)..".wav"
    end
end

function Schema:PlayerSpawnProp(ply)
    local char = ply:GetCharacter()
    local amount = char:GetMoney()

    if not ( ply:IsDonator() or ply:IsCombine() or ply:Team() == FACTION_CWU ) then
        if char:HasMoney(5) then
            char:SetMoney(char:GetMoney() - 5)
            ply:Notify("You spent 5 tokens to spawn this prop.")
            return true
        else
            ply:Notify("You need 5 tokens to spawn a prop!")
            return false
        end
    end
end

function Schema:PlayerSpray()
    return true
end

function Schema:OnDamagedByExplosion()
    return true
end

function Schema:PlayerSpawnRagdoll(ply)
    return ply:IsSuperAdmin() or ply:IsGamemaster()
end

function Schema:PlayerSpawnEffect(ply)
    return ply:IsSuperAdmin() or ply:IsGamemaster()
end

function Schema:PlayerSpawnSENT(ply)
    return ply:IsSuperAdmin() or ply:IsGamemaster()
end

function Schema:PlayerSpawnSWEP(ply)
    return ply:IsSuperAdmin() or ply:IsGamemaster()
end

function Schema:PlayerSpawnVehicle(ply)
    return ply:IsSuperAdmin() or ply:IsGamemaster()
end

local rebelOutfits = {
    ["face_blue_bandana"] = true,
    ["face_gray_bandana"] = true,
    ["face_red_bandana"] = true,
    ["torso_blue_rebel"] = true,
    ["torso_gray_rebel"] = true,
    ["torso_green_rebel"] = true,
}
function Schema:CanPlayerEquipItem(ply, item)
    for k, v in pairs(player.GetAll()) do
        if ( v:GetPos():Distance(ply:GetPos()) <= 256 and v:IsCP() and v != ply ) then
            if ( rebelOutfits[item.uniqueID] ) then
                ply:Notify("You are unable to equip a rebel item near a Civil Protection Unit!")
                return false
            end
        end
    end
end

local damageScaleValues = {
    [HITGROUP_HEAD] = 1.5,
    [HITGROUP_CHEST] = 1.1,
    [HITGROUP_STOMACH] = 1,

    // some reason, there is autoscalling already available, so buff this damage i guess?
    [HITGROUP_LEFTARM] = 1,
    [HITGROUP_RIGHTARM] = 1,

    [HITGROUP_LEFTLEG] = 1,
    [HITGROUP_RIGHTLEG] = 1,

    [HITGROUP_GEAR] = 0,
}

local function EquippedItem(ply, item)
    local char = ply:GetCharacter()
    if ( !char ) then
        return false
    end

    return char:GetInventory():HasItem(item, {["equip"] = true})
end

function Schema:ScalePlayerDamage(ply, hitgroup, dmginfo)
    local char = ply:GetCharacter()
    local attacker = dmginfo:GetAttacker()

    dmginfo:ScaleDamage(damageScaleValues[hitgroup] or 1)

    local scaled = false

    if ( EquippedItem(ply, "vest_ota") ) then
        dmginfo:ScaleDamage(0.6)
        scaled = true
    end

    if ( EquippedItem(ply, "vest_molle") ) then
        dmginfo:ScaleDamage(0.75)
        scaled = true
    end

    if ( ( EquippedItem(ply, "torso_blue_rebel") or EquippedItem(ply, "torso_gray_rebel") or EquippedItem(ply, "torso_green_rebel") ) and !scaled ) then
        dmginfo:ScaleDamage(0.8)
    elseif ( ply:IsCP() ) then
        dmginfo:ScaleDamage(0.7)
    elseif ( ply:IsOW() ) then
        dmginfo:ScaleDamage(0.6)
    elseif ( ply.IsHunter and ply:IsHunter() ) or ( ply.IsAntlion and ply:IsAntlion() ) or ( ply.IsNecrotic and ply:IsNecrotic() ) then
        dmginfo:ScaleDamage(0.6)
    end

    if ( ply:IsCP() and ply:GetTeamClass() == CLASS_CP_RECONNAISSANCE ) then
        dmginfo:ScaleDamage(0.9)
    end
end

function Schema:CanPlayerDropItem(ply, item)
    if not ( item ) then
        return
    end

    local instanceItem = ix.item.instances[item]

    if ( instanceItem and instanceItem:GetData("Restricted") ) then
        ply:Notify("You are not allowed to drop this Item!")
        return false
    end
end

function Schema:CanTransferItem(item, currentInv, oldInv)
    if not ( item ) then
        return
    end

    if ( item and item:GetData("Restricted") ) then
        return false
    end
end

local restrictedTools = {
    ["vjstool_npcspawner"] = function(ply, tool)
        return false--ply:IsGamemaster()
    end,
}
function Schema:CanTool(ply, trace, toolName, tool, button)
    if ( restrictedTools[toolName] ) then
        return restrictedTools[toolName](ply, toolName)
    end

    ix.log.AddRaw(ply:Nick().." used the tool "..toolName.."!")

    ply.ixLastTool = toolName
    if ( ply.ixLastTool != toolName ) then
        Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." used the tool "..toolName.."!", Schema.discordLogWebhook)
    end
end

function Schema:GetGameDescription()
    return "Minerva Servers"
end

function Schema:OnEntityCreated(ent)
    if ( ent:GetClass() == "ix_item" ) then
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        ent:SetCustomCollisionCheck(true)
    end

    if ( ent:GetClass() == "prop_ragdoll" ) then
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        ent:SetCustomCollisionCheck(true)
    end
end

function Schema:ShouldCollide(ent1, ent2)
    if ( ent1:GetClass() == "ix_item" and ent2:GetClass() == "ix_item" ) then
        return false
    end

    if ( ent1:GetClass() == "prop_ragdoll" and ent2:GetClass() == "prop_ragdoll" ) then
        return false
    end
end