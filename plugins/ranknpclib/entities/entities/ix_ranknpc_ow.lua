local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "OW NPC"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"
ENT.UIName = "Overwatch Vendor"
ENT.UIDesc = "The Overwatch vendor is used to get your rank and division."

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/minerva/combine_elite.mdl")
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)
        self:DropToFloor()
    end

    function ENT:Use(ply)
        if ( ply:Team() == FACTION_OW ) then
            net.Start("ixRankNPC.OpenMenu")
            net.Send(ply)
        end
    end
end
