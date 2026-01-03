local PLUGIN = PLUGIN

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local text = "Leafbox"
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
		local vec = Pos + Ang:Right()*-3 
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

		local pos1 = Pos+Ang:Right()*-14.5
		local pos2 = Pos+Ang:Right()*-10.5

		if (self:GetNWInt("leafs") == 0) then
			color = Color(255,0,0,alpha-100)
		elseif (self:GetNWInt("leafs") == self:GetNWInt("max_amount")) then
			pos2 = Pos+Ang:Right()*-13.5
			pos1 = Pos+Ang:Right()*-17.5
			color = Color(0,255,0,alpha-100)
			local text3 = "Box is filled"
			local TextWidth3 = surface.GetTextSize(text3)
			cam.Start3D2D(Pos+Ang:Right()*-10.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.07)
				draw.RoundedBox( 0, -TextWidth3*0.5, -3, TextWidth3+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth3*0.5, 35, TextWidth3+20, 2, Color(255,0,0,alpha-100) )
				draw.SimpleTextOutlined( text3, "ixMediumFont", -TextWidth3*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()
		else 
			color = Color(255,165,0,alpha-100)
		end

		cam.Start3D2D(pos1, Angle(Ang.p, pAng.y-90, Ang.r), 0.1)
			draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth*0.5 + 5, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(pos2, Angle(Ang.p, pAng.y-90, Ang.r), 0.07)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, color )
			draw.SimpleTextOutlined( text2, "ixMediumFont", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()
	end
end