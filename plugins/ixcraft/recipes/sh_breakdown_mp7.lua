RECIPE.name = "H&K MP7"
RECIPE.description = "Breakdown a submachine gun."
RECIPE.model = "models/weapons/w_smg1.mdl"
RECIPE.category = "Breakdownable"

RECIPE.requirements = {
	["wep_mp7"] = 1,
}
RECIPE.results = {
	["plastic"] = 2,
	["metalplate"] = 6,
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