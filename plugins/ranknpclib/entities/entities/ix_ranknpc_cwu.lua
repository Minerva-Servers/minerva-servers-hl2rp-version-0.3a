local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "CWU NPC"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"
ENT.UIName = "Civil Worker's Union Vendor"
ENT.UIDesc = "The Civil Worker's Union vendor is used to get your class."

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    util.AddNetworkString("ixRankNPC.OpenMenu")
    
    function ENT:Initialize()
        self:SetModel("models/Humans/Group02/male_02.mdl")
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)
        self:DropToFloor()
    end

    function ENT:Use(ply)
        if ( ply:Team() == FACTION_CWU ) then
            net.Start("ixRankNPC.OpenMenu")
            net.Send(ply)
        end
    end
end
