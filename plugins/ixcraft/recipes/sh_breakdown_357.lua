RECIPE.name = "Colt Python Revolver"
RECIPE.description = "Breakdown a 357."
RECIPE.model = "models/weapons/w_357.mdl"
RECIPE.category = "Breakdownable"

RECIPE.requirements = {
	["wep_357"] = 1,
}
RECIPE.results = {
	["metalplate"] = 8,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "minerva/global/craft/generic/1.wav"

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