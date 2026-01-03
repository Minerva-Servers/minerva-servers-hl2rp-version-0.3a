local PLUGIN = PLUGIN

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

function ENT:Initialize()
	if (PLUGIN.CustomModels.Stove) then
		self:SetModel("models/srcocainelab/portablestove.mdl");
		self:SetBodygroup(1, 1);
		self:SetBodygroup(2, 1);
		self:SetNWInt("gas", 0);
	else
		self:SetNWInt("gas", PLUGIN.Stove.MaxAmountOfGas);
		self:SetModel("models/props_c17/furnitureStove001a.mdl");
	end;
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	local phys = self:GetPhysicsObject();
	phys:Wake()
	if PLUGIN.Stove.GravityGun then
		phys:SetMass(200)
	end
	self.damage = 15;
	self:SetNWInt("max_gas", PLUGIN.Stove.MaxAmountOfGas);
	self:SetNWBool("left-top", false);
	self:SetNWBool("right-top", false);
	self:SetNWBool("left-bottom", false);
	self:SetNWBool("right-bottom", false);
	self:SetNWInt("distance", PLUGIN.Draw.Distance);
	self:SetNWBool("aiming", PLUGIN.Draw.AimingOnEntity);
	self:SetNWBool("fadein", PLUGIN.Draw.FadeInOnComingCloser);
	self.CanUse = true;
	if self:GetOwner() then
		self:SetOwner(self:GetOwner())
	end
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage();
	if (self.damage <= 0) then
		self:Remove();
	end;
end;

function ENT:Use(ply)
	local Pos = self:GetPos();
	local Ang = self:GetAngles();
	Ang:RotateAroundAxis(Ang:Forward(), 90);

	if (PLUGIN.CustomModels.Stove) then
		local pos = Pos+Ang:Right()*-2.3+Ang:Up()*-9.4+Ang:Forward()*9;
		if ply:GetEyeTrace().HitPos:Distance(pos) < 2 then
			local bodygroup = self:GetBodygroup(2);
			if bodygroup == 0 then 
				local status = self:GetNWBool("left-top");
				if status then
					self:SetNWBool("left-top", false);
				else 
					self:SetNWBool("left-top", true);
				end;
			end;
		end;

		local pbut = Pos+Ang:Right()*-2.3+Ang:Up()*-5.8+Ang:Forward()*8.5
		if ply:GetEyeTrace().HitPos:Distance(pbut) < 2 then
			local bodygroup = self:GetBodygroup(1);
			if bodygroup == 1 then 
				self:SetBodygroup(1, 0);
			else
				self:SetBodygroup(1, 1);
			end;
		end;
	else
		local poses = {
			[1] = Pos+Ang:Right()*-20.2+Ang:Up()*17+Ang:Forward()*14,
			[2] = Pos+Ang:Right()*-20.2+Ang:Up()*14+Ang:Forward()*14,
			[3] = Pos+Ang:Right()*-20.2+Ang:Up()*11+Ang:Forward()*14,
			[4] = Pos+Ang:Right()*-20.2+Ang:Up()*8+Ang:Forward()*14
		};

		local gas = self:GetNWInt("gas");
		if gas > 0 then
			for k, v in pairs(poses) do
				if ply:GetEyeTrace().HitPos:Distance(v) < 2 then
					if k == 1 then
						local status = self:GetNWBool("left-top");
						if status then
							self:SetNWBool("left-top", false);
						else 
							self:SetNWBool("left-top", true);
						end;
					elseif k == 2 then
						local status = self:GetNWBool("right-top");
						if status then
							self:SetNWBool("right-top", false);
						else 
							self:SetNWBool("right-top", true);
						end;
					elseif k == 3 then
						local status = self:GetNWBool("left-bottom");
						if status then
							self:SetNWBool("left-bottom", false);
						else 
							self:SetNWBool("left-bottom", true);
						end;
					elseif k == 4 then
						local status = self:GetNWBool("right-bottom");
						if status then
							self:SetNWBool("right-bottom", false);
						else 
							self:SetNWBool("right-bottom", true);
						end;
					end;
				end;
			end;
		end;
	end;
end;

function ENT:Think()
	if PLUGIN.StoveThink then
		PLUGIN:StoveThink(self)
	end
end;

function ENT:OnRemove()
	if not IsValid(self) then return end
end
