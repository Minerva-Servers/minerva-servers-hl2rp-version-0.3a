local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/metal_paintcan001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = 15
	self:SetNWInt("leafs", 0);
	self:SetNWInt("shaking", 0);
	self:SetNWInt("max_amount", PLUGIN.Kerosin.MaxAmount);
	self:SetNWInt("distance", PLUGIN.Draw.Distance);
	self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
	self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
	if self:GetOwner() then
		self:SetOwner(self:GetOwner())
	end
end

function ENT:Effect()
	local effectData = EffectData();
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
	self:Remove();
end

function ENT:Shaking()
	local shaking = self:GetNWInt("shaking");
	self:EmitSound("physics/plastic/plastic_barrel_impact_soft"..math.random(1, 5)..".wav", 75, 100, 0.25);
	self:EmitSound("ambient/water/water_splash"..math.random(1,3)..".wav", 75, 75, 0.05);
	self:SetNWInt("shaking", shaking + 2);
end;

function ENT:Touch(entity)
	local class = entity:GetClass();
	local localLeafs = self:GetNWInt("leafs");
	local maxLeafs = self:GetNWInt("max_amount");
	local entityLeafs = entity:GetNWInt("leafs");

	if class == "ecl_leafbox" and localLeafs < maxLeafs and entityLeafs != 0 then
		if (localLeafs + entityLeafs) <= maxLeafs then
			self:SetNWInt("leafs", localLeafs + entityLeafs);
			entity:SetNWInt("leafs", 0);
		else 
			local amount = (localLeafs + entityLeafs) - maxLeafs;

			self:SetNWInt("leafs", maxLeafs);
			entity:SetNWInt("leafs", amount);
		end
		entity:PlaySound();
	end
end

function ENT:Think()
	local localLeafs = self:GetNWInt("leafs");
	local maxLeafs = self:GetNWInt("max_amount");
	local shaking = self:GetNWInt("shaking");
	local velocity = self:GetVelocity():Length();

	if localLeafs == maxLeafs and shaking < 100 and velocity > 5 then 
		self:Shaking();
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
