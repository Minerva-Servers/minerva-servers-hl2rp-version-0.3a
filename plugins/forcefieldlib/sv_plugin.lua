local PLUGIN = PLUGIN

function PLUGIN:SaveForceFields()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_forcefield")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetMode()}
    end

    ix.data.Set("forceFields", data)
end

function PLUGIN:LoadForceFields()
    for _, v in ipairs(ix.data.Get("forceFields") or {}) do
        local field = ents.Create("ix_forcefield")

        field:SetPos(v[1])
        field:SetAngles(v[2])
        field:Spawn()
        field:SetMode(v[3])
    end
end

function PLUGIN:LoadData()
    self:LoadForceFields()
end

function PLUGIN:SaveData()
    self:SaveForceFields()
end