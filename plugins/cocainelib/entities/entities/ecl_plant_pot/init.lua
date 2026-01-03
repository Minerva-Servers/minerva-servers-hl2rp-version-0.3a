local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	local model = "models/props_junk/terracotta01.mdl";
	self:SetModel(model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(true)
	phys:Wake()
	self.damage = 15
	self.collect = true
	self.touchable = true
	self:SetNWBool("seeded", false)
	self:SetNWInt("distance", PLUGIN.Draw.Distance);
	self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
	self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
	if self:GetOwner() then
		self:SetOwner(self:GetOwner())
	end
end

function ENT:Touch(entity)
	local class = entity:GetClass();
	local leafs = self:GetNWInt("leafs");

	if class == "ecl_seed" and self.touchable then
		self.touchable = false;
		entity:Remove()
		self:SetNWBool("seeded", true)
			
		self.time = CurTime() + PLUGIN.Plant.GrowingTimer
		self:SetNWInt("timer", self.time)
	end;


end;

function ENT:Think()
	if self.time and self.time < CurTime() then
		local plant = ents.Create("ecl_plant");
		plant:SetPos(self:GetPos()+Vector(0,0,10))
		plant:Spawn()
		if (PLUGIN.CustomModels.Plant) then
			plant:SetModel("models/srcocainelab/cocaplant.mdl")
		else
			plant:SetModel("models/props/de_inferno/potted_plant"..math.random(1,3)..".mdl")
		end;
		local phys = plant:GetPhysicsObject()
		phys:EnableMotion(true)
		phys:Wake()
		if self:GetOwner() then
			plant:SetOwner(self:GetOwner())
		end
		

		self:Remove()
	end;
end;

function ENT:PlaySound()
	local grass = "player/footsteps/grass"..math.random(1,4)..".wav";
	self:EmitSound(grass, 75, 100, math.Rand(0.65, 1), CHAN_AUTO)
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
