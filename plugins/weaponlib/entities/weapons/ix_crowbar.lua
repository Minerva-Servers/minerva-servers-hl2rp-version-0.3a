AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Crowbar"
SWEP.Category = "HL2 RP"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee"

SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.ViewModelOffset = Vector(-4.783, -2.955, -2.586)
SWEP.ViewModelOffsetAng = Angle(10.618, 7.771, -23.73)
SWEP.ViewModelFOV = 50

SWEP.Slot = 1
SWEP.SlotPos = 1

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("WeaponFrag.Roll")
SWEP.Primary.ImpactSound = Sound("Canister.ImpactHard")
SWEP.Primary.Recoil = 3.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 15 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.6
SWEP.Primary.HitDelay = 0.2
SWEP.Primary.Range = 70
SWEP.Primary.StunTime = 0.3
SWEP.Primary.HullSize = 7