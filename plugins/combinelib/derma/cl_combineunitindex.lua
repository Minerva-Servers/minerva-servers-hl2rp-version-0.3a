local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    local combineFactions = {
        [FACTION_CP] = true,
        [FACTION_OW] = true,
    }
    for k2, v2 in SortedPairs(ix.faction.indices) do
        if ( combineFactions[k2] ) then
            if ( team.NumPlayers(v2.index) == 0 ) then
                continue
            end

            local label = self:Add("Panel")
            label:SetTall(64 + 8)
            label:Dock(TOP)
            label:DockMargin(16, 16, 16, 0)
            label.Paint = function(this, width, height)
                surface.SetDrawColor(0, 0, 0, 66)
                surface.DrawRect(0, 0, width, height)
            
                ix.util.DrawBlur(this, 2)
            
                surface.SetDrawColor(35, 214, 248)
                surface.DrawOutlinedRect(0, 0, width, height, 4)
                
                draw.SimpleText(string.upper(v2.name), "ixCombineButtonFont", 10, height / 2, v2.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            for k, v in pairs(player.GetAll()) do
                if ( v:Team() == v2.index ) then
                    local label = self:Add("Panel")
                    label:SetTall(32 + 8)
                    label:Dock(TOP)
                    label:DockMargin(32, 16, 32, 0)
                    label.Paint = function(this, width, height)
                        surface.SetDrawColor(0, 0, 0, 66)
                        surface.DrawRect(0, 0, width, height)
                    
                        surface.SetDrawColor(35, 214, 248)
                        surface.DrawOutlinedRect(0, 0, width, height, 4)
                        
                        if ( v:GetCharacter():GetDefunct() ) then
                            draw.SimpleText(string.upper(v:Nick()), "ixCombineButtonMediumFont", 10, height / 2, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(string.upper(v:Nick()), "ixCombineButtonMediumFont", 10, height / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end
                    end

                    if not ( v:GetCharacter():GetDefunct() ) then
                        local bolButton = label:Add("ixCombineButton")
                        bolButton:SetText("MARK DEFUNCT")
                        bolButton:SetFont("ixCombineButtonSmallFont")
                        bolButton:SizeToContents()
                        bolButton:Dock(RIGHT)
                        bolButton.DoClick = function(this)
                            Derma_Query("", "Combine Terminal - Mark Defunct", "Mark Defunct", function()
                                net.Start("ixCombineTerminalMarkDefunct")
                                    net.WriteEntity(v)
                                net.SendToServer()
            
                                ix.combine.terminal.panel:Remove()
                                vgui.Create("ixCombineTerminalMenu")
                            end, "Cancel")
                        end
                    else
                        local bolButton = label:Add("ixCombineButton")
                        bolButton:SetText("UN-MARK DEFUNCT")
                        bolButton:SetFont("ixCombineButtonSmallFont")
                        bolButton:SizeToContents()
                        bolButton:Dock(RIGHT)
                        bolButton.DoClick = function(this)
                            Derma_Query("", "Combine Terminal - Un-Mark Defunct", "Un-Mark Defunct", function()
                                net.Start("ixCombineTerminalUnMarkDefunct")
                                    net.WriteEntity(v)
                                net.SendToServer()
            
                                ix.combine.terminal.panel:Remove()
                                vgui.Create("ixCombineTerminalMenu")
                            end, "Cancel")
                        end
                    end
                end
            end
        end
    end
end

vgui.Register("ixCombineTerminalUnitIndexMenu", PANEL, "DScrollPanel")