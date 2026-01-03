ITEM.name = "Medical Base"
ITEM.description = "A Base for Medical Items."
ITEM.category = "Medical Items"
ITEM.model = "models/items/healthkit.mdl"

ITEM.width = 1
ITEM.height = 1

ITEM.healSound = "items/smallmedkit1.wav"
ITEM.healAmount = 50
ITEM.healTime = 3
ITEM.bFreeze = true

ITEM.functions.Apply = {
    name = "Heal Yourself",
    icon = "icon16/heart.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() and ply:Health() < ply:GetMaxHealth() ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player

        local function healFunc(ply)
            if ( istable(itemTable.healAmount) ) then
                ply:SetHealth(math.min(ply:Health() + table.Random(itemTable.healAmount), ply:GetMaxHealth()))
            else
                ply:SetHealth(math.min(ply:Health() + itemTable.healAmount, ply:GetMaxHealth()))
            end

            ply:EmitSound(itemTable.healSound)
            ply:Notify("You applied a "..itemTable.name.." on yourself and you have gained health.")

            if ( itemTable.bFreeze ) then
                ply:Freeze(false)
            end

            itemTable:Remove()
        end

        if ( itemTable.bFreeze ) then
            ply:Freeze(true)
        end

        if ( itemTable.healTime and itemTable.healTime >= 0 ) then
            ply:SetAction("Healing...", itemTable.healTime, function()
                healFunc(ply)
            end)
        else
            healFunc(ply)
        end

        return false
    end
}

ITEM.functions.ApplyTarget = {
    name = "Heal Target",
    icon = "icon16/heart_add.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( target:IsValid() and target:IsPlayer() and ( target:Health() < target:GetMaxHealth() ) ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            local function healFunc(ply, target)
                if ( istable(itemTable.healAmount) ) then
                    target:SetHealth(math.min(target:Health() + table.Random(itemTable.healAmount), target:GetMaxHealth()))
                else
                    target:SetHealth(math.min(target:Health() + itemTable.healAmount, target:GetMaxHealth()))
                end

                target:EmitSound(itemTable.healSound)
                target:Notify(ply:Nick().." applied a "..itemTable.name.." on you and you have gained health.")
                ply:Notify("You applied a "..itemTable.name.." on "..target:Nick().." and they have gained health.")

                if ( itemTable.bFreeze ) then
                    ply:Freeze(false)
                    target:Freeze(false)
                end

                itemTable:Remove()
            end

            if ( itemTable.bFreeze ) then
                ply:Freeze(true)
                target:Freeze(true)
            end

            if ( itemTable.healTime and itemTable.healTime >= 0 ) then
                ply:SetAction("Healing...", itemTable.healTime)
                ply:DoStaredAction(target, function()
                    healFunc(ply, target)
                end, itemTable.healTime, function()
                    ply:SetAction()
                end)
            else
                healFunc(ply, target)
            end

            return false
        end

        return false
    end
}