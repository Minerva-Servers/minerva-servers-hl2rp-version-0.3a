local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Ration Dispenser"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        self.dummy = ents.Create("prop_dynamic")
        self.dummy:SetPos(self:GetPos())
        self.dummy:SetAngles(self:GetAngles())
        self.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
        self.dummy:SetParent(self)
        self.dummy:Spawn()

        local physObj = self:GetPhysicsObject()

        if ( IsValid(physObj) ) then
            physObj:EnableMotion(false)
            physObj:Wake()
        end
    end

    function ENT:Use(ply)
        local pos = self.dummy:GetPos() + self.dummy:GetForward() * 15 + self.dummy:GetRight() * -6 + self.dummy:GetUp() * -6
        local ang = self.dummy:GetAngles()

        if not ( ix.rations.globalRationsEnabled ) then
            ply:Notify("You are not able to get Rations during this time.")
            self.dummy:EmitSound("buttons/combine_button2.wav")

            return false
        end

        if ( table.HasValue(ix.rations.globalRationsClaimed, ply:SteamID64()) ) then
            ply:Notify("You have already gotten your Ration.")
            self.dummy:EmitSound("buttons/combine_button2.wav")

            return false
        end

        self.dummy:EmitSound("ambient/machines/combine_terminal_idle4.wav")
        self.dummy:Fire("SetAnimation", "dispense_package", 0)

        timer.Simple(1.5, function()
            ix.item.Spawn("ration", pos, nil, ang)
        end)
        
        table.insert(ix.rations.globalRationsClaimed, ply:SteamID64())
    end
else
    surface.CreateFont("ixRationDispenser", {
        font = "Consolas",
        size = 28,
        antialias = false,
        scanlines = 2,
    })

    function ENT:Draw()
        local position, angles = self:GetPos(), self:GetAngles()

        angles:RotateAroundAxis(angles:Forward(), 90)
        angles:RotateAroundAxis(angles:Right(), 270)

        cam.Start3D2D(position + self:GetForward() * 7.6 + self:GetRight()*  8.5 + self:GetUp() * 3, angles, 0.1)
            render.PushFilterMin(TEXFILTER.NONE)
            render.PushFilterMag(TEXFILTER.NONE)

            surface.SetDrawColor(color_black)
            surface.DrawRect(10, 16, 153, 40)

            surface.SetDrawColor(50, 50, 50)
            surface.DrawOutlinedRect(9, 16, 155, 40)

            local alpha = math.abs(math.cos(RealTime() * 2) * 255)
            local color = ColorAlpha(color_white, alpha)
            local time = "UNAVAILABLE"
            local font = "ixRationDispenser"
            if ( ix.rations.globalRationsEnabled ) then
                time = "AVAILABLE"
            end

            draw.SimpleText(string.upper(time), font, 86, 36, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            render.PopFilterMin()
            render.PopFilterMag()
        cam.End3D2D()
    end
end
