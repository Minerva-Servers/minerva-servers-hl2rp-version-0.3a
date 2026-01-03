RECIPE.name = "Bandage"
RECIPE.description = "Craft some bandages with 2 pieces of cloth."
RECIPE.model = "models/props_wasteland/prison_toiletchunk01f.mdl"
RECIPE.category = "Medical"

RECIPE.requirements = {
	["cloth"] = 2,
}
RECIPE.results = {
	["bandage"] = 1,
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