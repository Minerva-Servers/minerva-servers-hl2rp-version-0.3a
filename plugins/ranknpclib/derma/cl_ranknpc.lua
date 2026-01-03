local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:MakePopup()

    local buttons = self:Add("Panel")
    buttons:SetTall(50)
    buttons:Dock(TOP)

    if ( ix.faction.Get(ply:Team()).taglines ) then
        if not ( table.IsEmpty(ix.faction.Get(ply:Team()).taglines) ) then
            local taglines = buttons:Add("DComboBox")
            taglines:Dock(LEFT)
            taglines:SetText("Close")
            taglines:SetContentAlignment(5)
            taglines:SetWide(self:GetWide() / 4)
            taglines:SetValue("Pick a Tagline")
            taglines:SetFont("ixMenuButtonFontSmall")
            for k, v in pairs(ix.faction.Get(ply:Team()).taglines) do
                taglines:AddChoice(v)
            end
            taglines.OnSelect = function(this, index, value)
                self.selectedTagline = value

                ix.util.Notify("Selected "..value.." as a Tagline!")
            end
        end
    end

    -- close button
    self.close = buttons:Add("ixMenuButton")
    self.close:Dock(LEFT)
    self.close:SetText("Close")
    self.close:SetContentAlignment(5)
    self.close:SetWide(self:GetWide() / 4)
    self.close.DoClick = function()
        self:Remove()
    end

    -- become button
    self.become = buttons:Add("ixMenuButton")
    self.become:Dock(LEFT)
    self.become:SetText("Become")
    self.become:SetContentAlignment(5)
    self.become:SetWide(self:GetWide() / 4)
    self.become.DoClick = function()
        if ( ix.faction.Get(ply:Team()).ranks and !table.IsEmpty(ix.faction.Get(ply:Team()).ranks) ) then
            net.Start("ixRankNPC.Become")
                net.WriteUInt(self.selectedClass, 8)
                net.WriteUInt(self.selectedRank, 8)
                net.WriteString(self.selectedTagline or "")
            net.SendToServer()
        else
            net.Start("ixRankNPC.BecomeNoRank")
                net.WriteUInt(self.selectedClass, 8)
                net.WriteString(self.selectedTagline or "")
            net.SendToServer()
        end

        self:Remove()
    end

    -- refill button
    self.refill = buttons:Add("ixMenuButton")
    self.refill:Dock(LEFT)
    self.refill:SetText("Refill")
    self.refill:SetContentAlignment(5)
    self.refill:SetWide(self:GetWide() / 4)
    self.refill.DoClick = function()
        net.Start("ixRankNPC.Refill")
        net.SendToServer()

        self:Remove()
    end

    self.refill.Think = function(panel)
        if ( ply:GetTeamClass() == 0 ) then
            panel:SetDisabled(true)
        else
            panel:SetDisabled(false)
        end
    end

    self.become.Think = function(panel)
        -- if you wanna fix this pyramid, sure go on.
        if ( ix.faction.Get(ply:Team()).ranks ) then
            if not ( table.IsEmpty(ix.faction.Get(ply:Team()).ranks) ) then
                if not ( self.selectedRank and self.selectedClass ) then
                    panel:SetDisabled(true)
                    panel:SetText("Select a rank and a class first")
                else
                    panel:SetDisabled(false)
                    panel:SetText("Become")
                end
            else
                if not ( self.selectedClass ) then
                    panel:SetDisabled(true)
                    panel:SetText("Select a class first")
                else
                    panel:SetDisabled(false)
                    panel:SetText("Become")
                end
            end
        end
    end

    self.leftpanel = self:Add("DScrollPanel")
    self.leftpanel:Dock(LEFT)
    self.leftpanel:SetWide(self:GetWide() / 1.5)
    self.leftpanel.Paint = function(panel, w, h)
        surface.SetDrawColor(Color(0, 0, 0, 66))
        surface.DrawRect(0, 0, w, h)
    end

    self.model = self:Add("ixModelPanel")
    self.model:Dock(FILL)
    self.model:SetModel("")
    self.model:SetFOV(ScreenScale(16))

    local label = self:Add("DLabel")
    label:Dock(TOP)
    label:DockMargin(8, 8, 8, 0)
    label:SetTextColor(ix.faction.Get(ply:Team()).color)
    label:SetText(ix.faction.Get(ply:Team()).name)
    label:SetFont("ixSubTitleFont")
    label:SetContentAlignment(5)
    label:SizeToContents()

    -- Ranks
    if ( ix.faction.Get(ply:Team()).ranks ) then
        if not ( table.IsEmpty(ix.faction.Get(ply:Team()).ranks) ) then
            local label = self.leftpanel:Add("Panel")
            label:Dock(TOP)
            label:SetTall(40)
            label.Paint = function(panel, width, height)
                ix.util.DrawBlur(panel, 10)
                draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(ix.config.Get("color"), 25))
                draw.RoundedBox(0, 0, 0, width, height, Color(20, 20, 20, 200))
        
                draw.SimpleText("Ranks", "ixMedium2Font", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            for k, v in SortedPairs(ix.faction.Get(ply:Team()).ranks) do
                local rankTable = ix.faction.Get(ply:Team()).ranks[k]
                local rank = self.leftpanel:Add("ixMenuButton")
                rank:Dock(TOP)
                rank:SetText(tostring(v.name))
                rank:SetContentAlignment(8)
                rank:SetSize(self:GetWide() / 2, 125)
                rank.DoClick = function()
                    self.selectedRank = k
                    self.selectedRankData = v.name

                    ix.util.Notify("Selected "..v.name.." as a Rank!")
                end
                rank.Think = function(this)
                    if ( this.rankDescription ) then
                        this.rankDescription:SetFontInternal("ixSmallLightFont")
                    end
                end

                rank.rankDescription = rank:Add("RichText")
                rank.rankDescription:SetText(rankTable.description)
                rank.rankDescription:Dock(FILL)
                rank.rankDescription:DockMargin(0, 35, 0, 0)
                rank.rankDescription:SetVerticalScrollbarEnabled(false)
                rank.rankDescription:SetMouseInputEnabled(false)

                rank.rankModel = rank:Add("ixSpawnIcon")
                rank.rankModel:Dock(LEFT)
                rank.rankModel:SetWide(rank:GetTall())
                rank.rankModel:SetModel(rank.model or "", rank.skin or 0)

                -- add a label to the button to show the xp cost of the faction
                if ( v.whitelistUID ) then
                    local whitelistLabel = rank:Add("DLabel")
                    whitelistLabel:Dock(RIGHT)
                    whitelistLabel:DockMargin(0, 0, 10, 0)
                    whitelistLabel:SetText("Whitelisted")
                    whitelistLabel:SetFont("ixMenuButtonFontSmall")
                    whitelistLabel:SetContentAlignment(5)
                    whitelistLabel:SetWide(rank:GetTall())
                else
                    local xpLabel = rank:Add("DLabel")
                    xpLabel:Dock(RIGHT)
                    xpLabel:DockMargin(0, 0, 10, 0)
                    xpLabel:SetText(tostring(v.xp))
                    if ( ply:GetXP() >= v.xp ) then
                        xpLabel:SetTextColor(Color(0, 200, 0))
                    else
                        xpLabel:SetTextColor(Color(200, 0, 0))
                    end
                    xpLabel:SetFont("ixMenuButtonFontSmall")
                    xpLabel:SetContentAlignment(5)
                    xpLabel:SetWide(rank:GetTall())
                end
            end
        end
    end

    -- Classes
    local label = self.leftpanel:Add("Panel")
    label:Dock(TOP)
    label:SetTall(40)
    label.Paint = function(panel, width, height)
        ix.util.DrawBlur(panel, 10)
        draw.RoundedBox(0, 0, 0, width, height, ColorAlpha(ix.config.Get("color"), 25))
        draw.RoundedBox(0, 0, 0, width, height, Color(20, 20, 20, 200))

        draw.SimpleText("Classes", "ixMedium2Font", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if ( ix.faction.Get(ply:Team()).classes ) then
        if not ( table.IsEmpty(ix.faction.Get(ply:Team()).classes) ) then
            for k, v in SortedPairs(ix.faction.Get(ply:Team()).classes) do
                local classTable = ix.faction.Get(ply:Team()).classes[k]
                if ( classTable.adminOnly and not ply:IsAdmin() ) then
                    continue
                end

                local class = self.leftpanel:Add("ixMenuButton")
                class:Dock(TOP)
                class:SetText(tostring(v.name))
                class:SetContentAlignment(8)
                class:SetSize(self:GetWide() / 2, 125)
                class.DoClick = function(this)
                    self.selectedClass = k
                    self.selectedClassData = v.name

                    local class = ix.faction.Get(ply:Team()).classes[self.selectedClass]

                    if ( self.model and class.model ) then
                        self.model:SetModel(class.model or LocalPlayer():GetModel(), class.skin or 0)

                        if ( v.bodyGroups and IsValid(self.model.Entity) ) then
                            for k, value in pairs(v.bodyGroups) do
                                local index = self.model.Entity:FindBodygroupByName(k)

                                if ( index > -1 ) then
                                    self.model.Entity:SetBodygroup(index, value)
                                end
                            end
                        end
                    end

                    ix.util.Notify("Selected "..v.name.." as a Class!")
                end
                class.Think = function(this)
                    if ( this.classDescription ) then
                        this.classDescription:SetFontInternal("ixSmallLightFont")
                    end
                end

                class.classDescription = class:Add("RichText")
                class.classDescription:SetText(classTable.description)
                class.classDescription:Dock(FILL)
                class.classDescription:DockMargin(0, 35, 0, 0)
                class.classDescription:SetVerticalScrollbarEnabled(false)
                class.classDescription:SetMouseInputEnabled(false)

                class.classModel = class:Add("ixSpawnIcon")
                class.classModel:Dock(LEFT)
                class.classModel:SetWide(class:GetTall())
                class.classModel:SetModel(classTable.usePermaModel and ply:GetCharacter():GetData("originalModel", table.Random(ix.faction.Get(FACTION_CITIZEN).models)) or classTable.model or "", classTable.skin or 0)

                -- add a label to the button to show the xp cost of the faction
                if ( v.whitelistUID ) then
                    local whitelistLabel = class:Add("DLabel")
                    whitelistLabel:Dock(RIGHT)
                    whitelistLabel:DockMargin(0, 0, 10, 0)
                    whitelistLabel:SetText("Whitelisted")
                    whitelistLabel:SetFont("ixMenuButtonFontSmall")
                    whitelistLabel:SetContentAlignment(5)
                    whitelistLabel:SetWide(class:GetTall())
                else
                    local xpLabel = class:Add("DLabel")
                    xpLabel:Dock(RIGHT)
                    xpLabel:DockMargin(0, 0, 10, 0)
                    xpLabel:SetText(tostring(v.xp))
                    if ( ply:GetXP() >= v.xp ) then
                        xpLabel:SetTextColor(Color(0, 200, 0))
                    else
                        xpLabel:SetTextColor(Color(200, 0, 0))
                    end
                    xpLabel:SetFont("ixMenuButtonFontSmall")
                    xpLabel:SetContentAlignment(5)
                    xpLabel:SetWide(class:GetTall())
                end
            end
        end
    end

    ix.rankNPC.gui = self
end

function PANEL:Paint(w, h)
    ix.util.DrawBlur(self, 10)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

vgui.Register("ixRankNPC", PANEL, "DPanel")

if ( ix.rankNPC and ix.rankNPC.gui and IsValid(ix.rankNPC.gui) ) then
    ix.rankNPC.gui:Remove()
end