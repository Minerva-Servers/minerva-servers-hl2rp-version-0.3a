RECIPE.name = "Pipe Bomb"
RECIPE.description = "Craft a Pipe Bomb."
RECIPE.model = "models/wick/weapons/l4d1/w_pipebomb.mdl"
RECIPE.category = "Weapons"

RECIPE.requirements = {
	["explosive"] = 1,
	["metalplate"] = 1,
	["pipe"] = 1,
	["electronics"] = 1,
}
RECIPE.results = {
	["wep_pipebomb"] = 1,
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