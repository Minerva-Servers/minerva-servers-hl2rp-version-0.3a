FACTION.name = "Vortigaunt"
FACTION.description = "A mysterious alien race, enslaved by the Combine. They are a wise and mainly peaceful race, forced into servitude by other races for centuries. They stayed hidden on Xen until the human scientists at Black Mesa opened a portal to it. Nihilanth used this opportunity to begin invading Earth, sending hordes of Vortigaunts, headcrabs and other creatures into this new realm. The death of the powerful Nihilanth actually made the rip in space-time worse, causing worldwide portal storms that lead to the invasion of the earth by the Combine."
FACTION.color = Color(200, 160, 20)
FACTION.isDefault = true

FACTION.models = {
    "models/minerva/vortigaunt.mdl",
}

FACTION.bodyGroups = {
    ["shackles"] = 1,
    ["collar"] = 1,
    ["hooks"] = 1,
}

FACTION.xp = 1600

FACTION.rationItems = {"comfort_supplements", "drink_water"}
FACTION.rationMoney = 80

function FACTION:OnSpawn(ply)
    timer.Simple(0, function()
        if not ( IsValid(ply) and ply:GetCharacter() ) then
            return
        end

        ply:SetName(ix.config.Get("cityIndex")..".UU:BIOTIC-"..Schema:ZeroNumber(math.random(1, 9999), 4))
        ply:SetModelScale(1.05)
        ply:SetViewOffset(Vector(0, 0, 68))

        ply:SetHealth(150)
        ply:SetMaxHealth(150)
    end)
end

FACTION_VORTIGAUNT = FACTION.index