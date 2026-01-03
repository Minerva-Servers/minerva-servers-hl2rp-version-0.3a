local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Combine Terminal"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_interface001.mdl")
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
        if ( ( ply.nextTerminalUse or 0 ) > CurTime() ) then
            return 
        end

        ply.nextTerminalUse = CurTime() + 2
        
        if not ( ply:IsCombine() ) then
            ply:Notify("You need to be Combine to use this terminal!")
            return
        end

        self:EmitSound("ambient/machines/combine_terminal_idle"..math.random(1, 2)..".wav")
    
        net.Start("ixCombineTerminalOpen")
            net.WriteEntity(self)
        net.Send(ply)
    end
else
    function ENT:CreateTexMat()
        PLUGIN.terminalMaterialIdx = PLUGIN.terminalMaterialIdx + 1
    
        self.tex = GetRenderTarget("ctouniquert" .. PLUGIN.terminalMaterialIdx, 512, 256, false)
        self.mat = CreateMaterial("ctouniquemat" .. PLUGIN.terminalMaterialIdx, "UnlitGeneric", {
            ["$basetexture"] = self.tex,
        })
    end
    
    function ENT:Think()
        if ( !self.tex or !self.mat ) then
            self:CreateTexMat()
        end
    
        PLUGIN.terminalsToDraw[self] = LocalPlayer():IsLineOfSightClear(self)
    end
    
    function ENT:Draw()
        self:DrawModel()
    end    
end
