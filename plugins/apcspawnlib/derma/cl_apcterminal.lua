local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()
    
    if not ( LocalPlayer():IsCombine() ) then
        self:Remove()
    end
    
    local closeButton = self:Add("ixCombineButton")
    closeButton:SetText("RETURN")
    closeButton:SetPos(ScrW() / 2 - 300, ScrH() - 200)
    closeButton:SetSize(500, 150)
    closeButton.DoClick = function(this)
        self:Remove()
    end
    
    local apcButton = self:Add("ixCombineButton")
    apcButton:SetText("ACTIVATE AN APC")
    apcButton:SetPos(ScrW() / 2 - 300, ScrH() - 400)
    apcButton:SetSize(500, 150)
    apcButton.DoClick = function(this)
        net.Start("ixAPCSpawn")
        net.SendToServer()
    end
    
    self.apcmodel = self:Add("DModelPanel")
    self.apcmodel:SetPos(ScrW() / 2 - 250, 500)
    self.apcmodel:SetSize(500, 500)
    self.apcmodel:SetModel("models/combine_apc_wheelcollision.mdl")
    self.apcmodel:SetCamPos(self.apcmodel:GetCamPos() - Vector(0, 225, 0) + Vector(0, 0, 20))
    self.apcmodel:SetFOV(70)
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

vgui.Register("ixAPCTerminal", PANEL, "DPanel")