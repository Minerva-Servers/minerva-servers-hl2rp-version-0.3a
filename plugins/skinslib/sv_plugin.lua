local PLUGIN = PLUGIN

util.AddNetworkString("ixUpdateCitizenSkin")
util.AddNetworkString("ixUpdateVortigauntSkin")

net.Receive("ixUpdateCitizenSkin", function(len, ply)
    local char = ply:GetCharacter()

    if not ( string.find(ply:GetModel(), "/hl2rp/") ) then
        return
    end
    
    if ( ply:Is647E() or ply:IsAdministrator() or ply:Team() == FACTION_CWU ) then
        return
    end

    ply:SetBodygroup(1, net.ReadUInt(8) or 0)
    ply:SetBodygroup(2, net.ReadUInt(8) or 0)
    ply:SetBodygroup(3, net.ReadUInt(8) or 0)
    ply:SetBodygroup(6, net.ReadUInt(8) or 0)
    ply:SetSkin(net.ReadUInt(8) or 0)
end)

net.Receive("ixUpdateVortigauntSkin", function(len, ply)
    local char = ply:GetCharacter()

    if ( ply:GetModel() != "models/minerva/vortigaunt.mdl" ) then
        return
    end

    local skinNumber = net.ReadUInt(8)
    ply:SetSkin(skinNumber or 0)
end)