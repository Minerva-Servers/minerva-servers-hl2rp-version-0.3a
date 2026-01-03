local PANEL = {}

function PANEL:Init()
	local ply = LocalPlayer()
	
	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:MakePopup()

	self.leftpanel = self:Add("Panel")
	self.leftpanel:Dock(LEFT)
	self.leftpanel:SetWide(self:GetWide() / 3)
	self.leftpanel.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 66))
		surface.DrawRect(0, 0, w, h)
	end

	self.rightpanel = self:Add("Panel")
	self.rightpanel:Dock(RIGHT)
	self.rightpanel:SetWide(self:GetWide() / 3)
	self.rightpanel.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 66))
		surface.DrawRect(0, 0, w, h)
	end

	self.model = self:Add("DModelPanel")
	self.model:SetModel(ply:GetModel())
	self.model:Dock(FILL)
	self.model:SetWide(self:GetWide() / 3)
	self.model:MoveToFront()
	self.model:SetFOV(ScreenScale(14))

	local ent = self.model.Entity
	if ( IsValid(ent) ) then
		if ( ent:GetModel() != ply:GetModel() ) then
			ent:SetModel(ply:GetModel(), ply:GetSkin())
		end
	
		for i, v in ipairs(ply:GetBodyGroups()) do
			ent:SetBodygroup(v.id, ply:GetBodygroup(v.id))
		end
		
		ent:SetSkin(ply:GetSkin())
	end

	self.close = self:Add("ixMenuButton")
	self.close:Dock(BOTTOM)
	self.close:DockMargin(1, 0, 1, 0)
	self.close:SetTall(40)
	self.close:SetText("Close")
	self.close:SetContentAlignment(5)
	self.close.DoClick = function()
		self:Remove()
	end
end

