local CROSSHAIR = CROSSHAIR
local PLUGIN = PLUGIN

CROSSHAIR.name = "Circle"

function CROSSHAIR:Draw( ply, char, x, y, scrw, scrh )
    local color = ix.option.Get( "crosshairColor", color_white )

    surface.DrawCircle( x, y, ix.option.Get("crosshairLength"), color.r, color.g, color.b, color.a )
end
