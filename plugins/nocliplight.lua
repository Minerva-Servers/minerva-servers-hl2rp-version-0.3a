local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Noclip Light"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

function PLUGIN:PlayerNoClip(ply, state)
    if not ( SERVER ) then
        return
    end
    
    if ( ply:IsAdmin() ) then
        if ( state ) then
            if ( ply:FlashlightIsOn() ) then
                ply:Flashlight(false)
            end

            ply:AllowFlashlight(false)
        else
            ply:AllowFlashlight(true)
        end
    end
end

if ( SERVER ) then
    return
end

local wait = 0
local lightOn = lightOn or false
local dLight
local size = 1200
function PLUGIN:Think()
    if not LocalPlayer():IsAdmin() or LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP or not LocalPlayer():Alive() then
        lightOn = false
        return
    end

    if ( lightOn ) then
        dLight = DynamicLight(LocalPlayer():EntIndex())
        if ( dLight ) then
            dLight.pos = LocalPlayer():EyePos()
            dLight.r = 255
            dLight.g = 255
            dLight.b = 255
            dLight.brightness = 2
            dLight.Size = size
            dLight.Decay = size * 5
            dLight.DieTime = CurTime() + 0.8
        end
    end

    if ( vgui.CursorVisible() ) then
        return
    end

    if ( wait > CurTime() ) then
        return
    end

    if ( input.IsKeyDown(KEY_F) ) then
        wait = CurTime() + 0.3

        if ( lightOn ) then
            lightOn = false
            surface.PlaySound("buttons/button14.wav")
            return
        end

        surface.PlaySound("buttons/button14.wav")
        lightOn = true
    end
end
