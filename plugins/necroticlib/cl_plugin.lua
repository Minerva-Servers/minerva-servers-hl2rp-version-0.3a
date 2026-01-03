local PLUGIN = PLUGIN

function PLUGIN:PopulateEntityInfo(ent, tooltip)
    local ply = LocalPlayer()

    if ( ent:GetClass() == "npc_zombie" ) then
        local title = tooltip:AddRow("zombieName")
        title:SetText("Zombie")
        title:SizeToContents()
    end
end

function PLUGIN:CanPlayerViewInventory()
    local ply = LocalPlayer()
    
    if ( ply:IsNecrotic() ) then
        return false
    end
end