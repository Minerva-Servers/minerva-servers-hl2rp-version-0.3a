local PLUGIN = PLUGIN

local function hideEnts(hide, hidePlayers)
	for k, v in pairs(ents.GetAll()) do
		if ( v.CPPIGetOwner ) then
			local owner = v:CPPIGetOwner()

			if ( owner ) then
				if not ( hide and v.sceneHide ) then
					continue
				end

				v:SetNoDraw(hide)
				v.sceneHide = hide
			end
		end
	end

	if ( hidePlayers or not hide ) then
		for k, v in pairs(player.GetAll()) do
			if ( !hidePlayers and v.sceneHide ) then
				v:SetNoDraw(false)
				v.sceneHide = nil
				continue
			end
			
			if ( hidePlayers and not v:GetNoDraw() ) then
				v:SetNoDraw(hidePlayers)
				v.sceneHide = true
			end
		end
	end
end

function ix.scenes.Play(stage, sceneData, onDone, skipPVS, preLoad)
	ix.scenes.pos = nil
	ix.scenes.ang = nil
	sceneData.speed = sceneData.speed or 1

	if not ( skipPVS ) then
		net.Start("ixScenePVS")
			net.WriteVector(sceneData.pvsPos or sceneData.pos)
		net.SendToServer()
	end

	hideEnts((sceneData.noHideProps == nil and true) or sceneData.noHideProps, sceneData.hidePlayers)

	local fov
	local lastAdd = 0
	local lastPosAdd = 0
	hook.Add("CalcView", "ixScene", function()
		ix.scenes.pos = ix.scenes.pos or sceneData.pos
		ix.scenes.ang = ix.scenes.ang or sceneData.ang

		local view = {}

		if ( sceneData.endpos and not sceneData.static ) then
		    if ( sceneData.posNoLerp ) then
		    	lastPosAdd = lastPosAdd + FrameTime() * sceneData.posSpeed
		    	ix.scenes.pos = LerpVector(lastPosAdd, sceneData.pos, sceneData.endpos)
		    else
		    	ix.scenes.pos = LerpVector(FrameTime() * sceneData.speed, ix.scenes.pos, sceneData.endpos)
		    end
		end

		if ( sceneData.endang and not sceneData.static ) then
			ix.scenes.ang = LerpAngle(FrameTime() * sceneData.speed, ix.scenes.ang, sceneData.endang)
		end

		if ( sceneData.fovFrom or sceneData.fovTo ) then
			if ( sceneData.fovSpeed ) then
				if ( sceneData.fovNoLerp ) then
					lastAdd = lastAdd + FrameTime() * sceneData.fovSpeed
					fov = Lerp(lastAdd, sceneData.fovFrom or 70, sceneData.fovTo or 70)
				else
					fov = Lerp(FrameTime() * sceneData.fovSpeed + ((fov or 0) * 0.000013), fov or (sceneData.fovFrom or 70), sceneData.fovTo or 70)
				end
			else
				fov = sceneData.fovFrom
			end
		end

		view.origin = ix.scenes.pos
		view.angles = ix.scenes.ang
		view.farz = 15000
		view.drawviewer = true
		view.fov = fov

		return view
	end)

	local outputText = ""
	local textPos = 1
	local nextTime = 0

	if ( sceneData.text ) then
		hook.Add("HUDPaint", "ixScene", function()
			if CurTime() > nextTime and textPos != string.len(sceneData.text) then
				textPos = textPos + 1
				nextTime = CurTime() + 0.05
				surface.PlaySound("minerva/global/typewriter"..tostring(math.random(1,4))..".mp3")
			end

			ix.scenes.markup = markup.Parse("<font=ixMediumFont>"..string.sub(sceneData.text, 1, textPos).."</font>", ScrW() * 0.7)
			ix.scenes.markup:Draw(ScrW() / 2, ScrH() * 0.8, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end)
	end

	if ( sceneData.time ) then
		timer.Simple(sceneData.time, function()
			hook.Remove("CalcView", "ixScene")
			hook.Remove("HUDPaint", "ixScene")

			if not sceneData.noHUDReEnable then
				ix_hudEnabled = true
			end

			hideEnts(false)

			if onDone then
				onDone()
			end
		end)

		timer.Simple(sceneData.time - 1, function()
			if ( sceneData.fadeOut ) then
				LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0, 0, 0), 1, 0.05)
			end

			if ( preLoad ) then
				preLoad(stage)
			end
		end)
	end

	if ( sceneData.onStart ) then
		sceneData.onStart()
	end

	if ( sceneData.fadeIn ) then
		LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0)
	end

	ix_hudEnabled = false
end

function ix.scenes.PlaySet(set, music, onDone)
	local counter = 1

	SCENES_PLAYING = true

	local function pvsPreLoad(counter) -- preloads the pvs 1 second before scene loads
		local nextScene = set[counter + 1]

		if ( nextScene ) then
			net.Start("ixScenePVS")
				net.WriteVector(nextScene.pvsPos or nextScene.pos)
			net.SendToServer()
		end
	end

	local function playScenes()
		if ( set[counter + 1] ) then
			counter = counter + 1
			ix.scenes.Play(counter, set[counter], playScenes, true, pvsPreLoad)
		else
			if onDone then
				onDone()
			end

			net.Start("ixSceneWipePVS")
			net.SendToServer()

			SCENES_PLAYING = false
		end
	end

	if ( music ) then
		if ( music:find("www.") or music:find("http") ) then
			if ( IsValid(SCENE_MUSIC) ) then
				SCENE_MUSIC:stop()
			end

			local service = medialib.load("media").guessService(link)
			local clip = service:load(music)

			SCENE_MUSIC = clip

			clip:play()
		else
			surface.PlaySound(music)
		end
	end

	ix.scenes.Play(1, set[counter], playScenes, false, pvsPreLoad)
end