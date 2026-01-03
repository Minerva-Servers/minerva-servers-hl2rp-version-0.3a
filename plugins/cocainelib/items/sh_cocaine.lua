local PLUGIN = PLUGIN

ITEM.name = "Cocaine Brick"
ITEM.description = ""
ITEM.model = "models/srcocainelab/cocainebrick.mdl"
ITEM.category = "Cocaine Laboratory"
ITEM.width = 1
ITEM.height = 1

ITEM.OnEntityTakeDamage = function(item, dmginfo)
    return false
end

ITEM.functions.Use = {
    name = "Consume",
    icon = "icon16/pill.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        
        ply:EmitSound("physics/cardboard/cardboard_box_break1.wav", 80, 120)
        PLUGIN.BecomeCracked(ply)
    end
}