local VENDOR = {}

VENDOR.UniqueID = "cpreq"
VENDOR.Name = "Requisition Supply Officer"
VENDOR.Desc = "Can supply Civil Protection officers with equipment."

VENDOR.Model = "models/minerva/metrocop.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = true

local function HasItem(ply, item)
    return ply:GetCharacter():GetInventory():HasItem(item)
end

VENDOR.Sell = {
    ["camerarepairkit"] = {
        Desc = "Technician only",
        Restricted = true,
        Max = 6,
        CanBuy = function(ply)
            return ply:GetTeamClass() == CLASS_CP_TECHNICIAN
        end,
    },
    ["healthvial"] = {
        Desc = "i2+ only",
        Restricted = true,
        Max = 1,
        Cooldown = 300,
        CanBuy = function(ply)
            return ply:GetTeamRank() >= RANK_CP_I2
        end,
    },
    ["ziptie"] = {
        Restricted = true,
        Max = 6,
    },
    ["ammo_pistol"] = {
        Desc = "i4+ only",
        Restricted = true,
        Max = 3,
        CanBuy = function(ply)
            return ply:GetTeamRank() >= RANK_CP_I4 and HasItem(ply, "wep_usp")
        end,
    },
    ["ammo_smg"] = {
        Desc = "i1+ only",
        Restricted = true,
        Max = 4,
        CanBuy = function(ply)
            return ply:GetTeamRank() >= RANK_CP_I1 and HasItem(ply, "wep_mp7")
        end,
    },
    ["ammo_357"] = {
        Desc = "SqL+ only",
        Restricted = true,
        Max = 3,
        CanBuy = function(ply)
            return ply:GetTeamRank() >= RANK_CP_SQL and HasItem(ply, "wep_357")
        end,
    },
    ["ammo_buckshot"] = {
        Desc = "SqL+ & Technician only",
        Restricted = true,
        Max = 3,
        CanBuy = function(ply)
            return ( ply:GetTeamRank() >= RANK_CP_SQL and HasItem(ply, "wep_spas12") ) or ( ply:GetTeamClass() >= CLASS_CP_TECHNICIAN and HasItem(ply, "wep_spas12") )
        end,
    },
    ["wep_357"] = {
        Desc = "SqL+ only",
        Restricted = true,
        Max = 1,
        CanBuy = function(ply)
            return ply:GetTeamRank() >= RANK_CP_SQL
        end,
    },
    ["wep_spas12"] = {
        Desc = "DvL+ only",
        Restricted = true,
        Max = 1,
        CanBuy = function(ply)
            return ply:GetTeamRank() >= RANK_CP_DVL
        end,
    },
}

VENDOR.Buy = {}

function VENDOR:CanUse(ply)
    return ply:IsCP()
end

function VENDOR:OnItemPurchased(class, ply)
    if ( class == "wep_357" and HasItem(ply, "wep_usp") ) then
        HasItem(ply, "wep_usp"):Remove()
    end
    
    if ( class == "wep_spas12" and HasItem(ply, "wep_mp7") ) then
        HasItem(ply, "wep_mp7"):Remove()
    end
end

ix.vendor.RegisterVendor(VENDOR)
