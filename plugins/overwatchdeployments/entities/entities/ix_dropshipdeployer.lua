local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Overwatch Deployer"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"
ENT.UIName = "Overwatch Deployer"
ENT.UIDesc = "Allows you to deploy to a certain location in the city."

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/minerva/combine_border_patrol.mdl")
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)
        self:DropToFloor()
        self:Give("ix_ar2")
    end

    function ENT:Use(ply)
        if ( ply:IsOW() ) then
            if not ( ix.od.enabledOW ) then
                ply:Notify("You are unavaible to use the dropship mechanic until a supervisor grants it.")
                return
            end
        elseif ( ply:IsOW() ) then
            if not ( ix.od.enabledCP ) then
                ply:Notify("You are unavaible to use the dropship mechanic until a supervisor grants it.")
                return
            end
        end

        ply:OpenVGUI("ixOverwatchDeployments")
    end

    function ENT:Think()
        local weapon = self:GetActiveWeapon()

        if ( IsValid(weapon) ) then
            weapon:SetClip1(1000)
            weapon:SetNextPrimaryFire(CurTime() + 0.01)
        end
    end
end
