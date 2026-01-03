local PLUGIN = PLUGIN

function PLUGIN:SaveOverwatchDeployers()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_dropshipdeployer")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("overwatchDeployers", data)
end

function PLUGIN:LoadOverwatchDeployers()
    for _, v in ipairs(ix.data.Get("overwatchDeployers") or {}) do
        local overwatchDeployers = ents.Create("ix_dropshipdeployer")

        overwatchDeployers:SetPos(v[1])
        overwatchDeployers:SetAngles(v[2])
        overwatchDeployers:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveOverwatchDeployers()
end

function PLUGIN:LoadData()
    self:LoadOverwatchDeployers()
end

util.AddNetworkString("ixOverwatchJoinSector1Queue")
util.AddNetworkString("ixOverwatchCancelSector1Queue")
util.AddNetworkString("ixOverwatchOpenSector1VGUI")
util.AddNetworkString("ixOverwatchUpdateSector1Queue")

net.Receive("ixOverwatchJoinSector1Queue", function(len, ply)
    if ( table.HasValue(ix.od.queue.sector1, ply) ) then
        ply:Notify("You cannot join the queue twice.")
        return
    end

    table.Add(ix.od.queue.sector1, {ply})
    ply:Notify("You have joined the queue for Sector 1.")

    net.Start("ixOverwatchUpdateSector1Queue")
        net.WriteTable(ix.od.queue.sector1)
    net.Broadcast()

    if ( #ix.od.queue.sector1 >= 3 ) then
        ix.od.DeployAtSector1(ix.od.queue.sector1[1], ix.od.queue.sector1[2], ix.od.queue.sector1[3])
        
        ix.od.queue.sector1 = {}

        net.Start("ixOverwatchUpdateSector1Queue")
            net.WriteTable(ix.od.queue.sector1)
        net.Broadcast()
    else
        net.Start("ixOverwatchOpenSector1VGUI")
            net.WriteUInt(1, 4)
        net.Send(ply)
    end
end)

net.Receive("ixOverwatchCancelSector1Queue", function(len, ply)
    for k, v in pairs(ix.od.queue.sector1) do
        if ( v == ply ) then
            table.remove(ix.od.queue.sector1, k)
            ply:Notify("You have left the queue for Sector 1.")

            net.Start("ixOverwatchUpdateSector1Queue")
                net.WriteTable(ix.od.queue.sector1)
            net.Broadcast()

            break
        end
    end
end)

function ix.od.DeployAtSector1(player1, player2, player3)
    if not ( IsValid(player1) and IsValid(player2) and IsValid(player3) ) then
        return
    end

    local dropship = ents.Create("npc_combinedropship")
    dropship:SetPos(Vector(3302.2094726563, 5076.0795898438, 854.09234619141))
    dropship:SetAngles(Angle(0, -90, 0))
    dropship:SetKeyValue("squadname", "overwatch")
    dropship:SetKeyValue("GunRange", "3000")
    dropship:SetKeyValue("CrateType", "1")
    dropship:CapabilitiesAdd(CAP_MOVE_FLY)
    dropship:CapabilitiesAdd(CAP_SQUAD)
    dropship:Spawn()
    dropship:Activate()

    local spectateEnt = ents.Create("prop_dynamic")
    spectateEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    spectateEnt:SetPos(dropship:GetPos() + dropship:GetForward() * 50 + dropship:GetUp() * 30)
    spectateEnt:SetAngles(dropship:GetAngles())
    spectateEnt:SetParent(dropship)
    spectateEnt:Spawn()
    spectateEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    spectateEnt:SetColor(Color(255, 255, 255, 0))

    local dropflyingpoint1 = ents.Create("path_track")
    dropflyingpoint1:SetName("sector1_dropship_track_1")
    dropflyingpoint1:SetPos(Vector(3312.0324707031, 2885.5698242188, 789.09368896484))
    dropflyingpoint1:SetKeyValue("target", "sector1_dropship_track_2")
    dropflyingpoint1:Spawn()

    local dropflyingpoint2 = ents.Create("path_track")
    dropflyingpoint2:SetName("sector1_dropship_track_2")
    dropflyingpoint2:SetPos(Vector(5707.3525390625, 2858.7111816406, 1011.9018554688))
    dropflyingpoint2:Spawn()

    dropship:Fire("SetTrack", "sector1_dropship_track_1")

    local dropposition = ents.Create("scripted_target")
    dropposition:SetPos(Vector(3350.7744140625, 3556.0942382813, 24.03125))
    dropposition:SetNotSolid(true)
    dropposition:SetNoDraw(true)
    dropposition:Spawn()
    dropposition:Activate()
    dropposition:SetName("sector1_dropship_landing_point")

    timer.Simple(10, function()
        dropship:Fire("SetLandTarget", "sector1_dropship_landing_point")
        dropship:Fire("StopWaitingForDropoff")
        dropship:Fire("LandTakeCrate", 0)
    end)

    player1:SetPos(dropship:GetPos())
    player1:SetMoveType(MOVETYPE_NONE)
    player1:SetNoTarget(true)
    player1:SetNotSolid(true)
    player1:SetNoDraw(true)
    player1:Freeze(true)
    player1:SetDSP(31)
    player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player2:SetPos(dropship:GetPos())
    player2:SetMoveType(MOVETYPE_NONE)
    player2:SetNoTarget(true)
    player2:SetNotSolid(true)
    player2:SetNoDraw(true)
    player2:Freeze(true)
    player2:SetDSP(31)
    player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player3:SetPos(dropship:GetPos())
    player3:SetMoveType(MOVETYPE_NONE)
    player3:SetNoTarget(true)
    player3:SetNotSolid(true)
    player3:SetNoDraw(true)
    player3:Freeze(true)
    player3:SetDSP(31)
    player3:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player1:SetViewEntity(spectateEnt)
    player2:SetViewEntity(spectateEnt)
    player3:SetViewEntity(spectateEnt)

    timer.Simple(19, function()
        player1:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)
        player2:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)
        player3:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)

        timer.Simple(1, function()
            player1:SetMoveType(MOVETYPE_WALK)
            player1:SetNoTarget(false)
            player1:SetNotSolid(false)
            player1:SetNoDraw(false)
            player1:Freeze(false)
            player1:SetDSP(0)
            player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player1:SetPos(Vector(3555.75, 3488.8256835938, 32.03125))
    
            player2:SetMoveType(MOVETYPE_WALK)
            player2:SetNoTarget(false)
            player2:SetNotSolid(false)
            player2:SetNoDraw(false)
            player2:Freeze(false)
            player2:SetDSP(0)
            player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player2:SetPos(Vector(3556.6696777344, 3555.0498046875, 32.03125))
    
            player3:SetMoveType(MOVETYPE_WALK)
            player3:SetNoTarget(false)
            player3:SetNotSolid(false)
            player3:SetNoDraw(false)
            player3:Freeze(false)
            player3:SetDSP(0)
            player3:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player3:SetPos(Vector(3556.6999511719, 3620.6516113281, 32.03125))

            player1:SetViewEntity(nil)
            player2:SetViewEntity(nil)
            player3:SetViewEntity(nil)
        end)
    end)

    timer.Simple(30, function()
        dropship:Fire("SetTrack", "sector1_dropship_track_2")
    end)

    timer.Simple(40, function()
        dropship:Fire("kill")
        dropflyingpoint1:Remove()
        dropflyingpoint2:Remove()
        dropposition:Remove()
    end)
