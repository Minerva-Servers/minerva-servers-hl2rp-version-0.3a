local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "Apex Roleplay"

surface.CreateFont("apexFont16", {
    font = "Arial",
    size = 16,
    weight = 800,
    antialias = true,
})

function HUD:Draw( ply, char, scrw, scrh )
    local HUDWidth, HUDHeight = 260, 115
    local RelativeX, RelativeY = 0, scrh

    local drawText = draw.DrawText
    local drawTexture = ix.util.DrawTexture

    ix.util.DrawBlurAt(10, scrh - HUDHeight - 65, HUDWidth, 30, 3)
    ix.util.DrawBlurAt(10, scrh - HUDHeight - 34, HUDWidth, 110, 3)
    ix.util.DrawBlurAt(10, scrh - HUDHeight + 77, HUDWidth, 30, 3)

    draw.RoundedBox(0, 10, scrh - HUDHeight - 65, HUDWidth, 30, Color(0, 0, 0, 230))
    draw.RoundedBox(0, 10, scrh - HUDHeight - 34, HUDWidth, 110, Color(0, 0, 0, 230))
    draw.RoundedBox(0, 10, scrh - HUDHeight + 77, HUDWidth, 30, Color(0, 0, 0, 230))

    drawText("Name: "..ply:Nick(), "apexFont16", RelativeX + 40, RelativeY - HUDHeight - 57, color_white, TEXT_ALIGN_LEFT)

    drawText("Health: "..ply:Health(), "apexFont16", RelativeX + 125, scrh - 130, color_white, TEXT_ALIGN_LEFT)
    drawText("Tokens: "..char:GetMoney(), "apexFont16", RelativeX + 125, scrh - 110, color_white, TEXT_ALIGN_LEFT)
    drawText("XP: "..ply:GetXP(), "apexFont16", RelativeX + 125, scrh - 90, color_white, TEXT_ALIGN_LEFT)
    drawText("Food: "..char:GetHunger(), "apexFont16", RelativeX + 125, scrh - 70, color_white, TEXT_ALIGN_LEFT)

    drawText("Job: "..team.GetName(ply:Team()), "apexFont16", RelativeX + 40, RelativeY - HUDHeight + 85, color_white, TEXT_ALIGN_LEFT)

    drawTexture("icon16/user.png", color_white, 18, scrh - 173, 16, 16)

    drawTexture("icon16/heart.png", color_white, RelativeX + 100, scrh - 130, 16, 16)
    drawTexture("icon16/money.png", color_white, RelativeX + 100, scrh - 110, 16, 16)
    drawTexture("icon16/star.png", color_white, RelativeX + 100, scrh - 90, 16, 16)
    drawTexture("icon16/cake.png", color_white, RelativeX + 100, scrh - 70, 16, 16)

    drawTexture("icon16/group.png", color_white, 18, scrh - 31, 16, 16)

    PLUGIN:DrawPlayerIcon(ply, char, 25, scrh - 125, 60, 60)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
