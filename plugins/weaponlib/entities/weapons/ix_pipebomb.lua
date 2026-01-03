AddCSLuaFile()

SWEP.Base = "ls_base_projectile"

SWEP.PrintName = "Pipe Bomb"
SWEP.Category = "HL2 RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "slam"

SWEP.WorldModel = "models/wick/weapons/l4d1/w_pipebomb.mdl"
SWEP.ViewModel = "models/wick/weapons/l4d1/c_pipebomb.mdl"
SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 3

SWEP.Primary.Sound = ""
SWEP.Primary.Recoil = 0
SWEP.Primary.Delay = 0.8
SWEP.Primary.HitDelay = 0.1

SWEP.Primary.Ammo = "Grenade"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Projectile = {}
SWEP.Projectile.Model = "models/wick/weapons/l4d1/w_pipebomb.mdl"
SWEP.Projectile.HitSound = "Weapon_Greande.Bounce"
SWEP.Projectile.Touch = false
SWEP.Projectile.ForceMod = 2
SWEP.Projectile.Mass = 5
SWEP.Projectile.Timer = 2
SWEP.Projectile.RemoveWait = 2

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

local function TimedTick(ent, time)
    timer.Simple(time, function()
        if not ( IsValid(ent) ) then
            return
        end
        
        ent:EmitSound("Weapon_PipeBomb.Tick")
    end)
end

function SWEP:ThrowAttack()
    if CLIENT then return end

    self:TakePrimaryAmmo(1)

    local projectile = ents.Create("ls_projectile")
    projectile:SetModel(self.Projectile.Model)
    projectile.Owner = self.Owner

    local pos = self.Owner:GetShootPos()
    pos = pos + self.Owner:GetForward() * 2
    pos = pos + self.Owner:GetRight() * 3
    pos = pos + self.Owner:GetUp() * -3

    projectile:SetPos(pos)

    if self.Projectile.Timer then
        projectile.Timer = CurTime() + self.Projectile.Timer
    end

    if self.Projectile.Touch then
        projectile.ProjTouch = self.Projectile.Touch
    end

    if self.ProjectileFire then
        projectile.OnFire = self.ProjectileFire
    end

    if self.ProjectileThink then
        projectile.ProjThink = self.ProjectileThink
    end

    if self.ProjectileRemove then
        projectile.ProjRemove = self.ProjectileRemove
    end

    if self.Projectile.FireSound then
        projectile.FireSound = self.Projectile.FireSound
    end

    if self.Projectile.HitSound then
        projectile.HitSound = self.Projectile.HitSound
    end

    if self.Projectile.RemoveWait then
        projectile.RemoveWait = self.Projectile.RemoveWait
    end

    projectile:SetOwner(self.Owner)
    projectile:Spawn()
	local trail = util.SpriteTrail(projectile, 0, Color(250, 50, 50), false, 5, 5, 1, 1 / ( 5 + 5 ) * 0.5, "trails/laser")
    TimedTick(projectile, 0)
    TimedTick(projectile, 1)
    TimedTick(projectile, 1.4)
    TimedTick(projectile, 1.6)
    TimedTick(projectile, 1.8)
    TimedTick(projectile, 1.9)
    TimedTick(projectile, 2)

    local force = 700

    if self.Owner:KeyDown(IN_FORWARD) then
        force = 1000
    elseif self.Owner:KeyDown(IN_BACK) then
        force = 200
    end

    if self.Projectile.ForceMod then
        force = force * self.Projectile.ForceMod
    end

    local phys = projectile:GetPhysicsObject()

    if not IsValid(phys) then
        return
    end

    if self.Projectile.Mass then
        if IsValid(phys) then
            phys:SetMass(self.Projectile.Mass)
        end
    end

    phys:ApplyForceCenter(self.Owner:GetAimVector() * force * 2 + Vector(0, 0, 0))
    phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
end

function SWEP:ProjectileFire()
    local pos = self:GetPos()
    local owner = self:GetOwner()

    if not ( IsValid(owner) ) then return end

    if ( SERVER ) then
        if not ( IsValid(self) ) then
            return
        end

        local explodeEnt = ents.Create("env_explosion")
        explodeEnt:SetPos(self:GetPos())

        if IsValid(self.placer) then
            explodeEnt:SetOwner(self.placer)
        end 

        explodeEnt:Spawn()
        explodeEnt:SetKeyValue("iMagnitude", "100")
        explodeEnt:SetKeyValue("iRadiusOverride", "256")
        explodeEnt:Fire("explode", "", 0)
        explodeEnt:EmitSound("Weapon_PipeBomb.Explode")

        local fire = ents.Create("env_fire")
        fire:SetPos(self:GetPos())
        fire:Spawn()
        fire:Fire("StartFire")

        timer.Simple(30, function()
            if ( IsValid(fire) ) then
                fire:Remove()
            end
        end)

        local effectData = EffectData()
        effectData:SetOrigin(self:GetPos())
        util.Effect("Explosion", effectData)

        util.ScreenShake(self:GetPos(), 4, 2, 2.5, 1000)

        for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
            if ( v:GetClass() == "prop_door_rotating" ) and ( self:IsInRoom(v) ) then
                local Door = ents.Create("prop_physics")
                local TargetDoorsPos = v:GetPos()
                Door:SetAngles(v:GetAngles())
                Door:SetPos(v:GetPos() + v:GetUp())
                Door:SetModel(v:GetModel())
                Door:SetSkin(v:GetSkin())
                Door:SetCollisionGroup(0)
                Door:SetRenderMode(RENDERMODE_TRANSALPHA)
                v:Fire("unlock")
                v:Fire("openawayfrom", self.Owner:UniqueID()..CurTime())
                v:SetCollisionGroup(20)
                v:SetRenderMode(10)
                Door:Spawn()
                Door:EmitSound("/physics/wood/wood_crate_break"..math.random(1, 4)..".wav" , 80, 50, 1)
                Door:GetPhysicsObject():ApplyForceCenter(Door:GetForward() * 1000)
                v.canbeshot = false
                v:SetPos(v:GetPos() + Vector(0,0,-1000))
                timer.Simple(ix.config.Get("Respawn Timer", 60), function()
                    if ( IsValid(v) and IsValid(Door) ) then
                        v:SetCollisionGroup(0)
                        v:SetRenderMode(0)
                        v.bHindge2 = false
                        v.bHindge1 = false
                        v:SetPos(v:GetPos() - Vector(0,0,-1000))
                        if ( Door ) then
                            Door:Remove()
                            v.canbeshot = true
                        end
                    end
                end)
            end
        end
    end
    
    self:Remove()
end

sound.Add({
    name = "Weapon_PipeBomb.Explode",
    sound = {
        "^weapons/hegrenade/explode3.wav",
        "^weapons/hegrenade/explode4.wav",
        "^weapons/hegrenade/explode5.wav",
    },
    channel = CHAN_WEAPON,
    level = 100,
    pitch = {85, 115},
})

sound.Add({
    name = "Weapon_PipeBomb.Bounce",
    sound = "weapons/hegrenade/he_bounce-1.wav",
    channel = CHAN_WEAPON,
    level = 50,
    volume = 0.05,
})

sound.Add({
    name = "Weapon_PipeBomb.Tick",
    sound = "weapons/hegrenade/beep.wav",
    channel = CHAN_WEAPON,
    level = 80,
})