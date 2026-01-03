local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Minerva"

surface.CreateFont("minervaFont30", {
    font = "Arial",
    size = 30,
    weight = 800,
    antialias = true,
})

surface.CreateFont("minervaFont22", {
    font = "Arial",
    size = 22,
    antialias = true,
})

surface.CreateFont("minervaFont20", {
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

    surface.SetFont("minervaFont30")
    local w = 260
    if ( ply:IsCombine() ) then
        w = 340
    end

    ix.util.DrawBlurAt(5, scrh - 205, math.Clamp(w + 17, 260, 500), 200)
    draw.RoundedBox(0, 5, scrh - 205, math.Clamp(w + 17, 260, 500), 200, Color(0, 0, 0, 150))

    drawText(ply:Nick(), "minervaFont30", 15, scrh - 200, color_white, TEXT_ALIGN_LEFT)
    drawText(team.GetName(ply:Team()), "minervaFont30", 15, scrh - 40, team.GetColor(ply:Team()), TEXT_ALIGN_LEFT)

    drawText(ply:Health(), "minervaFont30", 170, scrh - 155, color_white, TEXT_ALIGN_LEFT)
    drawText(char:GetHunger(), "minervaFont30", 170, scrh - 130, color_white, TEXT_ALIGN_LEFT)
    drawText(ix.currency.symbol..char:GetMoney(), "minervaFont30", 170, scrh - 105, color_white, TEXT_ALIGN_LEFT)
    drawText(ply:GetXP(), "minervaFont30", 170, scrh - 80, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/health.png", healthColor, 140, scrh - 155, 25, 25)
    drawTexture("minerva/icons/donut.png", hungerColor, 140, scrh - 130, 25, 25)
    drawTexture("minerva/icons/money.png", moneyColor, 140, scrh - 105, 25, 25)
    drawTexture("minerva/icons/star.png", xpColor, 140, scrh - 80, 25, 25)

    PLUGIN:DrawPlayerIcon(ply, char, 15, scrh - 160, 115, 115)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
