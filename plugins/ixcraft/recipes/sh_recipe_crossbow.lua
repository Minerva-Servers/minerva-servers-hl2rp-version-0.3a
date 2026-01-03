RECIPE.name = "Crossbow"
RECIPE.description = "Craft a Crossbow."
RECIPE.model = "models/weapons/w_crossbow.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["pipe"] = 4,
	["metalplate"] = 5,
	["glue"] = 3,
	["gear"] = 3,
	["refinedmetal"] = 4,
}
RECIPE.results = {
	["wep_crossbow"] = 1,
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