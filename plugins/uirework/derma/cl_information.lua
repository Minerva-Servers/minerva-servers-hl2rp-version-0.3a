
local PANEL = {}

function PANEL:Init()
    local parent = self:GetParent()

    self:SetSize(parent:GetWide(), parent:GetTall())
    self:Dock(RIGHT)

    self.VBar:SetWide(0)

    -- entry setup
    local suppress = {}
    hook.Run("CanCreateCharacterInfo", suppress)

    if (!suppress.time) then
        local format = ix.option.Get("24hourTime", false) and "%A, %B %d, %Y. %H:%M" or "%A, %B %d, %Y. %I:%M %p"

        self.time = self:Add("DLabel")
        self.time:SetFont("ixMediumFont")
        self.time:SetTall(28)
        self.time:SetContentAlignment(5)
        self.time:Dock(TOP)
        self.time:SetTextColor(color_white)
        self.time:SetExpensiveShadow(1, Color(0, 0, 0, 150))
        self.time:DockMargin(0, 0, 0, 32)
        self.time:SetText(ix.date.GetFormatted(format))
        self.time.Think = function(this)
            if ((this.nextTime or 0) < CurTime()) then
                this:SetText(ix.date.GetFormatted(format))
                this.nextTime = CurTime() + 0.5
            end
        end
    end

    if (!suppress.name) then
        self.name = self:Add("ixLabel")
        self.name:Dock(TOP)
        self.name:DockMargin(0, 0, 0, 8)
        self.name:SetFont("ixMenuButtonHugeFont")
        self.name:SetContentAlignment(5)
        self.name:SetTextColor(color_white)
        self.name:SetPadding(8)
        self.name:SetScaleWidth(true)
    end

    if (!suppress.characterInfo) then
        self.characterInfo = self:Add("Panel")
        self.characterInfo.list = {}
        self.characterInfo:Dock(TOP) -- no dock margin because this is handled by ixListRow
        self.characterInfo.SizeToContents = function(this)
            local height = 0

            for _, v in ipairs(this:GetChildren()) do
                if (IsValid(v) and v:IsVisible()) then
                    local _, top, _, bottom = v:GetDockMargin()
                    height = height + v:GetTall() + top + bottom
                end
            end

            this:SetTall(height)
        end

        if (!suppress.faction) then
            self.faction = self.characterInfo:Add("ixListRow")
            self.faction:SetList(self.characterInfo.list)
            self.faction:Dock(TOP)
        end

        if (!suppress.class) then
            self.class = self.characterInfo:Add("ixListRow")
            self.class:SetList(self.characterInfo.list)
            self.class:Dock(TOP)
        end

        if (!suppress.money) then
            self.money = self.characterInfo:Add("ixListRow")
            self.money:SetList(self.characterInfo.list)
            self.money:Dock(TOP)
            self.money:SizeToContents()
        end

        hook.Run("CreateCharacterInfo", self.characterInfo)
        self.characterInfo:SizeToContents()
    end

    -- no need to update since we aren't showing the attributes panel
    if (!suppress.attributes) then
        local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

        if (character) then
            self.attributes = self:Add("ixCategoryPanel")
            self.attributes:SetText(L("attributes"))
            self.attributes:Dock(TOP)
            self.attributes:DockMargin(0, 0, 0, 8)

            local boost = character:GetBoosts()
            local bFirst = true

            for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
                local attributeBoost = 0

                if (boost[k]) then
                    for _, bValue in pairs(boost[k]) do
                        attributeBoost = attributeBoost + bValue
                    end
                end

                local bar = self.attributes:Add("ixAttributeBar")
                bar:Dock(TOP)

                if (!bFirst) then
                    bar:DockMargin(0, 3, 0, 0)
                else
                    bFirst = false
                end

                local value = character:GetAttribute(k, 0)

                if (attributeBoost) then
                    bar:SetValue(value - attributeBoost or 0)
                else
                    bar:SetValue(value)
                end

                local maximum = v.maxValue or ix.config.Get("maxAttributes", 100)
                bar:SetMax(maximum)
                bar:SetReadOnly()
                bar:SetText(Format("%s [%.1f/%.1f] (%.1f%%)", L(v.name), value, maximum, value / maximum * 100))

                if (attributeBoost) then
                    bar:SetBoost(attributeBoost)
                end
            end

            self.attributes:SizeToContents()
        end
    end

    hook.Run("CreateCharacterInfoCategory", self)
