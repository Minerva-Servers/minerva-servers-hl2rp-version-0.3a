ENT.Type = "anim"
ENT.PrintName = "Safebox"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if (SERVER) then
    function ENT:Initialize()
        self:SetModel("models/props/CS_militia/footlocker01_closed.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(true)
            physObj:Wake()
        end
    end

	local cityCodes = {
		["turmoil"] = true,
		["jw"] = true,
		["aj"] = true,
	}
    function ENT:Use(ply)
        if (CurTime() < (ply.ixNextOpen or 0)) then
            return
        end

        if ( ply:IsCombine() ) then
            ply:Notify("You are not allowed to use this!")
            return
        end

        if ( cityCodes[ix.cityCode.GetCurrent()] ) then
            ply:Notify("You are not allowed to open a Safebox during "..ix.cityCode.GetName())
            return
        end

        self:EmitSound("physics/wood/wood_crate_impact_hard2.wav")

        local openTime = ix.config.Get("safeboxOpenTime", 0.5)

        ix.safebox.Restore(ply, function()
            if (openTime > 0) then
                ply:SetAction("@storageSearching", openTime)
                ply:DoStaredAction(self, function()
                    if (IsValid(ply) and ply:Alive()) then
                        net.Start("ixSafeboxOpen")
                        net.Send(ply)
                    end
                end, openTime, function()
                    if (IsValid(ply)) then
                        ply:SetAction()
                    end
                end)
            else
                net.Start("ixSafeboxOpen")
                net.Send(ply)
            end
        end)

        ply.ixNextOpen = CurTime() + 1
    end
else
    ENT.PopulateEntityInfo = true

    function ENT:OnPopulateEntityInfo(tooltip)
        local title = tooltip:AddRow("name")
        title:SetImportant()
        title:SetText(self.PrintName)
        title:SetBackgroundColor(ix.config.Get("color"))
        title:SizeToContents()

        local description = tooltip:AddRow("description")
        description:SetText("It can permanently hold stuff.")
        description:SizeToContents()
    end
end