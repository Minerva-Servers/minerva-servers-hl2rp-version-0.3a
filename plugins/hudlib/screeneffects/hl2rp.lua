local SCREENEFFECT = SCREENEFFECT
local PLUGIN = PLUGIN

SCREENEFFECT.name = "Half-Life 2 Roleplay"

function SCREENEFFECT:Draw( ply, char, x, y, scrw, scrh )
    local colorModify = {}

    colorModify["$pp_colour_colour"] = 0.77
    colorModify["$pp_colour_brightness"] = -0.02
    colorModify["$pp_colour_contrast"] = 1.2

    DrawColorModify(colorModify)
end
