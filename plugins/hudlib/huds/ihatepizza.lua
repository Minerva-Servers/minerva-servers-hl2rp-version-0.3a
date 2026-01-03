local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "IHatePizza"
HUD.gradient = ix.util.GetMaterial("vgui/gradient-l")

surface.CreateFont("pizzaFont50", {
    font = "Arial",
    size = 50,
    weight = 100,
    antialias = true,
})

surface.CreateFont("pizzaFont30", {
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

    surface.SetMaterial(self.gradient)

    surface.SetDrawColor(50, 50, 50, 100)
    surface.DrawTexturedRect(0, scrh - 95, 300, 95)

    surface.SetDrawColor(100, 100, 100, 255)
    surface.DrawTexturedRect(0, scrh - 95, 300, 5)

    drawTexture("minerva/icons/health.png", healthColor, 10, scrh - 80, 70, 70)
    draw.SimpleText(ply:Health(), "pizzaFont50", 80, scrh - 40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    drawTexture("minerva/icons/hunger.png", hungerColor, 210, scrh - 75, 35, 35)
    drawText(char:GetHunger(), "pizzaFont30", 260, scrh - 70, color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/money.png", moneyColor, 210, scrh - 45, 35, 35)
    drawText(char:GetMoney(), "pizzaFont30", 260, scrh - 40, color_white, TEXT_ALIGN_LEFT)

    PLUGIN:DrawPlayerIcon(ply, char, 0, 0, 0, 0)
    PLUGIN:DrawPlayerModel(ply, char, 0, scrh - 395, 200, 300)
end
