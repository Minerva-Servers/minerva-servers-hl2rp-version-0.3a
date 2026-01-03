local PLUGIN = PLUGIN

local function isEmpty(vector, ignore) -- findpos and isempty are from darkrp
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

    return a and b
end

if not ( ix.spawner.config[game.GetMap()] ) then
    return
end

for k, v in pairs(ix.spawner.config[game.GetMap()]) do
    ix.spawner.active[k] = {}

    if ( timer.Exists("ixSpawner."..k) ) then
        timer.Remove("ixSpawner."..k)
    end
    
    timer.Create("ixSpawner."..k, v.delay, 0, function()
        local randomSpawn = table.Random(v.spawns)
        if not ( isEmpty(randomSpawn.pos) ) then
            return
        end

        if ( #ents.FindByClass(k) >= v.max ) then
            return
        end

        local entity = ents.Create(k)
        entity:SetPos(randomSpawn.pos)
        entity:SetAngles(randomSpawn.ang)
        entity:Spawn()
        entity.spawnerCreated = true

        print(tostring(entity).." spawned")
    end)
end