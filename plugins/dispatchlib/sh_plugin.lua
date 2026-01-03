local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Dispatch Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.config.Add("passiveDispatch", true, "Whether or not passive dispatch should be globally enabled.", nil, {
    category = PLUGIN.name,
})

ix.dispatch = ix.dispatch or {}
ix.dispatch.last = ix.dispatch.last or {}
ix.dispatch.config = {
    ["dispatchCooldown"] = math.random(300, 600),
    ["dispatchLines"] = {
        {
            message = "Citizen reminder: Inaction is conspiracy. Report counter-behavior to a Civil-Protection team immediately.",
            soundFile = "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav",
        },
        {
            message = "Citizen notice: Failure to co-operate will result in permanent off-world relocation.",
            soundFile = "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav",
        },
        {
            message = "Attention, ground-units: Anti-citizen reported in this community. Code: Lock, Cauterize, Stabilize.",
            soundFile = "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav",
        },
        {
            message = "Protection team alert: Evidence of anti-civil activity in this community. Code: Assemble, Clamp, Contain.",
            soundFile = "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav",
        },
    },
}

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