end

function PANEL:Update(character)
    if (!character) then
        return
    end

    local faction = ix.faction.indices[character:GetFaction()]
    local class = ix.class.list[character:GetClass()]

    if (self.name) then
        self.name:SetText(character:GetName())

        if (faction) then
            self.name.backgroundColor = ColorAlpha(faction.color, 150) or Color(0, 0, 0, 150)
        end

        self.name:SizeToContents()
    end

    if (self.faction) then
        self.faction:SetLabelText(L("faction"))
        self.faction:SetText(L(faction.name))
        self.faction:SizeToContents()
    end

    if (self.class) then
        -- don't show class label if the class is the same name as the faction
        if (class and class.name != faction.name) then
            self.class:SetLabelText(L("class"))
            self.class:SetText(L(class.name))
            self.class:SizeToContents()
        else
            self.class:SetVisible(false)
        end
    end

    if (self.money) then
        self.money:SetLabelText(L("money"))
        self.money:SetText(ix.currency.Get(character:GetMoney()))
        self.money:SizeToContents()
    end

    hook.Run("UpdateCharacterInfo", self.characterInfo, character)

    self.characterInfo:SizeToContents()

    hook.Run("UpdateCharacterInfoCategory", self, character)
end

function PANEL:OnSubpanelRightClick()
    properties.OpenEntityMenu(LocalPlayer())
end

vgui.Register("ixCharacterInfo", PANEL, "DScrollPanel")

hook.Add("CreateMenuButtons", "ixCharInfo", function(tabs)
    tabs["You"] = {
        buttonColor = team.GetColor(LocalPlayer():Team()),
        Create = function(info, container)
            container.infoPanel = container:Add("ixCharacterInfo")

            container.OnMouseReleased = function(this, key)
                if (key == MOUSE_RIGHT) then
                    this.infoPanel:OnSubpanelRightClick()
                end
            end
        end,
        OnSelected = function(info, container)
            container.infoPanel:Update(LocalPlayer():GetCharacter())
        end,

        Sections = {
            /*
            ["Overview"] = {
                bHideBackground = true,
                OnSelected = function(info, container)
                    ix.gui.menu:SetCharacterOverview(true)
                end,
                OnDeselected = function(info, container)
                    ix.gui.menu:SetCharacterOverview(false)
                end,
            },
            */
            ["inv"] = {
                Create = function(info, container)
                    local canvas = container:Add("DTileLayout")
                    local canvasLayout = canvas.PerformLayout
                    canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
                    canvas:SetBorder(0)
                    canvas:SetSpaceX(2)
                    canvas:SetSpaceY(2)
                    canvas:Dock(FILL)

                    ix.gui.menuInventoryContainer = canvas

                    local panel = canvas:Add("ixInventory")
                    panel:SetPos(0, 0)
                    panel:SetDraggable(false)
                    panel:SetSizable(false)
                    panel:SetTitle(nil)
                    panel:SetIconSize(ScreenScale(48))
                    panel.bNoBackgroundBlur = true
                    panel.childPanels = {}

                    local inventory = LocalPlayer():GetCharacter():GetInventory()

                    if (inventory) then
                        panel:SetInventory(inventory)
                    end

                    ix.gui.inv1 = panel

                    if (ix.option.Get("openBags", true)) then
                        for _, v in pairs(inventory:GetItems()) do
                            if (!v.isBag) then
                                continue
                            end

                            v.functions.View.OnClick(v)
                        end
                    end

                    canvas.PerformLayout = canvasLayout
                    canvas:Layout()
                end,
            },
        }
    }
end)
