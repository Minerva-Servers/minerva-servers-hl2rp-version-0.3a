RECIPE.name = "Crossbow Bolts"
RECIPE.description = "Craft some Crossbow Bolt's."
RECIPE.model = "models/Items/CrossbowRounds.mdl"
RECIPE.category = "Ammunition"

RECIPE.requirements = {
	["pipe"] = 4,
	["glue"] = 3,
	["refinedmetal"] = 2,
}
RECIPE.results = {
	["ammo_crossbow"] = 1,
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