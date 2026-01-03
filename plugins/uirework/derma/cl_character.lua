
local gradient = surface.GetTextureID("vgui/gradient-d")
local audioFadeInTime = 2
local animationTime = 0.5
local matrixZScale = Vector(1, 1, 0.0001)

-- character menu panel
DEFINE_BASECLASS("ixSubpanelParent")
local PANEL = {}

function PANEL:Init()
    self:SetSize(self:GetParent():GetSize())
    self:SetPos(0, 0)

    self.childPanels = {}
    self.subpanels = {}
    self.activeSubpanel = ""

    self.currentDimAmount = 0
    self.currentY = 0
    self.currentScale = 1
    self.currentAlpha = 255
    self.targetDimAmount = 255
    self.targetScale = 0.9
end

function PANEL:Dim(length, callback)
    length = length or animationTime
    self.currentDimAmount = 0

    self:CreateAnimation(length, {
        target = {
            currentDimAmount = self.targetDimAmount,
            currentScale = self.targetScale
        },
        easing = "outCubic",
        OnComplete = callback
    })

    self:OnDim()
end

function PANEL:Undim(length, callback)
    length = length or animationTime
    self.currentDimAmount = self.targetDimAmount

    self:CreateAnimation(length, {
        target = {
            currentDimAmount = 0,
            currentScale = 1
        },
        easing = "outCubic",
        OnComplete = callback
    })

    self:OnUndim()
end

function PANEL:OnDim()
end

function PANEL:OnUndim()
end

function PANEL:Paint(width, height)
    local amount = self.currentDimAmount
    local bShouldScale = self.currentScale != 1
    local matrix

    -- draw child panels with scaling if needed
    if (bShouldScale) then
        matrix = Matrix()
        matrix:Scale(matrixZScale * self.currentScale)
        matrix:Translate(Vector(
            ScrW() * 0.5 - (ScrW() * self.currentScale * 0.5),
            ScrH() * 0.5 - (ScrH() * self.currentScale * 0.5),
            1
        ))

        cam.PushModelMatrix(matrix)
        self.currentMatrix = matrix
    end

    BaseClass.Paint(self, width, height)

    if (bShouldScale) then
        cam.PopModelMatrix()
        self.currentMatrix = nil
    end

    if (amount > 0) then
        local color = Color(0, 0, 0, amount)

        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, width, height)
    end
end

vgui.Register("ixCharMenuPanel", PANEL, "ixSubpanelParent")

-- character menu main button list
PANEL = {}

function PANEL:Init()
    local parent = self:GetParent()
    self:SetSize(parent:GetWide() * 0.25, parent:GetTall())

    self:GetVBar():SetWide(0)
    self:GetVBar():SetVisible(false)
end

function PANEL:Add(name)
    local panel = vgui.Create(name, self)
    panel:Dock(TOP)

    return panel
end

function PANEL:SizeToContents()
    self:GetCanvas():InvalidateLayout(true)

    -- if the canvas has extra space, forcefully dock to the bottom so it doesn't anchor to the top
    if (self:GetTall() > self:GetCanvas():GetTall()) then
        self:GetCanvas():Dock(BOTTOM)
    else
        self:GetCanvas():Dock(NODOCK)
    end
end

vgui.Register("ixCharMenuButtonList", PANEL, "DScrollPanel")

-- main character menu panel
PANEL = {}

AccessorFunc(PANEL, "bUsingCharacter", "UsingCharacter", FORCE_BOOL)

function PANEL:Init()
	self:RealInit()
end

