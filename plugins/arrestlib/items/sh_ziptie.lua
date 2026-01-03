ITEM.name = "Ziptie"
ITEM.description = "Can be used to restrain the less cooperative members of society."
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.category = "Tools"

ITEM.functions.Use = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            if ( !target:GetNetVar("tying") and !target:IsArrested() ) then
                itemTable.bBeingUsed = true

                ply:SetAction("Restraining...", 0.6)
                ply:EmitSound("npc/vort/claw_swing2.wav")
				ix.chat.Send(ply, "me", "begins cuffing "..target:Nick()..".")

                ply:DoStaredAction(target, function()
                    target:Arrest()
                    target:SetNetVar("tying")

					ix.chat.Send(target, "me", "is now cuffed.")
                    ply:Notify("You have detained "..target:Nick()..".")
                    target:Notify("You have been detained by "..ply:Nick()..".")
            
                    hook.Run("PlayerArrested", target, ply)
                    
                    itemTable.bBeingUsed = false 
                    itemTable:Remove()
                end, 0.6, function()
                    ply:SetAction()

                    target:SetAction()
                    target:SetNetVar("tying")

                    itemTable.bBeingUsed = false
                end)

                target:SetNetVar("tying", true)
                target:SetAction("You are being tied up.", 0.6)
            else
                ply:Notify("Target already detained.")
            end
        else
            ply:NotifyLocalized("plyNotValid")
        end

        return false
    end,
    OnCanRun = function(itemTable)
        return !IsValid(itemTable.entity) or itemTable.bBeingUsed
    end
}

function ITEM:CanTransfer(inventory, newInventory)
    return !self.bBeingUsed
end