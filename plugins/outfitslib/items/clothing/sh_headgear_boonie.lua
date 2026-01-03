ITEM.name = "Boonie Hat"
ITEM.description = "A green boonie hat, used and known by the price family."
ITEM.category = "Clothing"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.outfitCategory = "Headgear"

ITEM.bodyGroups = {
    ["headgear"] = 6
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

function ITEM:PopulateTooltip(tooltip)
    local tooltip = tooltip:AddRow("tooltip")
    tooltip:SetBackgroundColor(Color(200, 50, 0))
    tooltip:SetText("This is a strange item!")
    tooltip:SizeToContents()
end