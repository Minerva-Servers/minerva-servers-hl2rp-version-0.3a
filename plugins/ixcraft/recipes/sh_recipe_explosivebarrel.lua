RECIPE.name = "Explosive Barrel"
RECIPE.description = "Craft a Explosive Barrel."
RECIPE.model = "models/props_c17/oildrum001_explosive.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.requirements = {
	["refinedmetal"] = 1,
	["metalplate"] = 10,
	["glue"] = 3,
	["drink_special"] = 2,
	["explosive"] = 10,
}
RECIPE.results = {
	["explosivebarrel"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "minerva/global/craft/metal/"..math.random(1, 3)..".wav"

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