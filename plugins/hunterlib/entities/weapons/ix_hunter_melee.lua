AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Hunter Claws"
SWEP.Category = "HL2 RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "normal"

SWEP.WorldModel = ""
SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.ViewModelFOV = 50

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = "NPC_Hunter.MeleeAnnounce"
SWEP.Primary.ImpactSound = "NPC_Hunter.MeleeHit"
SWEP.Primary.Recoil = 30
SWEP.Primary.Damage = 120
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.5
SWEP.Primary.Delay = 2
SWEP.Primary.Range = 128
SWEP.Primary.StunTime = 3

function SWEP:PostPrimaryAttack(ply)
    if not ( SERVER ) then
        return
    end
    
    ply:ForceSequence("meleeleft", nil, ply:SequenceDuration(ply:LookupSequence("meleeleft")), false)
end