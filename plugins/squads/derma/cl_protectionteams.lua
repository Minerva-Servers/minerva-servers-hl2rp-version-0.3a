
local PLUGIN = PLUGIN

local backgroundColor = Color(0, 0, 0, 66)

local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.teams)) then
		ix.gui.teams:Remove()
	end

	ix.gui.teams = self

	self:Dock(FILL)

	self.teams = {}
	self.teamButtons = {}
	self.teamSubpanels = {}

	self.teamsPanel = self:Add("ixHelpMenuCategories")
	self.teamsPanel:SetWide(ScrW() * 0.2)
	self.teamsPanel.Paint = function(this, width, height)
		surface.SetDrawColor(backgroundColor)
		surface.DrawRect(0, 0, width, height)
	end

	self.teamButtonPanel = self.teamsPanel:Add("DScrollPanel")
	self.teamButtonPanel:Dock(FILL)

	self.canvasPanel = self:Add("EditablePanel")
	self.canvasPanel:Dock(FILL)

	local teams = {}
	hook.Run("PopulateSquadMenu", teams)

	for k, v in pairs(teams) do
		self:AddSquad(k)
		self.teams[k] = v
	end

	local createButton = self.teamsPanel:Add("ixMenuButton")
	createButton:SetText("tabCreateSquad")
	createButton:SizeToContents()
	createButton:SetZPos(-99)
	createButton:Dock(BOTTOM)
	createButton.DoClick = function()
		ix.command.Send("SquadCreate")
	end

	if (LocalPlayer().curSquad) then
		if (IsValid(createButton)) then
			createButton:Remove()
		end

		local leaveButton = self.teamsPanel:Add("ixMenuButton")
		leaveButton:SetText("tabLeaveSquad")
		leaveButton:SizeToContents()
		leaveButton:Dock(BOTTOM)
		leaveButton.DoClick = function()
			ix.command.Send("SquadLeave")
		end
	end

	if (self.teams[ix.gui.lastSquadMenuTab] or LocalPlayer().curSquad) then
		local lastTab = self.teams[ix.gui.lastSquadMenuTab] and ix.gui.lastSquadMenuTab or LocalPlayer().curSquad
		self:OnCategorySelected(lastTab)
	end
end

function PANEL:AddSquad(name)
	local button = self.teamButtonPanel:Add("ixMenuButton")
	button:SetText(L("SquadName", name))
	button:SetBackgroundColor(ix.config.Get("color"))
	button.backgroundAlpha = 255
	button:SizeToContents()
	button:Dock(TOP)
	button.DoClick = function(this)
		self:OnCategorySelected(name)
	end
	button.DoRightClick = function(this)
		if ((LocalPlayer().curSquad != name or !LocalPlayer().isSquadOwner) and !LocalPlayer():IsCombineCommand()) then return end

		local reassignMenu = DermaMenu(this)

		reassignMenu:AddOption(L("SquadReassign"), function()
			Derma_StringRequest(L("cmdSquadReassign"), L("cmdReassignSquadDesc"), name, function(text) ix.command.Send("SquadReassign", text, name) end)
		end)

		reassignMenu:Open()
		this.Menu = reassignMenu
	end

	local panel = self.canvasPanel:Add("DScrollPanel")
	panel:SetVisible(false)
	panel:Dock(FILL)

	-- reverts functionality back to a standard panel in the case that a category will manage its own scrolling
	panel.DisableScrolling = function()
		panel:GetCanvas():SetVisible(false)
		panel:GetVBar():SetVisible(false)
		panel.OnChildAdded = function() end
	end

	button.Paint = function(this, width, height)
		local alpha = panel:IsVisible() and this.backgroundAlpha or this.currentBackgroundAlpha
		surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), alpha))
		surface.DrawRect(0, 0, width, height)
	end

	self.teamSubpanels[name] = panel

	return button
end

function PANEL:OnCategorySelected(name)
	local panel = self.teamSubpanels[name]

	if (!IsValid(panel)) then
		return
	end

	if (!panel.bPopulated) then
		self.teams[name](panel)
		panel.bPopulated = true
	end

	if (IsValid(self.activeSquad)) then
		self.activeSquad:SetVisible(false)
	end

	panel:SetVisible(true)

	self.activeSquad = panel
	ix.gui.lastSquadMenuTab = name

	self:OnSquadSelected(name)
end

function PANEL:OnSquadSelected(index)
	if (LocalPlayer().curSquad != index and !LocalPlayer().curSquad) then
		if (IsValid(self.joinButton)) then
			self.joinButton:Remove()
		end

		self.joinButton = self.teamsPanel:Add("ixMenuButton")
		self.joinButton:SetText("tabJoinSquad")
		self.joinButton:SizeToContents()
		self.joinButton:Dock(BOTTOM)
		self.joinButton.DoClick = function(this)
			ix.command.Send("SquadJoin", index)
		end
	end
end

vgui.Register("ixSquadMenu", PANEL, "EditablePanel")

hook.Add("CreateMenuButtons", "ixSquadMenu", function(tabs)
	if (!LocalPlayer():IsOW()) then return end

	tabs["tabSquad"] = function(container)
		container:Add("ixSquadMenu")
	end
end)

hook.Add("PopulateSquadMenu", "ixSquadMenu", function(tabs)
	if (!PLUGIN.teams or table.IsEmpty(PLUGIN.teams)) then return end

	for k, v in pairs(PLUGIN.teams) do
		tabs[k] = function(container)
			container:DisableScrolling()

			local panel = container:Add("DScrollPanel")
			panel:Dock(FILL)

			local memberList = {}

			for k2, v2 in pairs(v["members"]) do
				if (v2.isSquadOwner) then
					memberList[#memberList + 1] = {
						client = v2,
						owner = 1
					}
				else
					memberList[#memberList + 1] = {
						client = v2,
						owner = 99
					}
				end
			end

			for k2, v2 in SortedPairsByMemberValue(memberList, "owner", false) do
				local member = panel:Add("ixMenuButton")
				member:SetFont("ixMenuButtonFont")
				member:SetText(v2.client:Name() or "Unknown")
				member:SizeToContents()
				member:Dock(TOP)
				member.Paint = function(this, width, height)
					derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, ColorAlpha(this.backgroundColor, this.currentBackgroundAlpha))
				end
				member.DoRightClick = function(this)
					if (!LocalPlayer():IsCombineCommand()) then
						if (!LocalPlayer().isSquadOwner or LocalPlayer().curSquad != k) then return end
					end

					local interactMenu = DermaMenu(this)
					local member = interactMenu:AddOption(v2.client:Name())
					member:SetContentAlignment(5)
					member.Paint = function(this, width, height) end

					local spacer = interactMenu:AddSpacer()
					spacer.Paint = function(this, width, height)
						surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
						surface.DrawRect( 0, 0, width, height )
					end

					interactMenu:AddOption(L("SquadTransferOwner"), function()
						ix.command.Send("SquadLead", v2.client:Name())
					end):SetIcon( "icon16/award_star_gold_1.png" )

					interactMenu:AddOption(L("SquadKickMember"), function()
						ix.command.Send("SquadKick", v2.client:Name())
					end):SetIcon( "icon16/cross.png" )

					interactMenu:Open()
					this.Menu = interactMenu
				end

				if (v2.client.isSquadOwner) then
					member.backgroundColor = Color(50,150,100)
				end
			end
		end
	end
end)
