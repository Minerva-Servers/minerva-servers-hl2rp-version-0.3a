local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Necrotic Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.anim.playerZombie = {
    normal = {
        [ACT_MP_STAND_IDLE] = {ACT_HL2MP_IDLE_ZOMBIE, ACT_HL2MP_IDLE_ZOMBIE},
        [ACT_MP_CROUCH_IDLE] = {ACT_HL2MP_IDLE_CROUCH_ZOMBIE, ACT_HL2MP_IDLE_CROUCH_ZOMBIE},
        [ACT_MP_WALK] = {ACT_HL2MP_WALK_ZOMBIE_01, ACT_HL2MP_WALK_ZOMBIE_01},
        [ACT_MP_CROUCHWALK] = {ACT_HL2MP_WALK_CROUCH_ZOMBIE_01, ACT_HL2MP_WALK_CROUCH_ZOMBIE_01},
        [ACT_MP_RUN] = {ACT_HL2MP_RUN_ZOMBIE, ACT_HL2MP_RUN_ZOMBIE},
        [ACT_LAND] = {ACT_RESET, ACT_RESET},
        attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
    },
    glide = ACT_ZOMBIE_LEAP_START,
}

ix.anim.zombine = {
    normal = {
        [ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
        [ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
        [ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
        [ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
        [ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
        [ACT_LAND] = {ACT_RESET, ACT_RESET},
        attack = ACT_MELEE_ATTACK1,
    },
    glide = "leap_loop",
}

ix.anim.fastZombie = {
    normal = {
        [ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
        [ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
        [ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
        [ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
        [ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
        [ACT_LAND] = {ACT_RESET, ACT_RESET},
        attack = ACT_MELEE_ATTACK1,
    },
    glide = "leap_loop",
}

ix.anim.SetModelClass("models/player/zombie_classic.mdl", "playerZombie")
ix.anim.SetModelClass("models/zombie/zombie_soldier.mdl", "zombine")
ix.anim.SetModelClass("models/zombie/fast.mdl", "fastZombie")

ALWAYS_RAISED["ix_fastzombie_claws"] = true
ALWAYS_RAISED["ix_zombie_claws"] = true

local PLAYER = FindMetaTable("Player")

function PLAYER:IsNecrotic()
    return self:Team() == FACTION_NECROTIC
end

ix.command.Add("BustDoor", {
    OnCheckAccess = function(self, ply)
        return ply:IsNecrotic()
    end,
    OnRun = function(self, ply)
        local ent = ply:GetEyeTrace().Entity

        if ( ( ply.nextKickdoor or 0 ) > CurTime() ) then return end

        if ( ent:GetClass() == "func_door" ) then
            return ply:Notify("You cannot kick down these type of doors!")
        end

        if not ( IsValid(ent) and ent:IsDoor() ) or ent:GetNetVar("disabled") then
            return ply:Notify("You are not looking at a door!")
        end

        if not ( ply:GetPos():Distance(ent:GetPos()) < 100 ) then
            return ply:Notify("You are not close enough!")
        end

        if ( IsValid(ent.ixLock) ) then
            ply:Notify("You cannot kick down a combine lock!")
            return false
        end
        
        if ( IsValid(ent) ) then 
            local Door = ents.Create("prop_physics")
            Door:SetAngles(ent:GetAngles())
            Door:SetPos(ent:GetPos() + ent:GetUp() + ply:GetForward() * 32)
            Door:SetModel(ent:GetModel())
            Door:SetSkin(ent:GetSkin())
            Door:SetCollisionGroup(COLLISION_GROUP_WORLD)
            Door:SetRenderMode(RENDERMODE_TRANSALPHA)
            Door:Spawn()
            Door:EmitSound("physics/wood/wood_crate_break"..math.random(1, 4)..".wav", 80, 50, 1)
            Door:GetPhysicsObject():ApplyForceCenter(ply:GetForward() * 20000)
            ent.canbeshot = false
            ent:SetPos(ent:GetPos() + Vector(0, 0, -1000))
            ent:Fire("unlock")
            ent:Fire("open")
            timer.Simple(ix.config.Get("Respawn Timer", 180), function()
                ent:SetCollisionGroup(0)
                ent:SetRenderMode(0)
                ent.bHindge2 = false
                ent.bHindge1 = false
                ent:SetPos(ent:GetPos() - Vector(0, 0, -1000))
                if ( IsValid(Door) ) then
                    Door:Remove()
                    ent.canbeshot = true
                end
            end)
        end

        ply.nextKickdoor = CurTime() + 2
    end,
})

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
    function PLUGIN:RenderScreenspaceEffects()
        local colorModify = {}

        if ( LocalPlayer():IsNecrotic() ) then
            colorModify["$pp_colour_addr"] = 0.02
            colorModify["$pp_colour_mulr"] = 0.5
            colorModify["$pp_colour_mulg"] = 0.1
            colorModify["$pp_colour_mulb"] = 0.1
            colorModify["$pp_colour_colour"] = 0.3
            colorModify["$pp_colour_brightness"] = -0.05
            colorModify["$pp_colour_contrast"] = 1.2
        else
            colorModify["$pp_colour_addr"] = 0
            colorModify["$pp_colour_mulr"] = 0
            colorModify["$pp_colour_mulg"] = 0
            colorModify["$pp_colour_mulb"] = 0
            colorModify["$pp_colour_colour"] = 1
            colorModify["$pp_colour_brightness"] = 0
            colorModify["$pp_colour_contrast"] = 1
        end
        
        DrawColorModify(colorModify)
    end
end
