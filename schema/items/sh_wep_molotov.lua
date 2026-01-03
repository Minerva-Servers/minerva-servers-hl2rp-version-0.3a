ITEM.name = "Molotov"
ITEM.description = "A cloth fuse and glass bottle filled with a flammable substance. Probably best to not drink this."
ITEM.model = "models/props_junk/garbage_glassbottle003a.mdl"
ITEM.category = "Weapons"
ITEM.class = "ix_molotov"

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