SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Urban Coalition"
SWEP.UC_CategoryPack = "1Minerva Servers"
SWEP.AdminOnly = false
SWEP.UseHands = true

-- Effects --

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

-- True name --

SWEP.PrintName = "H&K MP5A4"

-- Weapon slot --

SWEP.Slot = 2

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/arccw/c_ur_mp5.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_ur_mp5.mdl"
SWEP.ViewModelFOV = 60
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ProceduralIronFire = true

-- Damage --

SWEP.Damage = 10 -- 4 shot close range kill (3 on chest)
SWEP.DamageMin = 8 -- 6 shot long range kill
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
SWEP.Primary.ClipSize = 30
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 15

-- Recoil --

SWEP.Recoil = 0.22
SWEP.RecoilSide = 0.17

SWEP.RecoilRise = 0.6
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1.25
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 0.6
SWEP.RecoilPunchBack = 1.5

SWEP.Sway = 0.25

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

SWEP.Primary.Ammo = "pistol"
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

SWEP.HolsterPos = Vector(0.5, -2, 1)
SWEP.HolsterAng = Angle(-8.5, 8, -10)

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldType = "ar2"

SWEP.IronSightStruct = {
     Pos = Vector(-3.17, -1, 0.6),
     Ang = Angle(0.45, 0, 0),
     Magnification = 1,
     SwitchToSound = "",
     ViewModelFOV = 60,
}

SWEP.ActivePos = Vector(-0.3, 1.1, 0.6)
SWEP.ActiveAng = Angle(0, 0, -1)

-- SWEP.SprintPos = Vector(-0.5, 3, 1.5)
-- SWEP.SprintAng = Angle(-12, 15, -15)

SWEP.SprintPos = Vector(0, -3, 0)
SWEP.SprintAng = Angle(0, 0, 0)
-- SWEP.CustomizePos = Vector(6, -2, -1.5)
-- SWEP.CustomizeAng = Angle(16, 28, 0)
SWEP.CustomizePos = Vector(0, 0, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-2, 0.5, 0)
SWEP.CrouchAng = Angle(0, 0, -14)

SWEP.BarrelOffsetHip = Vector(4, 0, -4)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-8, 4, -5),
    ang        =    Angle(-12, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale = 1
}

-- Firing sounds --
local path = ")^weapons/arccw_ur/mp5/"
local common = ")^/arccw_uc/common/"

SWEP.ShootSound = {
    path .. "fire-01.ogg",
    path .. "fire-02.ogg",
    path .. "fire-03.ogg"
}
SWEP.ShootSoundSilenced = {
    path .. "fire-sup-01.ogg",
    path .. "fire-sup-02.ogg",
    path .. "fire-sup-03.ogg",
    path .. "fire-sup-04.ogg",
    path .. "fire-sup-05.ogg",
    path .. "fire-sup-06.ogg"
}
SWEP.DistantShootSound = nil
SWEP.DistantShootSoundSilenced = nil
SWEP.ShootDrySound = path .. "dryfire.ogg"

SWEP.DistantShootSoundOutdoors = {
    path .. "fire-dist-01.ogg",
    path .. "fire-dist-02.ogg",
    path .. "fire-dist-03.ogg",
    path .. "fire-dist-04.ogg",
    path .. "fire-dist-05.ogg",
    path .. "fire-dist-06.ogg"
}
SWEP.DistantShootSoundIndoors = {
    common .. "fire-dist-int-pistol-01.ogg",
    common .. "fire-dist-int-pistol-02.ogg",
    common .. "fire-dist-int-pistol-03.ogg",
    common .. "fire-dist-int-pistol-04.ogg",
    common .. "fire-dist-int-pistol-05.ogg",
    common .. "fire-dist-int-pistol-06.ogg"
}
SWEP.DistantShootSoundOutdoorsSilenced = {
    common .. "sup_tail.ogg"
}
SWEP.DistantShootSoundIndoorsSilenced = {
    common .. "sup_tail.ogg"
}
SWEP.DistantShootSoundOutdoorsVolume = 1
SWEP.DistantShootSoundIndoorsVolume = 0.6
SWEP.Hook_AddShootSound = ArcCW.UC.InnyOuty

-- Bodygroups --

SWEP.BulletBones = {
    -- [1] = "uzi_b1", [2] = "uzi_b2", [3] = "uzi_b3", [4] = "uzi_b4"
}

