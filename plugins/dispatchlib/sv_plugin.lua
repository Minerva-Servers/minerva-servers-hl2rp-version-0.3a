local PLUGIN = PLUGIN

util.AddNetworkString("ixDispatchSend")

function ix.dispatch.announce(text, delay, target)
    if ( delay ) then
        if not ( isnumber(delay) ) then
            return
        end

        timer.Simple(delay, function()
            if ( target and IsValid(target) ) then
                net.Start("ixDispatchSend")
                    net.WriteString(text)
                net.Send(target)
            else
                net.Start("ixDispatchSend")
                    net.WriteString(text)
                net.Broadcast()
            end
        end)
    else
        if ( target and IsValid(target) ) then
            net.Start("ixDispatchSend")
                net.WriteString(text)
            net.Send(target)
        else
            net.Start("ixDispatchSend")
                net.WriteString(text)
            net.Broadcast()
        end
    end
end

if ( timer.Exists("ixPasssiveDispatch") ) then
    timer.Remove("ixPassiveDispatch")
end

timer.Create("ixPassiveDispatch", ix.dispatch.config["dispatchCooldown"], 0, function()
    if ( ix.config.Get("passiveDispatch", true) ) then
        local randomLine = table.Random(ix.dispatch.config["dispatchLines"])
        if ( ix.dispatch.last == randomLine ) then
            randomLine = table.Random(ix.dispatch.config["dispatchLines"])
        end

        ix.event.PlaySoundGlobal({
            sound = randomLine.soundFile,
            volume = 0.2,
        })
        ix.dispatch.announce(randomLine.message)
        ix.dispatch.last = randomLine
        ix.dispatch.config["dispatchCooldown"] = math.random(300, 600)
    end
end)