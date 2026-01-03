RECIPE.name = "AKM"
RECIPE.description = "Craft a rifle."
RECIPE.model = "models/weapons/w_rif_ak47.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["pipe"] = 3,
	["glue"] = 4,
	["gear"] = 1,
	["plastic"] = 1,
	["refinedmetal"] = 4,
	["wood"] = 4,
}
RECIPE.results = {
	["wep_akm"] = 1,
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