local HUD = HUD
local PLUGIN = PLUGIN
local SS = ScreenScale

HUD.name = "Deathmatch"

surface.CreateFont("deathmatch10", {
    font = "Futura Std Medium",
    size = SS(10),
    antialias = true,
})

surface.CreateFont("deathmatch16", {
    font = "Futura Std Medium",
    size = SS(16),
    antialias = true,
})

function HUD:Draw(ply, char, scrw, scrh)
    local color = team.GetColor(ply:Team())
    local drawText = draw.DrawText
    local width, height = ix.util.TextSize(ply:Nick(), "deathmatch16")
    
    drawText("NAME", "deathmatch10", 20, ScrH() - 10 - SS(10) - SS(16), color)
    drawText(ply:Nick(), "deathmatch16", 20, ScrH() - 20 - SS(16), color_white)
    drawText("HEALTH", "deathmatch10", 40 + width, ScrH() - 10 - SS(10) - SS(16), color)
    drawText(ply:Health(), "deathmatch16", 40 + width, ScrH() - 20 - SS(16), color_white)

    drawText("HUNGER", "deathmatch10", 20, ScrH() - 10 - SS(10) * 2 - SS(16) * 2, color)
    drawText(char:GetHunger(), "deathmatch16", 20, ScrH() - 20 - SS(16) * 2 - SS(10), color_white)
    drawText("TOKENS", "deathmatch10", 40 + width, ScrH() - 10 - SS(16) * 2 - SS(10) * 2, color)
    drawText(ix.currency.symbol..char:GetMoney(), "deathmatch16", 40 + width, ScrH() - 20 - SS(16) * 2 - SS(10), color_white)

    drawText("XP", "deathmatch10", 20, ScrH() - 10 - SS(10) - SS(16) * 3 - SS(10) * 2, color)
    drawText(ply:GetXP(), "deathmatch16", 20, ScrH() - 20 - SS(16) * 3 - SS(10) * 2, color_white)
end
