local PLUGIN = PLUGIN

function PLUGIN:CreateMenuButtons(tabs)
    local ply, char = LocalPlayer(), LocalPlayer():GetCharacter()

    if not ( IsValid(ply) and ply:Alive() ) then
        return
    end
    
    if ( ply:IsArrested() ) then
        return
    end

    tabs["skins"] = {
        Create = function(info, container)
            container.idlePanel = container:Add("Panel")
            container.idlePanel:Dock(FILL)
            container.idlePanel:DockMargin(8, 0, 0, 0)
            container.idlePanel.Paint = function(_, width, height)
                surface.SetDrawColor(Color(0, 0, 0, 66))
                surface.DrawRect(0, 0, width, height)

                derma.SkinFunc("DrawHelixCurved", width * 0.5, height * 0.5, width * 0.2)

                surface.SetFont("ixIntroSubtitleFont")
                local text = L("helix"):lower()
                local textWidth, textHeight = surface.GetTextSize(text)

                surface.SetTextColor(color_white)
                surface.SetTextPos(width * 0.5 - textWidth * 0.5, height * 0.5 - textHeight * 0.75)
                surface.DrawText(text)

                surface.SetFont("ixMediumLightFont")
                text = "Select a category at the top"
                local infoWidth, _ = surface.GetTextSize(text)

                surface.SetTextColor(color_white)
                surface.SetTextPos(width * 0.5 - infoWidth * 0.5, height * 0.5 + textHeight * 0.25)
                surface.DrawText(text)
            end
        end,
        Sections = {
            ["citizen skins"] = {
                Create = function(info, container)
                    if ( !string.find(ply:GetModel(), "/hl2rp/") ) or ( ply:Is647E() or ply:IsAdministrator() or ply:Team() == FACTION_CWU ) then
                        container.idlePanel = container:Add("Panel")
                        container.idlePanel:Dock(FILL)
                        container.idlePanel:DockMargin(8, 0, 0, 0)
                        container.idlePanel.Paint = function(_, width, height)
                            surface.SetDrawColor(Color(0, 0, 0, 66))
                            surface.DrawRect(0, 0, width, height)
            
                            derma.SkinFunc("DrawHelixCurved", width * 0.5, height * 0.5, width * 0.2)
            
                            surface.SetFont("ixIntroSubtitleFont")
                            local text = L("helix"):lower()
                            local textWidth, textHeight = surface.GetTextSize(text)
            
                            surface.SetTextColor(color_white)
                            surface.SetTextPos(width * 0.5 - textWidth * 0.5, height * 0.5 - textHeight * 0.75)
                            surface.DrawText(text)
            
                            surface.SetFont("ixMediumLightFont")
                            text = "Your faction & model does not support this feature"
                            local infoWidth, _ = surface.GetTextSize(text)
            
                            surface.SetTextColor(color_white)
                            surface.SetTextPos(width * 0.5 - infoWidth * 0.5, height * 0.5 + textHeight * 0.25)
                            surface.DrawText(text)
                        end

                        return
                    end

                    local char = ply:GetCharacter()

                    container.selectedSkin = 0

                    local updateButton = container:Add("ixMenuButton")
                    updateButton:Dock(BOTTOM)
                    updateButton:SetText("Update")
                    updateButton:SetContentAlignment(5)
                    updateButton:SizeToContents()
                    updateButton.DoClick = function(self)
                        net.Start("ixUpdateCitizenSkin")
                            net.WriteUInt(container.selectedTorso or 0, 8)
                            net.WriteUInt(container.selectedLegs or 0, 8)
                            net.WriteUInt(container.selectedHands or 0, 8)
                            net.WriteUInt(container.selectedGlasses or 0, 8)
                            net.WriteUInt(container.selectedSkin or 0, 8)
                        net.SendToServer()
                    end

                    local skinPanel = container:Add("Panel")
                    skinPanel:Dock(LEFT)
                    skinPanel:SetWide(container:GetWide() / 3)

                    local scroller = skinPanel:Add("DScrollPanel")
                    scroller:Dock(FILL)

                    local model = char:GetData("originalModel", table.Random(ix.faction.Get(FACTION_CITIZEN).models))

                    local label = scroller:Add("ixLabel")
                    label:Dock(TOP)
                    label:SetText("Skins")
                    label:SetFont("ixBigFont")
                    label:SizeToContents()
                    label:SetContentAlignment(5)

                    for i = 0, LocalPlayer():SkinCount() - 1 do
                        local button = scroller:Add("ixMenuButton")
                        button:Dock(TOP)
                        button:SetText("Skin "..i)
                        button:SetContentAlignment(5)
                        button:SizeToContents()
                        button.DoClick = function(self)
                            container.selectedSkin = i

                            if ( container.model ) then
                                container.model:SetModel(model, container.selectedSkin or 0)

                                local ent = container.model.Entity
                                if ( ent ) then
                                    ent:SetBodygroup(1, container.selectedTorso or 0)
                                    ent:SetBodygroup(2, container.selectedLegs or 0)
                                    ent:SetBodygroup(3, container.selectedHands or 0)
                                    ent:SetBodygroup(6, container.selectedGlasses or 0)
                                end
                            end
                        end

                        button.buttonModel = button:Add("ixSpawnIcon")
                        button.buttonModel:Dock(LEFT)
                        button.buttonModel:SetWide(button:GetTall())
                        button.buttonModel:SetModel(model, i)
                    end

                    local label = scroller:Add("ixLabel")
                    label:Dock(TOP)
                    label:SetText("Hand Bodygroups")
                    label:SetFont("ixBigFont")
                    label:SizeToContents()
                    label:SetContentAlignment(5)

                    for i = 0, LocalPlayer():GetBodygroupCount(3) - 1 do
                        local button = scroller:Add("ixMenuButton")
                        button:Dock(TOP)
                        button:SetText("Hands "..i)
                        button:SetContentAlignment(5)
                        button:SizeToContents()
                        button.DoClick = function(self)
                            container.selectedHands = i

                            if ( container.model ) then
                                container.model:SetModel(model, container.selectedSkin or 0)

                                local ent = container.model.Entity
                                if ( ent ) then
                                    ent:SetBodygroup(1, container.selectedTorso or 0)
                                    ent:SetBodygroup(2, container.selectedLegs or 0)
                                    ent:SetBodygroup(3, container.selectedHands or 0)
                                    ent:SetBodygroup(6, container.selectedGlasses or 0)
                                end
                            end
                        end

                        button.buttonModel = button:Add("ixSpawnIcon")
                        button.buttonModel:Dock(LEFT)
                        button.buttonModel:SetWide(button:GetTall())
                        button.buttonModel:SetModel(model)
                        
                        local ent = button.buttonModel.Entity
                        if ( ent ) then
                            ent:SetBodygroup(3, i)
                        end
                    end

                    local label = scroller:Add("ixLabel")
                    label:Dock(TOP)
                    label:SetText("Glasses Bodygroups")
                    label:SetFont("ixBigFont")
                    label:SizeToContents()
                    label:SetContentAlignment(5)

                    for i = 0, LocalPlayer():GetBodygroupCount(6) - 1 do
                        local button = scroller:Add("ixMenuButton")
                        button:Dock(TOP)
                        button:SetText("Glasses "..i)
                        button:SetContentAlignment(5)
                        button:SizeToContents()
                        button.DoClick = function(self)
                            container.selectedGlasses = i

                            if ( container.model ) then
                                container.model:SetModel(model, container.selectedSkin or 0)

                                local ent = container.model.Entity
                                if ( ent ) then
                                    ent:SetBodygroup(1, container.selectedTorso or 0)
                                    ent:SetBodygroup(2, container.selectedLegs or 0)
                                    ent:SetBodygroup(3, container.selectedHands or 0)
                                    ent:SetBodygroup(6, container.selectedGlasses or 0)
                                end
                            end
                        end

                        button.buttonModel = button:Add("ixSpawnIcon")
                        button.buttonModel:Dock(LEFT)
                        button.buttonModel:SetWide(button:GetTall())
                        button.buttonModel:SetModel(model)
                        
                        local ent = button.buttonModel.Entity
                        if ( ent ) then
                            ent:SetBodygroup(6, i)
                        end
                    end

                    local bodygroupPanel = container:Add("Panel")
                    bodygroupPanel:Dock(RIGHT)
                    bodygroupPanel:SetWide(container:GetWide() / 3)

                    local scroller = bodygroupPanel:Add("DScrollPanel")
                    scroller:Dock(FILL)

                    local label = scroller:Add("ixLabel")
                    label:Dock(TOP)
                    label:SetText("Torso Bodygroups")
                    label:SetFont("ixBigFont")
                    label:SizeToContents()
                    label:SetContentAlignment(5)

                    for i = 0, 12 do
                        local button = scroller:Add("ixMenuButton")
                        button:Dock(TOP)
                        button:SetText("Torso "..i)
                        button:SetContentAlignment(5)
                        button:SizeToContents()
                        button.DoClick = function(self)
                            container.selectedTorso = i

                            if ( container.model ) then
                                container.model:SetModel(model, container.selectedSkin or 0)

                                local ent = container.model.Entity
                                if ( ent ) then
                                    ent:SetBodygroup(1, container.selectedTorso or 0)
                                    ent:SetBodygroup(2, container.selectedLegs or 0)
                                    ent:SetBodygroup(3, container.selectedHands or 0)
                                    ent:SetBodygroup(6, container.selectedGlasses or 0)
                                end
                            end
                        end

                        button.buttonModel = button:Add("ixSpawnIcon")
                        button.buttonModel:Dock(LEFT)
                        button.buttonModel:SetWide(button:GetTall())
                        button.buttonModel:SetModel(model)
                        
                        local ent = button.buttonModel.Entity
                        if ( ent ) then
                            ent:SetBodygroup(1, i)
                        end
                    end

                    local label = scroller:Add("ixLabel")
                    label:Dock(TOP)
                    label:SetText("Legs Bodygroups")
                    label:SetFont("ixBigFont")
                    label:SizeToContents()
                    label:SetContentAlignment(5)

                    for i = 0, 5 do
                        local button = scroller:Add("ixMenuButton")
                        button:Dock(TOP)
                        button:SetText("Legs "..i)
                        button:SetContentAlignment(5)
                        button:SizeToContents()
                        button.DoClick = function(self)
                            container.selectedLegs = i

                            if ( container.model ) then
                                container.model:SetModel(model, container.selectedSkin or 0)

                                local ent = container.model.Entity
                                if ( ent ) then
                                    ent:SetBodygroup(1, container.selectedTorso or 0)
                                    ent:SetBodygroup(2, container.selectedLegs or 0)
                                    ent:SetBodygroup(3, container.selectedHands or 0)
                                    ent:SetBodygroup(6, container.selectedGlasses or 0)
                                end
                            end
                        end

                        button.buttonModel = button:Add("ixSpawnIcon")
                        button.buttonModel:Dock(LEFT)
                        button.buttonModel:SetWide(button:GetTall())
                        button.buttonModel:SetModel(model)
                        
                        local ent = button.buttonModel.Entity
                        if ( ent ) then
                            ent:SetBodygroup(2, i)
                        end
                    end
                    
                    container.model = container:Add("ixModelPanel")
                    container.model:Dock(FILL)
                    container.model:SetModel(LocalPlayer():GetModel(), LocalPlayer():GetSkin() or 0)
                    container.model:SetFOV(ScreenScale(16))
                end,
            },
            ["vortigaunt skins"] = {
                Create = function(info, container)
                    if not ( ply:IsDonator() ) then
                        container.idlePanel = container:Add("Panel")
                        container.idlePanel:Dock(FILL)
                        container.idlePanel:DockMargin(8, 0, 0, 0)
                        container.idlePanel.Paint = function(_, width, height)
                            surface.SetDrawColor(Color(0, 0, 0, 66))
                            surface.DrawRect(0, 0, width, height)
            
                            derma.SkinFunc("DrawHelixCurved", width * 0.5, height * 0.5, width * 0.2)
            
                            surface.SetFont("ixIntroSubtitleFont")
                            local text = L("helix"):lower()
                            local textWidth, textHeight = surface.GetTextSize(text)
            
                            surface.SetTextColor(color_white)
                            surface.SetTextPos(width * 0.5 - textWidth * 0.5, height * 0.5 - textHeight * 0.75)
                            surface.DrawText(text)
            
                            surface.SetFont("ixMediumLightFont")
                            text = "This feature is restricted to donators only"
                            local infoWidth, _ = surface.GetTextSize(text)
            
                            surface.SetTextColor(color_white)
                            surface.SetTextPos(width * 0.5 - infoWidth * 0.5, height * 0.5 + textHeight * 0.25)
                            surface.DrawText(text)
                        end

                        return
                    end

                    if ( !ply:IsVortigaunt() and ply:GetModel() != "models/minerva/vortigaunt.mdl" ) then
                        container.idlePanel = container:Add("Panel")
                        container.idlePanel:Dock(FILL)
                        container.idlePanel:DockMargin(8, 0, 0, 0)
                        container.idlePanel.Paint = function(_, width, height)
                            surface.SetDrawColor(Color(0, 0, 0, 66))
                            surface.DrawRect(0, 0, width, height)
            
                            derma.SkinFunc("DrawHelixCurved", width * 0.5, height * 0.5, width * 0.2)
            
                            surface.SetFont("ixIntroSubtitleFont")
                            local text = L("helix"):lower()
                            local textWidth, textHeight = surface.GetTextSize(text)
            
                            surface.SetTextColor(color_white)
                            surface.SetTextPos(width * 0.5 - textWidth * 0.5, height * 0.5 - textHeight * 0.75)
                            surface.DrawText(text)
            
                            surface.SetFont("ixMediumLightFont")
                            text = "Your faction & model does not support this feature"
                            local infoWidth, _ = surface.GetTextSize(text)
            
                            surface.SetTextColor(color_white)
                            surface.SetTextPos(width * 0.5 - infoWidth * 0.5, height * 0.5 + textHeight * 0.25)
                            surface.DrawText(text)
                        end

                        return
                    end

                    local char = ply:GetCharacter()

                    container.selectedSkin = 0

                    local updateButton = container:Add("ixMenuButton")
                    updateButton:Dock(BOTTOM)
                    updateButton:SetText("Update")
                    updateButton:SetContentAlignment(5)
                    updateButton:SizeToContents()
                    updateButton.DoClick = function(self)
                        net.Start("ixUpdateVortigauntSkin")
                            net.WriteUInt(container.selectedSkin or 0, 8)
                        net.SendToServer()
                    end

                    local skinPanel = container:Add("Panel")
                    skinPanel:Dock(LEFT)
                    skinPanel:SetWide(container:GetWide() / 3)

                    local scroller = skinPanel:Add("DScrollPanel")
                    scroller:Dock(FILL)

                    local model = "models/minerva/vortigaunt.mdl"

                    local label = scroller:Add("ixLabel")
                    label:Dock(TOP)
                    label:SetText("Skins")
                    label:SetFont("ixBigFont")
                    label:SizeToContents()
                    label:SetContentAlignment(5)

                    for i = 0, LocalPlayer():SkinCount() - 1 do
                        if ( i == 1 ) then
                            continue
                        end

                        local button = scroller:Add("ixMenuButton")
                        button:Dock(TOP)
                        button:SetText("Skin "..i)
                        button:SetContentAlignment(5)
                        button:SizeToContents()
                        button.DoClick = function(self)
                            container.selectedSkin = i

                            if ( container.model ) then
                                container.model:SetModel(model, container.selectedSkin or 0)
                            end
                        end

                        button.buttonModel = button:Add("ixSpawnIcon")
                        button.buttonModel:Dock(LEFT)
                        button.buttonModel:SetWide(button:GetTall())
                        button.buttonModel:SetModel(model, i)
                    end

                    local bodygroupPanel = container:Add("Panel")
                    bodygroupPanel:Dock(RIGHT)
                    bodygroupPanel:SetWide(container:GetWide() / 3)

                    local scroller = bodygroupPanel:Add("DScrollPanel")
                    scroller:Dock(FILL)
                    
                    container.model = container:Add("ixModelPanel")
                    container.model:Dock(FILL)
                    container.model:SetModel(LocalPlayer():GetModel(), LocalPlayer():GetSkin() or 0)
                    container.model:SetFOV(ScreenScale(16))
                end,
            }
        }
    }
end