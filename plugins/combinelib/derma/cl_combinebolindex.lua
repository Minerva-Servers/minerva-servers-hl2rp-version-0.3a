local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    for k, v in pairs(player.GetAll()) do
        if not ( v:GetCharacter() and v:GetCharacter():GetBol() ) then
            continue
        end

        local label = self:Add("Panel")
        label:SetTall(64 + 8)
        label:Dock(TOP)
        label:DockMargin(16, 16, 16, 0)
        label.Paint = function(this, width, height)
            surface.SetDrawColor(0, 0, 0, 66)
            surface.DrawRect(0, 0, width, height)
        
            surface.SetDrawColor(35, 214, 248)
            surface.DrawOutlinedRect(0, 0, width, height, 4)
            
            draw.SimpleText(v:Nick(), "ixCombineButtonFont", 10, height / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(v:GetCharacter():GetBolReason(), "ixCombineButtonMediumFont", width - 10, height / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end
end

vgui.Register("ixCombineTerminalBolIndexMenu", PANEL, "DScrollPanel")