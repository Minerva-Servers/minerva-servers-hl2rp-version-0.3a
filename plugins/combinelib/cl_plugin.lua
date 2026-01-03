local PLUGIN = PLUGIN

surface.CreateFont("ixCombineButtonFont", {
    font = "Roboto",
    size = 64,
    weight = 1000,
    scanlines = 3,
})

surface.CreateFont("ixCombineButtonMediumFont", {
    font = "Roboto",
    size = 32,
    weight = 1000,
    scanlines = 3,
})

surface.CreateFont("ixCombineButtonSmallFont", {
    font = "Roboto",
    size = 16,
    weight = 1000,
    scanlines = 3,
})

net.Receive("ixCombineTerminalOpen", function()
    if not ( LocalPlayer():IsCombine() ) then
        return
    end

    local terminalEnt = net.ReadEntity()
    local terminal = vgui.Create("ixCombineTerminalMenu")
    terminal.combineTerminalEntity = terminalEnt
end)

function PLUGIN:HUDPaintAlternate(client, character)
    local width, height = ScrW(), ScrH()
    local fontHeight = draw.GetFontHeight("ixCombineHudFontSmall")

	if (client:IsCombine()) then
        for combineCamera, data in pairs(self.cameraData) do
            if (IsValid(combineCamera)) then
                local toScreen = combineCamera:GetPos():ToScreen()

                local violations = {}

                if (type(data) == "table") then
                    for player, vios in pairs(data) do
                        for i, vio in ipairs(vios) do
                            if (vio == self.VIOLATION_FALLEN_OVER) then
                                violations[#violations + 1] = "<:: Unconsciousness ::>"
                            elseif (vio == self.VIOLATION_647) then
                                violations[#violations + 1] = "<:: Unauthorized Clothing ::>"
                            end
                        end
                    end
                end

                if (#violations <= 0) and
                ((!bUnobstruct and !client:IsLineOfSightClear(combineCamera))
                or (client:EyePos():Distance(combineCamera:GetPos()) > 1024)) then
                    toScreen.visible = false
                end

                if (toScreen.visible) then
                    local text1 = "<:: C-i" .. combineCamera:EntIndex() .. " ::>"

                    draw.SimpleText(text1, "ixCombineHudFontSmall", toScreen.x, toScreen.y, team.GetColor(FACTION_CP), 1, 1)

                    if (type(data) == "table") then
                        local text2 = "<:: " .. table.Count(data) .. " Within Sights ::>"

                        toScreen.y = toScreen.y + fontHeight
                        draw.SimpleText(text2, "ixCombineHudFontSmall", toScreen.x, toScreen.y, color_white, 1, 1)

                        if (#violations > 0) then
                            toScreen.y = toScreen.y + fontHeight
                            draw.SimpleText("<:: Violations Within Sights ::>", "ixCombineHudFontSmall", toScreen.x, toScreen.y, Color(255, 0, 0), 1, 1)

                            for i, violation in ipairs(violations) do
                                toScreen.y = toScreen.y + fontHeight
                                draw.SimpleText(violation, "ixCombineHudFontSmall", toScreen.x, toScreen.y, color_white, 1, 1)
                            end
                        end
                    else
                        toScreen.y = toScreen.y + fontHeight
                        draw.SimpleText("<:: Disabled ::>", "ixCombineHudFontSmall", toScreen.x, toScreen.y, Color(255, 0, 0), 1, 1)
                    end
                end
            end
        end
    end

    if ( character:GetInformant() ) then
        draw.DrawText("You are an Informant!", "ixSmallFont", width / 2, height - 10, Color(0, 200, 0), TEXT_ALIGN_CENTER)
    end
end

// ported from cto, credits to aspect
PLUGIN.cameraData = PLUGIN.cameraData or {}
PLUGIN.terminalMaterialIdx = PLUGIN.terminalMaterialIdx or 0
PLUGIN.terminalsToDraw = PLUGIN.terminalsToDraw or {}

net.Receive("UpdateBiosignalCameraData", function()
	local data = net.ReadTable()
	local newCameraData = {}
	
	for entIndex, players in pairs(data) do
		local combineCamera = Entity(entIndex)
		
		if (IsValid(combineCamera)) then
			newCameraData[combineCamera] = players
		end
	end
	
	PLUGIN.cameraData = newCameraData
end)

-- Running on tick to avoid some HUD conflicts.
function PLUGIN:Tick()
    local client = LocalPlayer()

    for ent, bDraw in pairs(self.terminalsToDraw) do
        if (IsValid(ent) and bDraw) then
            local scrw, scrh = ScrW(), ScrH()

            local camera = ent:GetNWEntity("camera")

            if (IsValid(camera) and camera:GetClass() == "npc_combine_camera") then
                local bonePos, boneAngles = camera:GetBonePosition(camera:LookupBone("Combine_Camera.bone1"))
                local camPos, camAngles = camera:GetBonePosition(camera:LookupBone("Combine_Camera.Lens"))

                boneAngles.roll = boneAngles.roll + 90

                local bulbColor = camera:GetChildren()[1]:GetColor()
                local statusText = "All Clear"
                local signalText = "[512x256/p15@TR42/036]#=i" .. camera:EntIndex() .. "y=" .. math.floor(boneAngles.yaw) .. "&r=" .. math.floor(boneAngles.roll)
                if (bulbColor.g == 128) then
                    statusText = "Watching..."
                elseif (bulbColor.g == 0) then
                    statusText = "Violation!"
                end

                render.PushRenderTarget(ent.tex)
                    if (self:IsCameraEnabled(camera)) then
                        if (ent.lastCamOutputTime == nil or RealTime() - ent.lastCamOutputTime >= (1 / 15)) then
                            render.RenderView({
                                origin = camPos + (boneAngles:Forward() * 2.8),
                                angles = boneAngles,
                                fov = 90,
                                aspect = 2,
                                x = 0,
                                y = 0,
                                w = 512,
                                h = 256,
                                drawviewmodel = false
                            })

                            ent.lastCamOutputTime = RealTime()
                        end
                    else
                        render.Clear(0, 0, 0, 255, false, true)
                        statusText = "Disabled"
                        signalText = "no signal(?)"
                        bulbColor = Color(255, 0, 0)
                    end

                    cam.Start2D()
                        draw.SimpleText("<:: C-i" .. camera:EntIndex() .. " ::>", "BudgetLabel", 4, 6)
                        draw.SimpleText("<:: " .. statusText .. " ::>", "BudgetLabel", 4, 6 + draw.GetFontHeight("BudgetLabel"), bulbColor)
                        draw.SimpleText(signalText, "BudgetLabel", 4, 252 - draw.GetFontHeight("BudgetLabel"))
                        draw.SimpleText("*", "CloseCaption_Normal", 256, 126, bulbColor, 1, 1)
                    cam.End2D()
                render.PopRenderTarget()

                ent.mat:SetTexture("$basetexture", ent.tex)
                ent:SetSubMaterial(1, "!" .. ent.mat:GetName())
            else
                ent:SetSubMaterial(1, "models/props_combine/combine_interface_disp")
            end
        end
    end
end

function PLUGIN:PreDrawHalos()
    if not ( LocalPlayer():IsCombine() ) then
        return
    end
    
    for k, v in pairs(player.GetAll()) do    
        if not ( v:IsCombine() ) then
            return
        end
        
        if not ( LocalPlayer().curTeam == v.curTeam ) then
            return
        end
        
        if ( LocalPlayer().curTeam == nil and v.curTeam == nil ) then
            return
        end
        
        halo.Add({v}, ix.config.Get("color", Color(255, 255, 255)), 0, 0, 5, true, true)
    end
end