ix.voice.beepSounds = {}
ix.voice.beepSounds[FACTION_CP] = {
    on = {
        "npc/metropolice/vo/on2.wav"
    },
    off = {
        "npc/metropolice/vo/off1.wav",
        "npc/metropolice/vo/off2.wav",
        "npc/metropolice/vo/off3.wav",
        "npc/metropolice/vo/off4.wav",
        "npc/overwatch/radiovoice/off2.wav",
        "npc/overwatch/radiovoice/off4.wav"

    },
}
ix.voice.beepSounds[FACTION_OW] = {
    on = {
        "npc/combine_soldier/vo/on1.wav",
        "npc/combine_soldier/vo/on2.wav"
    },
    off = {
        "npc/combine_soldier/vo/off1.wav",
        "npc/combine_soldier/vo/off2.wav",
        "npc/combine_soldier/vo/off3.wav"
    },
}

hook.Add("CPTalk", "CPTalk", function(ply, message, chatType)
    local volume = 80

    local sounds, text = ix.voice.GetVoiceList("combine", message)
    if not ( sounds ) then
        return
    end

    local beeps = ix.voice.beepSounds[ply:Team()]

    table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
    sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}

    if ( chatType == "radio" or chatType == "commandradio" ) then
        for k, v in pairs(player.GetAll()) do
            if not ( v:IsCombine() ) then
                continue
            end

            netstream.Start(nil, "ixVoicePlay", sounds, 70, v:EntIndex())
        end
    else
        netstream.Start(nil, "ixVoicePlay", sounds, volume, ply:EntIndex())
    end

    return text
end)

hook.Add("VortTalk", "VortTalk", function(ply, message, chatType)
    local volume = 80

    local sounds, text = ix.voice.GetVoiceList("vort", message)
    if not ( sounds ) then
        return
    end

    netstream.Start(nil, "ixVoicePlay", sounds, volume, ply:EntIndex())

    return text
end)

function PLUGIN:PlayerMessageSend(ply, chatType, formattedText, anonynmous, receivers, message)
    if not ( ix.voice.chatTypes[chatType] ) then
        return
    end

    if ( ply:IsCombine() ) then
        message2 = hook.Call("CPTalk", nil, ply, message, chatType)

        if ( message2 ) then
            message = message2
        end

        message = message
    elseif ( ply:Team() == FACTION_VORTIGAUNT ) then
        message2 = hook.Call("VortTalk", nil, ply, message, chatType)

        if ( message2 ) then
            message = message2
        end

        message = message
    end

    if ( ix.config.Get("chatAutoFormat") ) then
        message = ix.chat.Format(message)
    end

    if ( ply:IsCombine() ) and not ( chatType == "radio" or chatType == "overwatchradio" or chatType == "commandradio" ) then
        return "<:: "..message.." ::>"
    end

    return message
end