--[[

1 --- 	id: 0
     [	name: iron
    num: 1
    submodels:
    0 --- ironSIGHT.smd
2 --- 	id: 1
     [	name: 1
    num: 4
    submodels:
    0 --- mp5UPPER.smd
    1 --- mp5sdUPPER.smd
    2 --- mp5kUPPER.smd
    3 --- swordUPPER.smd
3 --- 	id: 2
     [	name: 2
    num: 2
    submodels:
    0 --- fourLOWER.smd
    1 --- sefLOWER.smd
4 --- 	id: 3
     [	name: 3
    num: 11
    submodels:
    0 --- fixedSTOCK.smd
    1 --- collapseSTOCK.smd
    2 --- collapseSTOCKcoll.smd
    3 --- pdwSTOCK.smd
    4 --- pdwSTOCKfold.smd
    5 --- tacticSTOCK.smd
    6 --- tacticSTOCKfold.smd
    7 --- futureSTOCK.smd
    8 --- futureSTOCKcoll.smd
    9 --- futureSTOCKfold.smd
    10 --- buttSTOCK.smd
5 --- 	id: 4
     [	name: 4
    num: 10
    submodels:
    0 --- standardHG.smd
    1 --- flashHG.smd
    2 --- flashmlokHG.smd
    3 --- slimHG.smd
    4 --- picaHG.smd
    5 --- mlokHG.smd
    6 --- kurzgripHG.smd
    7 --- kurzslimHG.smd
    8 --- kurzmlokHG.smd
    9 ---
6 --- 	id: 5
     [	name: 5
    num: 4
    submodels:
    0 --- standardMAG.smd
    1 --- smallMAG.smd
    2 --- straightMAG.smd
    3 --- drumMAG.smd
7 --- 	id: 6
     [	name: 6
    num: 2
    submodels:
    0 ---
    1 --- mp5RAIL.smd

]]

-- Animations --

SWEP.Hook_Think = ArcCW.UC.ADSReload

local ratel = {common .. "rattle1.ogg", common .. "rattle2.ogg", common .. "rattle3.ogg"}
local rottle = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}
local rutle = {common .. "movement-smg-03.ogg",common .. "movement-smg-04.ogg"}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    -- ["idle_empty"] = {
    --     Source = "idle",
    -- },
    ["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = rottle, t = 0.15},
            {s = path .. "rack1.ogg",         t = 0.15, c = ci},
            {s = path .. "rack2.ogg",         t = 0.38, c = ci},
            {s = ratel,         t = 0.75},
        }
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = ArcCW.UC.DrawSounds,
    },
    -- ["draw_empty"] = {
    --     Source = "draw_empty",
    --     SoundTable = ArcCW.UC.DrawSounds,
    -- },
    ["holster"] = {
        Source = "holster",
        --Time = 0.25,
        SoundTable = ArcCW.UC.HolsterSounds,
    },
    -- ["holster_empty"] = {
    --     Source = "holster_empty",
    --     --Time = 0.25,
    --     SoundTable = ArcCW.UC.HolsterSounds,
    -- },
    ["fire"] = {
        Source = "fire",
        Time = 13 / 30,
        ShellEjectAt = 0.03,
        SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0, v = 0.25 }},
    },
    -- ["fire_empty"] = {
    --     Source = "fire",
    --     Time = 13 / 30,
    --     ShellEjectAt = 0.03,
    --     SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0 }},
    -- },
    ["fire_iron"] = {
        Source = "idle",
        Time = 13 / 30,
        ShellEjectAt = 0.03,
        SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0 }},
    },
    -- ["fire_empty_iron"] = {
    --     Source = "idle",
    --     Time = 13 / 30,
    --     ShellEjectAt = 0.03,
    --     SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0 }},
    -- },

    ["fix"] = {
        Source = "fix",
        Time = 40 / 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        ShellEjectAt = 0.36,
        SoundTable = {
            {s = rottle, t = 0.15},
            {s = path .. "rack1.ogg",         t = 0.27, c = ci},
            {s = path .. "rack2.ogg",         t = 0.5, c = ci},
        },
    },

    -- 30 Round Reloads --

    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 2,
        MinProgress = 1.2,
        LastClip1OutTime = 2,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = rottle, t = 0},
            {s = common .. "magpouch.ogg", t = 0.05},
            {s = path .. "magout.ogg",        t = 0.4, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.61, c = ci},
            {s = common .. "magpouchin.ogg", t = 1.25},
            {s = ratel,  t = 1.55},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "chback.ogg",         t = 0.045, c = ci},
            {s = path .. "chlock.ogg",         t = 0.18, c = ci},
            {s = common .. "magpouch.ogg", t = 0.4},
            {s = path .. "magout.ogg",        t = 0.86, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 1.13, c = ci},
            {s = common .. "magdrop_smg.ogg",  t = 1.5},
            {s = rottle, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.05, c = ci},
            {s = ratel,  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },
    ["reload_kurz"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 2,
        MinProgress = 1.2,
        LastClip1OutTime = 2,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = rottle, t = 0},
            {s = common .. "magpouch.ogg", t = 0.05},
            {s = path .. "magout.ogg",        t = 0.4, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.63, c = ci},
            {s = common .. "magpouchin.ogg", t = 1.25},
            {s = ratel,  t = 1.55},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty_kurz"] = {
        Source = "reload_empty_kurz",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "chback.ogg",         t = 0.066, c = ci},
            {s = path .. "chlock.ogg",         t = 0.2, c = ci},
            {s = common .. "magpouch.ogg", t = 0.4},
            {s = path .. "magout.ogg",        t = 0.86, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 1.13, c = ci},
            {s = common .. "magdrop_smg.ogg",  t = 1.5},
            {s = rottle, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.1, c = ci},
            {s = ratel,  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },

    -- 15 Round Reloads --

    ["reload_15"] = {
        Source = "reload",--"reload_15",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 67 / 30,
        MinProgress = 1.2,
        LastClip1OutTime = 67 / 30,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = rottle, t = 0},
            {s = common .. "magpouch.ogg", t = 0.05},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.5, c = ci},
            {s = common .. "magpouchin.ogg", t = 1.25},
            {s = ratel,  t = 1.55},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty_15"] = {
        Source = "reload_empty",--"reload_empty_15",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = common .. "magpouch.ogg", t = 0.4},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = common .. "magdrop_smg.ogg",  t = 1.5},
            {s = rottle, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = ratel,  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },
    ["reload_empty_kurz_15"] = {
        Source = "reload_empty_kurz",--"reload_empty_15",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = common .. "magpouch.ogg", t = 0.4},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = common .. "magdrop_smg.ogg",  t = 1.5},
            {s = rottle, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = ratel,  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },

    -- 40 Round Reloads --

    ["reload_40"] = {
        Source = "reload",--"reload_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 67 / 30,
        MinProgress = 1.2,
        LastClip1OutTime = 67 / 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = rottle, t = 0},
            {s = common .. "magpouch.ogg", t = 0.05},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.5, c = ci},
            {s = common .. "magpouchin.ogg", t = 1.25},
            {s = ratel,  t = 1.55},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty_40"] = {
        Source = "reload_empty",--"reload_empty_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = common .. "magpouch.ogg", t = 0.4},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = common .. "magdrop_smg.ogg",  t = 1.5},
            {s = rottle, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = ratel,  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },
    ["reload_empty_kurz_40"] = {
        Source = "reload_empty_kurz",--"reload_empty_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = common .. "magpouch.ogg", t = 0.4},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = rottle, t = 0.25},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = common .. "magdrop_smg.ogg",  t = 1.5},
            {s = rottle, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = ratel,  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },

    -- 100 Round Reloads --

    ["reload_drum"] = {
        Source = "reload_drum",--"reload_50",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 67 / 30,
        MinProgress = 1.6,
        LastClip1OutTime = 1,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.9,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "magout.ogg",        t = 0.32, c = ci},
            {s = rottle, t = 0.25},
            {s = rottle, t = 0.75},
            {s = path .. "magin.ogg",         t = 1.05, c = ci},
            {s = common .. "cloth_4.ogg",  t = 1.65},
            {s = path .. "magtap.ogg",         t = 1.755, c = ci},
            {s = common .. "shoulder.ogg",  t = 2.25},
        },
    },
    ["reload_empty_drum"] = {
        Source = "reload_empty_drum",--"reload_empty_50",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.4,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 1,
        SoundTable = {
            {s = rottle, t = 0},
            {s = path .. "magout.ogg",        t = 0.3, c = ci},
            {s = rottle, t = 0.25},
            {s = rottle, t = 0.75},
            {s = common .. "magdrop.ogg",  t = 1.0},
            {s = path .. "magin.ogg",         t = 1.05, c = ci},
            {s = common .. "cloth_4.ogg",  t = 1.65},
            {s = path .. "magtap.ogg",         t = 1.755, c = ci},
            {s = path .. "rack1.ogg",         t = 2.3, c = ci},
            {s = path .. "rack2.ogg",         t = 2.5, c = ci},
            {s = common .. "shoulder.ogg",  t = 3.0},
        },
    },

    ["enter_inspect"] = {
        Source = "inspect_enter",
        -- time = 35 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 2.5,
        SoundTable = {
            {s = rottle, t = 0},
            {s = common .. "movement-smg-03.ogg", t = 0},
        },
    },
    ["idle_inspect"] = {
        Source = "inspect_loop",
        -- time = 72 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 999, -- maybe im dumb
    },
    ["exit_inspect"] = {
        Source = "inspect_exit",
        -- time = 66 / 60,
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 999, -- maybe im dumb
        SoundTable = {
            {s = common .. "movement-smg-01.ogg", t = 0.2},
            {s = rottle, t = 0.25},
            {s = rottle, t = 1.2},
            {s = common .. "movement-smg-04.ogg", t = 1.25},
        },
    },

    ["enter_sprint"] = {
        Source = "sprint_enter",
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKOut = 0,
        Time = .5,
    },
    ["idle_sprint"] = {
        Source = "sprint_loop",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0,
    },
    ["exit_sprint"] = {
        Source = "sprint_exit",
        LHIK = true,
        LHIKIn = 0,
        LHIKEaseOut = 0.4,
        LHIKOut = 0.5,
        Time = .5,
    },
}

SWEP.AutosolveSourceSeq = "idle"