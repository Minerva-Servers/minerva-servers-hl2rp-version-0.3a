local PLUGIN = PLUGIN

util.AddNetworkString("PlayerNLRSync")

function PLUGIN:PlayerDeath(ply, ent, attacker)
    local area = ply:GetArea()

    ply.isActiveNLR = true
    ply.areaNlr = area

    timer.Create(ply:SteamID64().."NLR", self.time, 1, function()
        if not ( IsValid( ply ) ) then
            return
        end

        if ( ply.isActiveNLR ) then
            ply.isActiveNLR = false
        end

        ply.areaNlr = ""

        net.Start("PlayerNLRSync")
            net.WriteBool(ply.isActiveNLR)
            net.WriteString(ply.areaNlr)
        net.Send(ply)
    end)

    net.Start("PlayerNLRSync")
        net.WriteBool(ply.isActiveNLR)
        net.WriteString(ply.areaNlr)
    net.Send(ply)
end