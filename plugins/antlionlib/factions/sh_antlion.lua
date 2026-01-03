FACTION.name = "Antlion"
FACTION.description = "The Necrotic was once a Human, but still is a human. They are being possessed by a Headcrab mounted on their head, the person underneath the headcrab is very much alive. Although the headcrab is taking control of the human which makes them unable to resist the new Host. Necrotics are commonly found near packs of 3 or more, they are always found in the depths of the Sewers and sometimes in the outlands. There is multiple versions of these Necrotics. These Necrotics have no fear and simpaphy for it's enemies, which are basically anyone who is not their kind."
FACTION.color = Color(150, 120, 60)
FACTION.isDefault = true

FACTION.models = {
    "models/antlion.mdl",
}

FACTION.xp = 600

FACTION.rationItems = {}
FACTION.rationMoney = 0

FACTION.donatorOnly = true

function FACTION:OnBecome(ply)
    ply:GetCharacter():SetName("Antlion")

    ply:SetHealth(60)
    ply:SetMaxHealth(60)
    ply:SetJumpPower(600)
    ply:SetViewOffset(Vector(0, 0, 48))
    ply:SetViewOffsetDucked(Vector(0, 0, 48))
    
    ply:StripWeapons()
    ply:Give("ix_antlion_swep")
    ply:SelectWeapon("ix_antlion_swep")
end

FACTION_ANTLION = FACTION.index