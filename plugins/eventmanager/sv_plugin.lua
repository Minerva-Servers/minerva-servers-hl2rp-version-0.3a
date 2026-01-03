local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawnedNPC(ply, npc)
    npc:SetSpawnEffect(false)
    npc:SetKeyValue("spawnflags", npc:GetSpawnFlags() + SF_NPC_NO_WEAPON_DROP)
end

function MakeHeadcrabCanister(  model, pos, ang, keyFire, keyOpen, keySpawn, fire_immediately, headcrab, count, speed, time, height, damage, radius, duration, spawnflags, smoke )
    if ( tobool( smoke ) ) then duration = -1 end

    fire_immediately = fire_immediately or false
    headcrab = headcrab or 0
    count = count or 6
    speed = speed or 3000
    time = time or 5
    height = height or 0
    damage = damage or 150
    radius = radius or 750
    duration = duration or 30
    spawnflags = spawnflags or 0

    keyOpen = keyOpen or -1
    keyFire = keyFire or -1
    keySpawn = keySpawn or -1

    headcrab = math.Clamp( headcrab, 0, 2 )
    count = math.Clamp( count, 0, 10 )
    time = math.Clamp( time, 0, 30 )
    height = math.Clamp( height, 0, 10240 )
    damage = math.Clamp( damage, 0, 256 )
    radius = math.Clamp( radius, 0, 1024 )
    duration = math.Clamp( duration, 0, 90 )

    local env_headcrabcanister = ents.Create( "env_headcrabcanister" )
    if ( !IsValid( env_headcrabcanister ) ) then return false end
    env_headcrabcanister:SetPos( pos )
    env_headcrabcanister:SetAngles( ang )
    env_headcrabcanister:SetKeyValue( "HeadcrabType", headcrab )
    env_headcrabcanister:SetKeyValue( "HeadcrabCount", count )
    env_headcrabcanister:SetKeyValue( "FlightSpeed", speed )
    env_headcrabcanister:SetKeyValue( "FlightTime", time )
    env_headcrabcanister:SetKeyValue( "StartingHeight", height )
    env_headcrabcanister:SetKeyValue( "Damage", damage )
    env_headcrabcanister:SetKeyValue( "DamageRadius", radius )
    env_headcrabcanister:SetKeyValue( "SmokeLifetime", duration )
    env_headcrabcanister:SetKeyValue( "spawnflags", spawnflags )
    env_headcrabcanister:Spawn()
    env_headcrabcanister:Activate()

    if ( tobool( fire_immediately ) ) then env_headcrabcanister:Fire( "FireCanister" ) end

    table.Merge( env_headcrabcanister:GetTable(), {
        keyFire = keyFire,
        keyOpen = keyOpen,
        keySpawn = keySpawn,
        fire_immediately = fire_immediately,
        headcrab = headcrab,
        count = count,
        speed = speed,
        time = time,
        height = height,
        damage = damage,
        radius = radius,
        duration = duration,
        spawnflags = spawnflags,
        smoke = smoke
    } )

    return env_headcrabcanister
end

local function UpdateEventAdmins(eventid)
    for v,k in pairs(player.GetAll()) do
        if k:IsEventAdmin() then
            net.Start("ixOpsEMUpdateEvent")
            net.WriteUInt(eventid, 10)
            net.Send(k)
        end
    end
end

local eventTimerNames = {}
local sequenceTime = 0

local function queueEvent(sequence, eventid)
    local event = ix.ops.eventManager.sequences[sequence][eventid]
    local timerName = "ixOpsEM-"..eventid
    local time = sequenceTime + (event.Delay or 0)
    local x = table.insert(eventTimerNames, timerName)

    timer.Create(timerName, time, 1, function()
        ix.ops.eventManager.PlayEvent(sequence, eventid)
        eventTimerNames[x] = nil
    end)

    sequenceTime = time
end

