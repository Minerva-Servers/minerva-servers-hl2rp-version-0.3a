
local PLUGIN = PLUGIN

util.AddNetworkString("ixSquadSync")
util.AddNetworkString("ixSquadCreate")
util.AddNetworkString("ixSquadDelete")
util.AddNetworkString("ixSquadJoin")
util.AddNetworkString("ixSquadLeave")
util.AddNetworkString("ixSquadOwner")
util.AddNetworkString("ixSquadReassign")

function PLUGIN:CreateSquad(client, index, bNetworked)
	if (IsValid(client) and client.curSquad) then
		return "@AlreadyHasSquad"
	end

	if (self.teams[index]) then
		return "@SquadAlreadyExists", tostring(index)
	end

	if (index > 99 or index < 1) then
		return "@SquadMustClamp"
	end

	self.teams[index] = {
		owner = client,
		members = {client}
	}

	if (IsValid(client)) then
		client.curSquad = index
		client.isSquadOwner = true
	end

	if (!bNetworked) then
		net.Start("ixSquadCreate")
			net.WriteUInt(index, 8)
			net.WriteEntity(client)
		net.Send(self:GetReceivers())
	end

	hook.Run("OnCreateSquad", client, index)

	return "@SquadCreated", tostring(index)
end

function PLUGIN:ReassignSquad(index, newIndex, bNetworked)
	if (newIndex > 99 or newIndex < 1) then
		return "@SquadMustClamp"
	end

	if (self.teams[newIndex]) then
		return "@SquadAlreadyExists", tostring(index)
	end

	local curSquad = self.teams[index]

	self:DeleteSquad(index, true)

	self:CreateSquad(curSquad["owner"], newIndex, true)

	self.teams[newIndex]["members"] = curSquad["members"]

	for _, client in pairs(curSquad["members"]) do
		client.curSquad = newIndex
	end

	if (!bNetworked) then
		net.Start("ixSquadReassign")
			net.WriteUInt(index, 8)
			net.WriteUInt(newIndex, 8)
		net.Send(self:GetReceivers())
	end

	hook.Run("OnReassignSquad", index, newIndex)

	return "@SquadReassigned", tostring(index), tostring(newIndex)
end

function PLUGIN:SetSquadOwner(index, client, bNetworked)
	local curOwner = self.teams[index]["owner"]

	if (IsValid(curOwner)) then
		curOwner.isSquadOwner = nil
	end

	self.teams[index]["owner"] = client

	if (IsValid(client)) then
		client.isSquadOwner = true
	end

	if (!bNetworked) then
		net.Start("ixSquadOwner")
			net.WriteUInt(index, 8)
			net.WriteEntity(client)
		net.Send(self:GetReceivers())
	end

	hook.Run("OnSetSquadOwner", client, index)

	if (IsValid(client)) then
		return "@SquadOwnerSet", client:GetName()
	end
end

function PLUGIN:DeleteSquad(index, bNetworked)
	self.teams[index] = nil

	for _, client in pairs(self:GetReceivers()) do
		if (client.curSquad == index) then
			client.curSquad = nil

			if (client.isSquadOwner) then
				client.isSquadOwner = nil
			end
		end
	end

	if (!bNetworked) then
		net.Start("ixSquadDelete")
			net.WriteUInt(index, 8)
		net.Send(self:GetReceivers())
	end

	hook.Run("OnDeleteSquad", index)
end

function PLUGIN:JoinSquad(client, index, bNetworked)
	if (client.curSquad) then
		return "@SquadMustLeave"
	end

	if (index > 99 or index < 1) then
		return "@SquadMustClamp"
	end

	if (!self.teams[index]) then
		return "@SquadNonExistent", tostring(index)
	end

	table.insert(self.teams[index]["members"], client)

	client.curSquad = index

	if (!bNetworked) then
		net.Start("ixSquadJoin")
			net.WriteUInt(index, 8)
			net.WriteEntity(client)
		net.Send(self:GetReceivers())
	end

	hook.Run("OnJoinSquad", client, index)

	return "@JoinedSquad", index
end

function PLUGIN:LeaveSquad(client, bNetworked)
	if (!client.curSquad) then
		return "@NoCurrentSquad"
	end

	local index = client.curSquad
	local curSquad = self.teams[index]

	if (curSquad) then
		table.RemoveByValue(self.teams[index]["members"], client)

		client.curSquad = nil

		if (!bNetworked) then
			net.Start("ixSquadLeave")
				net.WriteUInt(index, 8)
				net.WriteEntity(client)
			net.Send(self:GetReceivers())
		end

		if (client.isSquadOwner) then
			self:SetSquadOwner(index, nil)
		end

		hook.Run("OnLeaveSquad", client, index)

		return "@LeftSquad", index
	end
end
