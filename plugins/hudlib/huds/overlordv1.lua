local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Overlord V1"
HUD.gradientDown = ix.util.GetMaterial("vgui/gradient-d")

surface.CreateFont("overlord1Font30", {
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

    surface.SetDrawColor(10, 10, 0, 255)
    surface.DrawRect(10, 10, 120, 120)

    surface.SetMaterial(self.gradientDown)
    surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 50))
    surface.DrawTexturedRect(10, 10, 120, 120)

    drawTexture("minerva/icons/name.png", color_white, 140, 10, 30, 30)
    drawText(ply:Nick(), "overlord1Font30", 180, 10, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/group.png", color_white, 140, 50, 30, 30)
    drawText(team.GetName(ply:Team()), "overlord1Font30", 180, 50, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/xp.png", xpColor, scrw - 40, 10, 30, 30)
    drawText(ply:GetXP(), "overlord1Font30", scrw - 50, 10, color_white, TEXT_ALIGN_RIGHT)

    drawTexture("minerva/icons/health.png", healthColor, 10, scrh - 100, 30, 30)
    drawText(ply:Health(), "overlord1Font30", 50, scrh - 100, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/hunger.png", hungerColor, 10, scrh - 70, 30, 30)
    drawText(char:GetHunger(), "overlord1Font30", 50, scrh - 70, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/money.png", moneyColor, 10, scrh - 40, 30, 30)
    drawText(char:GetMoney(), "overlord1Font30", 50, scrh - 40, color_white, TEXT_ALIGN_LEFT)

    PLUGIN:DrawPlayerIcon(ply, char, 10, 10, 120, 120)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
