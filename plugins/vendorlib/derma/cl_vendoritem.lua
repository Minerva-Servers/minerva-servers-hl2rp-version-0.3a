local PANEL = {}

function PANEL:Init()
	self.model = vgui.Create("ixSpawnIcon", self)
	self:SetMouseInputEnabled(true)
	self:SetTall(50)

	self:SetCursor("hand")
end

function PANEL:SetItem(item, sellData)
	self.Item = item
	self.SellData = sellData

	local panel = self

	self.model:SetPos(0, 0)
	self.model:SetSize(self:GetTall(), self:GetTall())
	self.model:SetMouseInputEnabled(true)
	self.model:SetModel(item and item.model or "models/error.mdl")

	function self.model:DoClick()
		panel:OnMousePressed()
	end
end

function PANEL:Think()
	if self.ItemID then
		local inv = ix.item.Get(self.ItemID)

		if not inv then
			self:Remove()
		end
	end
end

function PANEL:OnMousePressed()
	if self.Selling then
		net.Start("ixVendorSell")
			net.WriteString(ix.item.Get(self.ItemID).uniqueID)
		net.SendToServer()
	else
		net.Start("ixVendorBuy")
			net.WriteString(self.Item.uniqueID)
		net.SendToServer()
	end
end

local activeCol = Color(35, 35, 35, 88)
local hoverCol = Color(120, 120, 120, 88)
local disabledCol = Color(15, 15, 15, 150)
local grey = Color(170, 170, 170, 150)

function PANEL:Paint(w, h)
	local col = activeCol
	local cost = self.SellData and self.SellData.Cost or nil
	local max = self.SellData and self.SellData.Max or nil
	local hasItem = LocalPlayer():GetCharacter():GetInventory():HasItem(self.ItemID)
	local amount = LocalPlayer():GetCharacter():GetInventory():GetItemCount(self.ItemID, false)
	local disabled = false
	local maxed = false

	if (cost and cost > LocalPlayer():GetCharacter():GetMoney()) or (self.SellData and self.SellData.CanBuy and self.SellData.CanBuy(LocalPlayer()) == false) then
		col = disabledCol
		disabled = true
	end

	if max and hasItem and amount >= max then
		col = disabledCol
		disabled = true
		maxed = true
	end

	surface.SetDrawColor(col)
	surface.DrawRect(0, 0, w, h)

	if self:IsHovered() then
		if disabled then
			surface.SetDrawColor(disabledCol)
		else
			surface.SetDrawColor(hoverCol)
		end

		surface.DrawRect(0, 0, w, h)
	end

	draw.DrawText((self.SellData and self.SellData.Name) or (self.Item and self.Item.name) or "nil", "ixMediumFont", 60, 5, (disabled and grey) or color_white)

	local desc = ""

	if cost then
		desc = cost.." "..ix.currency.plural
	else
		desc = "Free"
	end

	if self.SellData and self.SellData.Desc then
		desc = desc.." ("..self.SellData.Desc..")"
	end

	draw.DrawText(desc, "ixSmallFont", 60, 25, grey)

	if max then
		draw.DrawText((amount or 0).."/"..max.." (max limit)", "ixSmallFont", 60, 50, grey)
	end
end

vgui.Register("ixVendorItem", PANEL, "DPanel")