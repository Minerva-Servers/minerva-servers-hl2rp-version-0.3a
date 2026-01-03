-- Schema info

Schema.name = "Half-Life 2 Roleplay"
Schema.description = "A Server made by Minerva Servers, heavily inspired by Lite Network 2021."
Schema.author = "Minerva Servers"

Schema.currentVersion = "0.3"
Schema.currentBanner = "https://media.discordapp.net/attachments/1046109609284354109/1060939508163551323/image.png"
Schema.changelogs = {
    ["0.3"] = "Introducing New factions, weapons & base, UI improvements, fixes, features and other small updates. Relive Half-Life 2 Roleplay, but in City 8!",
    ["0.2"] = "Brand new features and systems have been introduced, also introducing a new UI overhaul.",
    ["0.1"] = "Complete remade schema from scratch.",
}

-- Schema includes

ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.IncludeDir("hooks")
ix.util.IncludeDir("meta")

ix.util.Include("sh_chat.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sh_config.lua")

ix.util.Include("maps/"..game.GetMap()..".lua", "shared")

-- Here is where all shared functions should go.

function Schema:ZeroNumber(number, length)
    local amount = math.max(0, length - string.len(number))
    return string.rep("0", amount)..tostring(number)
end

local ent = FindMetaTable("Entity")
function ent:IsInRoom(target)
    local tracedata = {}
    tracedata.start = self:GetPos()
    tracedata.endpos = target:GetPos()
    local trace = util.TraceLine(tracedata)

    return not trace.HitWorld
end

function Schema:IsInRoom(ent, target)
    local tracedata = {}
    tracedata.start = ent:GetPos()
    tracedata.endpos = target:GetPos()
    local trace = util.TraceLine(tracedata)

    return not trace.HitWorld
end

function Schema:InitPostEntity()
    local toolgun = weapons.GetStored("gmod_tool")

    if not ( istable(toolgun) ) then
        return
    end

    function toolgun:DoShootEffect(hitpos, hitnorm, ent, physbone, predicted)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)

        return false
    end
end

ix.char.RegisterVar("description", {
    bNoDisplay = true,
})