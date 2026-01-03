local PLUGIN = PLUGIN

ITEM.name = "Deployable Base"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.description = ""

ITEM.width = 1
ITEM.height = 1

ITEM.functions.Deploy = {
    icon = "icon16/wrench.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        local trace = ply:GetEyeTraceNoCursor()
        if ( trace.HitPos:Distance(ply:GetShootPos()) <= itemTable.deployableRange ) then
            local deployable = ents.Create(itemTable.deployableEntity)
            deployable:SetPos(trace.HitPos)
            deployable:Spawn()
            if ( deployable.SetCPPIOwner ) then
                deployable:SetCPPIOwner(ply)
            end

            local physicsObject = deployable:GetPhysicsObject()
            if ( IsValid(physicsObject) ) then
                physicsObject:Wake()
                physicsObject:EnableMotion(false)
                timer.Simple(0.1, function()
                    physicsObject:EnableMotion(true)
                end)
            end

            if ( IsValid(deployable) ) then
                deployable:SetAngles(Angle(0, ply:EyeAngles().yaw + 360, 0))
            end
        else
            ply:Notify("You cannot place stuff that far away!")
            return false
        end
    end
}