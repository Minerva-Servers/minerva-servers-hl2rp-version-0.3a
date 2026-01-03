
local PLUGIN = PLUGIN

PLUGIN.name = "Squads"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds joinable squads to the tab menu."
PLUGIN.schema = "HL2 RP"
PLUGIN.license = [[
Copyright 2020 wowm0d
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
]]
PLUGIN.readme = [[
Adds joinable protection teams for combine to join from the tab menu.

---

> The Squad menu automatically updates whenever a Squad action occurs. ex: Squad Creation, Squad Joined, etc...
It is possible to modify the plugin to suit your schema, however by default it works OOTB with HL2 RP.

There are client & server hooks ran after any Squad action:
- PLUGIN:OnCreateSquad(client, index)
- PLUGIN:OnReassignSquad(index, newIndex)
- PLUGIN:OnSetSquadOwner(client, index)
- PLUGIN:OnDeleteSquad(index)
- PLUGIN:OnJoinSquad(client, index)
- PLUGIN:OnLeaveSquad(client, index)

There are also player variables set on client & server:
- LocalPlayer().curSquad & client.curSquad -- team index
- LocalPlayer().isSquadOwner & client.isSquadOwner -- bool

## Preview
![Menu](https://i.imgur.com/YkPh2zr.png)

If you like this plugin and want to see more consider getting me a coffee. https://ko-fi.com/wowm0d

Support for this plugin can be found here: https://discord.gg/mntpDMU
]]

PLUGIN.teams = {}

function PLUGIN:GetReceivers()
	local recievers = {}

	for _, client in pairs(player.GetAll()) do
		if (client:IsOW()) then
			table.insert(recievers, client)
		end
	end

	return recievers
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

ix.chat.Register("squadradio", {
    description = "",
    prefix = {"/SquadRadio", "/SR"},
    font = "ixRadioFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(21, 56, 146),
    CanSay = function(self, speaker, text)
        return speaker:IsCombine() and speaker.curSquad
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end

        chat.AddText(Color(21, 56, 146), "[SQUAD-RADIO] "..speaker:Nick().." <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return speaker.curSquad == receiver.curSquad
    end,
})

ix.command.Add("SquadCreate", {
	description = "@cmdSquadCreate",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, index)
		if (!client:IsOW()) then
			return "@CannotUseSquadCommands"
		end

		if (!index) then
			return client:RequestString("@cmdSquadCreate", "@cmdCreateSquadDesc", function(text) ix.command.Run(client, "SquadCreate", {text}) end, "")
		end

		return PLUGIN:CreateSquad(client, index)
	end
})

ix.command.Add("SquadJoin", {
	description = "@cmdSquadJoin",
	arguments = ix.type.number,
	OnRun = function(self, client, index)
		if (!client:IsOW()) then
			return "@CannotUseSquadCommands"
		end

		return PLUGIN:JoinSquad(client, index)
	end
})

ix.command.Add("SquadLeave", {
	description = "@cmdSquadLeave",
	OnRun = function(self, client)
		if (!client:IsOW()) then
			return "@CannotUseSquadCommands"
		end

		return PLUGIN:LeaveSquad(client)
	end
})

ix.command.Add("SquadLead", {
	description = "@cmdSquadLead",
	arguments = bit.bor(ix.type.player, ix.type.optional),
	OnRun = function(self, client, target)
		if (!client:IsOW()) then
			return "@CannotUseSquadCommands"
		end

		if (target == client or !target) then
			target = client
		end

		local index = target.curSquad

		if (!PLUGIN.teams[index]) then return "@TargetNoCurrentSquad" end

		if (!client:IsOWCommand()) then
			if (client.curSquad != target.curSquad) then return "@TargetNotSameSquad" end

			if (PLUGIN.teams[index]["owner"]) then
				if (target == client) then return "@SquadAlreadyHasOwner" end
				if (!client.isSquadOwner) then return "@CannotPromoteSquadMembers" end
			end
		end

		if (target == client or !target) then
			if (PLUGIN:SetSquadOwner(index, target)) then
				return "@SquadOwnerAssume"
			end
		end

		return PLUGIN:SetSquadOwner(index, target)
	end
})

ix.command.Add("SquadKick", {
	description = "@cmdSquadKick",
	arguments = ix.type.player,
	OnRun = function(self, client, target)
		if (!client:IsOW()) then
			return "@CannotUseSquadCommands"
		end

		local index = target.curSquad

		if (!PLUGIN.teams[index]) then return "@TargetNoCurrentSquad" end

		if (client.curSquad != target.curSquad and !client:IsOWCommand()) then return "@TargetNotSameSquad" end

		if (!client.isSquadOwner and !client:IsOWCommand()) then return "@CannotKickSquadMembers" end

		PLUGIN:LeaveSquad(target)

		return "@KickedFromSquad", target:GetName()
	end
})

ix.command.Add("SquadReassign", {
	description = "@cmdSquadReassign",
	arguments = {bit.bor(ix.type.number, ix.type.optional), bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function(self, client, newIndex, oldIndex)
		if (!client:IsOW()) then
			return "@CannotUseSquadCommands"
		end

		local index = client.curSquad

		if (!oldIndex and index) then
			oldIndex = index
		end

		if (!client:IsOWCommand()) then
			if (!PLUGIN.teams[oldIndex]) then return "@NoCurrentSquad" end
			if (!client.isSquadOwner) then return "@CannotReassignSquadIndex" end
		end

		if (newIndex and oldIndex) then
			return PLUGIN:ReassignSquad(oldIndex, newIndex)
		else
			return client:RequestString("@cmdSquadReassign", "@cmdReassignSquadDesc", function(text) ix.command.Run(client, "SquadReassign", {text, oldIndex}) end, "")
		end
	end
})
