local VIEW = VIEW
local PLUGIN = PLUGIN

VIEW.name = "Longsword"

local lerpFov = 90
local sway = 1.5
local lastAng = Angle(0, 0, 0)
local cacheAng = Angle(0, 0, 0)

local c_jump = 0
local c_look = 0
local c_move = 0
local c_sight = 0

local bob = 6
local idle = 6
function VIEW:Draw( client, character, pos, angles, fov )
    local view = GAMEMODE.BaseClass:CalcView(client, pos, angles, fov)
	local ft = FrameTime()
	local ct = RealTime()

    if not ( client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() and client:Alive() ) then
        -- player movement and wep movement, based on QTG weapon base cuz i dont like maths
        local ovel = client:GetVelocity()
        local move = Vector(ovel.x, ovel.y, 0)
        local movement = move:LengthSqr()
        local movepercent = math.Clamp(movement / client:GetRunSpeed() ^ 2, 0, 0.25)

        local vel = move:GetNormalized()
        local rd = client:GetRight():Dot(vel)
        local fd = (client:GetForward():Dot(vel) + 1) / 2

        local ft8 = math.min(ft * 8, 1)
        local onGround = client:OnGround()

        local c_move2 = movepercent
        c_move = Lerp(ft8, c_move or 0, onGround and movepercent or 0)
        c_sight = Lerp(ft8, c_sight or 0, onGround and 0.1 or 1)

        local jump = math.Clamp(ovel.z / 120, -0.25, 0.5) or 0
        c_jump = Lerp(ft8, c_jump or 0, (client:GetMoveType() == MOVETYPE_NOCLIP) and jump or math.Clamp(ovel.z / 120, -1.5, 1))

        if rd > 0.5 then
            c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 20 * c_move2)
        elseif rd < -0.5 then
            c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, -20 * c_move2)
        else
            c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 0)
        end

        view.origin = view.origin + view.angles:Up() * 0.75 * c_jump
        view.angles.p = view.angles.p + (c_jump or 0) * 3
        view.angles.r = view.angles.r + c_look

        if bob != 0 and c_move > 0 then
            local p = c_move * c_sight * bob

            view.origin = view.origin - view.angles:Forward() * c_move * c_sight * fd - view.angles:Up() * 0.75 * c_move + view.angles:Right() * 0.5 * c_move * c_sight
            view.angles.y = view.angles.y + math.sin(ct * 8.4) * 1.2 * p
            view.angles.p = view.angles.p + math.sin(ct * 16.8) * 0.8 * p
            view.angles.r = view.angles.r + math.cos(ct * 8.4) * 0.3 * p
        end

        if idle != 0 then
            local p = (1 - c_move) * c_sight * idle

            view.angles.p = view.angles.p + math.sin(ct * 0.5) * p
            view.angles.y = view.angles.y + math.sin(ct) * 0.5 * p
            view.angles.r = view.angles.r + math.sin(ct * 2) * 0.25 * p
        end

        local velocity = client:GetVelocity()
        lerpFov = Lerp(0.08, lerpFov, view.fov + math.sin(RealTime() * 0.5) * velocity:Length() * 0.005)

        view.fov = lerpFov
        
        return view
    end
end