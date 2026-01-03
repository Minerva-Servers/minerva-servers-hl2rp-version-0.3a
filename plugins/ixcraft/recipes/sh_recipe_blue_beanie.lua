RECIPE.name = "Black Blue"
RECIPE.description = "Craft a "..RECIPE.name.."."
RECIPE.model = "models/props_junk/cardboard_box004a.mdl"
RECIPE.category = "Clothing (Headgear)"

RECIPE.requirements = {
	["cloth"] = 2,
}
RECIPE.results = {
	["headgear_blue_beanie"] = 1,
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