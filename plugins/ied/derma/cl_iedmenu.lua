local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(300, 100)
    self:SetTitle("IED Detonation Menu")
    self:Center()
    self:MakePopup()

    self.combo = self:Add("DComboBox")
    self.combo:SetValue("Select an IED Frequency.")
    self.combo:SetFont("ixMediumFont")
    self.combo:Dock(TOP)
    self.combo:SizeToContents()
    for k, v in pairs(PLUGIN.frequencies) do
        self.combo:AddChoice(v)
    end

    self.detonate = self:Add("ixMenuButton")
    self.detonate:Dock(FILL)
    self.detonate:SetText("Detonate")
    self.detonate:SetContentAlignment(5)
    self.detonate.DoClick = function(but, w, h)
        if ( self.combo:GetValue() == "Select an IED Frequency." ) then
            ply:Notify("You haven't selected an IED Frequency!")
            return
        end

        net.Start("ixIEDStartClientside")
            net.WriteString(self.combo:GetValue())
        net.SendToServer()

        self:Close()
    end
end

vgui.Register("ixIEDMenu", PANEL, "DFrame")