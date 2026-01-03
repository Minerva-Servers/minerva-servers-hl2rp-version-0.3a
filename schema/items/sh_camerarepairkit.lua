ITEM.name = "Camera Repair Kit"
ITEM.description =  "This kit contains replacement parts and tools to repair damaged surveillance cameras."
ITEM.category = "Tools"
ITEM.model = Model("models/combine_turrets/floor_turret_gib1.mdl")

ITEM.functions.use = {
    name = "Use",
    OnRun = function(item)
        local ply = item.player

        local pos = ply:GetPos()

        for v,k in pairs(ents.FindByClass("npc_combine_camera")) do
            if not ix.plugin.list["combinelib"]:IsCameraEnabled(k) and k:GetPos():DistToSqr(pos) < (500 ^ 2) then
                ply:EmitSound("ambient/energy/weld2.wav")
                ply:Notify("You have repaired a broken camera.")

                k:RepairCombineCamera()
                return true
            end
        end

        ply:Notify("No broken cameras found nearby.")
        return false
    end
}