
local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    local pWidth, pHeight = ScrW(), ScrH()
    self:SetSize(pWidth, pHeight)
    self:Center()

    self:MakePopup()

    self.bodygroups = self:Add("DScrollPanel")
    self.bodygroups:Dock(RIGHT)
end

function PANEL:Display(target)
    local pWidth, pHeight = ScrW(), ScrH()

    self.closeButton = self:Add("ixMenuButton")
    self.closeButton:Dock(BOTTOM)
    self.closeButton:SetText("Close")
    self.closeButton:SetContentAlignment(5)
    self.closeButton:SizeToContents()
    self.closeButton.DoClick = function()
        self:Remove()
    end

    self.saveButton = self:Add("ixMenuButton")
    self.saveButton:Dock(BOTTOM)
    self.saveButton:SetText("Save Changes")
    self.saveButton:SetContentAlignment(5)
    self.saveButton:SizeToContents()
    self.saveButton.DoClick = function()
        local bodygroups = {}
        for _, v in pairs(self.bodygroupIndex) do
            table.insert(bodygroups, v.index, v.value)
        end

        net.Start("ixBodygroupTableSet")
            net.WriteEntity(self.target)
            net.WriteTable(bodygroups)
        net.SendToServer()
    end

    self.model = self:Add("DAdjustableModelPanel")
    self.model:SetSize(pWidth * 1/2, pHeight)
    self.model:Dock(LEFT)
    self.model:SetModel(target:GetModel())
    self.model:SetLookAng(Angle(10, 225, 0))
    self.model:SetCamPos(Vector(40, 40, 50))

    function self.model:FirstPersonControls()
        local x, y = self:CaptureMouse()

        local scale = self:GetFOV() / 180
        x = x * -0.5 * scale
        y = y * 0.5 * scale

        -- Look around
        self.aLookAngle = self.aLookAngle + Angle( y, x, 0 )

        local Movement = Vector( 0, 0, 0 )

        -- TODO: Use actual key bindings, not hardcoded keys.
        if ( input.IsKeyDown( KEY_W ) or input.IsKeyDown( KEY_UP ) ) then Movement = Movement + self.aLookAngle:Forward() end
        if ( input.IsKeyDown( KEY_S ) or input.IsKeyDown( KEY_DOWN ) ) then Movement = Movement - self.aLookAngle:Forward() end
        if ( input.IsKeyDown( KEY_A ) or input.IsKeyDown( KEY_LEFT ) ) then Movement = Movement - self.aLookAngle:Right() end
        if ( input.IsKeyDown( KEY_D ) or input.IsKeyDown( KEY_RIGHT ) ) then Movement = Movement + self.aLookAngle:Right() end
        if ( input.IsKeyDown( KEY_SPACE ) or input.IsKeyDown( KEY_SPACE ) ) then Movement = Movement + self.aLookAngle:Up() end
        if ( input.IsKeyDown( KEY_LCONTROL ) or input.IsKeyDown( KEY_LCONTROL ) ) then Movement = Movement - self.aLookAngle:Up() end

        local speed = 1
        if ( input.IsShiftDown() ) then speed = 4.0 end

        self.vCamPos = self.vCamPos + Movement * speed
    end

    self.target = target
    self:PopulateBodygroupOptions()

    function self.model:LayoutEntity(Entity)
        Entity:SetAngles(Angle(0,45,0))
        local sequence = Entity:SelectWeightedSequence(ACT_IDLE)

        if (sequence <= 0) then
            sequence = Entity:LookupSequence("idle_unarmed")
        end

        if (sequence > 0) then
            Entity:ResetSequence(sequence)
        else
            local found = false

            for _, v in ipairs(Entity:GetSequenceList()) do
                if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
                    Entity:ResetSequence(v)
                    found = true

                    break
                end
            end

            if (!found) then
                Entity:ResetSequence(4)
            end
        end

    end
end

