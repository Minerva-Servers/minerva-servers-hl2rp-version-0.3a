local PLUGIN = PLUGIN

local entMeta = FindMetaTable("Entity")

function entMeta:RepairCombineCamera()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local values = self:GetKeyValues()

	self:Remove()

	local new = ents.Create("npc_combine_camera")
	new:SetPos(pos)
	new:SetAngles(ang)
	new:Spawn()
	new:Activate()

	new:SetKeyValue("innerradius", values.outerradius)
	new:SetKeyValue("outerradius", values.outerradius)

	new:Fire("addoutput", "OnFoundPlayer __cctvhook:cctv:OnFoundPlayer:0:-1")

	return new
end

function PLUGIN:SaveTerminals()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_combineterminal")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel()}
    end

    ix.data.Set("terminals", data)
end

function PLUGIN:LoadTerminals()
    for _, v in ipairs(ix.data.Get("terminals") or {}) do
        local terminals = ents.Create("ix_combineterminal")

        terminals:SetPos(v[1])
        terminals:SetAngles(v[2])
        terminals:SetModel(v[3])
        terminals:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveTerminals()
end

function PLUGIN:LoadData()
    self:LoadTerminals()
end

util.AddNetworkString("ixCombineTerminalOpen")
util.AddNetworkString("ixCombineTerminalSync")
util.AddNetworkString("ixCombineTerminalMarkBOL")
util.AddNetworkString("ixCombineTerminalMarkDefunct")
util.AddNetworkString("ixCombineTerminalUnMarkDefunct")
util.AddNetworkString("ixCombineTerminalMarkInformant")
util.AddNetworkString("ixCombineTerminalUnmarkInformant")
util.AddNetworkString("ixCombineTerminalCameraSwitch")

net.Receive("ixCombineTerminalMarkBOL", function(len, ply)
    if not ( ply:IsCombine() and ply:IsCombineCommand() ) then
        return
    end

    local target = net.ReadEntity()
    local reason = net.ReadString()

    target:GetCharacter():SetBol(true)
    target:GetCharacter():SetBolReason(reason)

    ply:Notify("Successfully marked "..target:Nick().." as a BOL.")
end)

net.Receive("ixCombineTerminalMarkDefunct", function(len, ply)
    if not ( ply:IsCombine() and ply:IsCombineCommand() ) then
        return
    end

    local target = net.ReadEntity()

    target:GetCharacter():SetDefunct(true)

    ply:Notify("Successfully marked "..target:Nick().." as Defunct.")
end)

net.Receive("ixCombineTerminalUnMarkDefunct", function(len, ply)
    if not ( ply:IsCombine() and ply:IsCombineCommand() ) then
        return
    end

    local target = net.ReadEntity()

    target:GetCharacter():SetDefunct(false)

    ply:Notify("Successfully un-marked "..target:Nick().." as Defunct.")
end)

net.Receive("ixCombineTerminalMarkInformant", function(len, ply)
    if not ( ply:IsCombine() and ply:IsCombineCommand() ) then
        return
    end

    local target = net.ReadEntity()

    target:GetCharacter():SetInformant(true)

    ply:Notify("Successfully marked "..target:Nick().." as an Informant.")
end)

net.Receive("ixCombineTerminalUnmarkInformant", function(len, ply)
    if not ( ply:IsCombine() and ply:IsCombineCommand() ) then
        return
    end

    local target = net.ReadEntity()

    target:GetCharacter():SetInformant(false)

    ply:Notify("Successfully unmarked "..target:Nick().." from Informant.")
end)

net.Receive("ixCombineTerminalCameraSwitch", function(len, ply)
    local option = net.ReadString()
    local ent = net.ReadEntity()

    if ( option == "Disable" ) then
        ent:SetNWEntity("camera", ent)
        ent:EmitSound("minerva/hl2rp/miscellaneous/combineui/warning.wav", 60, 80)
    else
        local camID = string.sub(option, string.len("View C-i") + 1)
        local combineCamera = Entity(camID)

        if ( IsValid(combineCamera) and combineCamera:GetClass() == "npc_combine_camera" ) then
            ent:SetNWEntity("camera", combineCamera)
            ent:EmitSound("minerva/hl2rp/miscellaneous/combineui/warning.wav", 60)
        end
    end
end)

