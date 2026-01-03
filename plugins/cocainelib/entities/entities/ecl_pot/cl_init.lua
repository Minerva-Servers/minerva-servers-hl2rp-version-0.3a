local PLUGIN = PLUGIN

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local text = "Pot"
	local text2 = "Cleaned Leaves: "..self:GetNWInt("cleaned")
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

		if (self:GetNWInt("cleaned") == 0) then
			color = Color(255,0,0,alpha-100)
		elseif (self:GetNWInt("cleaned") == self:GetNWInt("max_amount")) then
			color = Color(0,255,0,alpha-100)
		else 
			color = Color(255,165,0,alpha-100)
		end

		cam.Start3D2D(Pos+Ang:Right()*-20, Angle(Ang.p, pAng.y-90, Ang.r), 0.075)
			draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth*0.5 + 5, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-17, Angle(Ang.p, pAng.y-90, Ang.r), 0.06)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, color )
			draw.SimpleTextOutlined( text2, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		if self:GetNWInt("max_amount") == self:GetNWInt("cleaned") then
			local clr = Color(255, 0, 0, alpha)
			if self:GetNWInt("timer") < CurTime() then
				local temp = self:GetNWInt("temperature")
				local text5
				local cl
				if temp < self:GetNWInt("need_temp") then
					text5 = "Not ready yet";
					cl = Color(255,0,0,alpha)
				else
					text5 = "Ready";
					cl = Color(0,255,0,alpha)
				end
				text4 = "Temperature: "..temp.."°";
				TextWidth4 = surface.GetTextSize(text4)
				if temp < 90 then
					clr = Color(255-temp*2.75,temp*2.75,0,alpha)
				else 
					clr = Color(temp*1.75,255-temp*1.75,0,alpha)
				end
				if self:GetNWBool("ingnited") then
					self:DrawParticles(25)
				else
					if self:GetNWInt("temperature") > self:GetNWInt("need_temp") then
						text5 = "Ready"
						cl = Color(0,255,0,alpha)
						self:DrawParticles(5)
					elseif self:GetNWInt("temperature") == self:GetNWInt("need_temp") then
						text5 = "Ready to use"
						cl = Color(0,255,0,alpha)
					end
				end

				local TextWidth5 = surface.GetTextSize(text5);

				cam.Start3D2D(Pos+Ang:Right()*-11, Angle(Ang.p, pAng.y-90, Ang.r), 0.075)
					draw.RoundedBox( 0, -TextWidth5*0.5, -3, TextWidth5+20, 40, Color(0,0,0,alpha-200) )
					draw.RoundedBox( 0, -TextWidth5*0.5, 35, TextWidth5+20, 2, cl )
					draw.SimpleTextOutlined( text5, "ixMediumFont", -TextWidth5*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
				cam.End3D2D()
			else
				local time = math.Round(self:GetNWInt("timer")-CurTime())
				text4 = "Wait about "..time.."sec."
				TextWidth4 = surface.GetTextSize(text4)
				clr = Color(255,165,0,alpha)
			end
			cam.Start3D2D(Pos+Ang:Right()*-14, Angle(Ang.p, pAng.y-90, Ang.r), 0.065)
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
	local Pos = self:GetPos()+Ang:Right()*-1+Ang:Forward()*math.random(-4, 4)+Ang:Up()*math.random(-4,4)
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
			particle:SetStartSize( 5 )
			particle:SetStartLength( 10 )
			particle:SetEndSize( 7.6 )
			particle:SetEndLength( 10 )
		end
	emitter:Finish()
end;