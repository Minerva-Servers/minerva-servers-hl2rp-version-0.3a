
function PLUGIN:PopulateCharacterInfo(client, character, container)
	if (client:Alive() and client:GetNetVar("IsAFK")) then
		local panel = container:AddRow("afk")
		panel:SetText(L("charAFK"))
		panel:SetBackgroundColor(Color(30, 30, 30, 255))
		panel:SizeToContents()
		panel:Dock(BOTTOM)
	end
end

function PLUGIN:HUDPaint()
	if ( LocalPlayer():GetNetVar("IsAFK") ) then
		draw.DrawText("You are AFK!", "ixTitleFont", ScrW() / 2, ScrH() / 4, Color(255, 0, 0), TEXT_ALIGN_CENTER)
	end
end