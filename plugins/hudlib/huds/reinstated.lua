local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Reinstated"
HUD.gradient = ix.util.GetMaterial("vgui/gradient-l")

surface.CreateFont("reinstatedFont20", {
    font = "Arial",
    size = 20,
    weight = 800,
    antialias = true,
})

function HUD:Draw( ply, char, scrw, scrh )
    local drawText = draw.DrawText
    local drawTexture = ix.util.DrawTexture

    surface.SetMaterial(self.gradient)
    surface.SetDrawColor(40, 40, 40, 50)
    surface.DrawTexturedRect(0, scrh - 75, 400, 75)

    surface.SetDrawColor(80, 80, 80, 255)
    surface.DrawTexturedRect(0, scrh - 75, 400, 2)
    surface.DrawTexturedRect(0, scrh - 2, 400, 2)

    drawText(char:GetName(), "reinstatedFont20", 30, scrh - 67.5, color_white, TEXT_ALIGN_LEFT)
    drawTexture("icon16/user.png", color_white, 5, scrh - 65, 16, 16)

    local healthText, healthColor = hook.Run("GetInjuredText", ply)
    if ( healthText ) then
        drawText(L(healthText) or ply:Health(), "reinstatedFont20", 30, scrh - 47.5, healthColor, TEXT_ALIGN_LEFT)
    else
        drawText(ply:Health(), "reinstatedFont20", 30, scrh - 47.5, color_white, TEXT_ALIGN_LEFT)
    end
    drawTexture("icon16/heart.png", color_white, 5, scrh - 45, 16, 16)

    drawText(char:GetMoney(), "reinstatedFont20", 30, scrh - 27.5, color_white, TEXT_ALIGN_LEFT)
    drawTexture("icon16/money.png", color_white, 5, scrh - 25, 16, 16)

    PLUGIN:DrawPlayerIcon(ply, char, 0, 0, 0, 0)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
