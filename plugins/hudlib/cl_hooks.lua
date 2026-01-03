local PLUGIN = PLUGIN

BAR_HEIGHT = 15

ix_hudEnabled = true

ix.bar.Remove("health")
ix.bar.Remove("armor")
ix.bar.Remove("stm")

do
    ix.bar.Add(function()
        local status = LocalPlayer():Health() or 100
        local var = math.max(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0)

        return var, tostring(status)
    end, Color(200, 0, 0), nil, "newHealth")

    ix.bar.Add(function()
        if not ( LocalPlayer():GetCharacter() ) then
            return false
        end

        local status = LocalPlayer():GetCharacter():GetHunger() or 100
        local var = LocalPlayer():GetCharacter():GetHunger()

        return var, tostring(status)
    end, Color(205, 133, 63), nil, "newHunger")

    ix.bar.Add(function()
        if not ( LocalPlayer():GetCharacter() ) then
            return false
        end

        local status = LocalPlayer():GetCharacter():GetMoney() or 0
        local var = 100

        return var, tostring(status)
    end, Color(133, 227, 91), nil, "newMoney")

    ix.bar.Add(function()
        local status = LocalPlayer():GetXP() or 0
        local var = 100
        
        return var, tostring(status)
    end, Color(205, 190, 0), nil, "newXP")
end

player_model = player_model;
function PLUGIN:DrawPlayerModel( client, character, x, y, w, h )
    if ( !IsValid( player_model ) ) then
        player_model = vgui.Create( "ixModelPanel" )
        player_model:SetModel( client:GetModel(), client:GetSkin() )
    end

    if ( ix.util.ShouldDrawHud( client, character ) ) then
        player_model:SetPos( x, y )
        player_model:SetSize( w, h )
    else
        player_model:SetPos( 0, 0 )
        player_model:SetSize( 0, 0 )
    end

    local entity = player_model.Entity

    if ( !IsValid( entity ) ) then
        return
    end

    if ( entity:GetModel() != client:GetModel() ) then
        entity:SetModel( client:GetModel(), client:GetSkin() )
    end

    for i, v in ipairs( client:GetBodyGroups() ) do
        entity:SetBodygroup( v.id, client:GetBodygroup( v.id ) )
    end
    entity:SetSkin( client:GetSkin() )

    local subindexes
    for i = 1, 10 do
        subindexes = client:GetSubMaterial( i )
        if ( subindexes ) then
            entity:SetSubMaterial( i, subindexes )
        end
    end

    player_model:SetFOV( 35 )
    player_model.brightness = 3

    function player_model:LayoutEntity()
        local e = self.Entity
        self.def_angle = self.def_angle or Angle( 0, 90, 0 )
        e:SetAngles( self.def_angle )
        e:SetIK( false )
        e:SetSequence( client:GetSequence() )
        e:SetPoseParameter( "move_yaw", 360 * client:GetPoseParameter( "move_yaw" ) - 180 )

        self:RunAnimation()
    end
end

player_icon = player_icon;
function PLUGIN:DrawPlayerIcon( client, character, x, y, w, h )
    if ( !IsValid( player_icon ) ) then
        player_icon = vgui.Create( "ixSpawnIcon" )
        return
    end

    if ( player_icon:GetModel() != client:GetModel() ) then
        player_icon:SetModel( client:GetModel() )
    end

    if ( ix.util.ShouldDrawHud( client, character ) ) then
        player_icon:SetPos( x, y )
        player_icon:SetSize( w, h )
    else
        player_icon:SetPos( 0, 0 )
        player_icon:SetSize( 0, 0 )
    end

    player_icon:MoveToBack()

    local entity = player_icon.Entity

    if ( !IsValid( entity ) ) then
        return
    end

    for i, v in ipairs( client:GetBodyGroups() ) do
        entity:SetBodygroup( v.id, client:GetBodygroup( v.id ) )
    end
    entity:SetSkin( client:GetSkin() )

    local subindexes
    for i = 1, 10 do
        subindexes = client:GetSubMaterial( i )
        if ( subindexes ) then
            entity:SetSubMaterial( i, subindexes )
        end
    end

    local subindexes
    for i = 1, 10 do
        subindexes = client:GetSubMaterial( i )
        if ( subindexes ) then
            entity:SetSubMaterial( i, subindexes )
        end
    end
