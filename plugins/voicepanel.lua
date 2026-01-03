PLUGIN.name = "Voice Overlay"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "This plugin makes voice overlay clear and look nice (really?)"

if (CLIENT) then
	local PANEL = {}
	local ixVoicePanels = {}

	function PANEL:Init()
		self.Model = vgui.Create("ixSpawnIcon", self)
		self.Model:Dock(LEFT)
		self.Model:DockMargin(0, 0, 0, 0)
		self.Model:SetModel("models/error.mdl")
		self.Model:SetWide(50)

		self.LabelName = vgui.Create("DLabel", self)
		self.LabelName:SetFont("ixMediumFont")
		self.LabelName:Dock(FILL)
		self.LabelName:DockMargin(8, 0, 0, 0)
		self.LabelName:SetTextColor(color_white)

		self.Color = color_transparent

		self:SetSize(ScrW() / 5, 50)
		self:DockMargin(0, 2, 0, 2)
		self:Dock(BOTTOM)
	end

	function PANEL:Setup(client)
		self.client = client
		self.name = hook.Run("ShouldAllowScoreboardOverride", client, "name") and hook.Run("GetDisplayedName", client) or client:Nick()
		self.Model:SetModel(client:GetModel())
		local entity = self.Model.Entity
	
		if ( IsValid(self.Model) ) then
			for k, v in ipairs(client:GetBodyGroups()) do
				entity:SetBodygroup(v.id, client:GetBodygroup(v.id))
			end
		end

		self.LabelName:SetText(self.name)
		self:InvalidateLayout()
	end

	function PANEL:Paint(w, h)
		if (!IsValid(self.client)) then return end

        ix.util.DrawBlur(self, 1)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(ix.config.Get("color"), 25))
        draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))

		surface.SetDrawColor(ColorAlpha(team.GetColor(self.client:Team()) or color_white, self.client:VoiceVolume() * 225))
		surface.DrawRect(0, 0, w, h)
	end

	function PANEL:Think()
		if (IsValid(self.client)) then
			self.Model:SetModel(self.client:GetModel(), self.client:GetSkin() or 0)
			local entity = self.Model.Entity
		
			if ( IsValid(self.Model) ) then
				for k, v in ipairs(self.client:GetBodyGroups()) do
					entity:SetBodygroup(v.id, self.client:GetBodygroup(v.id))
				end
			end

			self.LabelName:SetText(self.name)
		end

		if (self.fadeAnim) then
			self.fadeAnim:Run()
		end
	end

	function PANEL:FadeOut(anim, delta, data)
		if (anim.Finished) then
			if (IsValid(ixVoicePanels[self.client])) then
				ixVoicePanels[self.client]:Remove()
				ixVoicePanels[self.client] = nil
				return
			end
		return end

		self:SetAlpha(255 - (255 * (delta * 2)))
	end

	vgui.Register("VoicePanel", PANEL, "DPanel")

	function PLUGIN:PlayerStartVoice(client)
		if not ( ix.option.Get("showVoiceBoxes", true) ) then
			return
		end

		if ( ix_hidevoiceboxes ) then
			return
		end

		if (!IsValid(ixVoicePanelList) or !ix.config.Get("allowVoice", false)) then return end

		hook.Run("PlayerEndVoice", client)

		if (IsValid(ixVoicePanels[client])) then
			if (ixVoicePanels[client].fadeAnim) then
				ixVoicePanels[client].fadeAnim:Stop()
				ixVoicePanels[client].fadeAnim = nil
			end

			ixVoicePanels[client]:SetAlpha(255)

			return
		end

		if (!IsValid(client)) then return end

		local pnl = ixVoicePanelList:Add("VoicePanel")
		pnl:Setup(client)

		ixVoicePanels[client] = pnl
	end

	local function VoiceClean()
		for k, v in pairs(ixVoicePanels) do
			if (!IsValid(k)) then
				hook.Run("PlayerEndVoice", k)
			end
		end
	end
	timer.Create("VoiceClean", 10, 0, VoiceClean)

	function PLUGIN:PlayerEndVoice(client)
		if (IsValid(ixVoicePanels[client])) then
			if (ixVoicePanels[client].fadeAnim) then return end

			ixVoicePanels[client].fadeAnim = Derma_Anim("FadeOut", ixVoicePanels[client], ixVoicePanels[client].FadeOut)
			ixVoicePanels[client].fadeAnim:Start(0)
		end
	end

	local function CreateVoiceVGUI()
		gmod.GetGamemode().PlayerStartVoice = function() end
		gmod.GetGamemode().PlayerEndVoice = function() end

		if (IsValid(ixVoicePanelList)) then
			ixVoicePanelList:Remove()
		end

		ixVoicePanelList = vgui.Create("DPanel")

		ixVoicePanelList:ParentToHUD()
		ixVoicePanelList:SetSize(ScrW() / 5, ScrH() - 200)
		ixVoicePanelList:SetPos(ScrW() - ScrW() / 5, 100)
		ixVoicePanelList:SetPaintBackground(false)
	end

	hook.Add("InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI)
end