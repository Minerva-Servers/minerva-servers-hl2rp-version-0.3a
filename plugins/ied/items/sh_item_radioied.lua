local PLUGIN = PLUGIN

ITEM.name = "Radio Frequency IED"
ITEM.model = "models/weapons/w_c4_planted.mdl"
ITEM.description = "Can cause remotely triggered explosions."
ITEM.category = "Weapons"

ITEM.functions.Deploy = {
    icon = "icon16/wrench.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        local trace = ply:GetEyeTraceNoCursor()
        if ( trace.HitPos:Distance(ply:GetShootPos()) <= 192 ) then
            local deployable = ents.Create("ix_radioied")
            if ( itemTable.entity ) then
                deployable:SetAngles(Angle(0, itemTable.entity:EyeAngles().yaw + 360, 0))
            end
            deployable:SetPos(trace.HitPos)
            deployable:Spawn()

            local phys = deployable:GetPhysicsObject()
            if ( phys:IsValid() ) then
                phys:Wake()
                phys:EnableMotion(true)
            end

            deployable.placer = ply
            deployable.frequency = PLUGIN.frequencies[math.random(1, #PLUGIN.frequencies)]

            table.insert(PLUGIN.list, deployable)

            ply:ChatNotify("IED touch-off frequency is "..deployable.frequency..".")
        else
            ply:Notify("You cannot place a remote IED that far away!")
            return false
        end
    end
}