end

util.AddNetworkString("ixOverwatchJoinSector2Queue")
util.AddNetworkString("ixOverwatchCancelSector2Queue")
util.AddNetworkString("ixOverwatchOpenSector2VGUI")
util.AddNetworkString("ixOverwatchUpdateSector2Queue")

net.Receive("ixOverwatchJoinSector2Queue", function(len, ply)
    if ( table.HasValue(ix.od.queue.sector2, ply) ) then
        ply:Notify("You cannot join the queue twice.")
        return
    end

    table.Add(ix.od.queue.sector2, {ply})
    ply:Notify("You have joined the queue for Sector 1.")

    net.Start("ixOverwatchUpdateSector2Queue")
        net.WriteTable(ix.od.queue.sector2)
    net.Broadcast()

    if ( #ix.od.queue.sector2 >= 3 ) then
        ix.od.DeployAtSector2(ix.od.queue.sector2[1], ix.od.queue.sector2[2], ix.od.queue.sector2[3])
        
        ix.od.queue.sector2 = {}

        net.Start("ixOverwatchUpdateSector2Queue")
            net.WriteTable(ix.od.queue.sector2)
        net.Broadcast()
    else
        net.Start("ixOverwatchOpenSector2VGUI")
            net.WriteUInt(1, 4)
        net.Send(ply)
    end
end)

net.Receive("ixOverwatchCancelSector2Queue", function(len, ply)
    for k, v in pairs(ix.od.queue.sector2) do
        if ( v == ply ) then
            table.remove(ix.od.queue.sector2, k)
            ply:Notify("You have left the queue for Sector 1.")

            net.Start("ixOverwatchUpdateSector2Queue")
                net.WriteTable(ix.od.queue.sector2)
            net.Broadcast()

            break
        end
    end
end)

function ix.od.DeployAtSector2(player1, player2, player3)
    if not ( IsValid(player1) and IsValid(player2) and IsValid(player3) ) then
        return
    end

    local dropship = ents.Create("npc_combinedropship")
    dropship:SetPos(Vector(748.33435058594, -2122.6118164063, 432.03125))
    dropship:SetAngles(Angle(0, 90, 0))
    dropship:SetKeyValue("squadname", "overwatch")
    dropship:SetKeyValue("GunRange", "3000")
    dropship:SetKeyValue("CrateType", "1")
    dropship:CapabilitiesAdd(CAP_MOVE_FLY)
    dropship:CapabilitiesAdd(CAP_SQUAD)
    dropship:Spawn()
    dropship:Activate()

    local spectateEnt = ents.Create("prop_dynamic")
    spectateEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    spectateEnt:SetPos(dropship:GetPos() + dropship:GetForward() * 50 + dropship:GetUp() * 30)
    spectateEnt:SetAngles(dropship:GetAngles())
    spectateEnt:SetParent(dropship)
    spectateEnt:Spawn()
    spectateEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    spectateEnt:SetColor(Color(255, 255, 255, 0))

    local dropflyingpoint1 = ents.Create("path_track")
    dropflyingpoint1:SetName("sector2_dropship_track_1")
    dropflyingpoint1:SetPos(Vector(687.25213623047, -1425.7302246094, 869.16137695313))
    dropflyingpoint1:Spawn()

    local dropflyingpoint2 = ents.Create("path_track")
    dropflyingpoint2:SetName("dropship_track_2")
    dropflyingpoint2:SetPos(Vector(748.33435058594, -2122.6118164063, 432.03125))
    dropflyingpoint2:Spawn()

    dropship:Fire("SetTrack", "sector2_dropship_track_1")

    local dropposition = ents.Create("scripted_target")
    dropposition:SetPos(Vector(655.38055419922, -832.14007568359, 24.03125))
    dropposition:SetNotSolid(true)
    dropposition:SetNoDraw(true)
    dropposition:Spawn()
    dropposition:Activate()
    dropposition:SetName("sector2_dropship_landing_point")

    timer.Simple(4, function()
        dropship:Fire("SetLandTarget", "sector2_dropship_landing_point")
        dropship:Fire("StopWaitingForDropoff")
        dropship:Fire("LandTakeCrate", "0")
    end)

    player1:SetPos(dropship:GetPos())
    player1:SetMoveType(MOVETYPE_NONE)
    player1:SetNoTarget(true)
    player1:SetNotSolid(true)
    player1:SetNoDraw(true)
    player1:Freeze(true)
    player1:SetDSP(31)
    player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player2:SetPos(dropship:GetPos())
    player2:SetMoveType(MOVETYPE_NONE)
    player2:SetNoTarget(true)
    player2:SetNotSolid(true)
    player2:SetNoDraw(true)
    player2:Freeze(true)
    player2:SetDSP(31)
    player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player3:SetPos(dropship:GetPos())
    player3:SetMoveType(MOVETYPE_NONE)
    player3:SetNoTarget(true)
    player3:SetNotSolid(true)
    player3:SetNoDraw(true)
    player3:Freeze(true)
    player3:SetDSP(31)
    player3:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player1:SetViewEntity(spectateEnt)
    player2:SetViewEntity(spectateEnt)
    player3:SetViewEntity(spectateEnt)

    timer.Simple(13, function()
        player1:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)
        player2:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)
        player3:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)

        timer.Simple(1, function()
            player1:SetMoveType(MOVETYPE_WALK)
            player1:SetNoTarget(false)
            player1:SetNotSolid(false)
            player1:SetNoDraw(false)
            player1:Freeze(false)
            player1:SetDSP(0)
            player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player1:SetPos(Vector(838.34802246094, -720.61633300781, 24.03125))
    
            player2:SetMoveType(MOVETYPE_WALK)
            player2:SetNoTarget(false)
            player2:SetNotSolid(false)
            player2:SetNoDraw(false)
            player2:Freeze(false)
            player2:SetDSP(0)
            player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player2:SetPos(Vector(850.41839599609, -818.82977294922, 24.03125))
    
            player3:SetMoveType(MOVETYPE_WALK)
            player3:SetNoTarget(false)
            player3:SetNotSolid(false)
            player3:SetNoDraw(false)
            player3:Freeze(false)
            player3:SetDSP(0)
            player3:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player3:SetPos(Vector(863.28112792969, -947.48718261719, 24.03125))

            player1:SetViewEntity(nil)
            player2:SetViewEntity(nil)
            player3:SetViewEntity(nil)
        end)
    end)

    timer.Simple(21, function()
        dropship:Fire("SetTrack", "sector2_dropship_track_2")
    end)

    timer.Simple(26, function()
        dropship:Fire("kill")
        dropflyingpoint1:Remove()
        dropflyingpoint2:Remove()
        dropposition:Remove()
    end)
