local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()
    self.sector = nil

    local label = self:Add("Panel")
    label:Dock(TOP)
    label:DockMargin(16, 16, 16, 16)
    label:SetTall(ScreenScale(50))
    label.Paint = function(panel, w, h)
        draw.SimpleText("Waiting for more units...", "ixTitleFont", w / 2, h / 2, ix.config.Get("color"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local label = self:Add("Panel")
    label:Dock(TOP)
    label:DockMargin(16, 16, 16, 16)
    label:SetTall(ScreenScale(30))
    label.Paint = function(panel, w, h)
        if ( self.sector == 1 ) then
            draw.SimpleText(#ix.od.queue.sector1.." / 3", "ixSubTitle2Font", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif ( self.sector == 2 ) then
            draw.SimpleText(#ix.od.queue.sector2.." / 3", "ixSubTitle2Font", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif ( self.sector == 3 ) then
            draw.SimpleText(#ix.od.queue.sector3.." / 3", "ixSubTitle2Font", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local button = self:Add("ixMenuButton")
    button:SetText("Cancel")
    button:Dock(BOTTOM)
    button:SetContentAlignment(5)
    button:SizeToContents()
    button.DoClick = function()
        if ( self.sector == 1 ) then
            net.Start("ixOverwatchCancelSector1Queue")
            net.SendToServer()
        elseif ( self.sector == 2 ) then
            net.Start("ixOverwatchCancelSector2Queue")
            net.SendToServer()
        elseif ( self.sector == 3 ) then
            net.Start("ixOverwatchCancelSector3Queue")
            net.SendToServer()
        end

        self:Remove()
    end

    ix.gui.deploymentWait = self
end

function PANEL:Paint(w, h)
    ix.util.DrawBlur(self, 10)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

function PANEL:Think()
    if ( self.sector == 1 ) and ( #ix.od.queue.sector1 >= 3 ) then
        self:Remove()
    elseif ( self.sector == 2 ) and ( #ix.od.queue.sector2 >= 3 ) then
        self:Remove()
    elseif ( self.sector == 3 ) and ( #ix.od.queue.sector3 >= 3 ) then
        self:Remove()
    end
end

vgui.Register("ixOverwatchDeploymentWait", PANEL, "Panel")