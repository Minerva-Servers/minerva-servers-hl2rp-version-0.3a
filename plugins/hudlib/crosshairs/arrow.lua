local CROSSHAIR = CROSSHAIR
local PLUGIN = PLUGIN

CROSSHAIR.name = "Arrow"

function CROSSHAIR:Draw( ply, char, x, y, scrw, scrh )
    local color = ix.option.Get( "crosshairColor", color_white )
    surface.SetDrawColor( color )

    surface.DrawLine( x, y, x + ix.option.Get("crosshairLength"), y + ix.option.Get("crosshairLength") )
    surface.DrawLine( x, y, x - ix.option.Get("crosshairLength"), y + ix.option.Get("crosshairLength") )
end
