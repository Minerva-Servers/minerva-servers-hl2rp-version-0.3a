AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    if self.ixSaveKeyValue then
        local vendorID = self.ixSaveKeyValue["vendor"]

        if vendorID and ix.vendor.data[vendorID] then
            self.vendor = ix.vendor.data[vendorID]
        end
    end

    if self.vendor then
        self:SetModel(self.vendor.Model)

        if self.vendor.Skin then
            self:SetSkin(self.vendor.Skin)
        end

        if self.vendor.Bodygroups then
            self:SetBodyGroups(self.vendor.Bodygroups)
        end
    else
        self:SetModel("models/Humans/Group01/male_02.mdl")
    end
    
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    if self.vendor then
        self:SetVendor(self.vendor.UniqueID)
        
        if self.vendor.Initialize then
            self.vendor.Initialize(self)
        end
    end
end

function ENT:Use(activator, caller)
    if (activator.nextVendorUse or 0) > CurTime() then return end
    activator.nextVendorUse = CurTime() + 1

    if self.vendor.CanUse and self.vendor.CanUse(self, activator) == false then
        return activator:Notify("You can not use this vendor.")    
    end

    if not activator:Alive() then
        return
    end

    if self.vendor.DownloadTrades then
        local dBuy = pon.encode(self.vendor.Buy)
        local dSell = pon.encode(self.vendor.Sell)

        net.Start("ixVendorUseDownload")
        net.WriteString(self.vendor.UniqueID)
        net.WriteUInt(#dBuy, 32)
        net.WriteData(dBuy, #dBuy)
        net.WriteUInt(#dSell, 32)
        net.WriteData(dSell, #dSell)
        net.Send(activator)
    else
        net.Start("ixVendorUse")
        net.Send(activator)
    end

    activator.currentVendor = self
end

function ENT:Think()
    if self.vendor and self.vendor.Think then
        return self.vendor.Think(self)
    end
end