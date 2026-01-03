ITEM.name = "Unshackling Kit"
ITEM.description = "This kit can be used to unshackle Enslaved Vortigaunts."
ITEM.model = "models/props_c17/BriefCase001a.mdl"
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
            if ( !itemTable.bBeingUsed and !target:IsFreedVort() ) then
                itemTable.bBeingUsed = true

                ply:SetAction("Freeing Shackles...", 3)
                ply:EmitSound("npc/vort/claw_swing2.wav")

                ply:DoStaredAction(target, function()
                    target:FreeVort()

                    ply:Notify("You have unshackled this Vortigaunt.")
                    target:Notify("You have been unshackled by someone.")
                    ply:EmitSound("npc/vort/claw_swing1.wav")

                    itemTable.bBeingUsed = false
                    itemTable:Remove()
                end, 3, function()
                    ply:SetAction()

                    target:SetAction()

                    itemTable.bBeingUsed = false
                end)

                target:SetAction("You are being freed.", 3)
            else
                ply:Notify("Target already freed.")
            end
        else
            ply:NotifyLocalized("plyNotValid")
        end

        return false
    end,
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() and target:GetCharacter() and target:IsFreedVort() ) then
            return false
        end

        if ( itemTable.bBeingUsed ) then
            return false
        end

        return true
    end
}

function ITEM:CanTransfer(inventory, newInventory)
    return !self.bBeingUsed
end