util.AddNetworkString("ixSafeboxOpen")

function PLUGIN:PlayerLoadedCharacter(client)
	ix.safebox.Restore(client)
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_safebox")) do
		local motion = v:GetPhysicsObject()

		if (IsValid(motion)) then
			motion = motion:IsMotionEnabled()
		end

		data[#data + 1] = { v:GetPos(), v:GetAngles(), v:GetModel(), motion }
	end

	self:SetData(data)
	data = nil
end

function PLUGIN:LoadData()
	local data = self:GetData()

	if (data) then
		for _, v in ipairs(data) do
			local entity = ents.Create("ix_safebox")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
			entity:SetModel(v[3])
			entity:SetSolid(SOLID_VPHYSICS)
			entity:PhysicsInit(SOLID_VPHYSICS)

			local physObject = entity:GetPhysicsObject()

			if (IsValid(physObject)) then
				if (v[4] == false) then
					physObject:EnableMotion(false)
					physObject:Sleep()
				else
					physObject:EnableMotion(true)
				end
			end
		end
	end

	data = nil
end

function ix.safebox.Restore(client, callback)
	local character = client:GetCharacter()

	if (!character) then
		return
	end

	local index = character:GetData("safeboxID")
	local characterID = character:GetID()

	if (index) then
		local inventory = ix.inventory.Get(index)

		if (inventory) then
			inventory:Sync(client)
			inventory:AddReceiver(client)

			if (callback) then
				callback()
			end
		else
			local invType = ix.item.inventoryTypes["safebox"]
			ix.inventory.Restore(index, invType.w, invType.h, function(inv)
				inv:SetOwner(characterID)
			end)
		end
	else
		ix.inventory.New(characterID, "safebox", function(inv)
			character:SetData("safeboxID", inv:GetID())
		end)
	end
end