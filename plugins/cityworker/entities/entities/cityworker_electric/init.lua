AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
        phys:EnableMotion( false )
	end
    
    local range = CITYWORKER.Config.Electric.Time
    self.time = math.random( range.min, range.max )

    self:SetNoDraw( true )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
end