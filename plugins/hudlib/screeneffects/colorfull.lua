local SCREENEFFECT = SCREENEFFECT
local PLUGIN = PLUGIN

SCREENEFFECT.name = "Colorfull"

function SCREENEFFECT:Draw( ply, char, x, y, scrw, scrh )
    local colorModify = {}

    colorModify["$pp_colour_colour"] = 1.5
    colorModify["$pp_colour_brightness"] = 0
    colorModify["$pp_colour_contrast"] = 1

    DrawColorModify(colorModify)
end
