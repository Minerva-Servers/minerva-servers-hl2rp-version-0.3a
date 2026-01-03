local VENDOR = {}

VENDOR.UniqueID = "medical"
VENDOR.Name = "Infestation Control Supplier"
VENDOR.Desc = "Can sell infestation control supplies to the Infestation Control Team."

VENDOR.Model = "models/hl2rp/male_08.mdl"
VENDOR.Skin = 2
VENDOR.Bodygroups = {
    ["Torso"] = 14,
    ["Legs"] = 2,
    ["Glasses"] = 1,
    ["Badge"] = 1,
}
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
    ["corpsebag"] = {
        Cost = 10,
    },
}

VENDOR.Buy = {
    ["filledcorpsebag"] = {
        Cost = 40,
    },
}

function VENDOR:CanUse(ply)
    return ( ply:Team() == FACTION_CWU and ply:GetTeamClass() == CLASS_CWU_ICT )
end

ix.vendor.RegisterVendor(VENDOR)