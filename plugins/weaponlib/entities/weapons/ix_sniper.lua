AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Pulse-Sniper"
SWEP.Category = "HL2 RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/schwarzkruppzo/w_ospr.mdl")
SWEP.ViewModel = Model("models/weapons/schwarzkruppzo/c_ospr.mdl")
SWEP.ViewModelOffset = Vector(-1, -2, -0.5)
SWEP.ViewModelOffsetAng = Angle(2, 0.5, -7.5)
SWEP.ViewModelFOV = 50

SWEP.LowerAngles = Angle(10, -3, -7)
SWEP.LowerAngles2 = SWEP.LowerAngles

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_AR2.Reload")
SWEP.EmptySound = Sound("Weapon_AR2.Empty")

SWEP.Primary.Sound = Sound("weapons/ospr/fire1.ogg")
SWEP.Primary.Recoil = 10 -- base recoil value, SWEP.Spread mods can change thisS
SWEP.Primary.Damage = 73
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = RPM(50)
SWEP.Primary.Tracer = "AR2Tracer"

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0
SWEP.Spread.IronsightsMod = 0 -- multiply
SWEP.Spread.CrouchMod = 0 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.03 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 100 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(0, 0, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.2
SWEP.IronsightsSensitivity = 0.2
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 2
SWEP.IronsightsMuzzleFlash = "AirboatMuzzleFlash"

SWEP.LoweredPos = Vector(5, -10, -15)
SWEP.LoweredAng = Angle(40, 60, 0)

SWEP.ScopePaint = function(wep)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(ix.util.GetMaterial("ospr/scope_bg"))
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    surface.SetMaterial(ix.util.GetMaterial("ospr/scope_bg_overlay"))
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    surface.SetMaterial(ix.util.GetMaterial("vgui/hud/xbox_reticle"))
    surface.DrawTexturedRect(ScrW() / 2 - 100, ScrH() / 2 - 100, 200, 200)
    surface.SetMaterial(ix.util.GetMaterial("vgui/cursors/crosshair"))
    surface.DrawTexturedRect(ScrW() / 2 - 25, ScrH() / 2 - 25, 50, 50)
end

SWEP.ScopeBehaviour = "sniper_sight"

function SWEP:PrimaryAttack()
    self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self:CalculateSpread())

    self:AddRecoil()
    self:ViewPunch()

    self:EmitSound(self.Primary.Sound)

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    
    self.Owner:EmitSound("npc/sniper/sniper1.wav", 90)
end