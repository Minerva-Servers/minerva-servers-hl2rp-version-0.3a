local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()

    self.close = self:Add("ixMenuButton")
    self.close:Dock(TOP)
    self.close:SetText("Close")
    self.close:SizeToContents()
    self.close.DoClick = function()
        self:Remove()
    end

    self.sector3 = self:Add("Panel")
    self.sector3:SetSize(self:GetWide() / 3 - ScreenScale(22), self:GetTall())
    self.sector3:Dock(LEFT)
    self.sector3:DockMargin(ScreenScale(16), ScreenScale(16), 0, ScreenScale(16))
    self.sector3.Paint = function(panel, width, height)
        ix.util.DrawBlur(panel, 10)
        draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(ix.config.Get("color"), 25))
        draw.RoundedBox(0, 0, 0, width, height, Color(20, 20, 20, 200))
    end

    local label = self.sector3:Add("Panel")
    label:Dock(TOP)
    label:SetTall(ScreenScale(50))
    label.Paint = function(panel, width, height)
        draw.SimpleText("Sector 3", "ixTitleFont", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local button = self.sector3:Add("ixMenuButton")
    button:SetText("Join Queue")
    button:SetContentAlignment(5)
    button:SizeToContents()
    button:Dock(TOP)
    button.DoClick = function()
        net.Start("ixOverwatchJoinSector3Queue")
        net.SendToServer()

        self:Remove()
    end

    self.sector2 = self:Add("Panel")
    self.sector2:SetSize(self:GetWide() / 3 - ScreenScale(22), self:GetTall() - 40)
    self.sector2:Dock(LEFT)
    self.sector2:DockMargin(ScreenScale(16), ScreenScale(16), 0, ScreenScale(16))
    self.sector2.Paint = function(panel, width, height)
        ix.util.DrawBlur(panel, 10)
        draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(ix.config.Get("color"), 25))
        draw.RoundedBox(0, 0, 0, width, height, Color(20, 20, 20, 200))
    end

    local label = self.sector2:Add("Panel")
    label:Dock(TOP)
    label:SetTall(ScreenScale(50))
    label.Paint = function(panel, width, height)
        draw.SimpleText("Sector 2", "ixTitleFont", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local button = self.sector2:Add("ixMenuButton")
    button:SetText("Join Queue")
    button:SetContentAlignment(5)
    button:SizeToContents()
    button:Dock(TOP)
    button.DoClick = function()
        net.Start("ixOverwatchJoinSector2Queue")
        net.SendToServer()

        self:Remove()
    end

    self.sector1 = self:Add("Panel")
    self.sector1:SetSize(self:GetWide() / 3 - ScreenScale(22), self:GetTall() - 40)
    self.sector1:Dock(LEFT)
    self.sector1:DockMargin(ScreenScale(16), ScreenScale(16), 0, ScreenScale(16))
    self.sector1.Paint = function(panel, width, height)
        ix.util.DrawBlur(panel, 10)
        draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(ix.config.Get("color"), 25))
        draw.RoundedBox(0, 0, 0, width, height, Color(20, 20, 20, 200))
    end

    local label = self.sector1:Add("Panel")
    label:Dock(TOP)
    label:SetTall(ScreenScale(50))
    label.Paint = function(panel, width, height)
        draw.SimpleText("Sector 1", "ixTitleFont", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local button = self.sector1:Add("ixMenuButton")
    button:SetText("Join Queue")
    button:SetContentAlignment(5)
    button:SizeToContents()
    button:Dock(TOP)
    button.DoClick = function()
        net.Start("ixOverwatchJoinSector1Queue")
        net.SendToServer()

        self:Remove()
    end

    ix.gui.deployments = self
end

function PANEL:Paint(w, h)
    ix.util.DrawBlur(self, 10)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

vgui.Register("ixOverwatchDeployments", PANEL, "Panel")