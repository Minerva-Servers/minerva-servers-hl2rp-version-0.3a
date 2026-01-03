local PLUGIN = PLUGIN

net.Receive("ixDispatchSend", function()
    chat.AddText(Color(21, 23, 146), "Dispatch Announces: "..net.ReadString())
end)

function ix.dispatch.announce(text, delay)
    if ( delay ) then
        if not ( isnumber(delay) ) then
            return
        end
        
        timer.Simple(delay, function()
            chat.AddText(Color(21, 23, 146), "Dispatch Announces: "..text)
        end)
    else
        chat.AddText(Color(21, 23, 146), "Dispatch Announces: "..text)
    end
end