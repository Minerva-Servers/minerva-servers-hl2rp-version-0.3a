ITEM.name = "Consumable Base"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.description = "A base for consumables."
ITEM.category = "Consumables"


ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav"
ITEM.useName = "Consume"

ITEM.restoreHunger = 0
ITEM.restoreHealth = 0
ITEM.damage = 0

ITEM.functions.Consume = {
    icon = "icon16/user.png",
    name = "Consume",
    OnRun = function(item)
        local ply = item.player
        local char = item.player:GetCharacter()
        local actiontext = "Eating..."

        if ( ply.isEatingConsumeable ) then
            ply:Notify("You can't stuff too much food in your mouth, bruh.")
            return false
        end

        if ( item.useSound and string.find(item.useSound, "drink") ) then
            actiontext = "Drinking..."
        end

        local function EatFunction(ply, char)
            if not ( IsValid(ply) and ply:Alive() and char ) then
                return
            end

            if ( item.damage > 0 ) then
                ply:TakeDamage(item.damage, ply, ply)
            end
    
            if ( item.junk ) then
                if not ( char:GetInventory():Add(item.junk) ) then
                    ix.item.Spawn(item.junk, ply)
                end
            end
    
            if ( item.useSound ) then
                ply:EmitSound(item.useSound)
            end
    
            if ( item.restoreHunger > 0 ) then
                char:SetHunger(math.Clamp(char:GetHunger() + item.restoreHunger, 0, 100))
            end

            if ( item.restoreHealth > 0 ) then
                ply:SetHealth(math.Clamp(ply:Health() + item.restoreHealth, 0, ply:GetMaxHealth()))
            end
        end

        if ( item.useTime ) then
            ply.isEatingConsumeable = true
            ply:SetAction(actiontext, item.useTime, function()
                EatFunction(ply, char)

                ply.isEatingConsumeable = nil
            end)
        else
            EatFunction(ply, char)
        end
    end
}