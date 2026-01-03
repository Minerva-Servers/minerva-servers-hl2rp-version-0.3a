local PLUGIN = PLUGIN

local function factionPanel(container, ply, factions)
    local char = ply:GetCharacter()

    container.selectedFaction = nil

    local factionBecomeButton = container:Add("ixMenuButton")
    factionBecomeButton:Dock(BOTTOM)
    factionBecomeButton:SetText("Become Faction")
    factionBecomeButton:SetContentAlignment(5)
    factionBecomeButton:SizeToContents()
    factionBecomeButton.DoClick = function(self)
        net.Start("ixFactionMenuBecome")
            net.WriteUInt(container.selectedFaction, 8)
        net.SendToServer()
    end
    factionBecomeButton.Think = function(self)
        if ( container.selectedFaction and ply:GetXP() >= container.selectedFactionXP ) then
            factionBecomeButton:SetText("Become Faction")
            factionBecomeButton:SetEnabled(true)
        else
            factionBecomeButton:SetText("Select a Faction")
            factionBecomeButton:SetEnabled(false)
        end
    end

    local leftPanel = container:Add("DScrollPanel")
    leftPanel:Dock(LEFT)
    leftPanel:SetWide(container:GetWide() / 1.5)

    for k, v in pairs(factions) do
        if ( v.bDontShow ) then
            continue
        end

        if ( v.donatorOnly and not ply:IsDonator() ) then
            continue
        end

        if ( v.adminOnly and not ply:IsAdmin() ) then
            continue
        end

        if ( v.superAdminOnly and not ply:IsSuperAdmin() ) then
            continue
        end

        local model = tostring(table.Random(v.models)) or ply:GetModel()
        if ( string.find(model, "/hl2rp/") ) then
            model = char:GetData("originalModel", table.Random(ix.faction.Get(v.index).models))
        end
        
        local factionButton = leftPanel:Add("ixMenuButton")
        factionButton:Dock(TOP)
        factionButton:SetText(tostring(v.name))
        factionButton:SetContentAlignment(8)
        factionButton:SetSize(container:GetWide() / 2, 137,5)
        if ( ply:GetXP() >= v.xp ) then
            factionButton:SetTextColor(v.color)
            factionButton:SetBackgroundColor(Color(0, 255, 0))
        else
            factionButton:SetTextColor(v.color)
            factionButton:SetBackgroundColor(Color(255, 0, 0))
        end
        factionButton.DoClick = function(self)
            container.selectedFaction = k
            container.selectedFactionXP = v.xp

            if ( container.factionModel ) then
                container.factionModel:SetModel(model)

                if ( v.bodyGroups and IsValid(container.factionModel.Entity) ) then
                    for k, value in pairs(v.bodyGroups) do
                        local index = container.factionModel.Entity:FindBodygroupByName(k)

                        if ( index > -1 ) then
                            container.factionModel.Entity:SetBodygroup(index, value)
                        end
                    end
                end
            end
        end

        factionButton.Think = function(this)
            if ( v.donatorOnly and ply:IsDonator() ) then
                this:SetEnabled(true)
            elseif ( v.donatorOnly and not ply:IsDonator() ) then
                this:SetEnabled(false)
            end

            if ( this.factionButtonText ) then
                this.factionButtonText:SetFontInternal("ixSmallLightFont")
            end
        end

        factionButton.factionButtonModel = factionButton:Add("ixSpawnIcon")
        factionButton.factionButtonModel:Dock(LEFT)
        factionButton.factionButtonModel:SetWide(factionButton:GetTall())
        factionButton.factionButtonModel:SetModel(model)

        if ( v.bodyGroups and IsValid(factionButton.factionButtonModel.Entity) ) then
            for k, value in pairs(v.bodyGroups) do
                local index = factionButton.factionButtonModel.Entity:FindBodygroupByName(k)

                if ( index > -1 ) then
                    factionButton.factionButtonModel.Entity:SetBodygroup(index, value)
                end
            end
        end
        
        -- add a label to the button to show the xp cost of the faction
        local factionButtonLabel = factionButton:Add("DLabel")
        factionButtonLabel:Dock(RIGHT)
        factionButtonLabel:DockMargin(0, 0, 10, 0)
        factionButtonLabel:SetText(tostring(v.xp))
        if ( ply:GetXP() >= v.xp ) then
            factionButtonLabel:SetTextColor(Color(0, 200, 0))
        else
            factionButtonLabel:SetTextColor(Color(200, 0, 0))
        end
        factionButtonLabel:SetFont("ixMenuButtonFontSmall")
        factionButtonLabel:SetContentAlignment(5)
        factionButtonLabel:SetWide(factionButton:GetTall())
        
        factionButton.factionButtonText = factionButton:Add("RichText")
        factionButton.factionButtonText:SetText(v.description)
        factionButton.factionButtonText:Dock(FILL)
        factionButton.factionButtonText:DockMargin(0, 35, 0, 0)
        factionButton.factionButtonText:SetVerticalScrollbarEnabled(false)
        factionButton.factionButtonText:SetMouseInputEnabled(false)
    end
    
    container.factionModel = container:Add("ixModelPanel")
    container.factionModel:Dock(FILL)
    container.factionModel:SetModel("")
    container.factionModel:SetFOV(ScreenScale(16))
end

function PLUGIN:CreateMenuButtons(tabs)
    local ply = LocalPlayer()

    if not ( IsValid(ply) and ply:Alive() ) then
        return
    end
    
    if ( ply:IsArrested() ) then
        return
    end
    
    if ( ply:GetLocalVar("ragdoll") ) then
        return
    end

    local combineAllowedFactions = {
        [FACTION_ADMINISTRATOR] = true,
        [FACTION_CP] = true,
        [FACTION_OW] = true,
        [FACTION_HUNTER] = true,
    }

    local humanAllowedFactions = {
        [FACTION_CITIZEN] = true,
        [FACTION_CWU] = true,
        [FACTION_LEGION314] = true,
    }

    local xenAllowedFactions = {
        [FACTION_VORTIGAUNT] = true,
        [FACTION_ANTLION] = true,
        [FACTION_NECROTIC] = true,
    }

    local combineFactions = {}
    local humanFactions = {}
    local xenFactions = {}

    for k, v in pairs(ix.faction.indices) do
        if ( combineAllowedFactions[k] ) then
            combineFactions[k] = v
        end

        if ( humanAllowedFactions[k] ) then
            humanFactions[k] = v
        end

        if ( xenAllowedFactions[k] ) then
            xenFactions[k] = v
        end
    end

    tabs["Factions"] = {
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
            ["Combine Empire"] = {
                buttonColor = Color(0, 80, 180),
                Create = function(info, container)
                    factionPanel(container, ply, combineFactions)
                end,
            },
            ["Humanity"] = {
                buttonColor = Color(20, 180, 20),
                Create = function(info, container)
                    factionPanel(container, ply, humanFactions)
                end,
            },
            ["Xenians"] = {
                buttonColor = Color(120, 40, 180),
                Create = function(info, container)
                    factionPanel(container, ply, xenFactions)
                end,
            },
        }
    }
end