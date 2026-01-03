RECIPE.name = "Unshackling Kit"
RECIPE.description = "Craft a kit used to unshackle vortigaunts."
RECIPE.model = "models/props_c17/BriefCase001a.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.requirements = {
	["cloth"] = 2,
	["biolink"] = 1,
	["glue"] = 1,
	["metalplate"] = 2,
}
RECIPE.results = {
	["unshacklingkit"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "minerva/global/craft/plastic/"..math.random(1, 5)..".wav"

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