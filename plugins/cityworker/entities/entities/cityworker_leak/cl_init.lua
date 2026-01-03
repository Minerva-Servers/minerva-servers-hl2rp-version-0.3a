include( "shared.lua" )

function ENT:Initialize()
    self.emitter = ParticleEmitter( self:GetPos() )
    self.color = HSVToColor( math.random( 0, 360 ), math.Rand( 0.2, 0.6 ), math.Rand( 0, 0.3 ) )

    self.nextEmit = 0

    self.sound = CreateSound( self, "ambient/gas/steam2.wav")
    self.sound:SetSoundLevel( 53 )
    self.sound:Play()
end

function ENT:OnRemove()
    if IsValid( self.sound ) then
        self.sound:Stop()
    end
end

function ENT:Think()
    if LocalPlayer():GetPos():Distance( self:GetPos() ) > 1024 then return end
    if CurTime() > self.nextEmit then
        local smokemat = math.random( 1, 16 )
		smokemat = "particle/smokesprites_00"..( smokemat < 10 and "0"..smokemat or smokemat )

        local v = Vector( 0, 250, 0 )
        v:Rotate( self:GetAngles() )

        local smoke = self.emitter:Add( smokemat, self:LocalToWorld( Vector( 0, 0, 1 ) ) )
        smoke:SetVelocity( v )
        smoke:SetDieTime( 0.5 )
        smoke:SetStartAlpha( self.color.a )
        smoke:SetEndAlpha( 0 )
        smoke:SetAngles( AngleRand() )
        smoke:SetStartSize( math.Rand( 4, 6 ) )
        smoke:SetEndSize( math.Rand( 10, 13 ) )
        smoke:SetGravity( Vector( 0, 0, 10 ) )
        smoke:SetColor( self.color.r, self.color.g, self.color.b )
        smoke:SetAirResistance( 50 )

        self.nextEmit = CurTime() + 0.01
    end
end