local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Radio"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Frequency")
    self:SetFrequency(102.2)
end

function ENT:GetNearestButton(ply)
    ply = ply or ( ply and LocalPlayer() )

    if ( SERVER ) then
        local pos = self:GetPos()
        local ang = self:GetAngles()

        pos = pos + ang:Up() * 15.3
        pos = pos + ang:Forward() * 8.5
        pos = pos + ang:Right() * 5.7

        self.buttonLocation = self.buttonLocation or {}

        self.buttonLocation[1] = pos + ang:Forward() * 1.2 + ang:Right() * -7 + ang:Up() * - 7.7
        self.buttonLocation[2] = pos + ang:Forward() * 1.2 + ang:Right() * -14.5 + ang:Up() * - 7.7
    end

    local data = {}
    data.start = ply:GetShootPos()
    data.endpos = data.start + ply:GetAimVector() * 96
    data.filter = ply

    local trace = util.TraceLine(data)
    local hitPos = trace.HitPos

    if ( hitPos ) then
        for k, v in pairs(self.buttonLocation) do
            if ( v:DistToSqr(hitPos) < 4 ) then
                return k
            end
        end
    end
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_lab/citizenradio.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Use(ply)
        ply:OpenVGUI("ixIEDMenu")
    end
end
