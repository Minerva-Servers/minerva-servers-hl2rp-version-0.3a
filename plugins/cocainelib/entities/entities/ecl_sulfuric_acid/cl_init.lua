local PLUGIN = PLUGIN

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local text = "Cleaned Leaves"
	local text2 = "Drafted Leaves: "..self:GetNWInt("drafted")
	local text3 = "Sulfuric Acid"
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(text2)
	local TextWidth3 = surface.GetTextSize(text3)

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
		local vec = Pos + Ang:Right()*-4
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

		if (self:GetNWInt("drafted") == 0) then
			color = Color(255,0,0,alpha-100)
		elseif (self:GetNWInt("drafted") == self:GetNWInt("max_amount")) then
			color = Color(0,255,0,alpha-100)
		else 
			color = Color(255,165,0,alpha-100)
		end

		cam.Start3D2D(Pos+Ang:Right()*-20.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.075)
			draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth*0.5 + 5, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-17.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.06)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, color )
			draw.SimpleTextOutlined( text2, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-14.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.06)
			draw.RoundedBox( 0, -TextWidth3*0.5, -3, TextWidth3+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth3*0.5, 35, TextWidth3+20, 2, Color(0,255,0,alpha) )
			draw.SimpleTextOutlined( text3, "ixMediumFont", -TextWidth3*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		if self:GetNWInt("max_amount") == self:GetNWInt("drafted") then
			local clr = Color(255, 0, 0, alpha)
			if self:GetNWInt("timer") < CurTime() then
				text4 = "Ready to use"
				TextWidth4 = surface.GetTextSize(text4)
				clr = Color(0,255,0,alpha)
			else
				local time = math.Round(self:GetNWInt("timer")-CurTime())
				text4 = "Wait about "..time.."sec."
				TextWidth4 = surface.GetTextSize(text4)
				clr = Color(255,165,0,alpha)
				self:DrawParticles(20)
			end
			cam.Start3D2D(Pos+Ang:Right()*-11, Angle(Ang.p, pAng.y-90, Ang.r), 0.065)
				draw.RoundedBox( 0, -TextWidth4*0.5, -3, TextWidth4+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth4*0.5, 35, TextWidth4+20, 2, clr )
				draw.SimpleTextOutlined( text4, "ixMediumFont", -TextWidth4*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()
		end
	end
end

function ENT:DrawParticles(alpha)
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local Pos = self:GetPos()+Ang:Right()*-6+Ang:Forward()*math.random(-0.3, 0.3)+Ang:Up()*math.random(-0.3, 0.3)
	local emitter = ParticleEmitter( Pos, false )
	local particle = emitter:Add( "particle/smokesprites_0016", Pos )
		if particle then
			particle:SetAngles( Ang )
			particle:SetVelocity( Vector( math.random(-3,3), math.random(-3,3), 10) )
			particle:SetColor( 255, 150, 0, alpha)
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