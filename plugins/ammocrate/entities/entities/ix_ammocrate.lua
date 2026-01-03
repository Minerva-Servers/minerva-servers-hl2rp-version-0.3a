local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Ammo Crate"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/Items/ammocrate_smg1.mdl")
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
        if ( IsValid(self) ) then
            if ( ( self.nextopen or 0 ) > CurTime() ) then
                return
            end

            local ammo = PLUGIN.ammo[game.GetAmmoName(ply:GetActiveWeapon():GetPrimaryAmmoType())]
            if not ( ammo ) then
                ply:Notify("You aren't holding a weapon that has the type of ammunition inside the box.")
                return
            else
                local weapon = ply:GetActiveWeapon()
                if not ( IsValid( weapon ) ) then
                    return
                end

                timer.Simple(0.25, function()
                    if not ( IsValid(self) and IsValid(ply) and ply:Alive() ) then
                        return
                    end
        
                    self:EmitSound("items/ammo_pickup.wav")
                    ply:EmitSound("items/ammo_pickup.wav")
                    ply:SetAmmo(ammo, weapon:GetPrimaryAmmoType())
                    ply:GetActiveWeapon():SetClip1(ply:GetActiveWeapon():GetMaxClip1())
                end)
        
                if ( ( self.animationCooldown or 0 ) > CurTime() ) then
                    return
                end

                self:ResetSequence("close")
                self:EmitSound("items/ammocrate_open.wav")
                timer.Simple(0.5, function()
                    if not ( IsValid(self) and IsValid(ply) and ply:Alive() ) then
                        return
                    end
                    
                    self:ResetSequence("open")
                    self:EmitSound("items/ammocrate_close.wav")
                end)
                self.animationCooldown = CurTime() + 1
            end
            self.nextopen = CurTime() + 1
        end
    end
end
