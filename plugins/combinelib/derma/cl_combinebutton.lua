DEFINE_BASECLASS("DButton")

local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(5) // default alignment for buttons
	self:SetTextColor(Color(35, 214, 248))
    self:SetFont("ixCombineButtonFont")
    self:SetTextInset(ScreenScale(8), 0)
end

function PANEL:SetTextColorInternal(color)
	BaseClass.SetTextColor(self, color)
end

function PANEL:SetTextColor(color)
    BaseClass.SetTextColor(self, color)
    self.textColor = color
end

function PANEL:OnCursorEntered()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self:GetTextColor()
    self:SetTextColorInternal(Color(textColor.r + 100, textColor.g + 100, textColor.b + 100))

    LocalPlayer():EmitSound("minerva/hl2rp/miscellaneous/combineui/wpn_moveselect.wav", nil, nil, 0.4)
end

function PANEL:OnCursorExited()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self.textColor
    self:SetTextColorInternal(textColor)

    LocalPlayer():EmitSound("minerva/hl2rp/miscellaneous/combineui/wpn_denyselect.wav", nil, nil, 0.1)
end

function PANEL:OnMousePressed(key)
    BaseClass.OnMousePressed(self, key)

	if ( self:GetDisabled() ) then
		return
	end

    self.bPressed = true
    timer.Simple(0.1, function()
        if ( IsValid(self) ) then
            self.bPressed = nil
        end
    end)

    LocalPlayer():EmitSound("minerva/hl2rp/miscellaneous/combineui/wpn_hudoff.wav", nil, nil, 0.6)
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(0, 0, 0, 66)
    surface.DrawRect(0, 0, width, height)

    ix.util.DrawBlur(self, 2)

    surface.SetDrawColor(35, 214, 248)
    surface.DrawOutlinedRect(0, 0, width, height, 4)
end

vgui.Register("ixCombineButton", PANEL, "DButton")