ITEM.name = "Corpse Bag"
ITEM.description = "A bag which can be used to dispose bodies."
ITEM.model = "models/garbage_bag_1/garbage_bag_1.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Use = {
    name = "Dispose",
    icon = "icon16/box.png",
    OnRun = function(item)
        local whitelistedRagdolls = {}
        local ply = item.player
        local char = ply:GetCharacter()

        local trace = ply:GetEyeTrace()
        if ( IsValid(trace.Entity) and trace.Entity:GetClass() == "prop_ragdoll" and trace.HitPos:Distance(ply:GetShootPos()) <= 96 ) then
            local hitEnt = trace.Entity

            // If the ragdoll was made using charfallover then
            // ixPlayer will be set to the player but in persistent_corpses
            // the reference to this is removed so we can just check from there.
            if ( hitEnt and hitEnt.ixPlayer and IsValid( hitEnt.ixPlayer ) ) then
                ply:Notify( "You cannot dispose of a living corpse" )
                return false
            end

            hitEnt:EmitSound("minerva/global/ammopack.mp3", 70)
            ply:SetAction("Disposing Body...", 3)
            ply:DoStaredAction(hitEnt, function()
                hitEnt:EmitSound("minerva/global/clothingequip.mp3", 70)
                hitEnt:StopSound("minerva/global/ammopack.mp3")
                hitEnt:Remove()
                item:Remove()
                if not ( char:GetInventory():Add("filledcorpsebag") ) then
                    ix.item.Spawn("filledcorpsebag", hitEnt:GetPos())
                end
            end, 3, function()
                hitEnt:StopSound("minerva/global/ammopack.mp3")
                ply:SetAction()
            end)
        else
            ply:Notify("You are not aiming close enough to a body!")
        end

        return false
    end,
}