local PLUGIN = PLUGIN

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local text = "Drafted Leaves"
	local text3 = "Water"
	local text2 = "Leaves in Kerosin: "..self:GetNWInt("kerosin")
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
		local vec = Pos + Ang:Right()*-12
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

		if (self:GetNWInt("kerosin") == 0) then
			color = Color(255,0,0,alpha-100)
		elseif (self:GetNWInt("kerosin") == self:GetNWInt("max_amount")) then
			color = Color(0,255,0,alpha-100)
		else 
			color = Color(255,165,0,alpha-100)
		end

		cam.Start3D2D(Pos+Ang:Right()*-26, Angle(Ang.p, pAng.y-90, Ang.r), 0.075)
			draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth*0.5 + 5, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-22.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.06)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, color )
			draw.SimpleTextOutlined( text2, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-19.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.06)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, Color(0,255,0, alpha-100) )
			draw.SimpleTextOutlined( text3, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		if self:GetNWInt("max_amount") == self:GetNWInt("kerosin") then
			local clr = Color(255, 0, 0, alpha)
			if self:GetNWInt("timer") < CurTime() then
				if self:GetNWInt('shaking') < 100 then
					text4 = "Shake it: "..self:GetNWInt("shaking").."%"
					TextWidth4 = surface.GetTextSize(text4)
					clr = Color(255,165,0,alpha)
				elseif self:GetNWInt("shaking") == 100 then
					text4 = "Ready to use"
					TextWidth4 = surface.GetTextSize(text4)
					clr = Color(0,255,0,alpha)
				end
			else
				local time = math.Round(self:GetNWInt("timer")-CurTime())
				text4 = "Wait about "..time.."sec."
				TextWidth4 = surface.GetTextSize(text4)
				clr = Color(255,165,0,alpha)
			end
			cam.Start3D2D(Pos+Ang:Right()*-16.75, Angle(Ang.p, pAng.y-90, Ang.r), 0.065)
				draw.RoundedBox( 0, -TextWidth4*0.5, -3, TextWidth4+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth4*0.5, 35, TextWidth4+20, 2, clr )
				draw.SimpleTextOutlined( text4, "ixMediumFont", -TextWidth4*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()
		end
	end
end