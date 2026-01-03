local PLUGIN = PLUGIN

PLUGIN.mapConfig = {
    ["rp_minerva_city17"] = {
        Vector(9023.244141, 3288.411865, 6912.031250), 
        Vector(8753.211914, 3574.527100, 7119.968750),
    },
    ["rp_minerva_city8"] = {
        Vector(2928.7170410156, -15116.784179688, -2559.96875),
        Vector(3093.1550292969, -15214.987304688, -2428.7668457031),
    },
    ["rp_city24_v3"] = {
        Vector(12817.791992188, 4039.9294433594, 2323.2963867188),
        Vector(11792.831054688, 3377.8312988281, 2064.03125),
    },
}

local meta = FindMetaTable("Player")

function meta:CanBroadcastUsingVoice()
    if not ( self:GetCharacter() ) then
        return false
    end
    
    if not ( PLUGIN.mapConfig[game.GetMap()] ) then
        return false
    end
    
    if not ( PLUGIN.mapConfig[game.GetMap()][1] and PLUGIN.mapConfig[game.GetMap()][2] ) then
        return false
    end
    
    return self:GetPos():WithinAABox(PLUGIN.mapConfig[game.GetMap()][1], PLUGIN.mapConfig[game.GetMap()][2])
end

function PLUGIN:PlayerCanHearPlayersVoice( list, talk )
	if not ( talk:GetCharacter() ) then
		return
	end

	if not ( talk:CanBroadcastUsingVoice() ) then
		return
	end

    return true
end