local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Overlord V2"

surface.CreateFont("overlord2Font30", {
    font = "Arial",
    size = 30,
    weight = 100,
    antialias = true,
})

function HUD:Draw( ply, char, scrw, scrh )
    local bDrawColor = ix.option.Get( "hudIconColor", false )

    local healthColor = bDrawColor and Color(200, 0, 0, 255) or color_white
    local hungerColor = bDrawColor and Color(205, 133, 63, 255) or color_white
    local moneyColor = bDrawColor and Color(133, 227, 91, 255) or color_white
    local xpColor = bDrawColor and Color(205, 190, 0, 255) or color_white
    
    local drawText = draw.DrawText
    local drawTexture = ix.util.DrawTexture

    drawTexture("minerva/icons/name.png", color_white, 10, 10, 30, 30)
    drawText(ply:Nick(), "overlord2Font30", 50, 10, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/group.png", color_white, 10, 50, 30, 30)
    drawText(team.GetName(ply:Team()), "overlord2Font30", 50, 50, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/xp.png", xpColor, scrw - 40, 10, 30, 30)
    drawText(ply:GetXP(), "overlord2Font30", scrw - 50, 10, color_white, TEXT_ALIGN_RIGHT)

    drawTexture("minerva/icons/health.png", healthColor, 10, scrh - 100, 30, 30)
    drawText(ply:Health(), "overlord2Font30", 50, scrh - 100, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/hunger.png", hungerColor, 10, scrh - 70, 30, 30)
    drawText(char:GetHunger(), "overlord2Font30", 50, scrh - 70, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/money.png", moneyColor, 10, scrh - 40, 30, 30)
    drawText(char:GetMoney(), "overlord2Font30", 50, scrh - 40, color_white, TEXT_ALIGN_LEFT)

    PLUGIN:DrawPlayerIcon(ply, char, 0, 0, 0, 0)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