function ix.ops.eventManager.MakeBigExplosion(magnitude, debris)
    if ( debris ) then
        local debris = {}

        for i = 1, 9 do
            local flyer = ents.Create("prop_physics")
            flyer:SetPos(self:GetPos() + flyer:GetAngles():Up() * 3)

            if ( i > 4 ) then
                flyer:SetModel("models/props_debris/wood_chunk08b.mdl")
            else
                flyer:SetModel("models/combine_helicopter/bomb_debris_"..math.random(2, 3)..".mdl")
            end

            flyer:SetCollisionGroup(COLLISION_GROUP_WORLD)
            flyer:Spawn()
            flyer:Ignite(30)

            local phys = flyer:GetPhysicsObject()

            if ( phys ) and ( IsValid(phys) ) then
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
    end

    local explodeEnt = ents.Create("env_explosion")
    explodeEnt:SetPos(self:GetPos())

    if IsValid(self.placer) then
        explodeEnt:SetOwner(self.placer)
    end 

    explodeEnt:Spawn()
    explodeEnt:SetKeyValue("iMagnitude", tostring(magnitude))
    explodeEnt:Fire("explode", "", 0)

    local fire = ents.Create("env_fire")
    fire:SetPos(self:GetPos())
    fire:Spawn()
    fire:Fire("StartFire")

    timer.Simple(60, function()
        if ( IsValid(fire) ) then
            fire:Remove()
        end
    end)

    local effectData = EffectData()
    effectData:SetOrigin(self:GetPos())
    util.Effect("Explosion", effectData)

    self:EmitSound("weapons/c4/c4_explode1.wav", 500)
    self:EmitSound("weapons/c4/c4_exp_deb1.wav", 125)
    self:EmitSound("weapons/c4/c4_exp_deb2.wav", 125)
    self:EmitSound("ambient/atmosphere/terrain_rumble1.wav", 108)

    for k, v in pairs(player.GetAll()) do
        v:SurfacePlaySound("ambient/levels/streetwar/city_battle7.wav")
    end

    util.ScreenShake(self:GetPos(), 4, 2, 2.5, 100000)
    
    self:Remove()

    local pos = self:GetPos()

    timer.Simple(1, function()
        for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
            if ( v:GetPos():DistToSqr(pos) < (1200 ^ 2) ) then
                v:Ignite(40)
            end
        end
    end)
end

function ix.ops.eventManager.PlaySequence(name)
    local sequence = ix.ops.eventManager.sequences[name]

    eventTimerNames = {}
    sequenceTime = 0

    ix.ops.eventManager.SetSequence(name)

    for v,k in pairs(sequence) do
        queueEvent(name, v)
    end
end

function ix.ops.eventManager.StopSequence()
    for v,k in pairs(eventTimerNames) do
        if k and timer.Exists(k) and not (timer.TimeLeft(k) and timer.TimeLeft(k) <= 0) then
            timer.Remove(k)
        end
    end

    ix.ops.eventManager.SetSequence("")
end

