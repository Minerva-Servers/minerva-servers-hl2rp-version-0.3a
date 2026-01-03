local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers NLR Library"
PLUGIN.description = ""
PLUGIN.author = "eon"

PLUGIN.time = 600

ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
    net.Receive("PlayerNLRSync", function()
        local isNLR = net.ReadBool()
        local area = net.ReadString()
        local ply = LocalPlayer()
    
        ply.isActiveNLR = isNLR
        ply.areaNlr = area
    end)
    
    function PLUGIN:HUDPaintAlternate(ply, character)        
        if ( ply.isActiveNLR ) then
            if ( ply:GetArea() == ply.areaNlr ) then
                draw.DrawText("You are in your NLR zone, you must leave this zone.", "ixMediumFont", ScrW() / 2, 15, Color(255, 0, 0), TEXT_ALIGN_CENTER) 
            end
        end
    end
end