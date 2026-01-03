local PANEL = {}

local scrW, scrH = ScrW(), ScrH()
function PANEL:Init()
    local ply = LocalPlayer()
    
    self:SetSize(scrW, scrH)
    self:Center()
    self:MakePopup()

    local closeButton = self:Add("ixCombineButton")
    closeButton:SetFont("ixCombineButtonFont")
    closeButton:SetText("RETURN")
    closeButton:SetTextColor(Color(35, 214, 248))
    closeButton:SetPos(scrW / 2 - 250, scrH - 200)
    closeButton:SetSize(500, 150)
    closeButton.DoClick = function(this)
        self:Remove()
    end
end

function PANEL:SetPlayer(ply)
    self.arrestedguy = ply

    self.charges = vgui.Create("DPanel", self)
    self.charges:Dock(FILL)
    self.charges:DockMargin(ScreenScale(16), ScreenScale(16), ScreenScale(16), ScreenScale(16) + 200)
    self.charges.Paint = function(this, width, height)
        surface.SetDrawColor(14, 60, 73, 66)
        surface.DrawRect(0, 0, width, height)

        ix.util.DrawBlur(this, 2)

        surface.SetDrawColor(35, 214, 248)
        surface.DrawRect(0, 0, width, 30)
    end

    self.chargesInfo = vgui.Create("DLabel", self.charges)
    self.chargesInfo:SetText("YOU ARE CHARGING: "..string.upper(self.arrestedguy:Nick()))
    self.chargesInfo:SetFont("ixSmallFont")
    self.chargesInfo:SetTall(30)
    self.chargesInfo:Dock(TOP)
    self.chargesInfo:DockMargin(8, 0, 0, 0)

    self.chargesBody = vgui.Create("ixChargesMenu", self.charges)
    self.chargesBody:Dock(FILL)
end

local scanlines = ix.util.GetMaterial("minerva/scanlines.png")
function PANEL:Paint(width, height)
    surface.SetDrawColor(10, 40, 50)
    surface.DrawRect(0, 0, width, height)

    surface.SetDrawColor(30, 210, 250, 10)
    surface.SetMaterial(scanlines)
    surface.DrawTexturedRect(0, 0, width, height)

    surface.SetDrawColor(0, 0, 0, 66)
    surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixChargeMenu", PANEL, "Panel")