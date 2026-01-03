local VIEW = VIEW
local PLUGIN = PLUGIN

VIEW.name = "Clockwork"

function VIEW:Draw( client, character, pos, angles, fov )
    local view = GAMEMODE.BaseClass:CalcView(client, pos, angles, fov)

    if not ( lerpRoll ) then
        lerpRoll = view.angles.r
    end

    if not ( lerpZ ) then
        lerpZ = view.origin.z
    end

	if not ( client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() ) then
		local scale = 1

		if ( client.ixRagdoll ) then
			/*
			local ragdollEntity = client:GetRagdollEntity()
			local ragdollState = client:GetRagdollState()

			if (self.BlackFadeIn == 255) then
				return {origin = Vector(20000, 0, 0), angles = Angle(0, 0, 0), fov = fov}
			else
				local eyes = ragdollEntity:GetAttachment(ragdollEntity:LookupAttachment("eyes"))
				
				if (eyes) then
					local ragdollEyeAngles = eyes.Ang + cwKernel:GetRagdollEyeAngles()
					local physicsObject = ragdollEntity:GetPhysicsObject()
					
					if (IsValid(physicsObject)) then
						local velocity = physicsObject:GetVelocity().z
						
						if (velocity <= -1000 and client:GetMoveType() == MOVETYPE_WALK) then
							ragdollEyeAngles.p = ragdollEyeAngles.p + math.sin(UnPredictedCurTime()) * math.abs((velocity + 1000) - 16)
						end
					end
					
					return {origin = eyes.Pos, angles = ragdollEyeAngles, fov = fov}
				else
					return self.BaseClass:CalcView(client, origin, angles, fov)
				end
			end
			*/
		elseif not ( client:Alive() ) then
			return {origin = Vector(20000, 0, 0), angles = Angle(0, 0, 0), fov = fov}
		elseif ( ix.option.Get("viewBob", true) and scale > 0 ) then
			if ( client:IsOnGround() ) then
				local frameTime = FrameTime()
				
				if ( client:GetMoveType() != MOVETYPE_NOCLIP ) then
					local approachTime = frameTime * 2
					local curTime = UnPredictedCurTime()
					local info = {
						speed = 0.75,
						yaw = 1,
						roll = 0.2,
					}
					
					if not ( self.HeadbobAngle ) then
						self.HeadbobAngle = 0
					end
					
					if not ( self.HeadbobInfo ) then
						self.HeadbobInfo = info
					end
					
					hook.Run("PlayerAdjustHeadbobInfo", info)
					
					self.HeadbobInfo.yaw = math.Approach(self.HeadbobInfo.yaw, info.yaw, approachTime)
					self.HeadbobInfo.roll = math.Approach(self.HeadbobInfo.roll, info.roll, approachTime)
					self.HeadbobInfo.speed = math.Approach(self.HeadbobInfo.speed, info.speed, approachTime)
					self.HeadbobAngle = self.HeadbobAngle + (self.HeadbobInfo.speed * frameTime)
					
					local yawAngle = math.sin(self.HeadbobAngle)
					local rollAngle = math.cos(self.HeadbobAngle)
					
					angles.y = angles.y + (yawAngle * self.HeadbobInfo.yaw)
					angles.r = angles.r + (rollAngle * self.HeadbobInfo.roll)
	
					local velocity = client:GetVelocity()
					local eyeAngles = client:EyeAngles()
					
					if not ( self.VelSmooth ) then
						self.VelSmooth = 0
					end

					if not ( self.WalkTimer ) then
						self.WalkTimer = 0
					end

					if not ( self.LastStrafeRoll ) then
						self.LastStrafeRoll = 0
					end
					
					self.VelSmooth = math.Clamp(self.VelSmooth * 0.9 + velocity:Length() * 0.1, 0, 700)
					self.WalkTimer = self.WalkTimer + self.VelSmooth * FrameTime() * 0.05
					
					self.LastStrafeRoll = (self.LastStrafeRoll * 3) + (eyeAngles:Right():DotProduct(velocity) * 0.0001 * self.VelSmooth * 0.3)
					self.LastStrafeRoll = self.LastStrafeRoll * 0.25
					angles.r = angles.r + self.LastStrafeRoll
					
					if ( client:GetGroundEntity() != NULL ) then
						angles.p = angles.p + math.cos(self.WalkTimer * 0.5) * self.VelSmooth * 0.000002 * self.VelSmooth
						angles.r = angles.r + math.sin(self.WalkTimer) * self.VelSmooth * 0.000002 * self.VelSmooth
						angles.y = angles.y + math.cos(self.WalkTimer) * self.VelSmooth * 0.000002 * self.VelSmooth
					end
					
					velocity = client:GetVelocity().z
					
					if (velocity <= -1000 and client:GetMoveType() == MOVETYPE_WALK) then
						angles.p = angles.p + math.sin(UnPredictedCurTime()) * math.abs((velocity + 1000) - 16)
					end
				end
			end
		end
		
		local view = GAMEMODE.BaseClass:CalcView( client, pos, angles, fov )
		view.fov = fov - 5
		
		hook.Run("CalcViewAdjustTable", view)
		
		return view
	end
end

function PLUGIN:PlayerAdjustHeadbobInfo(info)
	if not ( info ) then
		return
	end

	if ( LocalPlayer():GetLocalVar("bIsHoldingObject", false) ) then
		info.speed = 0
		info.yaw = 0
		info.roll = 0

		return
	end

	local isDrunk = LocalPlayer():GetCharacter():GetData("drunk", false)
	local scale = 1
	
	if ( LocalPlayer():IsRunning() ) then
		info.speed = (info.speed * 4) * scale
		info.roll = (info.roll * 2) * scale
	/*
	elseif ( LocalPlayer():IsJogging() ) then
		info.speed = (info.speed * 4) * scale
		info.roll = (info.roll * 1.5) * scale
	*/
	elseif ( LocalPlayer():GetVelocity():Length() > 0 ) then
		info.speed = (info.speed * 3) * scale
		info.roll = (info.roll * 1) * scale
	else
		info.roll = info.roll * scale
	end
	
	if ( isDrunk ) then
		info.speed = info.speed * math.min(isDrunk * 0.25, 4)
		info.yaw = info.yaw * math.min(isDrunk, 4)
	end
end