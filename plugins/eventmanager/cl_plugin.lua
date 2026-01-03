local PLUGIN = PLUGIN

function PLUGIN:HUDPaint()
	local client = LocalPlayer()

    if ix_cinematicIntro and client:Alive() then
        local ft = FrameTime()
        local maxTall =  ScrH() * .12

        if holdTime and holdTime + 6 < CurTime() then
            letterboxFde = math.Clamp(letterboxFde - ft * .5, 0, 1)
            textFde = math.Clamp(textFde - ft * .3, 0, 1)

            if letterboxFde == 0 then
                ix_cinematicIntro = false
            end
        elseif holdTime and holdTime + 4 < CurTime() then
            textFde = math.Clamp(textFde - ft * .3, 0, 1)
        else
            letterboxFde = math.Clamp(letterboxFde + ft * .5, 0, 1)

            if letterboxFde == 1 then
                textFde = math.Clamp(textFde + ft * .1, 0, 1)
                holdTime = holdTime or CurTime()
            end
        end

        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, ScrW(), (maxTall * letterboxFde))
        surface.DrawRect(0, (ScrH() - (maxTall * letterboxFde)), ScrW(), maxTall + 1)

        draw.SimpleText(ix_cinematicTitle, "ixSubTitle2Font", 50, ScrH() - maxTall / 2, ColorAlpha(color_white, (255 * textFde)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        letterboxFde = 0
        textFde = 0
        holdTime = nil
    end
end

function ix.ops.eventManager.SequenceLoad(path)
    local fileData = file.Read(path, "DATA")
    local json = util.JSONToTable(fileData)

    if not json or not istable(json) then
        return false, "Corrupted sequence file"
    end

    if not json.Name or not json.Events or not json.FileName then
        return false, "Corrupted sequence file vital metadata"
    end

    ix.ops.eventManager.sequences[json.Name] = json

    return true
end

function ix.ops.eventManager.sequencesave(name)
    local sequence = ix.ops.eventManager.sequences[name]
    file.Write("minerva/eventmanager/"..sequence.FileName..".json", util.TableToJSON(sequence, true))
end

function ix.ops.eventManager.SequencePush(name)
    local sequence = ix.ops.eventManager.sequences[name]
    local events = sequence.Events
    local eventCount = table.Count(events)

    ix.log.AddRaw("Starting push of "..name..". (This might take a while)")

    net.Start("ixOpsEMPushSequence")
        net.WriteString(name)
        net.WriteUInt(eventCount, 16)

        for v,k in pairs(events) do
            local edata = pon.encode(k)
            net.WriteUInt(#edata, 16)
            net.WriteData(edata, #edata)

            ix.log.AddRaw("Packaged event "..v.."/"..eventCount.." ("..k.Type..")")
        end

    net.SendToServer()

    ix.log.AddRaw("Push fully sent to server!")
end

function ix.ops.eventManager.GetVersionHash()
    return util.CRC(util.TableToJSON(ix.ops.eventManager.config.Events))
end

net.Receive("ixCinematicMessage", function()
    local title = net.ReadString()

    ix_cinematicIntro = true
    ix_cinematicTitle = title
end)

net.Receive("ixOpsEMMenu", function()
    local count = net.ReadUInt(8)
    local svSequences = {}

    for i=1, count do
        table.insert(svSequences, net.ReadString())
    end

    if ( ix_eventmenu and IsValid(ix_eventmenu) ) then
        ix_eventmenu:Remove()
    end
    
    ix_eventmenu = vgui.Create("ixEventManager")
    ix_eventmenu:SetupPlayer(svSequences)
end)

net.Receive("ixOpsEMUpdateEvent", function()
    local event = net.ReadUInt(10)

    ix_OpsEM_LastEvent = event

    ix_OpsEM_CurEvents = ix_OpsEM_CurEvents or {}
    ix_OpsEM_CurEvents[event] = CurTime()
end)

net.Receive("ixOpsEMClientsideEvent", function()
    local event = net.ReadString()
    local uid = net.ReadString()
    local len = net.ReadUInt(16)
    local prop = pon.decode(net.ReadData(len))

    if not ix.ops.eventManager then
        return
    end

    local sequenceData = ix.ops.eventManager.config.Events[event]

    if not sequenceData then
        return
    end

    if not uid or uid == "" then
        uid = nil
    end

    sequenceData.Do(prop or {}, uid)
end)

net.Receive("ixOpsEMPlayScene", function()
    local scene = net.ReadString()

    if not ix.ops.eventManager.scenes[scene] then
        return ix.log.AddRaw("Error! Can't find sceneset: "..scene)
    end

    ix.scenes.PlaySet(ix.ops.eventManager.scenes[scene])
end)

local customAnims = customAnims or {}
net.Receive("ixOpsEMEntAnim", function()
    local entid = net.ReadUInt(16)
    local anim = net.ReadString()

    customAnims[entid] = anim

    timer.Remove("opsAnimEnt"..entid)
    timer.Create("opsAnimEnt"..entid, 0.05, 0, function()
        local ent = Entity(entid)

        if IsValid(ent) and customAnims[entid] and ent:GetSequence() == 0 then
            ent:ResetSequence(customAnims[entid])
        end
    end)
end)