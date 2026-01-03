
local PLUGIN = PLUGIN

function PLUGIN:Tick()
	local curTime = CurTime()

	if (!self.tick or self.tick < curTime) then
		self.tick = curTime + 30

		for index, teamTbl in pairs(self.teams) do
			if (table.IsEmpty(teamTbl["members"])) then
				self:DeleteSquad(index)
			end
		end
	end
end

function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
	if (character:IsOW()) then
		net.Start("ixSquadSync")
			net.WriteBool(true)
			net.WriteTable(self.teams)
		net.Send(client)
	else
		if (client.curSquad) then
			self:LeaveSquad(client)
		end

		net.Start("ixSquadSync")
			net.WriteBool(false)
		net.Send(client)
	end
end

function PLUGIN:PlayerChangedSquad(client)
	if (client.curSquad) then
		self:LeaveSquad(client)
	end
end

function PLUGIN:PlayerDisconnected(client)
	if (client.curSquad) then
		self:LeaveSquad(client)
	end
end
