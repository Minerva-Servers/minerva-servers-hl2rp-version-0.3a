local PLUGIN = PLUGIN

function PLUGIN:RenderScreenspaceEffects()
    if ( GetGlobalBool("voidactive") ) then
        local colorModifyStorm = {
            ["$pp_colour_addr"] = 0,
            ["$pp_colour_addg"] = 0.1,
            ["$pp_colour_addb"] = 0.2,
            ["$pp_colour_brightness"] = -0.03,
            ["$pp_colour_contrast"] = 1,
            ["$pp_colour_colour"] = 0.7,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0.7,
            ["$pp_colour_mulb"] = 0.8
        }

        DrawColorModify(colorModifyStorm)
    end
end