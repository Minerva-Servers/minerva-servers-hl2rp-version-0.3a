netstream.Hook("ixVoicePlay", function(sounds, volume, index)
    if ( index ) then
        local ply = Entity(index)

        if ( IsValid(ply) ) then
            ix.util.EmitQueuedSounds(ply, sounds, nil, nil, volume)
        end
    else
        if ( LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP ) then
            ix.util.EmitQueuedSounds(ply, sounds, nil, nil, volume)
        end
    end
end)