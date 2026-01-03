// Project Paradigm Gang was here lel.


RECIPE.name = "Supplements"
RECIPE.description = "Scotnay's favourite meal."
RECIPE.model = "models/props_lab/jar01b.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.requirements = {
	["fruit_watermelon"] = 2,
}
RECIPE.results = {
	["comfort_supplements"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = ""

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