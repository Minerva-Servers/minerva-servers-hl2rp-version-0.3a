ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "HL2 RP (Cocaine Laboratory)"
ENT.PrintName = "Gasoline"
ENT.Author = "James"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
end