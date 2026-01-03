RECIPE.name = "Bullet Casing"
RECIPE.description = "Craft a bullet casing."
RECIPE.model = "models/items/ar2_grenade.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.requirements = {
	["metalplate"] = 2,
}
RECIPE.results = {
	["bulletcasing"] = 1,
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