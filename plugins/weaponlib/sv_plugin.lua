local PLUGIN = PLUGIN

function PLUGIN:SetupMove(ply, mvData)
    if ( ply.StunTime ) then
        if ( ply.StunTime < CurTime() ) then
            ply.StunTime = nil
        else
            local v = math.Clamp((ply.StunStartTime - CurTime()) / (ply.StunStartTime - ply.StunTime), 0, 1)
            mvData:SetMaxClientSpeed(mvData:GetMaxClientSpeed() * v)
        end
    end
end

function PLUGIN:ScalePlayerDamage(ply, hitgroup, dmg)
    if ( ply:Armor() == 0 ) then
        return
    end

    local attacker = dmg:GetAttacker()
    if ( IsValid(attacker) and attacker:IsPlayer() ) then
        local wep = attacker:GetActiveWeapon()

        if ( IsValid(wep) and wep.Primary and wep.Primary.PenetrationScale ) then
            dmg:ScaleDamage(wep.Primary.PenetrationScale)
        end
    end
end

local rankCols = {
	["superadmin"] = Color(201, 15, 12),
	["communitymanager"] = Color(84, 204, 5),
	["leadadmin"] = Color(128, 0, 128),
	["admin"] = Color(34, 88, 216),
	["moderator"] = Color(34, 88, 216),
	["donator"] = Color(212, 185, 9)
}

function PLUGIN:PlayerLoadout(ply)
    local rankCol = rankCols[ply:GetUserGroup()]

    if rankCol then
        ply:SetWeaponColor(Vector(rankCol.r / 255, rankCol.g / 255, rankCol.b / 255))
    end
end