local PLUGIN = PLUGIN

local hunterNoises = {
    // play this more frequent
    "npc/ministrider/hunter_idle1.wav",
    "npc/ministrider/hunter_idle1.wav",
    "npc/ministrider/hunter_idle1.wav",
    "npc/ministrider/hunter_idle2.wav",
    "npc/ministrider/hunter_idle2.wav",
    "npc/ministrider/hunter_idle2.wav",
    "npc/ministrider/hunter_idle3.wav",
    "npc/ministrider/hunter_idle3.wav",
    "npc/ministrider/hunter_idle3.wav",

    // special noises
    "npc/ministrider/hunter_alert1.wav",
    "npc/ministrider/hunter_alert2.wav",
    "npc/ministrider/hunter_alert3.wav",
    "npc/ministrider/hunter_scan1.wav",
    "npc/ministrider/hunter_scan2.wav",
    "npc/ministrider/hunter_scan3.wav",
    "npc/ministrider/hunter_scan4.wav",
}
function PLUGIN:PlayerTick(ply)
    if not ( ply:IsHunter() ) then
        return
    end

    if not ( ( ply.nextHunterNoise or 0 ) > CurTime() ) then
        ply:EmitSound(table.Random(hunterNoises), 80, math.random(90, 110), 0.1)

        ply.nextHunterNoise = CurTime() + math.random(3, 15)
    end
end

function PLUGIN:PlayerUse(ply)
    if ( ply:IsHunter() ) then
        return false
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, speaker)
    if ( listener:IsHunter() ) then
        return false
    end
end

function PLUGIN:CanPlayerEquipItem(ply, item)
    if ( ply:IsHunter() ) then
        ply:Notify("You cannot equip this item as a Hunter!")
        
        return false
    end
end

function PLUGIN:CanPlayerTakeItem(ply, item)
    if ( ply:IsHunter() ) then
        ply:Notify("You cannot take this item as a Hunter!")
        
        return false
    end
end

function PLUGIN:GetFallDamage(ply)
    if ( ply:IsHunter() ) then
        return false
    end
end