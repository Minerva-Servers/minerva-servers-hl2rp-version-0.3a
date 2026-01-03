local PLUGIN = PLUGIN

local effect = ix.util.GetMaterial("effects/tp_eyefx/tpeye3")
function PLUGIN:HUDPaintAlternate(client, character, scrW, scrH)
    if ( character:GetData("ixHigh") ) then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(effect)
        surface.DrawTexturedRect(0, 0, scrW, scrH)
    end
end

local client;
function PLUGIN:CalcView(client, pos, angles, fov)
    if ( !IsValid( client ) ) then
        client = LocalPlayer()
        return
    end

    local character = client:GetCharacter()
    if ( !IsValid( client ) or !character ) then
        return
    end

    if ( character:GetData("ixHigh") ) then
        local view = GAMEMODE.BaseClass:CalcView( client, pos, angles, fov )
        view.fov = fov + 30

        return view
    end
end