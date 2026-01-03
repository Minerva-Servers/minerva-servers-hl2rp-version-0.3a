RECIPE.name = "Overwatch Vest"
RECIPE.description = "Craft an "..RECIPE.name.."."
RECIPE.model = "models/props_junk/cardboard_box004a.mdl"
RECIPE.category = "Clothing (Kevlar)"

RECIPE.requirements = {
	["cloth"] = 8,
	["glue"] = 3,
	["metalplate"] = 4,
	["ruinedotavest"] = 1,
}
RECIPE.results = {
	["vest_ota"] = 1,
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