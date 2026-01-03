RECIPE.name = "Splint"
RECIPE.description = "Craft a long wooden rod."
RECIPE.model = "models/props_junk/wood_crate001a_chunk05.mdl"
RECIPE.category = "Medical"

RECIPE.requirements = {
	["wood"] = 2,
}
RECIPE.results = {
	["splint"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftSound = "minerva/global/craft/wood/"..math.random(1, 6)..".wav"

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