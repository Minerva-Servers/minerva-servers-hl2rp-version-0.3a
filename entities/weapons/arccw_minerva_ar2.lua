sound.Add( {
    name = "Project_MMOD_AR2.Fire",
    channel = CHAN_weapon,
    volume = 0.8,
    level = SNDLVL_GUNFIRE,
    pitch = { 85, 95 },
    sound =  { "weapons/projectmmod_ar2/fire1.wav", "weapons/projectmmod_ar2/fire2.wav", "weapons/projectmmod_ar2/fire3.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.MagOut",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_magout.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.MagIn",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_magin.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Reload_Push",
    channel = CHAN_ITEM,
    volume = 0.9,
    level = 100,
    pitch = { 90, 110 },
    sound =  { "weapons/ar2/ar2_reload_push.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Reload_Rotate",
    channel = CHAN_ITEM,
    volume = 0.9,
    level = 100,
    pitch = { 90, 110 },
    sound =  { "weapons/ar2/ar2_reload_rotate.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Draw",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_deploy.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.FidgetPush",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 100, 100 },
    sound =  { "weapons/projectmmod_ar2/ar2_push.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.BoltPull",
    channel = CHAN_AUTO,
    volume = 0.9,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_boltpull.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.Charge",
    channel = CHAN_WEAPON,
    volume = 0.7,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_charge.wav" }
} )
sound.Add( {
    name = "Project_MMOD_AR2.SecondaryFire",
    channel = CHAN_WEAPON,
    volume = 0.7,
    level = SNDLVL_GUNFIRE,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_ar2/ar2_secondary_fire.wav" }
} )

SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Urban Coalition"
SWEP.UC_CategoryPack = "1Minerva Servers"
SWEP.AdminOnly = false
SWEP.UseHands = true

-- Muzzle and shell effects --

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellEffect = "arccw_uc_shelleffect"
SWEP.ShellModel = "models/weapons/shells/projectmmodirifleshell.mdl"
SWEP.ShellScale = 1
--SWEP.ShellMaterial = "models/weapons/arcticcw/shell_9mm"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.PistolShellSoundsTable

SWEP.MuzzleEffectAttachment = 1
SWEP.CaseEffectAttachment = 2
-- SWEP.CamAttachment = 3 ---------------------------------------------------------------------------
-- SWEP.TracerNum = 1
-- SWEP.TracerCol = Color(25, 255, 25)
-- SWEP.TracerWidth = 2

SWEP.PrintName = "Pulse-Rifle"

-- Weapon slot --

SWEP.Slot = 1

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/c_iiopnirifle.mdl"
SWEP.WorldModel = "models/weapons/w_iiopnirifle.mdl"
SWEP.ViewModelFOV = 60
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

-- Damage --

SWEP.Damage = 14 -- 4 shot close range kill (3 on chest)

SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 1100
SWEP.PhysBulletMuzzleVelocity = 1100

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 30

-- Recoil --

SWEP.Recoil = 0.5
SWEP.RecoilSide = 0.17

SWEP.RecoilRise = 0.6
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1.25
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 0.6
SWEP.RecoilPunchBack = 1.5

SWEP.Sway = 0.5

-- Firerate / Firemodes --

SWEP.Delay = 60 / 600
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3,
        Mult_MoveDispersion = 0.75,
        Mult_HipDispersion = 0.9,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0,
    },
}

SWEP.ShootPitch = 100
SWEP.ShootVol = 120

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.ReloadInSights = true

-- NPC --

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 200

-- Accuracy --

SWEP.AccuracyMOA = 3
SWEP.HipDispersion = 500
SWEP.MoveDispersion = 150
SWEP.JumpDispersion = 1000

SWEP.Primary.Ammo = "ar2"
SWEP.MagID = "ar2"

SWEP.HeatCapacity = 75
SWEP.HeatDissipation = 15
SWEP.HeatDelayTime = 3

SWEP.MalfunctionMean = 200

-- Speed multipliers --

SWEP.SpeedMult = 0.925
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.3
SWEP.ShootSpeedMult = 0.95

-- Length --

SWEP.BarrelLength = 27

-- Ironsights / Customization / Poses --

SWEP.HolsterPos = Vector(-1, -2, 3)
SWEP.HolsterAng = Angle(-15.5, 2, -7)

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldType = "ar2"

SWEP.IronSightStruct = {
     Pos = Vector(-4.5, -2, 0.8),
     Ang = Vector(0, 0, 0),
     Magnification = 1,
     ViewModelFOV = 50,
     SwitchToSound = ratel, -- sound that plays when switching to this sight
     SwitchFromSound = ratel
}

SWEP.ActivePos = Vector(-2, 2, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

-- SWEP.SprintPos = Vector(-0.5, 3, 1.5)
-- SWEP.SprintAng = Angle(-12, 15, -15)

SWEP.SprintPos = Vector(0, 0, 0)
SWEP.SprintAng = Angle(0, 20, -10)
-- SWEP.CustomizePos = Vector(6, -2, -1.5)
-- SWEP.CustomizeAng = Angle(16, 28, 0)
SWEP.CustomizePos = Vector(10, 0, 2)
SWEP.CustomizeAng = Angle(10, 30, 20)

SWEP.CrouchPos = Vector(-3, -4, 2)
SWEP.CrouchAng = Angle(0, 0, -14)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-9, 6, -7),
    ang        =    Angle(-6, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

-- Firing sounds --

SWEP.ShootSound = {
    "weapons/projectmmod_ar2/fire1.wav",
    "weapons/projectmmod_ar2/fire2.wav",
    "weapons/projectmmod_ar2/fire3.wav",
}

-- Animations --

SWEP.Hook_Think = ArcCW.UC.ADSReload

SWEP.Animations = {
    ["walk"] = {
        Source = "walk",
    },
    ["idle"] = {
        Source = "idle",
    },
    ["idle_empty"] = {
        Source = "idle_empty",
    },
    ["draw"] = {
        Source = "draw",
    },
    ["draw_empty"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "holster",
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0,
        LHIKOut = 0,
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 12 / 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0,
        LHIKOut = 0,
    },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3", "fire4"},
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_iron"] = {
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_empty"] = {
        Source = "fire_last",
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_iron_empty"] = {
        Source = "fire_last_is",
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 50 / 30,
        MinProgress = 1.1,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.3,
    },
    ["reload_empty"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 70 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.3,
    },
}