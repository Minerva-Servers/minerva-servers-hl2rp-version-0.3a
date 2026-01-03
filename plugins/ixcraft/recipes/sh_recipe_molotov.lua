RECIPE.name = "Molotov"
RECIPE.description = "Craft a Molotov."
RECIPE.model = "models/props_junk/garbage_glassbottle003a.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["cloth"] = 3,
    ["drink_water"] = 1
}
RECIPE.results = {
	["wep_molotov"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "minerva/global/craft/gunmetal/"..math.random(1, 3)..".wav"

RECIPE:PostHook("OnCanCraft", function(recipeTable, ply)
    if ( recipeTable.station ) then
        for _, v in pairs(ents.FindByClass(recipeTable.station)) do
            if (ply:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
                return true
            end
        end

        return false, "You need to be near a workbench."
    end
end)

RECIPE:PostHook("OnCraft", function(recipeTable, ply)
	ply:EmitSound(recipeTable.craftSound or "")
end)