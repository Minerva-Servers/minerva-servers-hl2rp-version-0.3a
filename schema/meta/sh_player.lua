local PLAYER = FindMetaTable("Player")

function PLAYER:IsCP()
    return self:Team() == FACTION_CP
end

function PLAYER:IsOW()
    return self:Team() == FACTION_OW
end

function PLAYER:IsCombine()
    return self:IsCP() or self:IsOW()
end

function PLAYER:IsAdministrator()
    return self:Team() == FACTION_ADMINISTRATOR
end

function PLAYER:IsVortigaunt()
    return self:Team() == FACTION_VORTIGAUNT
end

local function EquippedItem(ply, item)
    local char = ply:GetCharacter()
    if ( !char ) then
        return false
    end

    return char:GetInventory():HasItem(item, {["equip"] = true})
end

local rebelGear = {
    ["torso_blue_rebel"] = true,
    ["torso_gray_rebel"] = true,
    ["torso_green_rebel"] = true,
    ["face_blue_bandana"] = true,
    ["face_gray_bandana"] = true,
    ["face_red_bandana"] = true,
}
function PLAYER:Is647E()
    for i, v in pairs( rebelGear ) do
		return EquippedItem( self, i )
	end
end

function PLAYER:IsFreedVort()
    return ( self:GetBodygroup(7) == 0 and self:GetBodygroup(8) == 0 and self:GetBodygroup(9) == 0 )
end

function PLAYER:FreeVort()
    if not ( self:IsVortigaunt() ) then
        return
    end

    if ( self:IsFreedVort() ) then
        return
    end

    self:SetBodygroup(7, 0)
    self:SetBodygroup(8, 0)
    self:SetBodygroup(9, 0)
    self:Give("ix_vortbeam")
end

function PLAYER:IsDonator()
    return ( self:GetUserGroup() == "donator" or self:GetUserGroup() == "gamemaster" or self:IsAdmin() )
end

function PLAYER:IsGamemaster()
    return ( self:GetUserGroup() == "gamemaster" or self:GetUserGroup() == "senior" )
end

local devs = {
    ["76561197996534315"] = true,
    ["76561198373309941"] = true,
    ["76561197963057641"] = true,
}

function PLAYER:IsDeveloper()
    return ( devs[self:SteamID64()] )
end

function PLAYER:IsIncognito()
    return ( self:GetLocalVar("ixIncognito") )
end

function PLAYER:IsCombineTrusted()
    if ( self:IsCP() and ( self:GetTeamRank() >= RANK_CP_I1 or self:GetTeamClass() == RANK_CP_CPC ) ) then
        return true
    end

    if ( self:IsOW() and ( self:GetTeamClass() == RANK_OW_CPT or self:GetTeamRank() >= RANK_OW_EOW ) ) then
        return true
    end

    return false
end

function PLAYER:IsCombineCommand()
    if ( self:IsCP() and ( self:GetTeamRank() >= RANK_CP_SQL or self:GetTeamClass() == RANK_CP_CPC ) ) then
        return true
    end

    if ( self:IsOW() and ( self:GetTeamClass() == RANK_OW_CPT or self:GetTeamRank() == RANK_OW_LDR ) ) then
        return true
    end

    return false
end

function PLAYER:IsCombineSupervisor()
    if ( self:IsCP() and ( self:GetTeamRank() == RANK_CP_RL or self:GetTeamClass() == RANK_CP_CPC ) ) then
        return true
    end

    if ( self:IsOW() and self:GetTeamClass() == RANK_OW_CPT ) then
        return true
    end

    return false
end

function PLAYER:SurfacePlaySound(sound)
    net.Start("ixSurfaceSound")
        net.WriteString(sound)
    net.Send(self)
end

function PLAYER:OpenVGUI(panel)
    if not ( isstring(panel) ) then
        ErrorNoHalt("Warning argument is required to be a string! Instead is "..type(panel).."\n")
        return
    end

    if ( SERVER ) then
        net.Start("ixOpenVGUI")
            net.WriteString(panel)
        net.Send(self)
    else
        vgui.Create(panel)
    end
end

if ( CLIENT ) then
    net.Receive("ixOpenVGUI", function()
        local panel = net.ReadString()
        if not ( isstring(panel) ) then
            ErrorNoHalt("Warning argument is required to be a string! Instead is "..type(panel).."\n")
            return
        end

        vgui.Create(panel)
    end)
else
    function PLAYER:SetIncognito(boolean)
        self:SetLocalVar("ixIncognito", boolean)
    end
end
