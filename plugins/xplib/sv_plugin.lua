local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(ply, char)
    ply:SetXP(ply:GetPData("ixXP", 0))
    
    if ( ply:GetXP() <= 500 ) then
        ix.xp.SetXP(ply, 500)
    end

    timer.Create("ixXP.Timer."..ply:SteamID64(), ix.config.Get("xpTime", 600), 0, function()
        ix.xp.GainXP(ply, true)
    end)
end

function PLUGIN:PlayerDisconnected(ply)
    if ( timer.Exists("ixXP.Timer."..ply:SteamID64()) ) then
        timer.Remove("ixXP.Timer."..ply:SteamID64())
    end
end

function ix.xp.SetXP(ply, amount)
    ply:SetXP(amount)
    ply:SetPData("ixXP", amount)
end

function ix.xp.GainXP(ply, bNotify)
    if ( ply.isAFK ) then
        if ( bNotify ) then
            ply:Notify("You have not received any XP because you are AFK.")
        end

        return
    end

    local gain = ix.config.Get("normalXPGain", 5)
    if ( ply:IsDonator() ) then
        gain = ix.config.Get("donatorXPGain", 10)
    end

    if ( bNotify ) then
        ply:Notify("You have gained "..gain.." XP for playing on the server for 10 Minutes!")
    end
    
    ply:SetXP(ply:GetPData("ixXP") + gain)
    ply:SetPData("ixXP", ply:GetXP())
end