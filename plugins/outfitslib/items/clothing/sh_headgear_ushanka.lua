ITEM.name = "Ushanka"
ITEM.description = "A Russian headgear, quite rare to see."
ITEM.category = "Clothing"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.outfitCategory = "Headgear"

ITEM.bodyGroups = {
    ["headgear"] = 11
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
    tooltip:SetBackgroundColor(Color(150, 0, 200))
    tooltip:SetText("This is an unusual item!")
    tooltip:SizeToContents()
end