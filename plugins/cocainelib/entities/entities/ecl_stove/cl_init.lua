local PLUGIN = PLUGIN

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local pers = 0.96*(100/self:GetNWInt("max_gas")*self:GetNWInt("gas"));
	local text = "Gas: "..pers.."%";
	local text2 = "Plates:";
	local TextWidth1 = surface.GetTextSize(text);
	local TextWidth2 = surface.GetTextSize(text2);
	
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
		local vec = Pos+Ang:Right()*-21+Ang:Up()*22+Ang:Forward()*13
		local screen = vec:ToScreen()
		local fadein = self:GetNWBool("fadein");
		local distance = self:GetNWInt("distance");
		local alpha = math.Round((100-distance)*3.55)
		if fadein then 
			distance = math.Round(LocalPlayer():GetPos():Distance(Pos)) 
			alpha = math.Round((100-distance)*3.55)
		else
			alpha = 255
		end

		if alpha < 20 then
			alpha = alpha - 20
		end

		if (self:GetModel() == "models/srcocainelab/portablestove.mdl") then 
			local power = Color(255,0,0, alpha);
			if self:GetNWBool("left-top") then 
				self:DrawParticle(1, false)
				power = Color(0,255,0, alpha)
			end

			local sAng = self:GetAngles();
			sAng:RotateAroundAxis(sAng:Up(), 90)
			local text = "Gas:";
			local TextWidth2 = surface.GetTextSize(text);
			cam.Start3D2D(Pos+sAng:Right()*-6.5+sAng:Up()*4.5+sAng:Forward()*8.67, sAng, 0.045)
				draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, Color(255,175,0,alpha) )
				draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255, alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()

			if pers > 0 then 
				cam.Start3D2D(Pos+sAng:Right()*-4+sAng:Up()*4.5+sAng:Forward()*8.17, sAng, 0.1)
					draw.RoundedBox( 0, -2, 0, 22.5, 104, Color(0,0,0,alpha) )
					draw.RoundedBox( 0, 0, 2, 18.5, 100, Color(255,255,255,alpha*0.1) )
					draw.RoundedBox( 0, 2, 4, 14.5, pers, Color(255,175,0,alpha*2) )
				cam.End3D2D()
			else
				local aAng = self:GetAngles();
				aAng:RotateAroundAxis(aAng:Up(), 180)
				cam.Start3D2D(Pos+aAng:Right()*8.8+aAng:Up()+aAng:Forward()*-4, aAng, 0.0375)
					draw.SimpleTextOutlined( "Insert the Gascan", "ixMediumFont", 0, 0, Color(255,255,255, alpha), 0, 0, 1, Color(0,0,0, alpha) )
				cam.End3D2D()
			end;

			cam.Start3D()
				render.SetMaterial(Material("sprites/light_glow02_add"))
				render.DrawSprite(Pos+Ang:Right()*-2.3+Ang:Up()*-9.4+Ang:Forward()*9, 5, 5, power)
				render.DrawSprite(Pos+Ang:Right()*-2.3+Ang:Up()*-5.8+Ang:Forward()*8.5, 3, 3, Color(255,175,0,alpha))
			cam.End3D()
		else
			local power = {Color(255,0,0,alpha), Color(255,0,0,alpha), Color(255,0,0,alpha) ,Color(255,0,0,alpha)}
			if self:GetNWBool("left-top") then 
				self:DrawParticle(1, false)
				power[1] = Color(0,255,0, alpha)
			end
			if self:GetNWBool("right-top") then
				self:DrawParticle(2, false)
				power[2] = Color(0,255,0, alpha)
			end
			if self:GetNWBool("left-bottom") then
				self:DrawParticle(3, false)
				power[3] = Color(0,255,0, alpha)
			end
			if self:GetNWBool("right-bottom") then
				self:DrawParticle(4, false)
				power[4] = Color(0,255,0, alpha)
			end

			cam.Start3D2D(Pos+Ang:Right()*-21+Ang:Up()*22+Ang:Forward()*13, Angle(Ang.p, Ang.y+90, Ang.r-70), 0.06)
				draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, Color(255,0,0,alpha) )
				draw.SimpleTextOutlined( text2, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255, alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()

			cam.Start3D2D(Pos+Ang:Right()*-21+Ang:Up()*-19+Ang:Forward()*13, Angle(Ang.p, Ang.y+90, Ang.r-70), 0.06)
				draw.RoundedBox( 0, -TextWidth1*0.5, -3, TextWidth1+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth1*0.5, 35, TextWidth1+20, 2, Color(255,0,0,alpha) )
				draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth1*0.5 + 10, 0, Color(255,255,255, alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()

			cam.Start3D()
				render.SetMaterial(Material("sprites/light_glow02_add"))
				render.DrawSprite(Pos+Ang:Right()*-20.2+Ang:Up()*17+Ang:Forward()*14,5,5,power[1])
				render.DrawSprite(Pos+Ang:Right()*-20.2+Ang:Up()*14+Ang:Forward()*14,5,5,power[2])
				render.DrawSprite(Pos+Ang:Right()*-20.2+Ang:Up()*11+Ang:Forward()*14,5,5,power[3])
				render.DrawSprite(Pos+Ang:Right()*-20.2+Ang:Up()*8+Ang:Forward()*14,5,5,power[4])
			cam.End3D()
		end;
	end;
end;

function ENT:DrawParticle(plate, lowAlpha)
	local alpha = 150;
	if lowAlpha then
		alpha = 50;
	end
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local Pos = self:GetPos();
	if plate == 1 then
		if (self:GetModel() == "models/srcocainelab/portablestove.mdl") then
			Pos = self:GetPos()+Ang:Right()*-3.8+Ang:Forward()*-0.255+Ang:Up()*1.82
		else
			Pos = self:GetPos()+Ang:Right()*-19.8+Ang:Forward()*-9.75+Ang:Up()*11.5
		end;
	elseif plate == 3 then
		Pos = self:GetPos()+Ang:Right()*-19.8+Ang:Forward()*2.75+Ang:Up()*11.5
	elseif plate == 2 then
		Pos = self:GetPos()+Ang:Right()*-19.8+Ang:Forward()*-9.75+Ang:Up()*-11.2
	elseif plate == 4 then
		Pos = self:GetPos()+Ang:Right()*-19.8+Ang:Forward()*2.75+Ang:Up()*-11.2
	end
	local emitter = ParticleEmitter( Pos, false )
	local particle = emitter:Add( "sprites/light_glow02_add", Pos )
		if particle then
			particle:SetAngles( Ang )
			particle:SetVelocity( Vector( math.random(-1,1), math.random(-1,1), math.random(3, 7) ) )
			particle:SetColor( 255, math.random(70, 190), 0, alpha)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.275 )
			particle:SetStartAlpha( 150 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 1)
			particle:SetStartLength( 1 )
			particle:SetEndSize( 3 )
			particle:SetEndLength( 1 )
		end
	emitter:Finish()
end;