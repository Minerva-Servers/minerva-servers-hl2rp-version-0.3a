
local PLUGIN = PLUGIN

function PLUGIN:OnCreateSquad(client, index)
	self:UpdateSquadMenu()
end

function PLUGIN:OnReassignSquad(index, newIndex)
	self:UpdateSquadMenu()
end

function PLUGIN:OnDeleteSquad(index)
	self:UpdateSquadMenu()
end

function PLUGIN:OnLeaveSquad(client, index)
	self:UpdateSquadMenu()
end

function PLUGIN:OnJoinSquad(client, index)
	self:UpdateSquadMenu()
end

function PLUGIN:OnSetSquadOwner(client, index)
	self:UpdateSquadMenu()
end

function PLUGIN:PopulateCharacterInfo(client, character, container)
	if (LocalPlayer():IsOW() and client.curSquad) then
		local curSquad = container:AddRowAfter("name", "curSquad")
		curSquad:SetText(L("SquadStatus", client.curSquad, client.isSquadOwner and L("SquadOwnerStatus") or L("SquadMemberStatus")))
		curSquad:SetBackgroundColor(client.isSquadOwner and Color(50,200,50) or Color(50,100,150))
	end
end

net.Receive("ixSquadSync", function()
	local bSquads = net.ReadBool()

	if (!bSquads) then
		PLUGIN.teams = {}

		for _, client in pairs(player.GetAll()) do
			client.curSquad = nil
			client.isSquadOwner = nil
		end

		return
	end

	local teams = net.ReadTable()

	PLUGIN.teams = teams

	for index, teamTbl in pairs(teams) do
		for _, client in pairs(teamTbl["members"]) do
			client.curSquad = index
		end

		local owner = teamTbl["owner"]

		if (IsValid(owner)) then
			owner.isSquadOwner = true
		end
	end
end)

net.Receive("ixSquadCreate", function()
	local index = net.ReadUInt(8)
	local client = net.ReadEntity()

	PLUGIN:CreateSquad(client, index)
end)

net.Receive("ixSquadDelete", function()
	local index = net.ReadUInt(8)

	PLUGIN:DeleteSquad(index)
end)

net.Receive("ixSquadLeave", function()
	local index = net.ReadUInt(8)
	local client = net.ReadEntity()

	PLUGIN:LeaveSquad(client, index)
end)

net.Receive("ixSquadJoin", function()
	local index = net.ReadUInt(8)
	local client = net.ReadEntity()

	PLUGIN:JoinSquad(client, index)
end)

net.Receive("ixSquadOwner", function()
	local index = net.ReadUInt(8)
	local client = net.ReadEntity()

	PLUGIN:SetSquadOwner(index, client)
end)

net.Receive("ixSquadReassign", function()
	local index = net.ReadUInt(8)
	local newIndex = net.ReadUInt(8)

	PLUGIN:ReassignSquad(index, newIndex)
end)
