local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if (PLUGIN.CustomModels.Plant) then
		self:SetModel("models/srcocainelab/cocaplant.mdl")
		self:SetBodygroup(1, 2)
	else
		local model = "models/props/de_inferno/potted_plant"..math.random(1,3).."_p1.mdl";
		self:SetModel(model)
	end;
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	self.damage = 15
	self.collect = true
	self.touchable = true
	self.collectTime = 0;
	self:SetNWInt("leafs", PLUGIN.Plant.Leaves)
	self:SetNWInt("distance", PLUGIN.Draw.Distance);
	self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
	self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
	self:SetPos(self:GetPos() + Vector(0, 0, -10))
end

function ENT:Touch(entity)
	local class = entity:GetClass();
	local leafs = self:GetNWInt("leafs");

	if class == "ecl_leafbox" and self.touchable then
		if self.collect and entity:GetNWInt("leafs") < entity:GetNWInt("max_amount") then 
			self.collect = false;
			self.collectTime = CurTime() + 0.8;

			self:SetNWInt("leafs", leafs-1);
			entity:SetNWInt("leafs", entity:GetNWInt("leafs")+1)
			self:PlaySound();

			if (self:GetNWInt("leafs") <= (PLUGIN.Plant.Leaves*0.5)) then
				self:SetBodygroup(1,1)
			end

			if (self:GetNWInt("leafs") <= 0) then
				self:SetBodygroup(1,0)
			end;
		elseif self.collectTime < CurTime() then  
			self.collect = true;
		end;

		if leafs <= 1 then
			self:SetBodygroup(1,0)
		end;

		if leafs <= 0 then
			self.rotateTime = CurTime() + PLUGIN.Plant.RespawnTimer;
			self.touchable = false;
			if PLUGIN.Plant.DropSeed then 
				self:DropSeed();
			end;
		end;
	end;
end;

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Think()
	if self.rotateTime and self.rotateTime < CurTime() then
		local ang = self:GetAngles();
		self.rotateTime = false;
		self.touchable = true;
		self:SetNWInt("leafs", PLUGIN.Plant.Leaves)
		self:SetBodygroup(1,2)
	end;
end;

function ENT:PlaySound()
	local grass = "player/footsteps/grass"..math.random(1,4)..".wav";
	self:EmitSound(grass, 75, 100, math.Rand(0.65, 1), CHAN_AUTO)
end;

function ENT:DropSeed()
	local chance = 0.25;
	local random = math.Rand(0, 1);

	if chance > random then 
		local seed = ents.Create("ecl_seed");
		seed:SetPos(self:GetPos()+Vector(0,0,20))
		seed:Spawn()
		local phys = seed:GetPhysicsObject()
		phys:Wake()
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
