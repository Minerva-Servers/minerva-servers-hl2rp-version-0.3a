
ITEM.name = "Boxed Ammo Base"
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.ammoItem = "ammo_pistol" -- type of the ammo
ITEM.ammoAmount = 8 -- amount of the ammo
ITEM.description = "A Box that contains %s boxes of Pistol Ammo"
ITEM.category = "Boxed Ammunition"
ITEM.useSound = "physics/wood/wood_box_break1.wav"

function ITEM:GetDescription()
	local ammo = self:GetData("ammo", self.ammoAmount)
	return Format(self.description, ammo)
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
        draw.SimpleText(
            item:GetData("ammo", item.ammoAmount), 'ixTinyFont', w - 5, h - 5,
            color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black
        )
	end
end

ITEM.functions.use = {
	name = "Unpack",
	icon = "icon16/box.png",
	OnRun = function(item)
		local ammo = item:GetData("ammo", item.ammoAmount)
		for i = 1, ammo do
			if not ( item.player:GetCharacter():GetInventory():Add(item.ammoItem) ) then
				ix.item.Spawn(item.ammoItem, item.player)
			end
		end
		item.player:EmitSound(item.useSound, 45)

		return true
	end,
}