local CROSSHAIR = CROSSHAIR
local PLUGIN = PLUGIN

CROSSHAIR.name = "Normal"

function CROSSHAIR:Draw( ply, char, x, y, scrw, scrh )
    surface.SetDrawColor( ix.option.Get( "crosshairColor", color_white ) )

    surface.DrawLine( x - ix.option.Get("crosshairLength"), y, x - ix.option.Get("crosshairGap"), y )
    surface.DrawLine( x + ix.option.Get("crosshairLength"), y, x + ix.option.Get("crosshairGap"), y )
    surface.DrawLine( x, y - ix.option.Get("crosshairLength"), x, y - ix.option.Get("crosshairGap") )
    surface.DrawLine( x, y + ix.option.Get("crosshairLength"), x, y + ix.option.Get("crosshairGap") )
end