function PANEL:SetupVendor()
	local lp = LocalPlayer()

	local trace = {}
	trace.start = lp:EyePos()
	trace.endpos = trace.start + lp:GetAimVector() * 120
	trace.filter = lp

	local tr = util.TraceLine(trace)

	if not tr.Entity or not IsValid(tr.Entity) or tr.Entity:GetClass() != "ix_vendor" then
		return self:Remove()
	end

	local npc = tr.Entity
	local vendorType = npc:GetVendor()

	if not vendorType then
		return ix.log.AddRaw("Vendor has no VendorType set!")
	end

	if not ix.vendor.data[vendorType] then
		return ix.log.AddRaw(vendorType.." invalid.")
	end

	self.NPC = npc
	self.vendor = ix.vendor.data[vendorType]

	if self.vendor.Talk then
		surface.PlaySound(ix.vendor.GetRandomAmbientVO(self.vendor.Gender))
	end

	local vNameLbl = vgui.Create("DLabel", self.leftpanel)
	vNameLbl:SetText(self.vendor.Name)
	vNameLbl:SetFont("ixBigFont")
	vNameLbl:SizeToContents()
	vNameLbl:Dock(TOP)
	vNameLbl:DockMargin(8, 8, 8, 0)

	local vDescLbl = vgui.Create("DLabel", self.leftpanel)
	vDescLbl:SetText(self.vendor.Desc)
	vDescLbl:SetFont("ixMediumFont")
	vDescLbl:SizeToContents()
	vDescLbl:Dock(TOP)
	vDescLbl:DockMargin(8, 8, 8, 8)

	local yNameLbl = vgui.Create("DLabel", self.rightpanel)
	yNameLbl:SetText("You")
	yNameLbl:SetFont("ixBigFont")
	yNameLbl:SizeToContents()
	yNameLbl:Dock(TOP)
	yNameLbl:DockMargin(8, 8, 8, 0)

	local yDescLbl = vgui.Create("DLabel", self.rightpanel)
	yDescLbl:SetText("You have "..LocalPlayer():GetCharacter():GetMoney().." "..ix.currency.plural)
	yDescLbl:SetFont("ixMediumFont")
	yDescLbl:SizeToContents()
	yDescLbl:Dock(TOP)
	yDescLbl:DockMargin(8, 8, 8, 8)
	yDescLbl.lastMoney = LocalPlayer():GetCharacter():GetMoney()

	function yDescLbl:Think()
		if self.lastMoney != LocalPlayer():GetCharacter():GetMoney() then
			self.lastMoney = LocalPlayer():GetCharacter():GetMoney()
			self:SetText("You have "..LocalPlayer():GetCharacter():GetMoney().." "..ix.currency.plural)
		end
	end

	local w, h = self:GetSize()
	local empty = true

	self.vendorScroll = vgui.Create("DScrollPanel", self.leftpanel)
	self.vendorScroll:Dock(FILL)

	for v,k in pairs(self.vendor.Sell) do
		if not k.CanBuy or k.CanBuy(LocalPlayer()) then
			local itemid = v

			if not itemid then
				ix.log.AddRaw(v.." is invalid!")
				continue
			end

			local item = ix.item.Get(itemid)

			if not item then
				ix.log.AddRaw("Failed to resolve ItemID "..itemid.."! (Class "..v..")!")
				continue
			end

			local vendorItem = self.vendorScroll:Add("ixVendorItem")
			vendorItem.ItemID = item.uniqueID
			vendorItem:SetItem(item, k)
			vendorItem.Parent = self
			vendorItem:Dock(TOP)
		end

		empty = false
	end

	for v,k in pairs(self.vendor.Sell) do
		if k.CanBuy and not k.CanBuy(LocalPlayer()) then
			local itemid = v

			if not itemid then
				ix.log.AddRaw(v.." is invalid!")
				continue
			end

			local item = ix.item.list[itemid]

			if not item then
				ix.log.AddRaw("Failed to resolve ItemID "..itemid.."! (Class "..v..")!")
				continue
			end

			local vendorItem = self.vendorScroll:Add("ixVendorItem")
			vendorItem.ItemID = item.uniqueID
			vendorItem:SetItem(item, k)
			vendorItem.Parent = self
			vendorItem:Dock(TOP)
			vendorItem.DoClick = function(self)
				self:Remove()
			end
		end

		empty = false
	end

	if empty then
		local emptyLbl = vgui.Create("DLabel", self.vendorScroll)
		emptyLbl:SetText("Nothing to buy")
		emptyLbl:SetFont("ixMediumFont")
		emptyLbl:SizeToContents()
		emptyLbl:Dock(TOP)
		emptyLbl:DockMargin(0, 20, 0, 0)
		emptyLbl:SetContentAlignment(5)
	end

	empty = true

	self.youScroll = vgui.Create("DScrollPanel", self.rightpanel)
	self.youScroll:Dock(FILL)

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		local item = ix.item.Get(v.uniqueID)

		if self.vendor.Buy and self.vendor.Buy[v.uniqueID] then
			if ( v:GetData("Restricted") ) then
				return
			end
			
			local vendorItem = self.youScroll:Add("ixVendorItem")
			vendorItem.Selling = true
			vendorItem.ItemID = v.uniqueID
			vendorItem:SetItem(item, self.vendor.Buy[v.uniqueID])
			vendorItem.Parent = self
			vendorItem:Dock(TOP)

			empty = false
		end
	end

	if empty then
		local emptyLbl = vgui.Create("DLabel", self.youScroll)
		emptyLbl:SetText("Nothing to sell")
		emptyLbl:SetFont("ixMediumFont")
		emptyLbl:SizeToContents()
		emptyLbl:Dock(TOP)
		emptyLbl:DockMargin(0, 20, 0, 0)
		emptyLbl:SetContentAlignment(5)
	end
end

function PANEL:Paint(w, h)
	ix.util.DrawBlur(self, 10)
	draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

vgui.Register("ixVendorMenu", PANEL, "DPanel")