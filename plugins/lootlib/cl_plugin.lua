local PLUGIN = PLUGIN

function PLUGIN:PopulateEntityInfo(ent, tooltip)
    local ply = LocalPlayer()

    if ( ent:GetClass():find("ix_loot_container") ) then
        local loot = PLUGIN.containers[ent:GetContainerClass()]

        if not ( loot ) then
            return
        end
        
        local title = tooltip:AddRow("loot")
        title:SetText(loot.name)
        title:SetImportant()
        title:SizeToContents()
    end
end