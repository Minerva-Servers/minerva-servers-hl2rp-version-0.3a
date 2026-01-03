local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/plasticbucket001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = 15
	self:SetNWInt("timer", 0)
	self:SetNWInt("kerosin", 0)
	self:SetNWInt("shaking", 0)
	self:SetNWInt("max_amount", PLUGIN.Drafting.MaxAmount)
	self:SetNWInt("distance", PLUGIN.Draw.Distance);
	self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
	self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
	self.nextTouch = 0;
	if self:GetOwner() then
		self:SetOwner(self:GetOwner())
	end
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self:Remove()
	end
end

function ENT:Touch(hitEnt)
	if self.nextTouch < CurTime() then
		local class = hitEnt:GetClass()
		local kerosin = self:GetNWInt("kerosin");
		local maxAmount = self:GetNWInt("max_amount");

		if class == "ecl_kerosin" and kerosin < maxAmount then
			if hitEnt:GetNWInt("shaking") == 100 then
				self:SetNWInt("kerosin", kerosin+1)
				hitEnt:Effect();

				self:SetNWInt("timer", CurTime() + PLUGIN.Drafting.Timer);
			end;
		end
		self.nextTouch = CurTime() + 0.5
	end;
end

function ENT:Think()
	local time = self:GetNWInt("timer")
	if time and time < CurTime() then
		self:SetNWInt("timer", 0);

		local kerosin = self:GetNWInt("kerosin");
		local maxAmount = self:GetNWInt("max_amount");
		local shaking = self:GetNWInt("shaking");
		local velocity = self:GetVelocity():Length();

		if kerosin == maxAmount and shaking < 100 and velocity > 5 then 
			self:Shaking();
		end;
	end
end

function ENT:Shaking()
	local shaking = self:GetNWInt("shaking");
	self:EmitSound("physics/plastic/plastic_barrel_impact_soft"..math.random(1, 5)..".wav", 75, 100, 0.25);
	self:EmitSound("ambient/water/water_splash"..math.random(1,3)..".wav", 75, 75, 0.05);
	self:SetNWInt("shaking", shaking + 2);
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

function ENT:OnRemove()
	if not IsValid(self) then return end
end
