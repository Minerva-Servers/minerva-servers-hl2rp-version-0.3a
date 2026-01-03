RECIPE.name = "Rappel Gear"
RECIPE.description = "Breakdown a set of rappeling gear."
RECIPE.model = "models/props_c17/TrapPropeller_Lever.mdl"
RECIPE.category = "Breakdownable"

RECIPE.requirements = {
	["wep_rappel"] = 1,
}
RECIPE.results = {
	["metalplate"] = 2,
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