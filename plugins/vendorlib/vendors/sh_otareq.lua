local VENDOR = {}

VENDOR.UniqueID = "otareq"
VENDOR.Name = "Overwatch Requisition Supply Officer"
VENDOR.Desc = "Can supply Overwatch units with equipment."

VENDOR.Model = "models/minerva/combine_soldier.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = true

local function HasItem(ply, item)
    return ply:GetCharacter():GetInventory():HasItem(item)
end

VENDOR.Sell = {
    ["healthkit"] = {
        Restricted = true,
        Max = 1,
        Cooldown = 300,
    },
    ["healthvial"] = {
        Restricted = true,
        Max = 1,
    },
    ["ziptie"] = {
        Restricted = true,
        Max = 4,
    },
    ["ammo_smg"] = {
        Desc = ix.item.Get("wep_mp7").name.." Required!",
        Restricted = true,
        Max = 6,
        CanBuy = function(ply)
            return HasItem(ply, "wep_mp7")
        end,
    },
    ["ammo_buckshot"] = {
        Desc = ix.item.Get("wep_spas12").name.." Required!",
        Restricted = true,
        Max = 3,
        CanBuy = function(ply)
            return HasItem(ply, "wep_spas12")
        end,
    },
    ["ammo_pulse"] = {
        Desc = ix.item.Get("wep_ar2").name.." Required!",
        Restricted = true,
        Max = 6,
        CanBuy = function(ply)
            return HasItem(ply, "wep_spas12")
        end,
    },
    ["box_smg"] = {
        Desc = "Supplier only",
        Max = 2,
        CanBuy = function(ply)
            return ( ply:GetTeamClass() == CLASS_OW_SUPPLIER )
        end,
    },
    ["box_buckshot"] = {
        Desc = "Supplier only",
        Max = 2,
        CanBuy = function(ply)
            return ( ply:GetTeamClass() == CLASS_OW_SUPPLIER )
        end,
    },
    ["box_pulse"] = {
        Desc = "Supplier only",
        Max = 2,
        CanBuy = function(ply)
            return ( ply:GetTeamClass() == CLASS_OW_SUPPLIER )
        end,
    },
    ["wep_spas12"] = {
        Desc = "Super & Supplier only",
        Restricted = true,
        Max = 1,
        CanBuy = function(ply)
            return ply:GetTeamClass() == CLASS_OW_SUPPLIER or ply:GetTeamClass() == CLASS_OW_SUPER
        end,
    },
    ["wep_mp7"] = {
        Desc = "Supplier only",
        Restricted = true,
        Max = 1,
        CanBuy = function(ply)
            return ply:GetTeamClass() == CLASS_OW_SUPPLIER
        end,
    },
    ["wep_ar2"] = {
        Desc = "Super only",
        Restricted = true,
        Max = 1,
        CanBuy = function(ply)
            return ply:GetTeamClass() == CLASS_OW_SUPER
        end,
    },
    ["corpsebag"] = {
        Max = 6,
        CanBuy = function(ply)
            return ply:GetTeamClass() == CLASS_OW_INFESTATION
        end,
    },
}

VENDOR.Buy = {
    ["filledcorpsebag"] = {
        Cost = 40,
    },
}

function VENDOR:CanUse(ply)
    return ply:IsOW()
end

function VENDOR:OnItemPurchased(class, ply)
    if ( class == "wep_spas12" ) then
        if ( HasItem(ply, "wep_ar2") ) then
            HasItem(ply, "wep_ar2"):Remove()
        elseif ( HasItem(ply, "wep_mp7") ) then
            HasItem(ply, "wep_mp7"):Remove()
        end
    elseif ( class == "wep_mp7" and ply:GetTeamClass() == CLASS_OW_SUPPLIER ) then
        if ( HasItem(ply, "wep_spas12") ) then
            HasItem(ply, "wep_spas12"):Remove()
        end
    elseif ( class == "wep_ar2" and ply:GetTeamClass() == CLASS_OW_SUPER ) then
        if ( HasItem(ply, "wep_spas12") ) then
            HasItem(ply, "wep_spas12"):Remove()
        end
    end
end

function VENDOR:Initialize()
    self:Give("weapon_ar2")
end

ix.vendor.RegisterVendor(VENDOR)
