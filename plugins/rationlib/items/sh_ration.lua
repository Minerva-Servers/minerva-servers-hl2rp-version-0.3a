ITEM.name = "Ration"
ITEM.model = "models/weapons/w_package.mdl"
ITEM.description = "A shrink-wrapped packet containing some food and money."

ITEM.functions.Open = {
    name = "Unwrap",
    icon = "icon16/box.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        for k, v in ipairs(ix.faction.indices[ply:Team()].rationItems or {"comfort_supplements", "drink_water"}) do
            char:GetInventory():Add(v)
        end

        char:GiveMoney(ix.faction.indices[ply:Team()].rationMoney or 50)
        ply:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav", nil, nil, 0.3)
    end,
}