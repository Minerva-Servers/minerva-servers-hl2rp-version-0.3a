
local PLUGIN = PLUGIN

local color_green = Color(50,150,100)
local color_red = Color(150, 50, 50)

local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:SetTall(64)

	self:SetText("")
end

function PANEL:SetRecipe(recipeTable)
	self.recipeTable = recipeTable

	self.icon = self:Add("ixSpawnIcon")
	self.icon:InvalidateLayout(true)
	self.icon:Dock(LEFT)
	self.icon:DockMargin(0, 0, 8, 0)
	self.icon:SetMouseInputEnabled(false)
	self.icon:SetModel(recipeTable:GetModel(), recipeTable:GetSkin())
	self.icon.PaintOver = function(this) end

	self.name = self:Add("DLabel")
	self.name:Dock(FILL)
	self.name:SetContentAlignment(4)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixMenuButtonFont")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
	self.name:SetText(recipeTable.GetName and recipeTable:GetName() or L(recipeTable.name))

	self:SetBackgroundColor(recipeTable:OnCanCraft(LocalPlayer()) and color_green or color_red)
end

function PANEL:DoClick()
	if (self.recipeTable) then
		net.Start("ixCraftRecipe")
			net.WriteString(self.recipeTable.uniqueID)
		net.SendToServer()
	end
end

function PANEL:PaintBackground(width, height)
	local alpha = self.currentBackgroundAlpha

	derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, ColorAlpha(self.backgroundColor, alpha))
end

vgui.Register("ixCraftingRecipe", PANEL, "ixMenuButton")

PANEL = {}

