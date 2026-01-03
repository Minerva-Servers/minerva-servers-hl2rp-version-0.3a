local PLUGIN = PLUGIN

include("shared.lua")

hook.Add( "PreDrawHalos", "AddHeistHalos", function()
	local seeds = ents.FindByClass("ecl_seed")

	for k, v in pairs(seeds) do
		local fadein = v:GetNWBool("fadein");
		local Pos = v:GetPos();
		local distance = v:GetNWInt("distance");
		local alpha = 0;
		if fadein then 
			distance = math.Round(LocalPlayer():GetPos():Distance(Pos)) 
			alpha = math.Round((100-distance)*3.55)
		else
			alpha = 255
		end
		if alpha < 20 then
			alpha = alpha - 20
		end
		local array = {v}
		halo.Add(array, Color( 255, 150, 0, alpha ), 1, 1, 5, true, true )
	end
end )

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = EyeAngles()

	local owner = self:GetOwner()
	owner = (IsValid(owner) and owner:Nick()) or "Unknown"

	surface.SetFont("ixMediumFont")
	local text = "Coca Seed"
	local TextWidth = surface.GetTextSize(text)

	Ang:RotateAroundAxis(Ang:Up(),-90)
	Ang:RotateAroundAxis(Ang:Forward(),90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		local y = ScrH()/2
		local x = ScrW()/2
		local vec = self:GetPos()
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

		cam.Start3D2D(Pos + Ang:Up()*5 + Ang:Right()*-5, Ang, 0.05)
			draw.SimpleTextOutlined( text, "ixMediumFont", -TextWidth*0.5 + 5, -14, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()
	end
end