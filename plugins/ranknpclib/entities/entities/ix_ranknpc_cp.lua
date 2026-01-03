local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "CP NPC"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"
ENT.UIName = "Civil Protection Vendor"
ENT.UIDesc = "The Civil Protection vendor is used to get your rank and division."

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/minerva/metrocop.mdl")
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)
        self:DropToFloor()

        self:SetSkin(5)
    end

    function ENT:Use(ply)
        if ( ply:Team() == FACTION_CP ) then
            net.Start("ixRankNPC.OpenMenu")
            net.Send(ply)
        end
    end
end
