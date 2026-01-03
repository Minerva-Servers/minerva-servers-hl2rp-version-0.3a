local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    for k, v in pairs(ix.cityCode.codes) do
        local button = self:Add("ixCombineButton")
        button:SetText(string.upper(v.name))
        button:SetTextColor(v.color)
        button:SetTall(60)
        button:Dock(TOP)
        button:DockMargin(16, 16, 16, 0)
        button.DoClick = function()
            RunConsoleCommand("ix_code_set", k)
        end
    end
end

vgui.Register("ixCombineTerminalCityCodesMenu", PANEL, "DScrollPanel")