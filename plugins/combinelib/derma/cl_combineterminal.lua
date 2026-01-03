local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()

    if not ( ply.IsCombine and ply:IsCombine() ) then
        self:Remove()
    end

    local closeButton = self:Add("ixCombineButton")
    closeButton:SetText("RETURN")
    closeButton:SetPos(ScrW() / 2 - 250, ScrH() - 200)
    closeButton:SetSize(500, 150)
    closeButton.DoClick = function(this)
        self:Remove()
    end

    local panel = self:Add("Panel")
    panel:Dock(FILL)
    panel:DockMargin(ScreenScale(16), ScreenScale(16), ScreenScale(16), ScreenScale(16) + 200)
    panel.Paint = function(this, width, height)
        surface.SetDrawColor(14, 60, 73, 66)
        surface.DrawRect(0, 0, width, height)

        ix.util.DrawBlur(this, 2)

        surface.SetDrawColor(35, 214, 248)
        surface.DrawRect(0, 0, width, 30)
    end

    local label = panel:Add("DLabel")
    label:SetText("COMBINE TERMINAL")
    label:SetFont("ixSmallFont")
    label:SetTall(30)
    label:Dock(TOP)
    label:DockMargin(8, 0, 0, 0)

    self.sheet = panel:Add("ixCombineColumnSheet")
    self.sheet:Dock(FILL)
	self.sheet.Navigation:SetWidth(self:GetWide() / 6)
	self.sheet.Navigation:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))
	self.sheet.Navigation.Paint = function(this, width, height)
    end

    local unitIndex = panel:Add("ixCombineTerminalUnitIndexMenu")
    unitIndex:Dock(FILL)

    local unitIndexButton = self.sheet:AddSheet("UNIT INDEX", unitIndex)
    unitIndexButton.Button:DockMargin(0, 0, 0, ScreenScale(4))
    unitIndexButton.Button:SetTall(40)
    unitIndexButton.Button:SetFont("ixCombineButtonMediumFont")

    local citizenIndex = panel:Add("ixCombineTerminalCitizenIndexMenu")
    citizenIndex:Dock(FILL)

    local citizenIndexButton = self.sheet:AddSheet("CITIZEN INDEX", citizenIndex)
    citizenIndexButton.Button:DockMargin(0, 0, 0, ScreenScale(4))
    citizenIndexButton.Button:SetTall(40)
    citizenIndexButton.Button:SetFont("ixCombineButtonMediumFont")

    local bolIndex = panel:Add("ixCombineTerminalBolIndexMenu")
    bolIndex:Dock(FILL)

    local bolIndexButton = self.sheet:AddSheet("BOL INDEX", bolIndex)
    bolIndexButton.Button:DockMargin(0, 0, 0, ScreenScale(4))
    bolIndexButton.Button:SetTall(40)
    bolIndexButton.Button:SetFont("ixCombineButtonMediumFont")

    local cityCodes = panel:Add("ixCombineTerminalCityCodesMenu")
    cityCodes:Dock(FILL)

    local cityCodesButton = self.sheet:AddSheet("CITY CODES", cityCodes)
    cityCodesButton.Button:DockMargin(0, 0, 0, ScreenScale(4))
    cityCodesButton.Button:SetTall(40)
    cityCodesButton.Button:SetFont("ixCombineButtonMediumFont")

    local cameras = panel:Add("ixCombineTerminalCamerasMenu")
    cameras:Dock(FILL)
    timer.Simple(0, function()
        cameras.combineTerminalEntity = self.combineTerminalEntity
    end)

    local camerasButton = self.sheet:AddSheet("CAMERAS", cameras)
    camerasButton.Button:DockMargin(0, 0, 0, ScreenScale(4))
    camerasButton.Button:SetTall(40)
    camerasButton.Button:SetFont("ixCombineButtonMediumFont")

    ix.combine.terminal.panel = self
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

vgui.Register("ixCombineTerminalMenu", PANEL, "Panel")

if ( ix.combine and ix.combine.terminal and ix.combine.terminal.panel and IsValid(ix.combine.terminal.panel) ) then
    ix.combine.terminal.panel:Remove()
end