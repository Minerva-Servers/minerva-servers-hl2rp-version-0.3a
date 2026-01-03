local PANEL = {}
function PANEL:Init()
	local panel = self

	self.scrollpanel = self:Add("DScrollPanel")
	self.scrollpanel:Dock(FILL)

	self.setting = {}

	for k, v in SortedPairs(ix.arrest.config["arrestCharges"]) do
		self:AddCharge(k, v)
	end

	self.sentencebutton = panel:Add("ixCombineButton")
    self.sentencebutton:SetFont("ixCombineButtonFont")
    self.sentencebutton:SetText("RETURN")
	self.sentencebutton:Dock(BOTTOM)
    self.sentencebutton:SetTall(150)
	self.sentencebutton:SetText("ARREST (CHARGES: 0 | CYCLES: 0)")

	self.sentencebutton.DoClick = function()
		local chargecount = 0
		local charges = {}
		local chargestimeoriginal = 0
		local chargestime = 0

		for k, v in pairs(panel.setting) do
			table.insert(charges, k)
			chargestimeoriginal = chargestimeoriginal + ix.arrest.config["arrestCharges"][k].severity
			chargestime = 60 * ix.arrest.config["arrestCharges"][k].severity
			chargecount = chargecount + 1
		end

		if (chargecount > 0) and (chargecount < 5) then
			net.Start("ixCombineTerminalCharge")
				net.WriteTable(charges)
				net.WriteUInt(chargestimeoriginal, 4)
				net.WriteUInt(chargestime, 12)
			net.SendToServer()
		else
			if (chargecount > 4) then
				LocalPlayer():Notify("You cannot select too many charges!")
			elseif (chargecount == 0) then
				LocalPlayer():Notify("You must atleast select one resonable charge!")
			end
		end

        surface.PlaySound("buttons/combine_button1.wav")
	end
end

function PANEL:AddCharge(chargeid, data)
	local panel = self

	local chargesetting = self.scrollpanel:Add("ixSettingsRowBool")
	chargesetting:SetText(data.name)
	chargesetting:SizeToContents()
	chargesetting:Dock(TOP)
	chargesetting:DockMargin(4, 4, 1, 1)
	chargesetting.chargeID = chargeid

	function chargesetting:OnValueChanged(value)
		if value then
			panel.setting[self.chargeID] = value
		else
			panel.setting[self.chargeID] = nil
		end

		self.value = value

		local chargecount = 0
		local timecount = 0

		for k, v in pairs(panel.setting) do
			timecount = timecount + ix.arrest.config["arrestCharges"][k].severity
			chargecount = chargecount + 1
		end

		panel.sentencebutton:SetText("ARREST (CHARGES: "..chargecount.." | CYCLES: "..math.Clamp(timecount, 0, 999)..")")
	end

	/*
	function chargesetting:Think()
		if not chargesetting.value and table.Count(panel.setting) >= ix.arrest.config["maxArrestCharges"] then
			self:SetDisabled(true)
		else
			self:SetDisabled(false)
		end
	end
	*/
end

vgui.Register("ixChargesMenu", PANEL, "Panel")