function PANEL:RealInit()
	if ( !ix.characters ) then
		timer.Simple( 0.25, function()
			local _ = IsValid( self ) and self:RealInit()
		end )
		return
	end

    local parent = self:GetParent()
    local padding = self:GetPadding()
    local halfWidth = ScrW() * 0.5
    local halfPadding = padding * 0.5
    local bHasCharacter = #ix.characters > 0

    self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

    local infoLabel = self:Add("DLabel")
    infoLabel:SetTextColor(Color(255, 255, 255, 25))
    infoLabel:SetFont("ixMenuMiniFont")
    infoLabel:SetText(L("helix") .. " " .. GAMEMODE.Version)
    infoLabel:SizeToContents()
    infoLabel:SetPos(ScrW() - infoLabel:GetWide() - 4, ScrH() - infoLabel:GetTall() - 4)

    self.buttonCount = 4

    local news = self:Add("Panel")
    news:SetSize(600, 300)
    news:SetPos(self:GetWide() - 650, 25)

    local postBackground = news:Add("DHTML")
    postBackground:SetPos(-11,-11)
    postBackground:SetSize(news:GetWide() + 20, news:GetTall() + 20)
    postBackground:SetCursor("hand")
    postBackground:SetHTML([[<style type="text/css">
        body {
            overflow:hidden;
        }
        </style>
        <img src=]]..Schema.currentBanner..[[ style="width:100%;height:100%;">]])

    local dim = news:Add("Panel")
    dim:SetSize(news:GetWide(), news:GetTall())
    dim:SetPos(0, 0)
    dim.Paint = function(this, width, height)
        surface.SetTexture(gradient)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawTexturedRect(0, 0, width, height)

        ix.util.DrawBlur(this, 2)
    end

    local label = dim:Add("DLabel")
    label:SetText("Version "..Schema.currentVersion)
    label:SetFont("ixBigFont")
    label:SizeToContents()
    label:Dock(TOP)
    label:DockMargin(10, 5, 0, 0)

    local label = dim:Add("DLabel")
    label:SetText(Schema.changelogs[Schema.currentVersion])
    label:SetFont("ixMediumFont")
    label:Dock(TOP)
    label:DockMargin(20, 0, 0, 0)

    label:SetWrap(true)
    label:SetAutoStretchVertical(true)

    /*
    local buttonrow = news:Add("Panel")
    buttonrow:Dock(BOTTOM)
    buttonrow:DockMargin(1, 0, 1, 1)
    buttonrow:SetTall(30)

    local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
    local button = buttonrow:Add("DButton")
    button:SetText("")
    button:SetWide(20)
    button:Dock(LEFT)
    button:DockMargin(5, 5, 0, 5)
    button.Paint = function(this, width, height)
        if ( this:IsSelected() ) then
            draw.RoundedBox(0, 0, 0, width, height, Color(200, 200, 200, 140))
        else
            draw.RoundedBox(0, 0, 0, width, height, Color(100, 100, 100, 140))
        end

        surface.SetMaterial(vignette)
        surface.SetDrawColor(0, 0, 0, 66)
        surface.DrawTexturedRect(0, 0, width, height)
    end
    */

    local gradient = surface.GetTextureID("vgui/gradient-d")
    -- button list
    self.mainButtonList = self:Add("Panel")
    self.mainButtonList:SetWide(halfWidth / 2)
    self.mainButtonList:Dock(LEFT)
    self.mainButtonList:DockMargin(50, 25, 0, 25)
    self.mainButtonList.Paint = function(panel, width, height)
        surface.SetTexture(gradient)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawTexturedRect(0, 0, width, height)

        ix.util.DrawBlur(panel, 2)
    end

    local image = self.mainButtonList:Add("DImage")
    image:Dock(TOP)
    image:DockMargin(0, -halfWidth / 10, 0, -halfWidth / 10)
    image:SetTall(halfWidth / 2, halfWidth / 2)
    image:SetImage("minerva/logo.png")

    if (!bHasCharacter) then
        -- create character button
        local createButton = self.mainButtonList:Add("ixMenuButton")
        createButton:SetText("create")
        createButton:Dock(TOP)
        createButton:SizeToContents()
        createButton:SetContentAlignment(5)
        createButton.DoClick = function()
            local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)
            -- don't allow creation if we've hit the character limit
            if (#ix.characters >= maximum) then
                self:GetParent():ShowNotice(3, L("maxCharacters"))
                return
            end

            self:Dim()
            parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
            parent.newCharacterPanel:SlideUp()
        end
    else
        self.buttonCount = self.buttonCount - 1
    end

    if (bHasCharacter and !self.bUsingCharacter) then
        -- load character button
        self.loadButton = self.mainButtonList:Add("ixMenuButton")
        self.loadButton:SetText("play server")
        self.loadButton:Dock(TOP)
        self.loadButton:SizeToContents()
        self.loadButton:SetContentAlignment(5)
        self.loadButton.DoClick = function()
            --self:Dim()
            --parent.loadCharacterPanel:SlideUp()
            local id = ix.characters[1]
            local character = ix.char.loaded[id]
            self:SlideDown(1, function()
                net.Start("ixCharacterChoose")
                    net.WriteUInt(character:GetID(), 32)
                net.SendToServer()
            end, true)
        end
    else
        self.buttonCount = self.buttonCount - 1
    end

    if (!bHasCharacter) and (self.loadButton) then
        self.loadButton:SetDisabled(true)
    end

    -- community button
    local extraURL = ix.config.Get("communityURL", "")
    local extraText = ix.config.Get("communityText", "@community")

    if (extraURL != "" and extraText != "") then
        if (extraText:sub(1, 1) == "@") then
            extraText = L(extraText:sub(2))
        end

        local extraButton = self.mainButtonList:Add("ixMenuButton")
        extraButton:SetText(extraText, true)
        extraButton:Dock(TOP)
        extraButton:SizeToContents()
        extraButton:SetContentAlignment(5)
        extraButton.DoClick = function()
            gui.OpenURL(extraURL)
        end
    end

    -- leave/return button
    self.returnButton = self.mainButtonList:Add("ixMenuButton")
    self:UpdateReturnButton()
    self.returnButton.DoClick = function()
        if (self.bUsingCharacter) then
            parent:Close()
        else
            RunConsoleCommand("disconnect")
        end
    end
end

function PANEL:UpdateReturnButton(bValue)
    if (bValue != nil) then
        self.bUsingCharacter = bValue
        self.buttonCount = 3
    end

    self.returnButton:SetText(self.bUsingCharacter and "return" or "leave")
    self.returnButton:Dock(TOP)
    self.returnButton:SizeToContents()
    self.returnButton:SetContentAlignment(5)
end

function PANEL:OnDim()
    -- disable input on this panel since it will still be in the background while invisible - prone to stray clicks if the
    -- panels overtop slide out of the way
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
end

function PANEL:OnUndim()
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    -- we may have just deleted a character so update the status of the return button
    self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    self:UpdateReturnButton()
end

function PANEL:OnClose()
    for _, v in pairs(self:GetChildren()) do
        if (IsValid(v)) then
            v:SetVisible(false)
        end
    end
end

function PANEL:PerformLayout(width, height)
    local padding = self:GetPadding()

    self.mainButtonList:SetPos(padding, height - self.mainButtonList:GetTall() - padding)
end

vgui.Register("ixCharMenuMain", PANEL, "ixCharMenuPanel")

-- container panel
PANEL = {}

function PANEL:Init()
    if (IsValid(ix.gui.loading)) then
        ix.gui.loading:Remove()
    end

    if (IsValid(ix.gui.characterMenu)) then
        if (IsValid(ix.gui.characterMenu.channel)) then
            ix.gui.characterMenu.channel:Stop()
        end

        ix.gui.characterMenu:Remove()
    end

    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)

    -- main menu panel
    self.mainPanel = self:Add("ixCharMenuMain")

    -- new character panel
    self.newCharacterPanel = self:Add("ixCharMenuNew")
    self.newCharacterPanel:SlideDown(0)

    -- load character panel
    self.loadCharacterPanel = self:Add("ixCharMenuLoad")
    self.loadCharacterPanel:SlideDown(0)

    -- notice bar
    self.notice = self:Add("ixNoticeBar")

    -- finalization
    self:MakePopup()
    self.currentAlpha = 255
    self.volume = 0

    ix.gui.characterMenu = self

    if (!IsValid(ix.gui.intro)) then
        self:PlayMusic()
    end

    hook.Run("OnCharacterMenuCreated", self)
