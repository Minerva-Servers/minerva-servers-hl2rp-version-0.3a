local PLUGIN = PLUGIN

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local text = "Kerosin"
	local text2 = "Coca Leaves: "..self:GetNWInt("leafs")
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(text2)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang
	local pAng = EyeAngles()

	local time;
	local color;

	if (self:GetNWInt('timer') < CurTime()) then
		time = 0
	else 
		time = (self:GetNWInt('timer')-CurTime())
	end

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		local y = ScrH()/2
		local x = ScrW()/2
		local vec = Pos + Ang:Right()*-5
		local screen = vec:ToScreen()
		local dis = math.Round(math.sqrt((x-screen.x)^2 + (y-screen.y)^2))
		local dis2 = math.Round(LocalPlayer():GetPos():Distance(Pos))
		local fadein = self:GetNWBool("fadein");
		local aiming = self:GetNWBool("aiming");
		local distance = self:GetNWInt("distance");
		local alpha = math.Round((100-distance)*3.55)
		if fadein and aiming then 
			distance = (dis+dis2)/2;
			alpha = math.Round((100-distance)*3.55)
		elseif fadein then
			distance = dis2;
			alpha = math.Round((100-distance)*3.55)
		elseif aiming then
			distance = dis;
			alpha = math.Round((100-distance)*3.55)
		elseif !fadein and !aiming then
			alpha = 255;
		end

		if alpha < 20 then
			alpha = alpha - 20
		end

		if (self:GetNWInt("leafs") == 0) then
			color = Color(255,0,0,alpha-100)
		elseif (self:GetNWInt("leafs") == self:GetNWInt("max_amount")) then
			color = Color(0,255,0,alpha-100)
		else 
			color = Color(255,165,0,alpha-100)
		end

		cam.Start3D2D(Pos+Ang:Right()*-15, Angle(Ang.p, pAng.y-90, Ang.r), 0.08)
			draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth*0.5 + 5, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-11.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.05)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, color )
			draw.SimpleTextOutlined( text2, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		if self:GetNWInt("max_amount") == self:GetNWInt("leafs") then
			local clr = Color(255, 0, 0, alpha)
			if self:GetNWInt('shaking') < 100 then
				text3 = "Shake it: "..self:GetNWInt("shaking").."%"
				TextWidth3 = surface.GetTextSize(text3)
				clr = Color(255,165,0,alpha)
				if self:GetVelocity():Length() > 5 then
					self:DrawParticles(10);
				end
			elseif self:GetNWInt("shaking") == 100 then
				text3 = "Ready to use"
				TextWidth3 = surface.GetTextSize(text3)
				clr = Color(0,255,0,alpha)
			end
			cam.Start3D2D(Pos+Ang:Right()*-8.75, Angle(Ang.p, pAng.y-90, Ang.r), 0.045)
				draw.RoundedBox( 0, -TextWidth3*0.5, -3, TextWidth3+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth3*0.5, 35, TextWidth3+20, 2, clr )
				draw.SimpleTextOutlined( text3, "ixMediumFont", -TextWidth3*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()
		end
	end
end

function ENT:DrawParticles(alpha)
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local Pos = self:GetPos()+Ang:Right()*-5+Ang:Forward()*math.random(-0.75, 0.75)+Ang:Up()*math.random(-0.75, 0.75)
	local emitter = ParticleEmitter( Pos, false )
	local particle = emitter:Add( "particle/smokesprites_0016", Pos )
		if particle then
			particle:SetAngles( Ang )
			particle:SetVelocity( Vector( math.random(-3,3), math.random(-3,3), 10) )
			particle:SetColor( 255, 255, 255, alpha)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.5 )
			particle:SetStartAlpha( alpha )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 2 )
			particle:SetStartLength( 5 )
			particle:SetEndSize( 3.6 )
			particle:SetEndLength( 5 )
		end
	emitter:Finish()
end;