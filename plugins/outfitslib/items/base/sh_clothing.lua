
ITEM.name = "Clothing"
ITEM.model = Model("models/props_c17/BriefCase001a.mdl")
ITEM.description = "A generic piece of clothing."

if (CLIENT) then
    local vignette = Material("helix/gui/vignette.png")
    function ITEM:PaintOver(item, w, h)
        if (item:GetData("equip")) then
            surface.SetMaterial(vignette)
            surface.SetDrawColor(110, 255, 110, 10)
            surface.DrawTexturedRect(1, 1, w - 2, h - 2)
        end
    end

    function ITEM:PopulateTooltip(tooltip)
        if (self:GetData("equip")) then
            local name = tooltip:GetRow("name")
            name:SetBackgroundColor(derma.GetColor("Success", tooltip))
        end
    end
end

function ITEM:RemoveOutfit(ply)
    local char = ply:GetCharacter()
    self:SetData("equip", false)

    if ( char:GetData("oldModel" .. self.outfitCategory) ) then
        ply:SetModel(char:GetData("oldModel" .. self.outfitCategory))
        char:SetData("oldModel" .. self.outfitCategory, nil)
    end

    if ( self.newSkin ) then
        if ( char:GetData("oldSkin" .. self.outfitCategory) ) then
            ply:SetSkin(char:GetData("oldSkin" .. self.outfitCategory))
            char:SetData("oldSkin" .. self.outfitCategory, nil)
            char:SetData("skin", ply:GetSkin())
        else
            ply:SetSkin(0)
        end
    end

    if ( self.bodyGroups ) then
        for k in pairs(self.bodyGroups) do
            local index = ply:FindBodygroupByName(k)
            local char = ply:GetCharacter()
            local groups = char:GetData("groups", {})

            if ( index > -1 ) then
                groups[index] = 0
                char:SetData("groups", groups)
                ply:SetBodygroup(index, 0)
            end
        end
    end
end

ITEM:Hook("drop", function(item)
    if ( item:GetData("equip") ) then
        item:RemoveOutfit(item:GetOwner())
    end
end)

ITEM.functions.EquipUn = {
    name = "Unequip",
    tip = "unequipTip",
    icon = "icon16/cross.png",
    OnRun = function(item)
        local ply = item.player
        if (ply) then
            ply:SetAction("Unequipping...", item.time or 1.5, function()
                item:RemoveOutfit(ply)

                if item.OnUnEquip then
                    item:OnUnEquip(ply, item)
                end

                ply:EmitSound("minerva/global/equip.mp3", 45)
            end)
        else
            item:SetData("equip", false)

            if item.OnUnEquip then
                item:OnUnEquip(item.player, item)
            end
        end
        
        return false
    end,
    OnCanRun = function(item)
        local ply = item.player

        return !IsValid(item.entity) and IsValid(ply) and item:GetData("equip") == true and
            hook.Run("CanPlayerUnequipItem", ply, item) != false and item:CanUnequipOutfit()
    end
}

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(item, creationClient)
        local ply = item.player or creationClient
        local char = ply:GetCharacter()
        local items = char:GetInventory():GetItems()
        local groups = char:GetData("groups", {})

        -- Checks if any [Torso] is already equipped.
        for _, v in pairs(items) do
            if ( v.id != item.id ) then
                local itemTable = ix.item.instances[v.id]

                if ( v.outfitCategory == item.outfitCategory and itemTable:GetData("equip") ) then
                    ply:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
                    return false
                end
            end
        end

        ply:SetAction("Equipping...", item.time or 3, function()
            item:SetData("equip", true)
            
            if ( isfunction(item.OnGetReplacement) ) then
                char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, ply:GetModel()))
                ply:SetModel(item:OnGetReplacement())
            elseif ( item.replacement or item.replacements ) then
                char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, ply:GetModel()))

                if ( istable(item.replacements) ) then
                    if ( #item.replacements == 2 and isstring(item.replacements[1]) ) then
                        ply:SetModel(ply:GetModel():gsub(item.replacements[1], item.replacements[2]))
                    else
                        for _, v in ipairs(item.replacements) do
                            ply:SetModel(ply:GetModel():gsub(v[1], v[2]))
                        end
                    end
                else
                    ply:SetModel(item.replacement or item.replacements)
                end
            end

            if ( item.newSkin ) then
                char:SetData("oldSkin" .. item.outfitCategory, ply:GetSkin())
                char:SetData("skin", item.newSkin)

                ply:SetSkin(item.newSkin)
            end

            if ( item.bodyGroups ) then
                for k, value in pairs(item.bodyGroups) do
                    local index = ply:FindBodygroupByName(k)

                    if ( index > -1 ) then
                        groups[index] = value
                        char:SetData("groups", groups)
                        ply:SetBodygroup(index, value)

                        if item.OnEquip then
                            item:OnEquip(ply, item)
                        end
                    end
                end
            end

            ply:EmitSound("minerva/global/unequip.mp3", 45)
        end)

        return false
    end,
    OnCanRun = function(item)
        local ply = item.player
        if item.allowedModels and !table.HasValue(item.allowedModels, ply:GetModel()) then
            return false
        end

        return !IsValid(item.entity) and IsValid(ply) and item:GetData("equip") != true and
            hook.Run("CanPlayerEquipItem", ply, item) != false and item:CanEquipOutfit()
    end
}

function ITEM:CanTransfer(oldInventory, newInventory)
    if (newInventory and self:GetData("equip")) then
        return false
    end

    return true
end

function ITEM:OnRemoved()
    if (self.invID != 0 and self:GetData("equip")) then
        self.player = self:GetOwner()
        self:RemoveOutfit(self.player)

        if self.OnUnEquip then
            self:OnUnEquip()
        end

        self.player = nil
    end
end

function ITEM:CanEquipOutfit()
    return true
end

function ITEM:CanUnequipOutfit()
    return true
end