function PLUGIN:DoPlayerDeath(ply, attacker)
    if not ( ply:IsCombine() ) then
        ply:GetCharacter():SetBol(false)
        ply:GetCharacter():SetBolReason(nil)
        ply:GetCharacter():SetDefunct(false)
        ply:GetCharacter():SetInformant(false)

        return
    end
end

// ported from cto, credits to aspect
util.AddNetworkString("UpdateBiosignalCameraData")

PLUGIN.cameraData = PLUGIN.cameraData or {}

function PLUGIN:SafelyPrepareCamera(combineCamera)
	if (!IsValid(self.outputEntity)) then
		self.outputEntity = ents.Create("base_entity")
		self.outputEntity:SetName("__ixCTOhook")

		function self.outputEntity:AcceptInput(inputName, activator, called, data)
			if (data == "OnFoundPlayer") then
				PLUGIN:CombineCameraFoundPlayer(called, activator)
			end
		end

		self.outputEntity:Spawn()
		self.outputEntity:Activate()
	end

	combineCamera:Fire("addoutput", "OnFoundPlayer __ixCTOhook:PLUGIN:OnFoundPlayer:0:-1")
	self.cameraData[combineCamera] = {}
end

function PLUGIN:CombineCameraFoundPlayer(combineCamera, client)
	if (self.cameraData[combineCamera] and client:GetMoveType() != MOVETYPE_NOCLIP) then
		if (!self.cameraData[combineCamera][client]) then
			self.cameraData[combineCamera][client] = {}
		end
	end
end

-- Yuck. No wonder Clockwork had low FPS, with plugins like these.
function PLUGIN:Tick()
    local curTime = CurTime()
    local networkedCameraData = {}

    if (!self.nextCameraTick or curTime >= self.nextCameraTick) then
        for combineCamera, data in pairs(self.cameraData) do
            if (!IsValid(combineCamera)) then
                self.cameraData[combineCamera] = nil
            elseif (self:IsCameraEnabled(combineCamera)) then
                local camPos = combineCamera:GetPos()

                for client, _ in pairs(data) do
                    if (!IsValid(client)) then
                        data[client] = nil
                    else
                        if (camPos:Distance(client:GetPos()) > 450 or !combineCamera:IsLineOfSightClear(client)) then
                            data[client] = nil
                        elseif (#data[client] < 1) then
                            local violations = {}

                            if (client:GetLocalVar("ragdoll")) then
                                violations[#violations + 1] = self.VIOLATION_FALLEN_OVER
                            end

                            if (client:Is647E()) then
                                violations[#violations + 1] = self.VIOLATION_647
                            end

                            if (#violations > 0) then
                                if not ( client:IsCombine() ) then
                                    data[client] = violations

                                    combineCamera:Fire("SetIdle")
                                    combineCamera:Fire("SetAngry")

                                    Schema:AddCombineDisplayMessage("Movement violation(s) sighted by C-i" .. combineCamera:EntIndex() .. "...", Color(255, 128, 0, 255))
                                end
                            end
                        end
                    end
                end

                networkedCameraData[combineCamera:EntIndex()] = data
            else
                networkedCameraData[combineCamera:EntIndex()] = 0
            end
        end

        local receivers = {}

        for _, player in ipairs(player.GetAll()) do
            if (player:IsCombine()) then
                receivers[#receivers + 1] = player
            end
        end

        net.Start("UpdateBiosignalCameraData")
            net.WriteTable(networkedCameraData)
        net.Send(receivers)

        self.nextCameraTick = curTime + 1
    end
end

function PLUGIN:OnEntityCreated(entity)
    if (entity:GetClass() == "npc_combine_camera") then
        if (self.cameraData[entity] == nil) then
            self:SafelyPrepareCamera(entity)
        end
    end
end

function PLUGIN:SetupPlayerVisibility(client)
    for _, terminal in pairs(ents.FindByClass("ix_combineterminal")) do
        local camera = terminal:GetNWEntity("camera")

        if (IsValid(camera) and client:IsLineOfSightClear(terminal)) then
            AddOriginToPVS(camera:GetPos() + Vector("0 0 -10"))
        end
    end
end

function PLUGIN:PlayerCanHearPlayersVoice( list, talk )
	if ( !talk:GetCharacter() ) then
		return
	end

	if ( !list:IsCombine() or !talk:IsCombine() ) then
		return
	end

	if ( talk.radioOn ) then
		return true
	end
end
