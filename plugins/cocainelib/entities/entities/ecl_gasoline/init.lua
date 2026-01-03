local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/metalgascan.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()
    self.damage = 15
    self:SetNWInt("cooked", 0)
    self:SetNWInt("max_amount", PLUGIN.Gasoline.MaxAmount)
    self:SetNWInt("distance", PLUGIN.Draw.Distance);
    self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
    self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
    self.nextTouch = 0;
    if self:GetOwner() then
        self:SetOwner(self:GetOwner())
    end
end

function ENT:Use()
    local time = self:GetNWInt("timer")
    if time < CurTime() and time > 0 then
        local amount = 1
        if ( math.random(1, 5) == 1 ) then
            amount = 2
        end
        
        for i = 1, amount do
            ix.item.Spawn("cocaine", self:GetPos() + Vector(math.random(-4, 4), math.random(-4, 4), 8))
        end

        self:Effect();
    end;
end;

function ENT:Touch(hitEnt)
    if self.nextTouch < CurTime() then
        local class = hitEnt:GetClass()
        local cooked = self:GetNWInt("cooked");
        local maxAmount = self:GetNWInt("max_amount");

        if class == "ecl_pot" and cooked < maxAmount then
            if hitEnt:GetNWInt("temperature") == PLUGIN.Pot.Temperature then
                hitEnt:Clean();
                self:SetNWInt("cooked", cooked+1)

                if self:GetNWInt("cooked") == maxAmount then
                    self:SetNWInt("timer", CurTime() + PLUGIN.Gasoline.Timer);
                    self:PlaySound();
                end;
            end;
        end;

        self.nextTouch = CurTime() + 0.5
    end;
end;

function ENT:Think()
    local time = self:GetNWInt("timer")
    if time < CurTime() then
        self:StopPlay();
    end;
end;

function ENT:Effect()
    local effectData = EffectData();
    effectData:SetStart(self:GetPos());
    effectData:SetOrigin(self:GetPos());
    effectData:SetScale(8);    
    util.Effect("GlassImpact", effectData, true, true);
    self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
    self:Remove();
end

function ENT:PlaySound()
    if !self.sound then
        self.sound = CreateSound(self, "ambient/gas/steam_loop1.wav")
        self.sound:Play()
        self.sound:ChangeVolume(0.05)
    else
        self.sound:Play()
        self.sound:ChangeVolume(0.05)
    end;
end;

function ENT:StopPlay()
    if self.sound and self.sound:IsPlaying() then
        self.sound:Stop()
    end;
end;

function ENT:OnTakeDamage(dmg)
    self.damage = self.damage - dmg:GetDamage()
    if (self.damage <= 0) then
        self:Remove()
    end
end

function ENT:OnRemove()
    if not IsValid(self) then return end
end
