local PLUGIN = PLUGIN

net.Receive("ixCBanSend", function()
    chat.AddText(ix.config.Get("color"), "[Minerva] ", Color(255, 140, 40), "You have been Combine Banned Until: ", ix.config.Get("color"), " "..LocalPlayer():GetCBanTimeReal()..".")
    surface.PlaySound("buttons/button10.wav")
end)

net.Receive("ixCBanSendRemove", function()
    chat.AddText(ix.config.Get("color"), "[Minerva] ", Color(255, 140, 40), "Your Combine Ban Has Been Removed.")
    surface.PlaySound("buttons/button10.wav")
end)