local PLUGIN = PLUGIN

function PLUGIN:SaveAmmoCrates()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_ammocrate")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("ammoCrates", data)
end

function PLUGIN:LoadAmmoCrates()
    for _, v in ipairs(ix.data.Get("ammoCrates") or {}) do
        local ammoCrates = ents.Create("ix_ammocrate")

        ammoCrates:SetPos(v[1])
        ammoCrates:SetAngles(v[2])
        ammoCrates:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveAmmoCrates()
end

function PLUGIN:LoadData()
    self:LoadAmmoCrates()
end