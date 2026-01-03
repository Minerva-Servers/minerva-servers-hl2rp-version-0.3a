local PLUGIN = PLUGIN

net.Receive("ixRankNPC.OpenMenu", function()
    vgui.Create("ixRankNPC")
end)

net.Receive("ixRankNPC.OpenMenuNoClose", function()
    local panel = vgui.Create("ixRankNPC")
    if ( panel.close ) then
        panel.close:Remove()
    end
    
    if ( panel.refill ) then
        panel.refill:Remove()
    end
end)