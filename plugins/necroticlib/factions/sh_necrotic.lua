FACTION.name = "Necrotic"
FACTION.description = "The Necrotic was once a Human, but still is a human. They are being possessed by a Headcrab mounted on their head, the person underneath the headcrab is very much alive. Although the headcrab is taking control of the human which makes them unable to resist the new Host. Necrotics are commonly found near packs of 3 or more, they are always found in the depths of the Sewers and sometimes in the outlands. There is multiple versions of these Necrotics. These Necrotics have no fear and simpaphy for it's enemies, which are basically anyone who is not their kind."
FACTION.color = Color(120, 20, 20)
FACTION.isDefault = true

FACTION.models = {
    "models/player/zombie_classic.mdl",
}

FACTION.bodyGroups = {
    ["headcrab1"] = 1,
}

FACTION.xp = 200

FACTION.rationItems = {}
FACTION.rationMoney = 0

FACTION.ranks = {}

FACTION.classes = {
    {
        name = "Regular Zombie",
        description = "",
        health = 150,
        armor = 0,
        xp = 200,
        model = "models/player/zombie_classic.mdl",
        onBecome = function(ply, char, inv, rank)
            ply:GetCharacter():SetName("Zombie")

            ply:SetHealth(200)
            ply:SetMaxHealth(200)
            ply:SetJumpPower(100)

            ply:SetModel("models/player/zombie_classic.mdl")
            ply:SetBodygroup(1, 1)
            
            ply:StripWeapons()
            ply:Give("ix_zombie_claws")
            ply:SelectWeapon("ix_zombie_claws")
        end,
    },
    {
        name = "Fast Zombie",
        description = "",
        health = 150,
        armor = 0,
        xp = 600,
        model = "models/zombie/fast.mdl",
        onBecome = function(ply, char, inv, rank)
            ply:GetCharacter():SetName("Fast Zombie")

            ply:SetHealth(100)
            ply:SetMaxHealth(100)
            ply:SetJumpPower(300)

            ply:SetModel("models/zombie/fast.mdl")
            ply:SetBodygroup(1, 1)
            
            ply:StripWeapons()
            ply:Give("ix_fastzombie_claws")
            ply:SelectWeapon("ix_fastzombie_claws")

            ply:EmitSound("npc/fast_zombie/fz_alert_far1.wav", 100, math.random(80, 120))
        end,
    },
    {
        name = "Zombine",
        description = "",
        health = 600,
        armor = 0,
        xp = 1500,
        model = "models/zombie/zombie_soldier.mdl",
        onBecome = function(ply, char, inv, rank)
            ply:GetCharacter():SetName("Zombine")

            ply:SetHealth(100)
            ply:SetMaxHealth(100)
            ply:SetJumpPower(100)

            ply:SetModel("models/zombie/zombie_soldier.mdl")
            ply:SetBodygroup(1, 1)
            
            ply:StripWeapons()
            ply:Give("ix_zombie_claws")
            ply:SelectWeapon("ix_zombie_claws")

            ply:EmitSound("npc/zombine/zombine_charge1.wav", 100, math.random(80, 120))
        end,
    },
}

function FACTION:OnBecome(ply, char, factionTable)
    ply:ScreenFade(SCREENFADE.IN, color_black, 4, 2)

    timer.Simple(0.5, function() -- Keep for the sake for the support of switching from another team like OTA or CP to this one.
        net.Start("ixRankNPC.OpenMenuNoClose")
        net.Send(ply)
    end)
end

FACTION_NECROTIC = FACTION.index

CLASS_NECROTIC_REGULAR = 1
CLASS_NECROTIC_FAST = 2
CLASS_NECROTIC_SOLDIER = 3