end

function PANEL:PlayMusic()
    local path = "sound/" .. ix.config.Get("music")
    local url = path:match("http[s]?://.+")
    local play = url and sound.PlayURL or sound.PlayFile
    path = url and url or path

    play(path, "noplay", function(channel, error, message)
        if (!IsValid(self) or !IsValid(channel)) then
            return
        end

        channel:SetVolume(self.volume or 0)
        channel:Play()

        self.channel = channel

        self:CreateAnimation(audioFadeInTime, {
            index = 10,
            target = {volume = 1},

            Think = function(animation, panel)
                if (IsValid(panel.channel)) then
                    panel.channel:SetVolume(self.volume * 0.5)
                end
            end
        })
    end)
end

function PANEL:ShowNotice(type, text)
    self.notice:SetType(type)
    self.notice:SetText(text)
    self.notice:Show()
end

function PANEL:HideNotice()
    if (IsValid(self.notice) and !self.notice:GetHidden()) then
        self.notice:Slide("up", 0.5, true)
    end
end

function PANEL:OnCharacterDeleted(character)
    if (#ix.characters == 0) then
        self.mainPanel.loadButton:SetDisabled(true)
        self.mainPanel:Undim() -- undim since the load panel will slide down
    else
        self.mainPanel.loadButton:SetDisabled(false)
    end

    self.loadCharacterPanel:OnCharacterDeleted(character)
end

function PANEL:OnCharacterLoadFailed(error)
    self.loadCharacterPanel:SetMouseInputEnabled(true)
    self.loadCharacterPanel:SlideUp()
    self:ShowNotice(3, error)
end

function PANEL:IsClosing()
    return self.bClosing
end

function PANEL:Close(bFromMenu)
    self.bClosing = true
    self.bFromMenu = bFromMenu

    local fadeOutTime = animationTime * 8

    self:CreateAnimation(fadeOutTime, {
        index = 1,
        target = {currentAlpha = 0},

        Think = function(animation, panel)
            panel:SetAlpha(panel.currentAlpha)
        end,

        OnComplete = function(animation, panel)
            panel:Remove()
        end
    })

    self:CreateAnimation(fadeOutTime - 0.1, {
        index = 10,
        target = {volume = 0},

        Think = function(animation, panel)
            if (IsValid(panel.channel)) then
                panel.channel:SetVolume(self.volume * 0.5)
            end
        end,

        OnComplete = function(animation, panel)
            if (IsValid(panel.channel)) then
                panel.channel:Stop()
                panel.channel = nil
            end
        end
    })

    -- hide children if we're already dimmed
    if (bFromMenu) then
        for _, v in pairs(self:GetChildren()) do
            if (IsValid(v)) then
                v:SetVisible(false)
            end
        end
    else
        -- fade out the main panel quicker because it significantly blocks the screen
        self.mainPanel.currentAlpha = 255

        self.mainPanel:CreateAnimation(animationTime * 2, {
            target = {currentAlpha = 0},
            easing = "outQuint",

            Think = function(animation, panel)
                panel:SetAlpha(panel.currentAlpha)
            end,

            OnComplete = function(animation, panel)
                panel:SetVisible(false)
            end
        })
    end

    -- relinquish mouse control
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    gui.EnableScreenClicker(false)
end

function PANEL:Paint(width, height)
    surface.SetTexture(gradient)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawTexturedRect(0, 0, width, height)

    if (!ix.option.Get("cheapBlur", false)) then
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawTexturedRect(0, 0, width, height)
        ix.util.DrawBlur(self, Lerp((self.currentAlpha - 200) / 255, 0, 10))
    end
end

function PANEL:PaintOver(width, height)
    if (self.bClosing and self.bFromMenu) then
        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, width, height)
    end
end

function PANEL:OnRemove()
    if (self.channel) then
        self.channel:Stop()
        self.channel = nil
    end
end

vgui.Register("ixCharMenu", PANEL, "EditablePanel")

if (IsValid(ix.gui.characterMenu)) then
    ix.gui.characterMenu:Remove()

    --TODO: REMOVE ME
    ix.gui.characterMenu = vgui.Create("ixCharMenu")
end
