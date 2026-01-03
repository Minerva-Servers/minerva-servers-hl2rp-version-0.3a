RECIPE.name = "Grenade"
RECIPE.description = "Craft a Grenade."
RECIPE.model = "models/Items/grenadeAmmo.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["explosive"] = 2,
	["metalplate"] = 2,
	["pipe"] = 1,
	["electronics"] = 1,
	["plastic"] = 4,
}
RECIPE.results = {
	["wep_grenade"] = 1,
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