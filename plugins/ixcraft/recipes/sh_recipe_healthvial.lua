RECIPE.name = "Health Vial"
RECIPE.description = "Craft a Health Vial."
RECIPE.model = "models/healthvial.mdl"
RECIPE.category = "Medical"

RECIPE.requirements = {
	["plastic"] = 3,
	["aidfluid"] = 1,
}
RECIPE.results = {
	["healthvial"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"

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