local VIEW = VIEW
local PLUGIN = PLUGIN

VIEW.name = "SCP"

local lerpFov = 90
local lerpRoll
function VIEW:Draw( client, character, pos, angles, fov )
    local view = GAMEMODE.BaseClass:CalcView(client, pos, angles, fov)

    if not ( lerpRoll ) then
        lerpRoll = view.angles.r
    end

    if not ( client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() and client:Alive() ) then
        local velocity = client:GetVelocity()
        local eyeAngles = client:EyeAngles()
        local intensity = 1

        local maxHealth = client:GetMaxHealth()
        local health = client:Health()
        
        if ( health < maxHealth ) then
            intensity = math.Clamp(1 * (maxHealth / health) * 0.75, 1, 3)
        end

        if ( client:GetMoveType() != MOVETYPE_NOCLIP ) then
            if ( client:IsOnGround() ) then
                lerpFov = Lerp(0.08, lerpFov, view.fov + math.sin(RealTime() * 0.5) * velocity:Length() * 0.0075)
                lerpRoll = math.Round(Lerp(0.1, lerpRoll, view.angles.r + (math.sin(RealTime() * 8) * velocity:Length() * 0.0075) * intensity), 2)
            else
                lerpFov = Lerp(0.1, lerpFov, fov - 10)
                lerpRoll = Lerp(0.1, lerpRoll, view.angles.r)
            end
        else
            lerpFov = view.fov
            lerpRoll = view.angles.r
        end

        view.fov = lerpFov
        view.angles.r = lerpRoll
        
        return view
    end
end