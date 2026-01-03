local PLUGIN = PLUGIN

hook.Remove("CreateMenuButtons", "ixConfig")

function PLUGIN:CreateMenuButtons(tabs)
    if not ( CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Manage Config", nil) ) then
        return
    end

    tabs["Cassie"] = {
        buttonColor = ix.config.Get("color"),
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
            ["Players"] = {
                Create = function(info, container)
                end,
            },
            ["Items"] = {
                Create = function(info, container)
                    container:Add("ixCassieItemsMenu")
                end,
            },
            ["Config"] = {
                Create = function(info, container)
                    container.panel = container:Add("ixConfigManager")
                end,
        
                OnSelected = function(info, container)
                    container.panel.searchEntry:RequestFocus()
                end,
            },
            ["Plugins"] = {
                Create = function(info, container)
                    ix.gui.pluginManager = container:Add("ixPluginManager")
                end,

                OnSelected = function(info, container)
                    ix.gui.pluginManager.searchEntry:RequestFocus()
                end,
            },
        }
    }
end

function PLUGIN:PopulateItemsMenu(tabs)
    local categories = {}
    for _, item in pairs(ix.item.list) do
        if ( table.HasValue(categories, item.category) ) then continue end

        if ( item.category ) then
            table.insert(categories, item.category)
        end
    end

    for k2, v2 in SortedPairs(categories) do
        tabs[v2] = function(container)
            for k, v in pairs(ix.item.list) do
                if ( v.category != v2 ) then
                    continue
                end

                local button = container:Add("ixMenuButton")
                button:Dock(TOP)
                button:SetText(v.name)
                button:SizeToContents()
                button.DoClick = function()
                    RunConsoleCommand("ix", "CharSpawnItem", v.uniqueID)
                end
                
                button.DoRightClick = function(self)
                    local menu = DermaMenu(false, self)

                    menu:AddOption("Copy uniqueID", function()
                        SetClipboardText(v.uniqueID)
                    end)

                    menu:AddSpacer()

                    for i = 1, 10 do
                        menu:AddOption("Give "..i.."x", function()
                            RunConsoleCommand("ix", "CharGiveItem", LocalPlayer():Nick(), v.uniqueID, i)
                        end)
                    end

                    menu:AddSpacer()

                    for i = 1, 10 do
                        menu:AddOption("Spawn "..i.."x", function()
                            RunConsoleCommand("ix", "CharSpawnItem", v.uniqueID, i)
                        end)
                    end

                    menu:Open()

                    for _, v in pairs(menu:GetChildren()[1]:GetChildren()) do
                        if ( v:GetClassName() == "Label" ) then
                            v:SetFont("ixSmallFont")
                        end
                    end
                end
            
                local icon = button:Add("ixSpawnIcon")
                icon:Dock(LEFT)
                icon:SetWide(button:GetTall())
                icon:SetModel(v.model)
                icon:SetSkin(v.skin or 0)

                button:SetTextInset(icon:GetWide() + 5, 0)
            end
        end
    end
end