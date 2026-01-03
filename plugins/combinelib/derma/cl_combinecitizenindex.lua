local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    for k, v in pairs(player.GetAll()) do
        if ( v:Team() == FACTION_CITIZEN ) then
            local label = self:Add("Panel")
            label:SetTall(40)
            label:Dock(TOP)
            label:DockMargin(16, 16, 16, 0)
            label.Paint = function(this, width, height)
                surface.SetDrawColor(0, 0, 0, 66)
                surface.DrawRect(0, 0, width, height)
            
                surface.SetDrawColor(35, 214, 248)
                surface.DrawOutlinedRect(0, 0, width, height, 4)
                
                draw.SimpleText(string.upper(v:Nick()), "ixCombineButtonMediumFont", 10, height / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            if not ( v:GetCharacter():GetBol() ) then
                local bolButton = label:Add("ixCombineButton")
                bolButton:SetText("MARK BOL")
                bolButton:SetFont("ixCombineButtonSmallFont")
                bolButton:SizeToContents()
                bolButton:Dock(RIGHT)
                bolButton.DoClick = function(this)
                    Derma_StringRequest("Combine Terminal - Mark BOL", "", "", function(text)
                        net.Start("ixCombineTerminalMarkBOL")
                            net.WriteEntity(v)
                            net.WriteString(text)
                        net.SendToServer()

                        ix.combine.terminal.panel:Remove()
                        vgui.Create("ixCombineTerminalMenu")
                    end, nil, "Mark BOL", "Cancel")
                end
            end

            local informantButton = label:Add("ixCombineButton")
            informantButton:SetText("MARK INFORMANT")
            informantButton:SetFont("ixCombineButtonSmallFont")
            informantButton:SizeToContents()
            informantButton:Dock(RIGHT)
            informantButton.DoClick = function(this)
                Derma_Query("", "Combine Terminal - Mark Informant", "Mark Informant", function()
                    net.Start("ixCombineTerminalMarkInformant")
                        net.WriteEntity(v)
                    net.SendToServer()

                    ix.combine.terminal.panel:Remove()
                    vgui.Create("ixCombineTerminalMenu")
                end, "Unmark Informant", function()
                    net.Start("ixCombineTerminalUnmarkInformant")
                        net.WriteEntity(v)
                    net.SendToServer()

                    ix.combine.terminal.panel:Remove()
                    vgui.Create("ixCombineTerminalMenu")
                end, "Cancel", nil)
            end
        end
    end
end

vgui.Register("ixCombineTerminalCitizenIndexMenu", PANEL, "DScrollPanel")