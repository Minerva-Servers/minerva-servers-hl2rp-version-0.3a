local PLUGIN = PLUGIN

net.Receive("ixWarnSend", function()
    local reason = net.ReadString()

    chat.AddText(ix.config.Get("color"), "[Minerva] ", Color(255, 40, 40), "You have been warned for: ", color_white, reason)
    surface.PlaySound("buttons/button10.wav")
end)

net.Receive("ixWarnSendAll", function()
    local target = net.ReadString()
    local reason = net.ReadString()

    if ( target == LocalPlayer():SteamName() ) then
        return
    end

    chat.AddText(ix.config.Get("color"), "[Minerva] ", Color(255, 140, 40), target.." has been warned for: ", color_white, reason)
    surface.PlaySound("minerva/global/talk.mp3")
end)

net.Receive("ixWarnGetAll", function()
    local amount = net.ReadString()
    local warnings = " warnings!"

    if ( amount == 1 ) then
        warnings = " warning!"
    end

    chat.AddText(ix.config.Get("color"), "[Minerva] ", color_white, "You have an amount of ", amount, warnings)
    surface.PlaySound("minerva/global/talk.mp3")
end)

net.Receive("ixWarnListAll", function()
    local warnTable = net.ReadTable()
    local name = net.ReadString()

    if ( #warnTable == 0 ) then
        chat.AddText(ix.config.Get("color"), "[Minerva] ", color_white, name, " has no warnings!")
        surface.PlaySound("minerva/global/talk.mp3")
        return
    end

    chat.AddText(ix.config.Get("color"), "[Minerva] ", color_white, "List of warnings from ", name, "!")
    for k, v in pairs(warnTable) do
        chat.AddText(ix.config.Get("color"), "[Minerva] ", color_white, k, ' -> "'..v..'"')
    end
    surface.PlaySound("minerva/global/talk.mp3")
end)

net.Receive("ixWarnSync", function()
    local warnTable = net.ReadTable()

    LocalPlayer().warnings = warnTable
end)