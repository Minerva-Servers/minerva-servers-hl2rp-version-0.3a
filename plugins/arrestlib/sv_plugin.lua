local PLUGIN = PLUGIN

util.AddNetworkString("ixArrestClientSync")

function PLUGIN:SaveArrestTerminals()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_arrestterminal")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel()}
    end

    ix.data.Set("arrestTerminals", data)
end

function PLUGIN:LoadArrestTerminals()
    for _, v in ipairs(ix.data.Get("arrestTerminals") or {}) do
        local arrestTerminals = ents.Create("ix_arrestterminal")

        arrestTerminals:SetPos(v[1])
        arrestTerminals:SetAngles(v[2])
        arrestTerminals:SetModel(v[3])
        arrestTerminals:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveArrestTerminals()
end

function PLUGIN:LoadData()
    self:LoadArrestTerminals()
end

ix.arrest.dragged = ix.arrest.dragged or {}
ix.arrest.prison = ix.arrest.prison or {}
ix.arrest.disconnectRemember = ix.arrest.disconnectRemember or {}

local function isEmpty(vector, ignore) // findpos and isEmpty are from darkrp
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

	return a and b
end

local function findEmptyPos(pos, ignore, distance, step, area)
    if isEmpty(pos, ignore) and isEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do // alternate in direction
            local k = j * i

            // Look North/South
            if isEmpty(pos + Vector(k, 0, 0), ignore) and isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            // Look East/West
            if isEmpty(pos + Vector(0, k, 0), ignore) and isEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            // Look Up/Down
            if isEmpty(pos + Vector(0, 0, k), ignore) and isEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end

util.AddNetworkString("ixOpenChargeMenu")
util.AddNetworkString("ixCombineTerminalCharge")

net.Receive("ixCombineTerminalCharge", function(len, ply)
    local chargesTable = net.ReadTable()
    local chargesTimeOriginal = net.ReadUInt(4)
	local chargesTime = net.ReadUInt(12) 
    local arrest = ( IsValid(ply.arrestedDragging) and ply.arrestedDragging )

    PrintTable(chargesTable)

    ply:Notify("You have jailed "..arrest:Nick().." for "..chargesTime.." seconds. With the reasons of: ")

    arrest:Jail(chargesTime)
end)

function PLUGIN:PlayerInitialSpawn(ply)
	local jailTime = ix.arrest.disconnectRemember[ply:SteamID()]

	if jailTime then
		ply:Arrest()
		ply:Jail(jailTime)
		ix.arrest.disconnectRemember[ply:SteamID()] = nil
	end
end

function PLUGIN:PlayerSpawn(ply)
	local cellID = ply.inJail

	if ply.inJail then
		local pos = ix.arrest.config["maps"][game.GetMap()]["prisonCells"][cellID]
		ply:SetPos(findEmptyPos(pos, {self}, 150, 30, Vector(16, 16, 64)))
		ply:SetEyeAngles(ix.arrest.config["maps"][game.GetMap()]["prisonAngle"])
		ply:Arrest()

		return
	end
	
	if ply:GetCharacter() and ply:GetCharacter():GetData("arrested", false) == true then
		ply:GetCharacter():SetData("arrested", false)
	end

	ply.arrestedWeapons = nil

	hook.Run("PlayerLoadout", ply)
end

function PLUGIN:KeyPress(ply, key)
	if key == IN_USE and not ply:InVehicle() then
		local trace = {}
		trace.start = ply:GetShootPos()
		trace.endpos = trace.start + ply:GetAimVector() * 96
		trace.filter = ply

		local entity = util.TraceLine(trace).Entity

		if IsValid(entity) and entity:IsPlayer() then
			if ply:CanArrest(entity) then
				if not entity.arrestedDragger then
					ply:DragPlayer(entity)
				else
					entity:StopDrag()
				end
			end
		end
	end
end

function PLUGIN:SetupMove(ply, mvData)
	if IsValid(ply.arrestedDragging) then
		mvData:SetMaxClientSpeed(80)
	end
end

function PLUGIN:Think()
	for v,k in pairs(ix.arrest.dragged) do
		if not IsValid(v) then
			ix.arrest.dragged[v] = nil
			continue
		end

		local dragger = v.arrestedDragger

		if IsValid(dragger) then
			if (dragger:GetPos() - v:GetPos()):LengthSqr() >= (175 ^ 2) then
				v:StopDrag()
			end
		else
			v:StopDrag()
		end
	end
end

