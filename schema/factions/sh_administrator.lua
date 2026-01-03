FACTION.name = "Administrator"
FACTION.description = "The Administrator is an unmodified human appointed to run the city by the Universal Union. He has been chosen because of his fierce support of and loyalty for the Universal Union. He spends most of his time in his office, managing the piles of paperwork a bustling city produces, and rarely takes to the streets."
FACTION.color = Color(255, 200, 100)
FACTION.isDefault = false

FACTION.models = {
    "models/hl2rp/male_01.mdl",
    "models/hl2rp/male_02.mdl",
    "models/hl2rp/male_03.mdl",
    "models/hl2rp/male_04.mdl",
    "models/hl2rp/male_05.mdl",
    "models/hl2rp/male_06.mdl",
    "models/hl2rp/male_07.mdl",
    "models/hl2rp/male_08.mdl",
    "models/hl2rp/male_09.mdl",
    "models/hl2rp/female_01.mdl",
    "models/hl2rp/female_02.mdl",
    "models/hl2rp/female_03.mdl",
    "models/hl2rp/female_04.mdl",
    "models/hl2rp/female_06.mdl",
    "models/hl2rp/female_07.mdl",
}

FACTION.bodyGroups = {
    // cia lookin mf black suit
    ["torso"] = 38,
    // epic brown suit
    --["torso"] = 40,
    // shitty brown suit
    --["torso"] = 39,

    // black leggies
    ["legs"] = 16,
    // brown leggies
    --["legs"] = 18,
}

FACTION.xp = 4000

FACTION.rationItems = {"comfort_supplements", "drink_water"}
FACTION.rationMoney = 250

function FACTION:PreBecome(ply, char, factionTable)
    if ( team.NumPlayers(FACTION_ADMINISTRATOR) >= 1 ) then
        ply:Notify("There is already enough players in this faction!")
        return false
    end
    
    if ( ply:GetCBanTime() ) then
        if ( os.time() > ply:GetCBanTime() ) then
            ply:RemoveCBan()
        end
    end
    
    if ( ply:HasActiveCBan() ) then
        ply:Notify("You are unable to join this team due to you having an active Combine Ban! You are combine banned until - "..ply:GetCBanTimeReal())
        
        return false
    end

    return true
end

FACTION_ADMINISTRATOR = FACTION.index