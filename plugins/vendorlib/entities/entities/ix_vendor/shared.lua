ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Vendor Base"
ENT.Author = "vin"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Unset Vendor"
ENT.HUDDesc = "This vendor has no VendorType set. Use the key/value save system to set 'vendor' to the string ID of the vendor. Then reload me."

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Vendor")
end