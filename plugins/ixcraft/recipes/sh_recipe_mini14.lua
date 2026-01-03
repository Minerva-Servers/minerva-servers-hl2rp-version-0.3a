RECIPE.name = "Mini-14"
RECIPE.description = "Craft a rifle."
RECIPE.model = "models/weapons/arccw/c_ud_mini14.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["pipe"] = 6,
	["glue"] = 6,
	["gear"] = 3,
	["refinedmetal"] = 3,
	["wood"] = 10,
}
RECIPE.results = {
	["wep_mini14"] = 1,
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