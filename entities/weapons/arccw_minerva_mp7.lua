sound.Add( {
    name = "Project_MMOD_SMG1.Fire",
    channel = CHAN_STATIC,
    volume = 1,
    level = 125,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_smg1/fire1.wav", "weapons/projectmmod_smg1/fire2.wav", "weapons/projectmmod_smg1/fire3.wav" }
} )
sound.Add( {
    name = "Project_MMOD_SMG1.ClipOut",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_smg1/clipout.wav" }
} )
sound.Add( {
    name = "Project_MMOD_SMG1.ClipIn",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_smg1/clipin.wav" }
} )
sound.Add( {
    name = "Project_MMOD_SMG1.GripFold",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_smg1/gripfold.wav"  }
} )
sound.Add( {
    name = "Project_MMOD_SMG1.GripUnFold",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_smg1/gripunfold.wav"  }
} )
sound.Add( {
    name = "Project_MMOD_SMG1.GLaunch",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    pitch = { 90, 110 },
    sound =  { "weapons/ar2/ar2_altfire.wav"  }
} )
sound.Add( {
    name = "Project_MMOD_SMG1.BRelease",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_smg1/griprelease.wav"  }
} )

SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Urban Coalition"
SWEP.UC_CategoryPack = "1Minerva Servers"
SWEP.AdminOnly = false
SWEP.UseHands = true

-- Muzzle and shell effects --

SWEP.MuzzleEffect = "muzzleflash_mp5"
SWEP.ShellEffect = "arccw_uc_shelleffect"
SWEP.ShellModel = "models/weapons/arccw/uc_shells/9x19.mdl"
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

SWEP.PrintName = "H&K MP7"

-- Weapon slot --

SWEP.Slot = 1

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/c_iiopnsmg1.mdl"
SWEP.WorldModel = "models/weapons/w_iiopnsmg1.mdl"
SWEP.ViewModelFOV = 60
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

-- Damage --

SWEP.Damage = 9 -- 4 shot close range kill (3 on chest)
SWEP.DamageMin = 3 -- 6 shot long range kill
SWEP.RangeMin = 20
SWEP.Range = 100 -- 4 shot until ~50m

SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 400
SWEP.PhysBulletMuzzleVelocity = 400

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 45

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

SWEP.Delay = 60 / 800
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

SWEP.NPCWeaponType = "weapon_smg1"
SWEP.NPCWeight = 60

-- Accuracy --

SWEP.AccuracyMOA = 3
SWEP.HipDispersion = 500
SWEP.MoveDispersion = 150
SWEP.JumpDispersion = 1000

SWEP.Primary.Ammo = "smg1"
SWEP.MagID = "mp5"

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

SWEP.BarrelLength = 24
SWEP.ExtraSightDist = 2

-- Ironsights / Customization / Poses --

SWEP.HolsterPos = Vector(-1, 2, 2)
SWEP.HolsterAng = Angle(-5, 5, -10)

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldType = "ar2"

SWEP.IronSightStruct = {
     Pos = Vector(-4.45, -2, 1.65),
     Ang = Vector(0, 0, -2),
     Magnification = 1,
     ViewModelFOV = 50,
     SwitchToSound = ratel, -- sound that plays when switching to this sight
     SwitchFromSound = ratel
}

SWEP.ActivePos = Vector(-1, -2, 2)
SWEP.ActiveAng = Angle(0, 0, 0)

-- SWEP.SprintPos = Vector(-0.5, 3, 1.5)
-- SWEP.SprintAng = Angle(-12, 15, -15)

SWEP.SprintPos = Vector(0, 0, 0)
SWEP.SprintAng = Angle(0, 15, -10)
-- SWEP.CustomizePos = Vector(6, -2, -1.5)
-- SWEP.CustomizeAng = Angle(16, 28, 0)
SWEP.CustomizePos = Vector(10, 0, 2)
SWEP.CustomizeAng = Angle(10, 30, 20)

SWEP.CrouchPos = Vector(-3, -4, 2)
SWEP.CrouchAng = Angle(0, 0, -14)

SWEP.BarrelOffsetHip = Vector(0, 0, -4)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-14, 6, -6),
    ang        =    Angle(-6, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

-- Firing sounds --

SWEP.ShootSound = {
    "weapons/projectmmod_smg1/fire1.wav",
    "weapons/projectmmod_smg1/fire2.wav",
    "weapons/projectmmod_smg1/fire3.wav",
}

-- Animations --

SWEP.Hook_Think = ArcCW.UC.ADSReload

SWEP.Animations = {
    ["idle"] = {
        Source = "idle01",
    },
    ["idle_empty"] = {
        Source = "idle01",
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
        Source = {"shoot1", "shoot2", "shoot3"},
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_iron"] = {
        Source = {"shoot1_is", "shoot2_is", "shoot3_is"},
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_empty"] = {
        Source = "shoot_last",
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_iron_empty"] = {
        Source = "shoot_last",
        Time = 16 / 30,
        ShellEjectAt = 0.03,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Time = 56 / 30,
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
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Time = 65 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.3,
    },
}

SWEP.AutosolveSourceSeq = "idle"