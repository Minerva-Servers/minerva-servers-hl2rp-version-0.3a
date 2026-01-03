RECIPE.name = "Crowbar"
RECIPE.description = "Craft a crowbar."
RECIPE.model = "models/weapons/w_crowbar.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["metalplate"] = 1,
	["refinedmetal"] = 2,
	["glue"] = 1,
}
RECIPE.results = {
	["wep_crowbar"] = 1,
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