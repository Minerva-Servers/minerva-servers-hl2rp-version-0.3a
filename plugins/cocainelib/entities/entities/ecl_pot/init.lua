local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/metalPot001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:EnableMotion(true)
    phys:Wake()
    self.damage = 15
    self:SetNWInt("timer", 0);
    self:SetNWInt("cleaned", 0);
    self:SetNWInt("temperature", 0);
    self:SetNWInt("max_amount", PLUGIN.Pot.MaxAmount);
    self:SetNWInt("distance", PLUGIN.Draw.Distance);
    self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
    self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
    self:SetNWInt("need_temp", PLUGIN.Pot.Temperature)
    self:SetNWBool("ingnited", false);
    if self:GetOwner() then
        self:SetOwner(self:GetOwner())
    end
    self.nextTick = 0;
    self.nextTouch = 0;
end

function ENT:Touch(hitEnt)
    if self.nextTouch < CurTime() then
        local class = hitEnt:GetClass()
        local time = hitEnt:GetNWInt("timer")
        local cleaned = self:GetNWInt("cleaned");
        local maxAmount = self:GetNWInt("max_amount");

        if class == "ecl_sulfuric_acid" and cleaned < maxAmount and time < CurTime() and 
            hitEnt:GetNWInt("timer") > 0 and hitEnt:GetNWInt("timer") < CurTime() then
            hitEnt:Effect();
            hitEnt:Remove();
            self:SetNWInt("cleaned", cleaned+1)
        end;
    self.nextTouch = CurTime() + 0.5
    end;
end;

function ENT:PlaySound()
    if !self.sound then
        self.sound = CreateSound(self, "ambient/gas/steam_loop1.wav")
        self.sound2 = CreateSound(self, "ambient/water/water_run1.wav")
        self.sound:Play()
        self.sound:ChangeVolume(0.035)
        self.sound2:Play()
        self.sound2:ChangeVolume(0.1)
    else
        self.sound:Play()
        self.sound:ChangeVolume(0.035)
        self.sound2:Play()
        self.sound2:ChangeVolume(0.1)
    end;
end;

function ENT:StopPlay()
    if self.sound and self.sound:IsPlaying() then
        self.sound:Stop()
        self.sound2:Stop()
    end;
end;

function ENT:Think()
    if PLUGIN.PotThink then
        PLUGIN:PotThink(self)
    end
end;

function ENT:OnTakeDamage(dmg)
    self.damage = self.damage - dmg:GetDamage()
    if (self.damage <= 0) then
        self:Remove()
    end
end

function ENT:Explode()
    local pos = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(pos)
    effectdata:SetOrigin(pos)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
	self:EmitSound("physics/metal/metal_box_break1.wav")
    self:Remove()
end;

function ENT:Clean()
    self:SetNWInt("timer", 0);
    self:SetNWInt("cleaned", 0);
    self:SetNWInt("temperature", 0);
    self:SetNWInt("max_amount", PLUGIN.Pot.MaxAmount);
    self:SetNWInt("distance", PLUGIN.DrawDistance);
    self:SetNWBool("ingnited", false);
    self.nextTick = 0;
    self.nextTouch = 0;
    self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
end;

function ENT:OnRemove()
    if not IsValid(self) then return end
end
