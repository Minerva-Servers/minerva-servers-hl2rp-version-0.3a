ITEM.name = "Pipe Bomb"
ITEM.description = "An improvised low explosive consisting of an explosive material in a tightly sealed metal pipe equipped with an electronic fuse."
ITEM.model = "models/wick/weapons/l4d1/w_pipebomb.mdl"
ITEM.category = "Weapons"
ITEM.class = "ix_pipebomb"

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon(item.class) ) then
            ply:Give(item.class)
            ply:SelectWeapon(item.class)
        else
            ply:ChatPrint("You already have a "..item.name.."!")

            return false
        end
    end
}