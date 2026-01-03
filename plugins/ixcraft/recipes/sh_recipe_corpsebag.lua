RECIPE.name = "Corpse Bag"
RECIPE.description = "Craft a "..RECIPE.name.."."
RECIPE.model = "models/bodybags/bodybag_01.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.requirements = {
	["cloth"] = 5,
}
RECIPE.results = {
	["corpsebag"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "minerva/global/craft/fabric/"..math.random(1, 6)..".wav"

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