local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Hunter Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.hunter = ix.hunter or {}

local defaulhunteranims = {
	[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
	[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
	[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
	[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
	[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
	[ACT_LAND] = {ACT_RESET, ACT_RESET}
}

ix.anim.playerHunter = {
	normal = defaulhunteranims,
	pistol = defaulhunteranims,
	smg = defaulhunteranims,
	shotgun = defaulhunteranims,
	melee = defaulhunteranims,
	glide = ACT_GLIDE
}

ix.anim.SetModelClass("models/hunter.mdl", "playerHunter")

ALWAYS_RAISED["ix_hunter_swep"] = true
ALWAYS_RAISED["ix_hunter_melee"] = true

local PLAYER = FindMetaTable("Player")

function PLAYER:IsHunter()
    return self:Team() == FACTION_HUNTER
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
