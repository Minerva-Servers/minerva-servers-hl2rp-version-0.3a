-- Here is where all clientside functions should go.

net.Receive("ixSurfaceSound", function()
    local sound = net.ReadString()

    surface.PlaySound(sound)
end)

function ix.util.DrawTexture(material, color, x, y, w, h)
    surface.SetDrawColor(color or color_white)
    surface.SetMaterial(ix.util.GetMaterial(material))
    surface.DrawTexturedRect(x, y, w, h)
end

function ix.util.TextSize(text, font)
    surface.SetFont(font)
    return surface.GetTextSize(text)
end

concommand.Add("ix_debug_pos", function(ply)
    local pos = ply:GetPos()
    local output = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"

    chat.AddText(output)
    SetClipboardText(output)
end)

concommand.Add("ix_debug_eyepos", function(ply)
    local pos = ply:EyePos()
    local output = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"

    chat.AddText(output)
    SetClipboardText(output)
end)

concommand.Add("ix_debug_ang", function(ply)
    local pos = ply:EyeAngles()
    local output = "Angle("..pos.p..", "..pos.y..", "..pos.r..")"

    chat.AddText(output)
    SetClipboardText(output)
end)

concommand.Add("ix_debug_getbones", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    for i = 0, ent:GetBoneCount() - 1 do
        local bonepos = ent:GetBonePosition(i)
        print("Bone "..i.."\nName: "..ent:GetBoneName(i).."\nVector("..bonepos.x..", "..bonepos.y..", "..bonepos.z..")")
    end
end)

concommand.Add("ix_debug_intro_getpos", function(ply)
    local pos = ply:EyePos()
    local introDetails = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
    
    chat.AddText(introDetails)
    SetClipboardText(introDetails)
end)

concommand.Add("ix_debug_intro_getang", function(ply)
    local ang = ply:GetAngles()
    local introDetails = "Angle("..ang.p..", "..ang.y..", "..ang.r..")"

    chat.AddText(introDetails)
    SetClipboardText(introDetails)
end)

concommand.Add("ix_debug_intro_getposang", function(ply)
    local pos = ply:EyePos()
    local ang = ply:GetAngles()
    local introDetails = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
    introDetails = introDetails..",\nAngle("..ang.p..", "..ang.y..", "..ang.r..")"

    chat.AddText(introDetails)
    SetClipboardText(introDetails)
end)

concommand.Add("ix_debug_getattachments", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    PrintTable(ent:GetAttachments())
end)

sound.Add({
    name = "Helix.Whoosh",
    sound = "",
})

sound.Add({
    name = "Helix.Rollover",
    volume = 0.1,
    pitch = 100,
    sound = "ui/buttonrollover.wav",
})

sound.Add({
    name = "Helix.Press",
    volume = 0.6,
    pitch = 100,
    sound = "ui/buttonclickrelease.wav",
})

sound.Add({
    name = "Helix.Notify",
    volume = 0.4,
    pitch = 120,
    sound = "buttons/blip1.wav",
})

surface.CreateFont("ixRadioFont", {
    font = "Consolas",
    size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
    scanlines = 2,
    antialias = true,
    shadow = true,
})