local PLUGIN = PLUGIN

AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.PrintName = "IED"
SWEP.Author = "Riggs"
SWEP.Category = "HL2 RP"

SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Blow yourself up."
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.UseHands = true

SWEP.IsAlwaysRaised = true

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.ViewModelFOV = 50

SWEP.Slot = 4
SWEP.SlotPos = 5

SWEP.HoldType = "slam"

SWEP.Primary.Delay = 3
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Delay = 0.5
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
 
function SWEP:Reload()
end

function SWEP:Think()
    self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
    if ( ( self.primaryCooldown or 0 ) < CurTime() ) then
        if ( SERVER ) then
            self:Kaboom()
        end
        self.primaryCooldown = CurTime() + self.Primary.Delay
    end
end

function SWEP:Kaboom()
    self.Owner:EmitSound("weapons/c4/c4_plant.wav")
    self.Owner:EmitSound("weapons/c4/c4_beep1.wav", 90)

    timer.Simple(1, function()
        if not ( IsValid(self) ) then
            return
        end

        self.Owner:EmitSound("weapons/c4/c4_beep1.wav", 90)
    end)

    timer.Simple(2, function()
        if not ( IsValid(self) ) then
            return
        end

        self.Owner:EmitSound("weapons/c4/c4_beep1.wav", 90)
    end)

    timer.Simple(2.5, function()
        if not ( IsValid(self) ) then
            return
        end

        self.Owner:EmitSound("weapons/c4/c4_beep1.wav", 90)
    end)

    timer.Simple(3, function()
        if not ( IsValid(self) ) then
            return
        end

        local debris = {}

        for i = 1, 9 do
            local flyer = ents.Create("prop_physics")
            flyer:SetPos(self:GetPos() + flyer:GetAngles():Up() * 3)

            if ( i > 4 ) then
                flyer:SetModel("models/props_debris/wood_chunk08b.mdl")
            else
                flyer:SetModel("models/combine_helicopter/bomb_debris_"..math.random(2, 3)..".mdl")
            end

            flyer:SetCollisionGroup(COLLISION_GROUP_WORLD)
            flyer:Spawn()
            flyer:Ignite(30)

            local phys = flyer:GetPhysicsObject()

            if ( phys ) and ( IsValid(phys) ) then
                phys:SetVelocity(Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150)))
            end

            table.insert(debris, flyer)
        end

        timer.Simple(40, function()
            for k, v in pairs(debris) do
                if ( IsValid(v) ) then
                    v:Remove()
                end
            end
        end)

        local explodeEnt = ents.Create("env_explosion")
        explodeEnt:SetPos(self:GetPos())

        if IsValid(self.placer) then
            explodeEnt:SetOwner(self.placer)
        end 

        explodeEnt:Spawn()
        explodeEnt:SetKeyValue("iMagnitude", "380")
        explodeEnt:Fire("explode", "", 0)

        local fire = ents.Create("env_fire")
        fire:SetPos(self:GetPos())
        fire:Spawn()
        fire:Fire("StartFire")

        timer.Simple(60, function()
            if ( IsValid(fire) ) then
                fire:Remove()
            end
        end)

        local effectData = EffectData()
        effectData:SetOrigin(self:GetPos())
        util.Effect("Explosion", effectData)

        self.Owner:EmitSound("weapons/c4/c4_explode1.wav", 500)
        self.Owner:EmitSound("weapons/c4/c4_exp_deb1.wav", 125)
        self.Owner:EmitSound("weapons/c4/c4_exp_deb2.wav", 125)
        self.Owner:EmitSound("ambient/atmosphere/terrain_rumble1.wav", 108)

        for k, v in pairs(player.GetAll()) do
            v:SurfacePlaySound("ambient/levels/streetwar/city_battle7.wav")
        end

        util.ScreenShake(self:GetPos(), 4, 2, 2.5, 100000)
        
        self:Remove()

        local pos = self:GetPos()

        timer.Simple(1, function()
            for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
                if ( v:GetPos():DistToSqr(pos) < (1200 ^ 2) ) then
                    v:Ignite(40)
                end
            end
        end)
    end)
end