function ix.ops.eventManager.PlayEvent(sequence, eventid)
    local count = table.Count(ix.ops.eventManager.sequences[sequence])
    local event = ix.ops.eventManager.sequences[sequence][eventid]

    if not ix.ops.eventManager.config.Events[event.Type] then
        return ix.ops.eventManager.StopSequence()
    end

    UpdateEventAdmins(eventid)

    if ix.ops.eventManager.config.Events[event.Type].Clientside then
        net.Start("ixOpsEMClientsideEvent")
        net.WriteString(event.Type)
        net.WriteString(event.UID or "")
        local data = pon.encode(event.Prop)
        net.WriteUInt(#data, 16)
        net.WriteData(data, #data)
        net.Broadcast()
    else
        ix.ops.eventManager.config.Events[event.Type].Do(event.Prop or {}, event.UID or nil)
    end

    if eventid >= count then
        ix.ops.eventManager.StopSequence()
    end
end

function ix.ops.eventManager.cinematicIntro(message)
    net.Start("ixCinematicMessage")
    net.WriteString(message)
    net.Broadcast()
end

concommand.Add("ix_cinematicmessage", function(ply, cmd, args)
    if not ( ply:IsSuperAdmin() ) then
        return
    end
    
    ix.ops.eventManager.cinematicIntro(args[1] or "")
end)

util.AddNetworkString("ixCinematicMessage")
util.AddNetworkString("ixOpsEMMenu")
util.AddNetworkString("ixOpsEMPushSequence")
util.AddNetworkString("ixOpsEMUpdateEvent")
util.AddNetworkString("ixOpsEMPlaySequence")
util.AddNetworkString("ixOpsEMStopSequence")
util.AddNetworkString("ixOpsEMClientsideEvent")
util.AddNetworkString("ixOpsEMIntroCookie")
util.AddNetworkString("ixOpsEMPlayScene")
util.AddNetworkString("ixOpsEMEntAnim")

net.Receive("ixOpsEMPushSequence", function(len, ply)
    if (ply.nextOpsEMPush or 0) > CurTime() then return end
    ply.nextOpsEMPush = CurTime() + 1

    if not ply:IsEventAdmin() then
        return
    end

    local seqName = net.ReadString()
    local seqEventCount = net.ReadUInt(16)
    local events = {}

    ix.log.AddRaw("Starting pull of "..seqName.." (by "..ply:SteamName().."). Total events: "..seqEventCount.."")

    for i=1, seqEventCount do
        local dataSize = net.ReadUInt(16)
        local eventData = pon.decode(net.ReadData(dataSize))

        table.insert(events, eventData)
        ix.log.AddRaw("Got event "..i.."/"..seqEventCount.." ("..eventData.Type..")")
    end

    ix.ops.eventManager.sequences[seqName] = events

    ix.log.AddRaw("Finished pull of "..seqName..". Ready to play sequence!")

    if IsValid(ply) then
        ply:Notify("Push completed.")
    end
end)

net.Receive("ixOpsEMPlaySequence", function(len, ply)
    if (ply.nextOpsEMPlay or 0) > CurTime() then return end
    ply.nextOpsEMPlay = CurTime() + 1

    if not ply:IsEventAdmin() then
        return
    end

    local seqName = net.ReadString()

    if not ix.ops.eventManager.sequences[seqName] then
        return ply:Notify("Sequence does not exist on server (push first).")
    end

    if ix.ops.eventManager.GetSequence() == seqName then
        return ply:Notify("Sequence already playing.")
    end

    ix.ops.eventManager.PlaySequence(seqName)

    ix.log.AddRaw("Playing sequence "..seqName.." (by "..ply:SteamName()..").")
    ply:Notify("Playing sequence "..seqName..".")
end)

net.Receive("ixOpsEMStopSequence", function(len, ply)
    if (ply.nextOpsEMStop or 0) > CurTime() then return end
    ply.nextOpsEMStop = CurTime() + 1

    if not ply:IsEventAdmin() then
        return
    end

    local seqName = net.ReadString()

    if not ix.ops.eventManager.sequences[seqName] then
        return ply:Notify("Sequence does not exist on server (push first).")
    end

    if ix.ops.eventManager.GetSequence() != seqName then
        return ply:Notify("Sequence not playing.")
    end

    ix.ops.eventManager.StopSequence(seqName)

    ix.log.AddRaw("Stopping sequence "..seqName.." (by "..ply:SteamName()..").")
    ply:Notify("Stopped sequence "..seqName..".")
end)

net.Receive("ixOpsEMIntroCookie", function(len, ply)
    if ply.usedIntroCookie or not ix.ops.eventManager.GetEventMode() then
        return
    end
    
    ply.usedIntroCookie = true

    ply:AllowScenePVSControl(true)

    timer.Simple(900, function()
        if IsValid(ply) then
            ply:AllowScenePVSControl(false)
        end
    end)
end)