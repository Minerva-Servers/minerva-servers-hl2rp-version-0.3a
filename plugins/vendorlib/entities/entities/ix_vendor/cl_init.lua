include("shared.lua")

function ENT:Think()
	local vendor = self:GetVendor()

	if ix.vendor.data[vendor] then
		self.vendor = ix.vendor.data[vendor]

		self.HUDName = self.vendor.Name
		self.HUDDesc = self.vendor.Desc
	end

	self:SetNextClientThink(CurTime() + 0.25)

	return true
end