include( "shared.lua" )

function ENT:Initialize()
    self.emitter = ParticleEmitter( self:GetPos() )

    self.nextEmit = 0

    self.sound = CreateSound( self, "ambient/water/water_flow_loop1.wav" )
    self.sound:SetSoundLevel( 60 )
    --self.sound:Play()
end

function ENT:OnRemove()
    if IsValid( self.sound ) then
        self.sound:Stop()
    end
end

function ENT:Think()
    if self:GetLeaking() then
        if not self.sound:IsPlaying() then
            self.sound:Play()
        end

        if LocalPlayer():GetPos():Distance( self:GetPos() ) <= 2048 then
            if CurTime() > self.nextEmit then
                local v = Vector( 0, 70, 550 )
                v:Rotate( self:GetAngles() )

                -- 2 ^ math.random( 0, 2 ) because we want only 1, 2, and 4 lmao
                local water = self.emitter:Add( "effects/splash"..2 ^ math.random( 0, 2 ), self:LocalToWorld( Vector( 0, 0, 35 ) ) )
                water:SetVelocity( v )
                water:SetDieTime( 2 )
                water:SetStartAlpha( 200 )
                water:SetEndAlpha( 50 )
                water:SetAngles( AngleRand() )
                water:SetStartSize( 10 )
                water:SetEndSize( 50 )
                water:SetGravity( Vector( 0, 0, -600 ) )
                water:SetColor( 255, 255, 255 )
                water:SetAirResistance( 0 )

                self.nextEmit = CurTime() + 0.02
            end
        end
    else
        if self.sound:IsPlaying() then
            self.sound:Stop()
        end
    end

    self:DrawModel()
end