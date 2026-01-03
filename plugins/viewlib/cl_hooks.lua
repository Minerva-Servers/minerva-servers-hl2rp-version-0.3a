local PLUGIN = PLUGIN

local yang
local xang
function PLUGIN:InputMouseApply(cmd, x, y, ang)
    if not ( ix.option.Get("smoothView", true) ) then
        return
    end

    if not ( xang ) then
        xang = x
    end

    if not ( yang ) then
        yang = y
    end

    xang = Lerp(0.03, xang, xang - x)
    yang = Lerp(0.03, yang, math.Clamp(yang - y, -89.99, 89.99))

    cmd:SetViewAngles(LerpAngle(0.05, ang, Angle(-yang, xang)))

    return true
end

local client
function PLUGIN:CalcView( client, pos, angles, fov )
    if ( !IsValid( client ) ) then
        client = LocalPlayer()
        return
    end

    local cur_view = ix.custview.current
    if ( !cur_view ) then
        ix.custview.SetCurrent( ix.option.Get( "viewDesign" ) )
        return
    end

    local character = client:GetCharacter()
    if ( !IsValid( client ) or !character ) then
        return
    end

    if ( !ix.util.ShouldDrawView( client, client:GetCharacter(), pos, angles, fov ) ) then
        return
    end

    if ( cur_view.Draw ) then
        cur_view:Draw( client, character, pos, angles, fov )
    end

    hook.Run( "CalcViewAlternate", client, character, pos, angles, fov )
end

function PLUGIN:OnReloaded()
    ix.custview.SetCurrent( ix.option.Get( "viewDesign" ) )
end

function ix.util.ShouldDrawView(client, char)
    if not ( IsValid(client) and client:Alive() and char ) then return end
    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then return end
    if ( IsValid(ix.gui.menu) ) then return end
    if ( IsValid(client:GetActiveWeapon()) and client:GetActiveWeapon():GetClass() == "gmod_camera" ) then return end
    if ( client:GetMoveType() == MOVETYPE_NOCLIP ) then return end

    return true
end