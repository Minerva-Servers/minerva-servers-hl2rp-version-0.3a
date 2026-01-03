local PLUGIN = PLUGIN

net.Receive("ixOverwatchOpenSector1VGUI", function()
    local deyploymentWait = vgui.Create("ixOverwatchDeploymentWait")
    deyploymentWait.sector = 1
end)

net.Receive("ixOverwatchUpdateSector1Queue", function()
    ix.od.queue.sector1 = net.ReadTable()
end)

net.Receive("ixOverwatchOpenSector2VGUI", function()
    local deyploymentWait = vgui.Create("ixOverwatchDeploymentWait")
    deyploymentWait.sector = 2
end)

net.Receive("ixOverwatchUpdateSector2Queue", function()
    ix.od.queue.sector2 = net.ReadTable()
end)

net.Receive("ixOverwatchOpenSector3VGUI", function()
    local deyploymentWait = vgui.Create("ixOverwatchDeploymentWait")
    deyploymentWait.sector = 3
end)

net.Receive("ixOverwatchUpdateSector3Queue", function()
    ix.od.queue.sector3 = net.ReadTable()
end)