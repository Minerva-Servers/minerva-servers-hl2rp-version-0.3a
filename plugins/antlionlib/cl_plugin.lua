local PLUGIN = PLUGIN

function PLUGIN:PopulateEntityInfo(ent, tooltip)
    local ply = LocalPlayer()

    if ( ent:GetClass() == "npc_hunter" ) then
        local title = tooltip:AddRow("hunterName")
        title:SetText("Hunter")
        title:SizeToContents()
    end
end

function PLUGIN:CanPlayerViewInventory()
    local ply = LocalPlayer()
    
    if ( ply:IsAntlion() ) then
        return false
    end
end

function PLUGIN:RenderScreenspaceEffects()
    local colorModify = {}

    if ( LocalPlayer():IsAntlion() ) then
        colorModify["$pp_colour_addr"] = 0
        colorModify["$pp_colour_addg"] = 0.1
        colorModify["$pp_colour_addb"] = 0
        colorModify["$pp_colour_mulr"] = 0.1
        colorModify["$pp_colour_mulg"] = 0.5
        colorModify["$pp_colour_mulb"] = 0.1
        colorModify["$pp_colour_colour"] = 0.3
        colorModify["$pp_colour_brightness"] = -0.2
        colorModify["$pp_colour_contrast"] = 0.8
    else
        colorModify["$pp_colour_addr"] = 0
        colorModify["$pp_colour_addg"] = 0
        colorModify["$pp_colour_addb"] = 0
        colorModify["$pp_colour_mulr"] = 0
        colorModify["$pp_colour_mulg"] = 0
        colorModify["$pp_colour_mulb"] = 0
        colorModify["$pp_colour_colour"] = 1
        colorModify["$pp_colour_brightness"] = 0
        colorModify["$pp_colour_contrast"] = 1
    end
    
    DrawColorModify(colorModify)
end