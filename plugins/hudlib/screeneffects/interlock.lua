local SCREENEFFECT = SCREENEFFECT
local PLUGIN = PLUGIN

SCREENEFFECT.name = "Interlock"

function SCREENEFFECT:Draw( ply, char, x, y, scrw, scrh )
    local colorModify = {}

    local modifier = ply:Health()
    if ( modifier > 100 ) then
        modifier = 100
    end

    colorModify["$pp_colour_colour"] = 0.0077 * modifier
    colorModify["$pp_colour_brightness"] = -0.03
    colorModify["$pp_colour_contrast"] = 1.1

    DrawColorModify(colorModify)
end
