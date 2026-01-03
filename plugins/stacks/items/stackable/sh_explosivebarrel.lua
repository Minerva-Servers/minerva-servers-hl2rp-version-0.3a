ITEM.name = "Explosive Barrel"
ITEM.description = "A barrel filled with explosives and gasoline, if shot enough it will ignite and explode."
ITEM.category = "Stackables"
ITEM.model = "models/props_c17/oildrum001_explosive.mdl"
ITEM.illegal = true
ITEM.width = 2
ITEM.height = 3

ITEM.maxStacks = 3

ITEM:Hook("drop", function(itemTable)
    local ply = itemTable.player

    ply:ForceSequence("dropitem")
end)

ITEM.OnEntityTakeDamage = function(item, dmginfo)
    local barrel = item:GetEntity()

    if ( barrel.exploded ) then
        return
    end

    barrel.exploded = true
    
    for l = 1, item:GetData("stacks", 1) do
        local debris = {}
        
        for i = 1, 5 do
            local flyer = ents.Create("prop_physics")
            flyer:SetPos(barrel:GetPos() + flyer:GetAngles():Up() * 3)

            flyer:SetModel(table.Random({
                "models/props_c17/oildrumchunk01a.mdl",
                "models/props_c17/oildrumchunk01b.mdl",
                "models/props_c17/oildrumchunk01c.mdl",
                "models/props_c17/oildrumchunk01d.mdl",
                "models/props_c17/oildrumchunk01e.mdl",
            }))

            flyer:SetCollisionGroup(COLLISION_GROUP_WORLD)
            flyer:Spawn()
            flyer:Ignite(30)

            local phys = flyer:GetPhysicsObject()

            if ( phys and IsValid(phys) ) then
                phys:SetVelocity(Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150)))
            end

            table.insert(debris, flyer)
        end

        timer.Simple(40, function()
            for k, v in pairs(debris) do
                if ( IsValid(v) ) then
                    v:Remove()
                end
            end
        end)

        local explodeEnt = ents.Create("env_explosion")
        explodeEnt:SetPos(barrel:GetPos())
        explodeEnt:Spawn()
        explodeEnt:SetKeyValue("iMagnitude", "260")
        explodeEnt:SetKeyValue("iRadiusOverride", "384")
        explodeEnt:Fire("explode", "", 0)

        local fire = ents.Create("env_fire")
        fire:SetPos(barrel:GetPos())
        fire:Spawn()
        fire:Fire("StartFire")

        timer.Simple(60, function()
            if ( IsValid(fire) ) then
                fire:Remove()
            end
        end)

        local effectData = EffectData()
        effectData:SetOrigin(barrel:GetPos())
        util.Effect("Explosion", effectData)

        util.ScreenShake(barrel:GetPos(), 4, 2, 2.5, 1000)
    end
end