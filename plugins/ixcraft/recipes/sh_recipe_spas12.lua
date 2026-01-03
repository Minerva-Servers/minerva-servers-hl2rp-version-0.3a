RECIPE.name = "Franchi SPAS-12"
RECIPE.description = "Craft a spas-12 shotgun."
RECIPE.model = "models/weapons/w_shotgun.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["pipe"] = 4,
	["glue"] = 2,
	["gear"] = 2,
	["plastic"] = 2,
	["refinedmetal"] = 3,
}
RECIPE.results = {
	["wep_spas12"] = 1,
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