function PLUGIN:StartCommand(ply, cmd)
	local dragger = ply.arrestedDragger

	if IsValid(dragger) and ply == dragger.arrestedDragging and ply:Alive() and dragger:Alive() then
		cmd:ClearMovement()
		cmd:ClearButtons()

		if ply:GetPos():DistToSqr(dragger:GetPos()) > (60 ^ 2) then
			cmd:SetForwardMove(200)
		end

		cmd:SetViewAngles((dragger:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle())
	end
end

local meta = FindMetaTable("Player")

util.AddNetworkString("ixSendJailInfo")

function meta:Arrest()
	self.arrestedWeapons = {}
	for v,k in pairs(self:GetWeapons()) do
		self.arrestedWeapons[k:GetClass()] = true
	end

	self:StripWeapons()
	self:StripAmmo()

	self:Give("ix_hands")
	self:SelectWeapon("ix_hands")
	self:SetHandsBehindBack(true)

	self:GetCharacter():SetData("arrested", true)
end

function meta:UnArrest()
	self:GetCharacter():SetData("arrested", false)

	if self.arrestedWeapons then
		for v,k in pairs(self.arrestedWeapons) do
			self:Give(v)
		end

		self.arrestedWeapons = nil
	end

	self:SetHandsBehindBack(false)
	self:SelectWeapon("ix_hands")
	self:StopDrag()
	self:StripAmmo()
end

function meta:DragPlayer(ply)
	if self:CanArrest(ply) and ply:IsArrested() then
		ply.arrestedDragger = self
		self.arrestedDragging = ply
		ix.arrest.dragged[ply] = true

		self:Say("/me starts dragging "..ply:Nick()..".")
	end
end

function meta:StopDrag()
	ix.arrest.dragged[self] = nil

	local dragger = self.arrestedDragger

	if IsValid(dragger) then
		dragger:Say("/me stops dragging "..dragger.arrestedDragging:Nick()..".")
		dragger.arrestedDragging = nil
	end
	
	self.arrestedDragger = nil
end

function meta:SendJailInfo(time, jailData)
	net.Start("ixSendJailInfo")
	net.WriteUInt(time, 16)
	
	if jailData then
		net.WriteBool(true)
		net.WriteTable(jailData)
	else
		net.WriteBool(false)
	end

	net.Send(self)
end

function meta:Jail(time, jailData)
	local doCellMates = false
	local pos
	local cellID

	if self.inJail then
		return
	end

	if table.Count(ix.arrest.prison) >= table.Count(ix.arrest.config["maps"][game.GetMap()]["prisonCells"]) then
		doCellMates = true
	end

	if self:GetCharacter() and not self:GetCharacter():GetData("arrested", false) then
		self:Arrest()
	end

	for v,k in pairs(ix.arrest.config["maps"][game.GetMap()]["prisonCells"]) do
		local cellData = ix.arrest.prison[v]
		
		if cellData and not doCellMates then // if something is assigned to this cell
			continue
		end

		pos = k
		cellID = v
		
		if doCellMates then
			local cell = ix.arrest.prison[v]
			cell[self:EntIndex()] = {
				inmate = self,
				jailData = jailData,
				duration = time,
				start = CurTime()
			} 

			break
		else
			ix.arrest.prison[v] = {}
			ix.arrest.prison[v][self:EntIndex()] = {
				inmate = self,
				jailData = jailData,
				duration = time,
				start = CurTime()
			}

			break
		end
	end

	if pos then
		self:SetPos(findEmptyPos(pos, {self}, 100, 30, Vector(16, 16, 64)))
		self:SetEyeAngles(ix.arrest.config["maps"][game.GetMap()]["prisonAngle"])

		for k, v in pairs(self:GetCharacter():GetInventory():GetItems()) do
			if ( v:GetData("equip") ) then
				v:SetData("equip", nil)
			end
			v:Remove()
		end
		
		self.carryWeapons = {}

		self:Notify("You have been imprisoned for "..(time / 60).." minutes.")
		self:SendJailInfo(time, jailData)
		self.inJail = cellID

		net.Start("ixArrestClientSync")
			net.WriteUInt(time, 32)
		net.Send(self)
		
		timer.Create(self:UserID().."ixPrison", time, 1, function()
			if IsValid(self) and self.inJail then
				self:UnJail()
			end
		end)
	end
end

function meta:UnJail()
	ix.arrest.prison[self.inJail][self:EntIndex()] = nil
	self.inJail = nil

	if self.JailEscaped then
		self.JailEscaped = false
		return
	end

	if self:Alive() then
		self:Spawn()
	end
	
	self:UnArrest()

	self:Notify("You have been released from prison as your sentence has ended.")

	hook.Run("PlayerUnJailed", self)
end