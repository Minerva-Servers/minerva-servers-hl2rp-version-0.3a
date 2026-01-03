sound.Add( {
    name = "Project_MMOD_USP.Fire",
    channel = CHAN_STATIC,
    volume = 1,
    level = 125,
    pitch = { 90, 110 },
    sound =  { "^weapons/projectmmod_pistol/pistolfire.wav", "^weapons/projectmmod_pistol/pistolfire2.wav", "^weapons/projectmmod_pistol/pistolfire3.wav" }
} )

sound.Add( {
    name = "Project_MMOD.Pistol.Deploy",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_pistol/pistoldeploy.wav" }
} )

sound.Add( {
    name = "Project_MMOD_USP.ClipOut",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_pistol/pistolclipout.wav" }
} )

sound.Add( {
    name = "Project_MMOD_USP.Clipin",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_pistol/pistolclipin.wav" }
} )

sound.Add( {
    name = "Project_MMOD_USP.SlideBack",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_pistol/pistolslideback.wav" }
} )

sound.Add( {
    name = "Project_MMOD_USP.SlideForward",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = SNDLVL_NORM,
    pitch = { 90, 110 },
    sound =  { "weapons/projectmmod_pistol/pistolslideforward.wav" }
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
SWEP.ShellModel = "models/weapons/arccw/uc_shells/9x19.mdl"
SWEP.ShellScale = 1
--SWEP.ShellMaterial = "models/weapons/arcticcw/shell_9mm"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.PistolShellSoundsTable

SWEP.MuzzleEffectAttachment = 1
SWEP.CaseEffectAttachment = 2
SWEP.CamAttachment = 3
SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 255, 25)
SWEP.TracerWidth = 2

SWEP.PrintName = "H&K USP Match"

-- Weapon slot --

SWEP.Slot = 1

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/c_iiopnpistol.mdl"
SWEP.WorldModel = "models/weapons/w_iiopnpistol.mdl"
SWEP.ViewModelFOV = 60
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

-- Damage --

SWEP.Damage = 8 -- 4 shot close range kill (3 on chest)
SWEP.DamageMin = 4 -- 5 shot long range kill
SWEP.Penetration = ArcCW.UC.StdDmg["9mm"].pen

SWEP.RangeMin = 15
SWEP.Range = 50 -- 4 shot until ~35m
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 375
SWEP.PhysBulletMuzzleVelocity = 375

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 17
SWEP.ExtendedClipSize = 33
SWEP.ReducedClipSize = 10

-- Recoil --

SWEP.Recoil = 1.0
SWEP.RecoilSide = 0.5

SWEP.RecoilRise = 0.24
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 0.5
SWEP.MaxRecoilPunch = 0.6

SWEP.Sway = 1

-- Firerate / Firemodes --

SWEP.Delay = 60 / 525
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        PrintName = "fcg.safe2",
        Mode = 0,
    }
}

SWEP.ShootPitch = 100
SWEP.ShootVol = 120

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.ReloadInSights = true

-- NPC --

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 60

-- Accuracy --

SWEP.AccuracyMOA = 7
SWEP.HipDispersion = 500
SWEP.MoveDispersion = 250
SWEP.JumpDispersion = 1000

SWEP.Primary.Ammo = "pistol"
SWEP.MagID = "glock"

SWEP.HeatCapacity = 50
SWEP.HeatDissipation = 20
SWEP.HeatDelayTime = 3

SWEP.MalfunctionMean = 150
SWEP.MalfunctionTakeRound = false

-- Speed multipliers --

SWEP.SpeedMult = 0.975
SWEP.SightedSpeedMult = 0.9
SWEP.SightTime = 0.25
SWEP.ShootSpeedMult = 1

-- Length --

SWEP.BarrelLength = 8
SWEP.ExtraSightDist = 10

-- Ironsights / Customization / Poses --

SWEP.HolsterPos = Vector(-0.5, -2, -1)
SWEP.HolsterAng = Angle(3.5, 7, -20)

SWEP.HolsterPos = Vector(-1, -2, 3)
SWEP.HolsterAng = Angle(-15.5, 2, -7)

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"
SWEP.HoldType = "revolver"

SWEP.IronSightStruct = {
     Pos = Vector(-4.25, -2, 1.6),
     Ang = Vector(0, 0.0875, 0),
     Magnification = 1,
     ViewModelFOV = 55,
}

SWEP.ActivePos = Vector(0, 3, 1)
SWEP.ActiveAng = Angle(0, 0, -5)

SWEP.CustomizePos = Vector(7, -2, -2)
SWEP.CustomizeAng = Angle(15, 25, 0)

SWEP.CrouchPos = Vector(-2, -6, 1)
SWEP.CrouchAng = Angle(0, 0, -20)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-15.5, 6, -4),
    ang        =    Angle(-6, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

-- Firing sounds --

SWEP.ShootSound = {
    "weapons/projectmmod_pistol/pistolfire.wav",
    "weapons/projectmmod_pistol/pistolfire2.wav",
    "weapons/projectmmod_pistol/pistolfire3.wav",
}

-- Animations --

SWEP.Hook_Think = ArcCW.UC.ADSReload

SWEP.Animations = {
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
        Time = 60 / 30,
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

SWEP.AutosolveSourceSeq = "idle"