function PANEL:PopulateBodygroupOptions()
    self.bodygroupBox = {}
    self.bodygroupPrevious = {}
    self.bodygroupIndex = {}
    self.bodygroupNext = {}
    self.bodygroupName = {}
    self.bodygroupID = {}
    self.bodygroupCount = {}
    self.bodygroups:Dock(FILL)

    for k, v in pairs(self.target:GetBodyGroups()) do
        -- Disregard the model bodygroup.
        if !(v.id == 0) then
            local index = v.id

            self.bodygroupBox[v.id] = self.bodygroups:Add("DPanel")
            self.bodygroupBox[v.id]:Dock(TOP)
            self.bodygroupBox[v.id]:DockMargin(0, 0, 0, 0)
            self.bodygroupBox[v.id]:SetHeight(ScreenScale(14))
            self.bodygroupBox[v.id].Paint = function(this, width, height)
                surface.SetDrawColor(Color(0, 0, 0, 66))
                surface.DrawRect(0, 0, width, height)
            end

            self.bodygroupPrevious[v.id] = self.bodygroupBox[v.id]:Add("ixMenuButton")
            self.bodygroupPrevious[v.id].index = v.id
            self.bodygroupPrevious[v.id]:Dock(LEFT)
            self.bodygroupPrevious[v.id]:SetWide(200)
            self.bodygroupPrevious[v.id]:SetText("Previous")
            self.bodygroupPrevious[v.id]:SetContentAlignment(5)
            self.bodygroupPrevious[v.id].DoClick = function()
                local index = v.id
                if 0 == self.bodygroupIndex[index].value then
                    return
                end
                self.bodygroupIndex[index].value = self.bodygroupIndex[index].value - 1
                self.bodygroupIndex[index]:SetText(self.bodygroupIndex[index].value)
                self.model.Entity:SetBodygroup(index, self.bodygroupIndex[index].value)
            end

            self.bodygroupIndex[v.id] = self.bodygroupBox[v.id]:Add("DLabel")
            self.bodygroupIndex[v.id].index = v.id
            self.bodygroupIndex[v.id].value = self.target:GetBodygroup(index)
            self.bodygroupIndex[v.id]:SetText(self.bodygroupIndex[v.id].value)
            self.bodygroupIndex[v.id]:SetFont("ixBigFont")
            self.bodygroupIndex[v.id]:Dock(LEFT)
            self.bodygroupIndex[v.id]:DockMargin(8, 8, 8, 8)
            self.bodygroupIndex[v.id]:SetContentAlignment(5)
            self.bodygroupIndex[v.id]:SetWide(50)

            self.bodygroupNext[v.id] = self.bodygroupBox[v.id]:Add("ixMenuButton")
            self.bodygroupNext[v.id].index = v.id
            self.bodygroupNext[v.id]:Dock(LEFT)
            self.bodygroupNext[v.id]:SetWide(100)
            self.bodygroupNext[v.id]:SetText("Next")
            self.bodygroupNext[v.id]:SetContentAlignment(5)
            self.bodygroupNext[v.id].DoClick = function(this)
                local index = v.id
                if (self.model.Entity:GetBodygroupCount(index) - 1) <= self.bodygroupIndex[index].value then
                    return
                end

                self.bodygroupIndex[index].value = self.bodygroupIndex[index].value + 1
                self.bodygroupIndex[index]:SetText(self.bodygroupIndex[index].value)
                self.model.Entity:SetBodygroup(index, self.bodygroupIndex[index].value)
            end

            self.model.Entity:SetBodygroup(index, self.target:GetBodygroup(index))

            self.bodygroupCount[v.id] = self.bodygroupBox[v.id]:Add("DLabel")
            self.bodygroupCount[v.id].index = v.id
            self.bodygroupCount[v.id]:SetText("  "..(self.model.Entity:GetBodygroupCount(v.id)-1).."  ")
            self.bodygroupCount[v.id]:SetFont("ixBigFont")
            self.bodygroupCount[v.id]:Dock(LEFT)
            self.bodygroupCount[v.id]:DockMargin(0, 0, 0, 0)
            self.bodygroupCount[v.id]:SetContentAlignment(5)
            self.bodygroupCount[v.id]:SizeToContents()

            self.bodygroupName[v.id] = self.bodygroupBox[v.id]:Add("DLabel")
            self.bodygroupName[v.id].index = v.id
            self.bodygroupName[v.id]:SetText("  "..v.name:gsub("^%l", string.upper).."  ")
            self.bodygroupName[v.id]:SetFont("ixBigFont")
            self.bodygroupName[v.id]:Dock(LEFT)
            self.bodygroupName[v.id]:DockMargin(0, 0, 0, 0)
            self.bodygroupName[v.id]:SetContentAlignment(5)
            self.bodygroupName[v.id]:SizeToContents()

            self.bodygroupID[v.id] = self.bodygroupBox[v.id]:Add("DLabel")
            self.bodygroupID[v.id].index = v.id
            self.bodygroupID[v.id]:SetText("  "..v.id.."  ")
            self.bodygroupID[v.id]:SetFont("ixBigFont")
            self.bodygroupID[v.id]:Dock(RIGHT)
            self.bodygroupID[v.id]:DockMargin(0, 0, 0, 0)
            self.bodygroupID[v.id]:SetContentAlignment(5)
            self.bodygroupID[v.id]:SizeToContents()
        end
    end
end

function PANEL:Paint(w, h)
    ix.util.DrawBlur(self, 10)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

vgui.Register("ixBodygroupView", PANEL, "DPanel")
