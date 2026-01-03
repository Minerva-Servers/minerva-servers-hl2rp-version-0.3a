local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Antlion Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.antlion = ix.antlion or {}

ix.antlion.config = {
    spawns = {
        ["rp_minerva_city17"] = {
            {
                pos = Vector(-3456.4392089844, -6084.2021484375, 24.03125),
                ang = Angle(5.2767214775085, 123.02408599854, 0),
            },
            {
                pos = Vector(-4573.1684570313, -8619.412109375, -3.0215034484863),
                ang = Angle(2.1879391670227, 112.12770080566, 0),
            },
            {
                pos = Vector(-7295.1962890625, -8334.6025390625, -114.88472747803),
                ang = Angle(4.0326404571533, 92.565231323242, 0),
            },
        }
    }
}

local defaulantlionanims = {
	[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
	[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
	[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
	[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
	[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
	[ACT_LAND] = {ACT_RESET, ACT_RESET}
}

ix.anim.playerAntlion = {
	normal = defaulantlionanims,
	pistol = defaulantlionanims,
	smg = defaulantlionanims,
	shotgun = defaulantlionanims,
	melee = defaulantlionanims,
	glide = ACT_GLIDE
}

ix.anim.SetModelClass("models/antlion.mdl", "playerAntlion")

ALWAYS_RAISED["ix_antlion_swep"] = true

local PLAYER = FindMetaTable("Player")

function PLAYER:IsAntlion()
    return self:Team() == FACTION_ANTLION
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