end

util.AddNetworkString("ixOverwatchJoinSector3Queue")
util.AddNetworkString("ixOverwatchCancelSector3Queue")
util.AddNetworkString("ixOverwatchOpenSector3VGUI")
util.AddNetworkString("ixOverwatchUpdateSector3Queue")

net.Receive("ixOverwatchJoinSector3Queue", function(len, ply)
    if ( table.HasValue(ix.od.queue.sector3, ply) ) then
        ply:Notify("You cannot join the queue twice.")
        return
    end

    table.Add(ix.od.queue.sector3, {ply})
    ply:Notify("You have joined the queue for Sector 1.")

    net.Start("ixOverwatchUpdateSector3Queue")
        net.WriteTable(ix.od.queue.sector3)
    net.Broadcast()

    if ( #ix.od.queue.sector3 >= 3 ) then
        ix.od.DeployAtSector3(ix.od.queue.sector3[1], ix.od.queue.sector3[2], ix.od.queue.sector3[3])
        
        ix.od.queue.sector3 = {}

        net.Start("ixOverwatchUpdateSector3Queue")
            net.WriteTable(ix.od.queue.sector3)
        net.Broadcast()
    else
        net.Start("ixOverwatchOpenSector3VGUI")
            net.WriteUInt(1, 4)
        net.Send(ply)
    end
end)

net.Receive("ixOverwatchCancelSector3Queue", function(len, ply)
    for k, v in pairs(ix.od.queue.sector3) do
        if ( v == ply ) then
            table.remove(ix.od.queue.sector3, k)
            ply:Notify("You have left the queue for Sector 1.")

            net.Start("ixOverwatchUpdateSector3Queue")
                net.WriteTable(ix.od.queue.sector3)
            net.Broadcast()

            break
        end
    end
end)

function ix.od.DeployAtSector3(player1, player2, player3)
    if not ( IsValid(player1) and IsValid(player2) and IsValid(player3) ) then
        return
    end

    local dropship = ents.Create("npc_combinedropship")
    dropship:SetPos(Vector(1726.7947998047, 7630.3056640625, 118.41480255127))
    dropship:SetAngles(Angle(0, 0, 0))
    dropship:SetKeyValue("squadname", "overwatch")
    dropship:SetKeyValue("GunRange", "3000")
    dropship:SetKeyValue("CrateType", "1")
    dropship:CapabilitiesAdd(CAP_MOVE_FLY)
    dropship:CapabilitiesAdd(CAP_SQUAD)
    dropship:Spawn()
    dropship:Activate()

    local spectateEnt = ents.Create("prop_dynamic")
    spectateEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    spectateEnt:SetPos(dropship:GetPos() + dropship:GetForward() * 50 + dropship:GetUp() * 30)
    spectateEnt:SetAngles(dropship:GetAngles())
    spectateEnt:SetParent(dropship)
    spectateEnt:Spawn()
    spectateEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    spectateEnt:SetColor(Color(255, 255, 255, 0))

    local dropflyingpoint1 = ents.Create("path_track")
    dropflyingpoint1:SetName("sector3_dropship_track_1")
    dropflyingpoint1:SetPos(Vector(2687.3159179688, 7598.0659179688, 566.50579833984))
    dropflyingpoint1:Spawn()

    local dropflyingpoint2 = ents.Create("path_track")
    dropflyingpoint2:SetName("sector3_dropship_track_2")
    dropflyingpoint2:SetPos(Vector(1593.873046875, 7653.3017578125, 32.03125))
    dropflyingpoint2:Spawn()

    dropship:Fire("SetTrack", "sector3_dropship_track_1")

    local dropposition = ents.Create("scripted_target")
    dropposition:SetPos(Vector(3692.2019042969, 7393.609375, 24.03125))
    dropposition:SetNotSolid(true)
    dropposition:SetNoDraw(true)
    dropposition:Spawn()
    dropposition:Activate()
    dropposition:SetName("sector3_dropship_landing_point")

    timer.Simple(4, function()
        dropship:Fire("SetLandTarget", "sector3_dropship_landing_point")
        dropship:Fire("StopWaitingForDropoff")
        dropship:Fire("LandTakeCrate", 0)
    end)

    player1:SetPos(dropship:GetPos())
    player1:SetMoveType(MOVETYPE_NONE)
    player1:SetNoTarget(true)
    player1:SetNotSolid(true)
    player1:SetNoDraw(true)
    player1:Freeze(true)
    player1:SetDSP(31)
    player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player2:SetPos(dropship:GetPos())
    player2:SetMoveType(MOVETYPE_NONE)
    player2:SetNoTarget(true)
    player2:SetNotSolid(true)
    player2:SetNoDraw(true)
    player2:Freeze(true)
    player2:SetDSP(31)
    player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player3:SetPos(dropship:GetPos())
    player3:SetMoveType(MOVETYPE_NONE)
    player3:SetNoTarget(true)
    player3:SetNotSolid(true)
    player3:SetNoDraw(true)
    player3:Freeze(true)
    player3:SetDSP(31)
    player3:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, 1)

    player1:SetViewEntity(spectateEnt)
    player2:SetViewEntity(spectateEnt)
    player3:SetViewEntity(spectateEnt)

    timer.Simple(15, function()
        player1:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)
        player2:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)
        player3:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0)

        timer.Simple(1, function()
            player1:SetMoveType(MOVETYPE_WALK)
            player1:SetNoTarget(false)
            player1:SetNotSolid(false)
            player1:SetNoDraw(false)
            player1:Freeze(false)
            player1:SetDSP(0)
            player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player1:SetPos(Vector(3838.7705078125, 7519.64453125, 24.03125))
    
            player2:SetMoveType(MOVETYPE_WALK)
            player2:SetNoTarget(false)
            player2:SetNotSolid(false)
            player2:SetNoDraw(false)
            player2:Freeze(false)
            player2:SetDSP(0)
            player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player2:SetPos(Vector(3840.3127441406, 7382.4204101563, 24.03125))
    
            player3:SetMoveType(MOVETYPE_WALK)
            player3:SetNoTarget(false)
            player3:SetNotSolid(false)
            player3:SetNoDraw(false)
            player3:Freeze(false)
            player3:SetDSP(0)
            player3:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
            player3:SetPos(Vector(3830.8776855469, 7263.7553710938, 24.03125))

            player1:SetViewEntity(nil)
            player2:SetViewEntity(nil)
            player3:SetViewEntity(nil)
        end)
    end)

    timer.Simple(25, function()
        dropship:Fire("SetTrack", "sector3_dropship_track_2")
    end)

    timer.Simple(30, function()
        dropship:Fire("kill")
        dropflyingpoint1:Remove()
        dropflyingpoint2:Remove()
        dropposition:Remove()
    end)
end