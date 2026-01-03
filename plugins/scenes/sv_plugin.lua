local PLUGIN = PLUGIN

function PLUGIN:SetupPlayerVisibility(ply)
	if ( ply.extraPVS ) then
		AddOriginToPVS(ply.extraPVS)
	end

	if ( ply.extraPVS2 ) then
		AddOriginToPVS(ply.extraPVS2)
	end
end

util.AddNetworkString("ixScenePVS")
net.Receive("ixScenePVS", function(len, ply)
	if ( ply.nextPVSTry or 0 ) > CurTime() then return end
	ply.nextPVSTry = CurTime() + 1

	--if ( ply:Team() == 0 or ply.allowPVS ) then
		local pos = net.ReadVector()
		local last = ply.lastPVS or 1

		if ( last == 1 ) then
			ply.extraPVS = pos
			ply.lastPVS = 2
		else
			ply.extraPVS2 = pos
			ply.lastPVS = 1
		end

		timer.Simple(1.33, function()
			if not ( IsValid(ply) ) then
				return
			end

			if ( last == 1 ) then
				ply.extraPVS2 = nil
			else
				ply.extraPVS = nil
			end
		end)
	--end
end)

util.AddNetworkString("ixSceneWipePVS")
net.Receive("ixSceneWipePVS", function(len, ply)
	ply.extraPVS2 = nil
	ply.extraPVS = nil
end)