function PANEL:Init()
	ix.gui.crafting = self

	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:MakePopup()

	self.categories = self:Add("Panel")
	self.categories:Dock(LEFT)
	self.categories:SetWide(self:GetWide() / 4)
	self.categories.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 66)
		surface.DrawRect(0, 0, w, h)
	end

	self.information = self:Add("Panel")
	self.information:Dock(RIGHT)
	self.information:SetWide(self:GetWide() / 4)
	self.information.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 66)
		surface.DrawRect(0, 0, w, h)
	end

	self.information.icon = self.information:Add("ixSpawnIcon")
	self.information.icon:InvalidateLayout(true)
	self.information.icon:Dock(TOP)
	self.information.icon:SetTall(450)
	self.information.icon:SetMouseInputEnabled(false)
	self.information.icon.PaintOver = function(this) end
	
	self.information.name = self.information:Add("DLabel")
	self.information.name:InvalidateLayout(true)
	self.information.name:Dock(TOP)
	self.information.name:SetTall(150)
	self.information.name:SetMouseInputEnabled(false)
	self.information.name.PaintOver = function(this) end
	self.information.name:SetText("")
	self.information.name:SetFont("ixBigFont")
	self.information.name:SetWrap(true)
	self.information.name:DockMargin(8, 0, 0, 0)
	
	self.information.desc = self.information:Add("DLabel")
	self.information.desc:InvalidateLayout(true)
	self.information.desc:Dock(TOP)
	self.information.desc:SetTall(300)
	self.information.desc:SetMouseInputEnabled(false)
	self.information.desc.PaintOver = function(this) end
	self.information.desc:SetText("")
	self.information.desc:SetFont("ixBigFont")
	self.information.desc:SetWrap(true)
	self.information.desc:DockMargin(8, 0, 0, 0)

	self.categoryPanels = {}

	local button = self.categories:Add("ixMenuButton")
	button:Dock(BOTTOM)
	button:SetText("Return")
	button:SizeToContents()
	button.DoClick = function(this)
		ix.gui.crafting:Remove()
	end

	self.craft = self.information:Add("ixMenuButton")
	self.craft:Dock(BOTTOM)
	self.craft:SetText("craft recipe")
	self.craft:SizeToContents()

	self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)

	self.search = self:Add("ixIconTextEntry")
	self.search:SetEnterAllowed(false)
	self.search:Dock(TOP)

	local leftMargin = self.search:GetDockMargin()
	self.search:DockMargin(leftMargin, 0, 0, 0)

	self.search.OnChange = function(this)
		local text = self.search:GetText():lower()

		if (self.selected) then
			self:LoadRecipes(self.selected.category, text:find("%S") and text or nil, nil)
			self.scroll:InvalidateLayout()
		end
	end

	local first = true

	for k, v in pairs(PLUGIN.craft.recipes) do
		if (v:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (!self.categoryPanels[L(v.category)]) then
			self.categoryPanels[L(v.category)] = v.category
		end
	end

	for category, realName in SortedPairs(self.categoryPanels) do
		local button = self.categories:Add("ixMenuButton")
		button:Dock(TOP)
		button:SetText(category)
		button:SetContentAlignment(4)
		button:SizeToContents()
		button.DoClick = function(this)
			if (self.selected != this) then
				self.selected = this
				self:LoadRecipes(realName, nil, nil)
				timer.Simple(0.01, function()
					self.scroll:InvalidateLayout()
				end)
			end
		end
		button.category = realName

		if (first) then
			self.selected = button
			first = false
		end

		self.categoryPanels[realName] = button
	end

	if (self.selected) then
		self:LoadRecipes(self.selected.category, nil, nil)
	end
end

function PANEL:LoadRecipes(category, search, tableType)
	category = category	or "Crafting"
	local recipes = PLUGIN.craft.recipes

	self.scroll:Clear()
	self.scroll:InvalidateLayout(true)

	for uniqueID, recipeTable in SortedPairsByMemberValue(recipes, "name") do
		if (recipeTable:OnCanSee(LocalPlayer()) == false) then
			continue
		end

		if (recipeTable.category == category) then
			if (search and search != "" and !L(recipeTable.name):lower():find(search, 1, true)) then
				continue
			end

			local recipeButton = self.scroll:Add("ixCraftingRecipe")
			recipeButton:SetRecipe(recipeTable)
			recipeButton:SetHelixTooltip(function(tooltip)
				PLUGIN:PopulateRecipeTooltip(tooltip, recipeTable)
			end)

			recipeButton.DoClick = function(this)
				if (recipeButton.recipeTable) then
					self.selectedRecipe = recipeButton.recipeTable.uniqueID
					self.information.icon:SetModel(recipeButton.recipeTable:GetModel(), recipeButton.recipeTable:GetSkin())
					local nametbl = {}
					for k, v in pairs(recipeButton.recipeTable.results) do
						local amount = v

						if (istable(v)) then
							if (v["min"] and v["max"]) then
								amount = v["min"].."-"..v["max"]
							else
								amount = v[1].."-"..v[#v]
							end
						end
						
						local name = ix.item.Get(k).name
						local desc = ix.item.Get(k).description
						
						if ( amount > 1 ) then
							name = name.." X"..amount.."\n"
						end
						
						
						
						if ( ix.item.Get(k).base == "base_ammo" ) then
							local rounds = ix.item.Get(k):GetData("rounds", ix.item.Get(k).ammoAmount)
							desc = Format(ix.item.Get(k).description, rounds)
						end
						
						self.information.name:SetText(name or "")
						self.information.desc:SetText(desc.."\n" or "")
					end

					self.craft:SetBackgroundColor(recipeButton.recipeTable:OnCanCraft(LocalPlayer()) and color_green or color_red)
					self.craft:SetHelixTooltip(function(tooltip)
						PLUGIN:PopulateRecipeTooltip(tooltip, recipeTable)
					end)
				end
			end

			self.craft.DoClick = function(this)
				if (self.selectedRecipe) then
					net.Start("ixCraftRecipe")
						net.WriteString(self.selectedRecipe)
					net.SendToServer()
				end
			end
		end
	end
end

function PANEL:Paint(w, h)
    ix.util.DrawBlur(self, 10)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
end

vgui.Register("ixCrafting", PANEL, "DPanel")

net.Receive("ixCraftRefresh", function()
	local craftPanel = ix.gui.crafting

	if (IsValid(craftPanel)) then
		craftPanel.search:OnChange()
	end
end)
