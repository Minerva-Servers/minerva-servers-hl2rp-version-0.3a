local PLUGIN = PLUGIN

function PLUGIN:HUDPaintAlternate(ply, char)
	if not ( ply:IsArrested() ) then
		return
	end
	
	draw.DrawText("You have been Arrested! "..string.ToMinutesSeconds(timer.TimeLeft(LocalPlayer():UserID().."ixPrison")).." Remaining", "ixBigFont", ScrW() / 2, 100, color_white, TEXT_ALIGN_CENTER)
end

net.Receive("ixOpenChargeMenu", function()
	local ply = LocalPlayer()
	local arrestguy = net.ReadEntity()

	if not ( chargemenu ) then
		chargemenu = vgui.Create("ixChargeMenu")
		chargemenu:SetPlayer(arrestguy)
	else
		chargemenu:Remove()
		chargemenu = vgui.Create("ixChargeMenu")
		chargemenu:SetPlayer(arrestguy)
	end
end)

net.Receive("ixArrestClientSync", function()
	local time = net.ReadUInt(32)
	
	timer.Create(LocalPlayer():UserID().."ixPrison", time, 1, function()
	end)
end)