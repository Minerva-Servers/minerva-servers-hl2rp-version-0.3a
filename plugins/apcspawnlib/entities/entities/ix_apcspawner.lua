local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "APC Terminal"
ENT.Author = "eon"
ENT.Category = "HL2 RP"

ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_combine/breenconsole.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local physObj = self:GetPhysicsObject()

        if ( IsValid(physObj) ) then
            physObj:EnableMotion(false)
            physObj:Wake()
        end
    end
    
    function ENT:Use(ply)
        if ( ( ply.nextAPCSpawnerUse or 0 ) > CurTime() ) then
            return 
        end

        ply.nextAPCSpawnerUse = CurTime() + 2
        
        if not ( ply:IsCombine() ) then
            ply:Notify("You need to be Combine to use this terminal!")
            return
        end

        self:EmitSound("ambient/machines/combine_terminal_idle"..math.random(1, 2)..".wav")
    
        ply:SendLua([[vgui.Create("ixAPCTerminal")]])
    end
end