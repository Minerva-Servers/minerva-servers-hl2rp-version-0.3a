ITEM.name = "Grenade"
ITEM.description = "A small, green colored MK3A2 grenade that explodes a few seconds after it is thrown."
ITEM.model = "models/weapons/w_grenade.mdl"
ITEM.category = "Weapons"
ITEM.class = "ix_grenade"

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