// https://github.com/LandisGames/impulse/blob/main/gamemode/core/cl_hud.lua

local HUD = HUD
local PLUGIN = PLUGIN

HUD.name = "impulse"

surface.CreateFont("Impulse-Elements23", {
    font = "Arial",
    size = 23,
    weight = 800,
    antialias = true,
    shadow = false,
})

surface.CreateFont("Impulse-Elements19", {
    font = "Arial",
    size = 19,
    weight = 1000,
    antialias = true,
    shadow = false,
})

function HUD:Draw( ply, char, scrw, scrh )
    local bDrawColor = ix.option.Get( "hudIconColor", false )

    local healthColor = bDrawColor and Color(200, 0, 0, 255) or color_white
    local hungerColor = bDrawColor and Color(205, 133, 63, 255) or color_white
    local moneyColor = bDrawColor and Color(133, 227, 91, 255) or color_white
    local xpColor = bDrawColor and Color(205, 190, 0, 255) or color_white

    local drawText = draw.DrawText
    local drawTexture = ix.util.DrawTexture

    local hudWidth, hudHeight = 300, 178
    
    local y = scrh - hudHeight - 8 - 10
    local yAdd = 0

    ix.util.DrawBlurAt(10, y, hudWidth, hudHeight)
    draw.RoundedBox(0, 10, y, hudWidth, hudHeight, Color(30, 30, 30, 190))

    drawText(ply:Nick(), "Impulse-Elements23", 30, y + 10, color_white, TEXT_ALIGN_LEFT)
    drawText(team.GetName(ply:Team()), "Impulse-Elements23", 30, y + 30, team.GetColor(ply:Team()), TEXT_ALIGN_LEFT)

    drawText("Health: "..ply:Health(), "Impulse-Elements19", 136, y + 64 + yAdd, color_white, TEXT_ALIGN_LEFT)
    drawText("Hunger: "..char:GetHunger(), "Impulse-Elements19", 136, y + 86 + yAdd, color_white, TEXT_ALIGN_LEFT)
    drawText("Money: "..ix.currency.symbol..char:GetMoney(), "Impulse-Elements19", 136, y + 108 + yAdd, color_white, TEXT_ALIGN_LEFT)

    drawText(ply:GetXP().."XP", "Impulse-Elements19", 55, y + 150 + ( yAdd - 8 ), color_white, TEXT_ALIGN_LEFT)

    drawTexture("minerva/icons/health.png", healthColor, 110, y + 66 + yAdd, 18, 16)
    drawTexture("minerva/icons/hunger.png", hungerColor, 110, y + 87 + yAdd, 18, 18)
    drawTexture("minerva/icons/banknotes.png", moneyColor, 110, y + 107 + yAdd, 18, 18)
    drawTexture("minerva/icons/xp.png", xpColor, 30, y + 150 + ( yAdd - 8 ), 18, 18)

    PLUGIN:DrawPlayerIcon(ply, char, 30, y + 60, 64, 64)
    PLUGIN:DrawPlayerModel(ply, char, 0, 0, 0, 0)
end
