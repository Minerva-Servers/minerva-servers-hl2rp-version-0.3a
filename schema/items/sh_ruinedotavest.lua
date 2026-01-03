ITEM.name = "Ruined Overwatch Vest"
ITEM.description = "A ruined vest that was once used by Overwatch Soldiers."
ITEM.model = "models/nemez/combine_soldiers/combine_soldier_prop_vest.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.OnEntityTakeDamage = function()
    return false
end