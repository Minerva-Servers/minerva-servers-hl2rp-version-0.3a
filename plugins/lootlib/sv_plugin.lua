local PLUGIN = PLUGIN

function PLUGIN:SaveLootContainers()
    local data = {}

    for _, v in pairs(ents.FindByClass("ix_loot_container")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetContainerClass(), v:GetModel(), v:GetSkin()}
    end

    ix.data.Set("lootContainer", data)
end

function PLUGIN:LoadLootContainers()
    for _, v in pairs(ix.data.Get("lootContainer") or {}) do
        local lootContainer = ents.Create("ix_loot_container")
        lootContainer:SetPos(v[1])
        lootContainer:SetAngles(v[2])
        lootContainer:SetContainerClass(v[3])
        lootContainer:Spawn()
        timer.Simple(10, function()
            if not ( IsValid(lootContainer) ) then
                return
            end
            
            lootContainer:SetModel(v[4])
            lootContainer:SetSkin(v[5])
        end)
    end
end

function PLUGIN:SaveData()
    self:SaveLootContainers()
end

function PLUGIN:LoadData()
    self:LoadLootContainers()
end