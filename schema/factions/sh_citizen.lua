FACTION.name = "Citizen"
FACTION.description = "The lowest class of Universal Union society. They are forced to follow the Universal Union's dictatorship with absolute obedience, or face punishments and even execution. The Universal Union keeps citizens weak and malnourished, and it is all they can do to try and survive. However, some brave citizens dare to stand against the Combine..."
FACTION.color = Color(20, 120, 20)
FACTION.isDefault = true

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

FACTION.bodyGroups = nil

FACTION.xp = 0

FACTION.rationItems = {"comfort_supplements", "drink_water"}
FACTION.rationMoney = 100

function FACTION:OnCharacterCreated(ply, char)
    char:SetData("originalName", char:GetName())
    char:SetData("originalModel", char:GetModel())
    char:GiveFlags("pet")
end

FACTION_CITIZEN = FACTION.index