local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    local options = {}
    options["Disable"] = true
    for k, v in pairs(ents.FindByClass("npc_combine_camera")) do
        options["View C-i"..v:EntIndex()] = true
    end

    for k, v in pairs(options) do
        local button = self:Add("ixCombineButton")
        button:SetText(k)
        button:SetFont("ixCombineButtonMediumFont")
        button:SetTall(40)
        button:Dock(TOP)
        button:DockMargin(16, 16, 16, 0)
        button.DoClick = function()
            print(self.combineTerminalEntity)
            net.Start("ixCombineTerminalCameraSwitch")
                net.WriteString(k)
                net.WriteEntity(self.combineTerminalEntity)
            net.SendToServer()
        end
    end
end

vgui.Register("ixCombineTerminalCamerasMenu", PANEL, "DScrollPanel")