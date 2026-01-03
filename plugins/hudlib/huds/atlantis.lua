local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Atlantis United"

surface.CreateFont("impulseFont30", {
    font = "Arial",
    size = 30,
    weight = 800,
    antialias = true,
})

surface.CreateFont("impulseFont22", {
    font = "Arial",
    size = 22,
    antialias = true,
})

surface.CreateFont("impulseFont20", {
    font = "Arial",
    size = 20,
    weight = 800,
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

    ix.util.DrawBlurAt(5, scrh - 205, 360, 200)
    draw.RoundedBox(0, 5, scrh - 205, 360, 200, Color(30, 30, 30, 200))

    drawText(ply:Nick(), "impulseFont30", 15, scrh - 200, color_white, TEXT_ALIGN_LEFT)
    drawText(team.GetName(ply:Team()), "impulseFont30", 15, scrh - 170, team.GetColor(ply:Team()), TEXT_ALIGN_LEFT)

    drawText("Health: "..ply:Health(), "impulseFont22", 140, scrh - 125, color_white, TEXT_ALIGN_LEFT)
    drawText("Hunger: "..char:GetHunger(), "impulseFont22", 140, scrh - 105, color_white, TEXT_ALIGN_LEFT)
    drawText("Money: "..ix.currency.symbol..char:GetMoney(), "impulseFont22", 140, scrh - 85, color_white, TEXT_ALIGN_LEFT)

    drawText(ply:GetXP().."XP", "impulseFont20", 40, scrh - 30, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/health.png", healthColor, 115, scrh - 125, 20, 20)
    drawTexture("minerva/icons/hunger.png", hungerColor, 115, scrh - 105, 20, 20)
    drawTexture("minerva/icons/banknotes.png", moneyColor, 115, scrh - 85, 20, 20)
    drawTexture("minerva/icons/xp.png", xpColor, 15, scrh - 30, 20, 20)

    PLUGIN:DrawPlayerIcon(ply, char, 25, scrh - 135, 80, 80)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
