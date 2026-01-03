local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Radio Frequency IED"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"

ENT.Spawnable = false
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/weapons/w_c4_planted.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    function ENT:Use(ply)
        if ( self.placer == ply ) then
            local pos, ang = self:GetPos(), self:GetAngles()

            table.RemoveByValue(PLUGIN.list, self)
            self:Remove()
            
            timer.Simple(1, function()
                ix.item.Spawn("item_radioied", pos, function(itme, ent)
                    ent:EmitSound("weapons/c4/c4_disarm.wav")
                end, ang)
                ply:Notify("You have disarmed the Remote IED.")
            end)
        end
    end

    function ENT:Kaboom()
        self:EmitSound("weapons/c4/c4_beep1.wav", 90)
        table.RemoveByValue(PLUGIN.list, self)

        timer.Simple(1.5, function()
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

            self:EmitSound("weapons/c4/c4_explode1.wav", 500)
            self:EmitSound("weapons/c4/c4_exp_deb1.wav", 125)
            self:EmitSound("weapons/c4/c4_exp_deb2.wav", 125)
            self:EmitSound("ambient/atmosphere/terrain_rumble1.wav", 108)

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
end
