local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Lite Network"

surface.CreateFont("litenetworkFont32", {
    font = "Arial",
    size = 32,
    weight = 100,
    antialias = true,
})

surface.CreateFont("litenetworkFont26", {
    font = "Arial",
    size = 26,
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

    ix.util.DrawBlurAt(10, scrh - 210, 365, 200)

    surface.SetDrawColor(ColorAlpha(team.GetColor(ply:Team()), 25))
    surface.DrawRect(10, scrh - 210, 365, 200)

    surface.SetDrawColor(Color(30, 30, 30, 100))
    surface.DrawRect(10, scrh - 210, 365, 200)

    drawText(team.GetName(ply:Team()), "litenetworkFont32", 20, scrh - 200, team.GetColor(ply:Team()), TEXT_ALIGN_LEFT)
    drawText(ply:Nick(), "litenetworkFont32", 20, scrh - 50, color_white, TEXT_ALIGN_LEFT)
    drawText("Health: "..ply:Health(), "litenetworkFont26", 160, scrh - 200 - 10 + 50, color_white, TEXT_ALIGN_LEFT)
    drawText("Tokens: "..char:GetMoney(), "litenetworkFont26", 160, scrh - 200 - 10 + 75, color_white, TEXT_ALIGN_LEFT)
    drawText("Hunger: "..char:GetHunger(), "litenetworkFont26", 160, scrh - 200 - 10 + 100, color_white, TEXT_ALIGN_LEFT)
    drawText("XP: "..ply:GetXP(), "litenetworkFont26", 160, scrh - 200 - 10 + 125, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/health.png", healthColor, 130, scrh - 200 - 10 + 52.5, 25, 25)
    drawTexture("minerva/icons/banknotes.png", moneyColor, 130, scrh - 200 - 10 + 77.5, 25, 25)
    drawTexture("minerva/icons/hunger.png", hungerColor, 130, scrh - 200 - 10 + 102.5, 25, 25)
    drawTexture("minerva/icons/star.png", xpColor, 130, scrh - 200 - 10 + 125, 25, 25)

    PLUGIN:DrawPlayerIcon(ply, char, 20, scrh - 200 - 10 + 50, 100, 100)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
