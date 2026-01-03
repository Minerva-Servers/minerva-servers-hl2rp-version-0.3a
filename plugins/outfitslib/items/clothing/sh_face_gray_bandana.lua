ITEM.name = "Gray Bandana"
ITEM.description = "A gray bandana that wraps around the lower half of the head."
ITEM.category = "Clothing"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.outfitCategory = "Face"

ITEM.bodyGroups = {
    ["headstrap"] = 6
}

ITEM.allowedModels = {
    "models/hl2rp/male_01.mdl",
    "models/hl2rp/male_02.mdl",
    "models/hl2rp/male_03.mdl",
    "models/hl2rp/male_04.mdl",
    "models/hl2rp/male_05.mdl",
    "models/hl2rp/male_06.mdl",
    "models/hl2rp/male_07.mdl",
    "models/hl2rp/male_08.mdl",
    "models/hl2rp/male_09.mdl",
    "models/hl2rp/female_01.mdl",
    "models/hl2rp/female_02.mdl",
    "models/hl2rp/female_03.mdl",
    "models/hl2rp/female_04.mdl",
    "models/hl2rp/female_06.mdl",
    "models/hl2rp/female_07.mdl",
}

ITEM:Hook("Equip", function(item)
    local ply = item.player

    ix.chat.Send(ply, "me", "takes out a "..item.name.." and starts to wrap it around the lower half of their head.")
    ply:ForceSequence("crouchidlehide")
end)

ITEM:Hook("EquipUn", function(item)
    local ply = item.player

    ix.chat.Send(ply, "me", "unties the "..item.name.." from their head and staches it back into their pockets.")
    ply:ForceSequence("crouchidlehide")
end)