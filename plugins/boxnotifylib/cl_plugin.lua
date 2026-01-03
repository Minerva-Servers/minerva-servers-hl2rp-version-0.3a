local PLUGIN = PLUGIN

local newY = 0
local gradient = surface.GetTextureID("vgui/gradient-u")
local function boxNotify(message, color)
    surface.SetFont("ixSubTitleFont")
    local w, h = surface.GetTextSize(ix.boxNotify.message or "INVALID INPUT")

    local height = h + 50
    newY = -height

    ix.boxNotify.message = message or "INVALID INPUT"
    ix.boxNotify.color = color or color_white
    ix.boxNotify.notified = true

    timer.Remove("ixBoxNotifyTimer")

    timer.Create("ixBoxNotifyTimer", ix.option.Get("noticeDuration", 8), 1, function()
        ix.boxNotify.notified = nil
    end)

    surface.PlaySound("buttons/bell1.wav")
end

function ix.boxNotify.BoxNotify(message)
    boxNotify(message)
end

net.Receive("ixBoxNotify.NewMessage", function()
    boxNotify(net.ReadString() or "INVALID INPUT", net.ReadColor() or color_white)
end)

function PLUGIN:HUDPaintAlternate(client, character)
    local text = ix.boxNotify.message or "INVALID INPUT"
    local color = ix.boxNotify.color or color_white

    surface.SetFont("ixSubTitleFont")
    local w, h = surface.GetTextSize(text)

    local width = w + 100
    local height = h + 50

    surface.SetTexture(gradient)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawTexturedRect(0, newY, ScrW(), height)

    ix.util.DrawBlurAt(0, newY, ScrW(), height, 2)

    draw.SimpleText(text, "ixSubTitleFont", ScrW() / 2, newY + height / 2 - 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if ( ix.boxNotify.notified ) then
        newY = Lerp(0.1, newY, 0)
    else
        newY = Lerp(0.1, newY, -height)
    end
end