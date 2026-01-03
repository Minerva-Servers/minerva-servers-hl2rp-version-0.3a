local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_milkcarton001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = 15
	self:SetNWInt("timer", 0)
	self:SetNWInt("drafted", 0)
	self:SetNWInt("max_amount", PLUGIN.Cleaning.MaxAmount)
	self:SetNWInt("distance", PLUGIN.Draw.Distance);
	self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
	self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
	self.nextTouch = 0;
	if self:GetOwner() then
		self:SetOwner(self:GetOwner())
	end
end

function ENT:Think()
	local time = self:GetNWInt("timer")
	if time < CurTime() then
		self:StopPlay();
	end;
end;

function ENT:PlaySound()
	if !self.sound then
		self.sound = CreateSound(self, "ambient/water/water_run1.wav")
		self.sound:Play()
		self.sound:ChangeVolume(0.1)
	else
		self.sound:Play()
		self.sound:ChangeVolume(0.1)
	end;
end;

function ENT:StopPlay()
	if self.sound and self.sound:IsPlaying() then
		self.sound:Stop()
	end;
end;


function ENT:Touch(hitEnt)
	if self.nextTouch < CurTime() then
		local class = hitEnt:GetClass()
		local drafted = self:GetNWInt("drafted");
		local maxAmount = self:GetNWInt("max_amount");

		if class == "ecl_drafted" and drafted < maxAmount then
			if hitEnt:GetNWInt("shaking") == 100 then
				hitEnt:Effect();
				self:SetNWInt("drafted", drafted+1)

				if self:GetNWInt("drafted") == maxAmount then
					self:SetNWInt("timer", CurTime() + PLUGIN.Cleaning.Timer);
					self:PlaySound();
				end;
			end;
		end;

		self.nextTouch = CurTime() + 0.5
	end;
end;

function ENT:Effect()
	local effectData = EffectData();
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
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
