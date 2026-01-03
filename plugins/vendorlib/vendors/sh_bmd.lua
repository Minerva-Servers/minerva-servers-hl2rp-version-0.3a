local VENDOR = {}

VENDOR.UniqueID = "bmd"
VENDOR.Name = "Black Market Dealer"
VENDOR.Desc = "Can trade contraband items."

VENDOR.Model = "models/Humans/Group03/Male_04.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
    ["drafted"] = {
        Cost = 20,
    },
    ["gas"] = {
        Cost = 10,
    },
    ["gasoline"] = {
        Cost = 50,
    },
    ["kerosin"] = {
        Cost = 20,
    },
    ["leafbox"] = {
        Cost = 10,
    },
    ["plant_pot"] = {
        Cost = 25,
    },
    ["pot"] = {
        Cost = 30,
    },
    ["seed"] = {
        Cost = 5,
    },
    ["stove"] = {
        Cost = 50,
    },
    ["sulfuric_acid"] = {
        Cost = 40,
    },
    ["gunpowder"] = {
        Cost = 38,
        BuyMax = 7,
        TempCooldown = 100,
    },
    ["plastic"] = {
        Cost = 25,
        BuyMax = 8,
        TempCooldown = 60,
    },
    ["glue"] = {
        Cost = 20,
        BuyMax = 6,
        TempCooldown = 80,
    },
    ["bulletcasing"] = {
        Cost = 80,
    },
    ["wood"] = {
        Cost = 25,
        BuyMax = 10,
        TempCooldown = 100,
    },
    ["cloth"] = {
        Cost = 35,
        BuyMax = 30,
        TempCooldown = 150,
    },
    ["wep_357"] = {
        Cost = 8000,
        BuyMax = 2,
        TempCooldown = 2000,
    },
    ["ammo_357"] = {
        Cost = 550,
    },
    ["wep_mp7"] = {
        Cost = 1750,
        BuyMax = 5,
        TempCooldown = 1600,
    },
    ["ammo_smg"] = {
        Cost = 330,
    },
    ["wep_usp"] = {
        Cost = 1300,
        BuyMax = 8,
        TempCooldown = 1800,
    },
    ["ammo_pistol"] = {
        Cost = 350,
    },
    ["wep_spas12"] = {
        Cost = 2400,
        BuyMax = 5,
        TempCooldown = 2400,
    },
    ["ammo_buckshot"] = {
        Cost = 315,
    },
    ["wep_crowbar"] = {
        Cost = 120,
    },
    ["bandage"] = {
        Cost = 45,
    },
    ["healthkit"] = {
        Cost = 115,
    },
    ["healthvial"] = {
        Cost = 80,
    },
}

VENDOR.Buy = {
    ["wep_ar2"] = {
        Cost = 3500,
    },
    ["wep_stunstick"] = {
        Cost = 80,
    },
    ["cocaine"] = {
        Cost = ix.plugin.list["cocainelib"].Cocaine.Reward or 500,
    },
    ["util_fuel"] = {
        Cost = 300,
    },
}

function VENDOR:CanUse(ply)
    return not ( ply:IsCombine() )
end

function VENDOR:Initialize()
    self.Positions = ix.vendor.config[game.GetMap()].dealerLocations
    self.NextMove = CurTime() + 10
end

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

local function moveToNextPosition(ent)
    ent.NextMove = CurTime() + math.random(ix.vendor.config[game.GetMap()].dealerTeleportTimeMin, ix.vendor.config[game.GetMap()].dealerTeleportTimeMax)
    local newPosition = ent.Positions[math.random(#ent.Positions)]

    if newPosition.pos == ent:GetPos() then
        return moveToNextPosition(ent)
    end

    if isEmpty(newPosition.pos) then
        ent:SetPos(newPosition.pos)
        ent:SetAngles(newPosition.ang)
    else
        -- decreases chance of position being built on, however it is intentionally not perfect to stop players from making dupes to force the npc pos
        newPosition = ent.Positions[math.random(#ent.Positions)]
        ent:SetPos(newPosition.pos)
        ent:SetAngles(newPosition.ang)
    end

    ent:RemoveAllDecals()
end

function VENDOR:Think()
    if CurTime() > self.NextMove then
        moveToNextPosition(self)
    end

    self:NextThink(CurTime() + 8)
    return true
end

ix.vendor.RegisterVendor(VENDOR)