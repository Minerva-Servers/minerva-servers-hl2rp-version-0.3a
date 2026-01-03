local PLUGIN = PLUGIN

function PLUGIN:SaveATMs()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_atm")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("atms", data)
end

function PLUGIN:LoadATMs()
    for _, v in ipairs(ix.data.Get("atms") or {}) do
        local atms = ents.Create("ix_atm")

        atms:SetPos(v[1])
        atms:SetAngles(v[2])
        atms:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveATMs()
end

function PLUGIN:LoadData()
    self:LoadATMs()
end

util.AddNetworkString("ixATMMoney")

net.Receive("ixATMMoney", function(_, ply)
	local bWithdraw = net.ReadBool()
	local amount = net.ReadUInt(32)

	local character = ply:GetCharacter()

	if ( bWithdraw ) then
		if ( character:CanWithdraw( amount ) ) then
			character:WithdrawMoney( amount )
		end
	else
		if ( character:CanDeposit( amount ) ) then
			character:DespositMoney( amount )
		end
	end
end)