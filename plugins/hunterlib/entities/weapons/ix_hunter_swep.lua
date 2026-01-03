if ( !IsMounted( "ep2" ) ) then return end

AddCSLuaFile()

SWEP.PrintName = "Hunter SWEP"
SWEP.Author = "Riggs"
SWEP.Purpose = ""

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/v_superphyscannon.mdl" )
SWEP.WorldModel = Model( "" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.Category = "HL2 RP"
SWEP.HoldType = "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.AdminOnly = true

game.AddParticles( "particles/hunter_flechette.pcf" )
game.AddParticles( "particles/hunter_projectile.pcf" )

local ShootSound = Sound( "NPC_Hunter.FlechetteShoot" )

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
end

function SWEP:CanBePickedUpByNPCs()
	return false
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.1 )

	self:EmitSound( ShootSound )
	self:ShootEffects( self )

	if ( CLIENT ) then return end

	SuppressHostEvents( NULL ) -- Do not suppress the flechette effects

	local ent = ents.Create( "hunter_flechette" )
	if ( !IsValid( ent ) ) then return end

	local Forward = self.Owner:GetAimVector()

	ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:SetOwner( self.Owner )
	ent:Spawn()
	ent:Activate()

	ent:SetVelocity( Forward * 2000 )

	ent.fired = (ent.fired or 0) + 1
end

function SWEP:SecondaryAttack()
end

function SWEP:ShouldDropOnDie()
	return false
end
