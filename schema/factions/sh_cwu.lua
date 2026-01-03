FACTION.name = "Civil Worker's Union"
FACTION.description = "A citizen who has been recruited or signed up to work for the Universal Union. Civil Worker's Union receive many benefits, with access to better food and medical supplies. Most Civil Worker's Union operate business in the city, selling resources to other citizens in return for tokens, and some may be hired by the City Administrator to work for him. Most Civil Worker's Union believe that the goal of the Combine is good and do their best to support it."
FACTION.color = Color(100, 150, 200)
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

FACTION.bodyGroups = {
    ["torso"] = 21,
    ["legs"] = 7,
}

FACTION.xp = 15

FACTION.rationItems = {"comfort_supplements", "drink_water"}
FACTION.rationMoney = 150

FACTION.ranks = {}

FACTION.classes = {
    {
        name = "City Maintenance Worker",
        description = "A Standard City Maintenance Worker, you are the lowest class in the Civil Worker's Union. You maintain the streets and keep them clean and tidy, you report anti-civil activity and you stay loyal to the Universal Union, or not. You may not open up your own store.",
        health = 100,
        armor = 0,
        xp = 15,
        model = nil,
        usePermaModel = true,
        onBecome = function(ply, char, inv, rank)
            ply:SetBodygroup(1, 21)
            ply:SetBodygroup(2, 7)
            
            ply:Give("cityworker_pliers")
            ply:Give("cityworker_shovel")
            ply:Give("cityworker_wrench")
        end,
    },
    {
        name = "Medical Worker",
        description = "A Medical Worker, in the Civil Worker's Union is capable of healing civilians or Benefactors whether it be for Tokens or for free. You may open up your own Store to sell medical items. Though in Fighting Scenarios you might aswell support the Universal Union by healing!",
        health = 100,
        armor = 0,
        xp = 50,
        model = nil,
        usePermaModel = true,
        onBecome = function(ply, char, inv, rank)
            ply:SetBodygroup(1, 13)
        end,
    },
    {
        name = "Cook",
        description = "A Cook, you are capable of handing out food to random civilians whether it may be for Money or for Free.. up to you! Same applies to the Universal Union. You may open your own store to sell your Food with reasonable prices.",
        health = 100,
        armor = 0,
        xp = 180,
        model = nil,
        usePermaModel = true,
        onBecome = function(ply, char, inv, rank)
            ply:SetBodygroup(1, 6)
        end,
    },
    {
        name = "Infestation Control Team",
        description = "Employed as cleanup crews and researchers, Hazmat Workers are stationed primarily in and around the Quarantine Zone or Sewers to stem the infestation of alien flora and fauna from Xen. Most of them wear yellow hazmat suits, green medical gloves, black rubber boots, and helmets identical to that of Combine Workers.",
        health = 100,
        armor = 0,
        xp = 400,
        model = "models/hlvr/characters/hazmat_worker/hazmat_worker_male.mdl",
        onBecome = function(ply, char, inv, rank)
        end,
    },
    {
        name = "Researcher",
        description = "A Researcher's Task is to advance into the Combine or Human Technology to find more machinery to make to potentially improve the City, or you can improve the City populist by increasing their stats freely in the Research Facility. You may not open your own store, however you can open your own Lab in the Research Facility in Sector 3.",
        health = 100,
        armor = 0,
        xp = 1200,
        model = nil,
        usePermaModel = true,
        onBecome = function(ply, char, inv, rank)
            ply:SetBodygroup(1, 22)
            ply:SetBodygroup(2, 17)
        end,
    },
    {
        name = "Director",
        description = "The Director's job is to keep the Civil Worker's Union in tip top shape, once in a while a City Administrator might come to your doorstep to see how thing's are going. You cannot own any stores, however you own the Civil Worker's Union Headquarters in the Plaza.",
        health = 100,
        armor = 0,
        xp = 2500,
        model = nil,
        usePermaModel = true,
        onBecome = function(ply, char, inv, rank)
            ply:SetBodygroup(1, 38)
            ply:SetBodygroup(2, 16)
        end,
    },
}

FACTION_CWU = FACTION.index

CLASS_CWU_MAINTENANCE = 1
CLASS_CWU_MEDIC = 2
CLASS_CWU_COOK = 3
CLASS_CWU_ICT = 4
CLASS_CWU_RESEARCHER = 5
CLASS_CWU_DIRECTOR = 6