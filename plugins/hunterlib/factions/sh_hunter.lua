FACTION.name = "Hunter"
FACTION.description = "A hunter is a fast and deadly synthetic unit. The hunter is used by the combine as a scout or escort, due to its reliable armour and weaponary."
FACTION.color = Color(0, 120, 150)
FACTION.isDefault = true

FACTION.models = {
    "models/hunter.mdl",
}

FACTION.xp = 8000

FACTION.rationItems = {}
FACTION.rationMoney = 0

FACTION.donatorOnly = true

function FACTION:PreBecome(ply, char, factionTable)
    if ( ix.cityCode.GetCurrent() == "civil" ) then
        ply:Notify("You can not become this faction during Civil!")
        return false
    end

    if ( team.NumPlayers(FACTION_HUNTER) >= 2 ) then
        ply:Notify("There is already enough players in this faction!")
        return false
    end
    
    if ( ply:GetCBanTime() ) then
        if ( os.time() > ply:GetCBanTime() ) then
            ply:RemoveCBan()
        end
    end
    
    if ( ply:HasActiveCBan() ) then
        ply:Notify("You are unable to join this team due to you having an active Combine Ban!\nYou are combine banned until - "..ply:GetCBanTimeReal())
        
        return false
    end

    return true
end

function FACTION:OnBecome(ply)
    ply:GetCharacter():SetName(ix.config.Get("sectorIndex")..":SYNTH.HUNTER-"..tostring(math.random(1,9)))

    ply:SetHealth(500)
    ply:SetMaxHealth(500)
    ply:SetJumpPower(500)
    ply:SetViewOffset(Vector(0, 0, 88))
    ply:SetViewOffsetDucked(Vector(0, 0, 88))
    
    ply:StripWeapons()
    ply:Give("ix_hunter_swep")
    ply:Give("ix_hunter_melee")
    ply:SelectWeapon("ix_hunter_melee")
end

FACTION_HUNTER = FACTION.index