end

local client;
function PLUGIN:RenderScreenspaceEffects()
    local scrW = ScrW()
    local scrH = ScrH()

    if ( !IsValid( client ) ) then
        client = LocalPlayer()
        return
    end

    local character = client:GetCharacter()
    if ( !IsValid( client ) or !character ) then
        return
    end

    local cur_screeneffect = ix.custscreeneffect.current
    if ( !cur_screeneffect ) then
        ix.custscreeneffect.SetCurrent( ix.option.Get( "screeneffectDesign" ) )
        return
    end

    if ( cur_screeneffect.Draw ) then
        cur_screeneffect:Draw( client, character, scrW, scrH )
    end
end

local client;
local scrW;
local scrH;

function PLUGIN:OnScreenSizeChanged()
	scrW = ScrW()
	scrH = ScrH()
end

function PLUGIN:HUDPaint()
	if ( !scrW or !scrH ) then
    	scrW = ScrW()
    	scrH = ScrH()
	end

    if ( !IsValid( client ) ) then
        client = LocalPlayer()
        return
    end

    local cur_hud = ix.custhud.current
    if ( !cur_hud ) then
        ix.custhud.SetCurrent( ix.option.Get( "hudDesign" ) )
        return
    end

    local cur_crosshair = ix.custcrosshair.current
    if ( !cur_crosshair ) then
        ix.custcrosshair.SetCurrent( ix.option.Get( "crosshairDesign" ) )
        return
    end

    local character = client:GetCharacter()
    if ( !IsValid( client ) or !character ) then
        return
    end

    if ( IsValid( player_icon ) ) then
        player_icon:SetSize( 0, 0 )
        player_icon:SetPos( 0, 0 )
    end

    if ( IsValid( player_model ) ) then
        player_model:SetSize( 0, 0 )
        player_model:SetPos( 0, 0 )
    end

    if ( !ix.util.ShouldDrawHud( client, client:GetCharacter() ) ) then
        return
    end

    if ( cur_hud.Draw ) then
        cur_hud:Draw( client, character, scrW, scrH )
    end

    local weapon = client:GetActiveWeapon()
    if ( !IsValid( weapon ) ) then
        return
    end

    local x, y;
    --if ( weapon.ShouldDrawCrosshair and weapon:ShouldDrawCrosshair() ) then
        if ( ix.option.Get( "thirdpersonEnabled" ) ) then
            local p = client:GetEyeTrace().HitPos:ToScreen()

            x = p.x
            y = p.y
        else
            x = scrW / 2
            y = scrH / 2
        end

        if ( cur_crosshair.Draw ) then
            cur_crosshair:Draw( client, character, x, y, scrW, scrH )
        end
    --end

    hook.Run( "HUDPaintAlternate", client, character, scrW, scrH )
end

function PLUGIN:ShouldHideBars()
    if ( ix.option.Get( "hudDesign" ) != "helix" ) then
        return true
    end
end

function PLUGIN:ShouldDrawCrosshair()
    return false
end

function PLUGIN:OnReloaded()
    ix.custhud.SetCurrent( ix.option.Get( "hudDesign" ) )
    ix.custcrosshair.SetCurrent( ix.option.Get( "crosshairDesign" ) )
    ix.custscreeneffect.SetCurrent( ix.option.Get( "screeneffectDesign" ) )
end

function ix.util.ShouldDrawHud(client, char)
    if not ( IsValid(client) and client:Alive() and char ) then
        return
    end

    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then
        return
    end

    if ( IsValid(ix.gui.menu) ) then
        return
    end

    if ( IsValid(client:GetActiveWeapon()) and string.find(tostring(client:GetActiveWeapon():GetClass()), "camera") ) then
        return
    end

    if ( client:GetNetVar("IsAFK") ) then
        return
    end

    if ( ix_cinematicIntro ) then
        return
    end

    if not ( ix_hudEnabled ) then
        return
    end

    return true
end
