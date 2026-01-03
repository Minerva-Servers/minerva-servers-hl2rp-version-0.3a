AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
    local range, mdl = table.Random( CITYWORKER.Config.Rubble.Models )

    self:SetModel( mdl )
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
        phys:EnableMotion( false )
	end

    self.time = math.random( range.min, range.max )

    self:DropToFloor()
    self:SetPos( self:GetPos() - Vector( 0, 0, 4.5 ) )
end