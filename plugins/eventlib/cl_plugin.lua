net.Receive("ixEvent.PlaySound", function()
    local soundData = net.ReadTable()
    if not ( soundData.sound ) then return end

    if ( soundData.delay and isnumber(soundData.delay) ) then
        timer.Simple(soundData.delay, function()
            LocalPlayer():EmitSound(soundData.sound, soundData.db, soundData.pitch, soundData.volume)
        end)
    else
        LocalPlayer():EmitSound(soundData.sound, soundData.db, soundData.pitch, soundData.volume)
    end
end)

net.Receive("ixEvent.StopSound", function()
    local soundString = net.ReadString()
    if not ( soundString ) then return end

    LocalPlayer():StopSound(soundString)
end)

net.Receive("ixEvent.ViewPunch", function()
    local angle = net.ReadAngle()
    if not ( angle ) then return end

    LocalPlayer():ViewPunch(angle)
end)