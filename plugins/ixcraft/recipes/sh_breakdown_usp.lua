RECIPE.name = "H&K USP Match"
RECIPE.description = "Breakdown a 9mm sidearm pistol."
RECIPE.model = "models/weapons/w_pistol.mdl"
RECIPE.category = "Breakdownable"

RECIPE.requirements = {
	["wep_usp"] = 1,
}
RECIPE.results = {
	["plastic"] = 3,
	["metalplate"] = 4,
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