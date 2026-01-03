
local PLUGIN = PLUGIN

function PLUGIN:UpdateSquadMenu()
	if (IsValid(ix.gui.teams) and IsValid(ix.gui.menu)) then
		local subpanel = nil
		local tabs = {}
		hook.Run("CreateMenuButtons", tabs)

		for k, v in pairs(ix.gui.menu.subpanels) do
			if v.subpanelName == "tabSquad" then
				subpanel = v
				break
			end
		end

		if (ix.gui.teams:IsVisible() and ix.gui.menu:GetActiveTab() == "tabSquad") then
			ix.gui.teams:Remove()
			tabs["tabSquad"](ix.gui.menu:GetActiveSubpanel())
		elseif (subpanel) then
			ix.gui.teams:Remove()
			tabs["tabSquad"](subpanel)
		end
	end
end

function PLUGIN:CreateSquad(client, index)
	self.teams[index] = {
		owner = client,
		members = {client}
	}

	client.curSquad = index
	client.isSquadOwner = true

	hook.Run("OnCreateSquad", client, index)
end

function PLUGIN:ReassignSquad(index, newIndex)
	local curSquad = self.teams[index]

	self:DeleteSquad(index)

	self:CreateSquad(curSquad["owner"], newIndex)

	self.teams[newIndex]["members"] = curSquad["members"]

	for _, client in pairs(curSquad["members"]) do
		client.curSquad = newIndex
	end

	hook.Run("OnReassignSquad", index, newIndex)
end

function PLUGIN:DeleteSquad(index)
	self.teams[index] = nil

	for _, client in pairs(self:GetReceivers()) do
		if (client.curSquad == index) then
			client.curSquad = nil

			if (client.isSquadOwner) then
				client.isSquadOwner = nil
			end
		end
	end

	hook.Run("OnDeleteSquad", index)
end

function PLUGIN:LeaveSquad(client, index)
	table.RemoveByValue(self.teams[index]["members"], client)

	client.curSquad = nil

	hook.Run("OnLeaveSquad", client, index)
end

function PLUGIN:JoinSquad(client, index)
	table.insert(self.teams[index]["members"], client)

	client.curSquad = index

	hook.Run("OnJoinSquad", client, index)
end

function PLUGIN:SetSquadOwner(index, client)
	local curOwner = self.teams[index]["owner"]

	if (IsValid(curOwner)) then
		curOwner.isSquadOwner = nil
	end

	self.teams[index]["owner"] = client

	if (IsValid(client)) then
		client.isSquadOwner = true
	end

	hook.Run("OnSetSquadOwner", client, index)
end
