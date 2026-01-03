local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Forcefield"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Mode")
    self:NetworkVar("Entity", 0, "Dummy")
end

if (SERVER) then
    function ENT:SpawnFunction(client, trace)
        local angles = (client:GetPos() - trace.HitPos):Angle()
        angles.p = 0
        angles.r = 0
        angles:RotateAroundAxis(angles:Up(), 270)

        local entity = ents.Create("ix_forcefield")
        entity:SetPos(trace.HitPos + Vector(0, 0, 40))
        entity:SetAngles(angles:SnapTo("y", 90))
        entity:Spawn()
        entity:Activate()

        PLUGIN:SaveForceFields()
        return entity
    end

    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_fence01b.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)

        local data = {}
            data.start = self:GetPos() + self:GetRight() * -16
            data.endpos = self:GetPos() + self:GetRight() * -480
            data.filter = self
        local trace = util.TraceLine(data)

        local angles = self:GetAngles()
        angles:RotateAroundAxis(angles:Up(), 45)

        self.dummy = ents.Create("prop_physics")
        self.dummy:SetModel("models/props_combine/combine_fence01a.mdl")
        self.dummy:SetPos(trace.HitPos)
        self.dummy:SetAngles(self:GetAngles())
        self.dummy:Spawn()
        self.dummy.PhysgunDisabled = true
        self:DeleteOnRemove(self.dummy)

        local verts = {
            {pos = Vector(0, 0, -25)},
            {pos = Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0, 0, 25)},
            {pos = Vector(0, 0, -25)}
        }

        self:PhysicsFromMesh(verts)

        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        self:SetCustomCollisionCheck(true)
        self:EnableCustomCollisions(true)
        self:SetDummy(self.dummy)

        physObj = self.dummy:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        self:SetMoveType(MOVETYPE_NOCLIP)
        self:SetMoveType(MOVETYPE_PUSH)
        self:MakePhysicsObjectAShadow()
        self:SetMode(1)
        self:SetSkin(0)
        self.dummy:SetSkin(0)
    end

    function ENT:StartTouch(entity)
        if (!self.buzzer) then
            self.buzzer = CreateSound(entity, "ambient/machines/combine_shield_touch_loop1.wav")
            self.buzzer:Play()
            self.buzzer:ChangeVolume(0.8, 0)
        else
            self.buzzer:ChangeVolume(0.8, 2)
            self.buzzer:Play()
        end

        self.entities = (self.entities or 0) + 1
    end

    function ENT:EndTouch(entity)
        self.entities = math.max((self.entities or 0) - 1, 0)

        if (self.buzzer and self.entities == 0) then
            self.buzzer:FadeOut(1)
        end
    end

    function ENT:OnRemove()
        if (self.buzzer) then
            self.buzzer:Stop()
            self.buzzer = nil
        end

        if (self.idle1) then
            self.idle1:Stop()
            self.idle1 = nil
        end

        if (self.idle2) then
            self.idle2:Stop()
            self.idle2 = nil
        end

        if (!ix.shuttingDown and !self.ixIsSafe) then
            PLUGIN:SaveForceFields()
        end
    end

    local MODES = {
        {
            function(client)
                return false
            end,
            "Off."
        },
        {
            function(client)
                return client:Team() != FACTION_CWU
            end,
            "Only allow Civil Worker's Union."
        },
        {
            function(client)
                return (client:Team() != FACTION_CWU and client:GetTeamClass() != CLASS_CWU_MAINTENANCE)
            end,
            "Only allow City Maintenance Workers."
        },
        {
            function(client)
                return (client:Team() != FACTION_CWU and client:GetTeamClass() != CLASS_CWU_ICT)
            end,
            "Only allow Infestation Control Workers."
        },
        {
            function(client)
                return ix.cityCode.GetCurrent() == "civil" or ix.cityCode.GetCurrent() == "unrest"
            end,
            "Only allow during civil and civil unrest status."
        },
        {
            function(client)
                return ix.cityCode.GetCurrent() == "civil"
            end,
            "Only allow during civil status."
        },
        {
            function(client)
                return true
            end,
            "Never allow citizens."
        },
    }

    function ENT:Use(activator)
        if ((self.nextUse or 0) < CurTime()) then
			if (activator:IsCombineTrusted()) then
				self.nextUse = CurTime() + 0.3
			else
				self.nextUse = CurTime() + 2
			end
        else
            return
        end

        if (activator:IsCombineTrusted()) then
            self:SetMode(self:GetMode() + 1)

            if (self:GetMode() > #MODES) then
                self:SetMode(1)

                self:SetSkin(1)
                self.dummy:SetSkin(1)
                self:EmitSound("ambient/levels/outland/combineshield_deactivate.wav")
                self.dummy:EmitSound("ambient/levels/outland/combineshield_deactivate.wav")

                if (self.idle1) then
                    self.idle1:FadeOut(1)
                end

                if (self.idle2) then
                    self.idle2:FadeOut(1)
                end
            elseif (self:GetMode() == 2) then
                self:SetSkin(0)
                self.dummy:SetSkin(0)
                self:EmitSound("ambient/levels/outland/combineshieldactivate.wav")
                self.dummy:EmitSound("ambient/levels/outland/combineshieldactivate.wav")

                if (!self.idle1) then
                    self.idle1 = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
                    self.idle1:Play()
                    self.idle1:ChangeVolume(0.1, 0)
                else
                    self.idle1:Play()
                    self.idle1:ChangeVolume(0.1, 1)
                end

                if (!self.idle2) then
                    self.idle2 = CreateSound(self.dummy, "ambient/machines/combine_shield_loop3.wav")
                    self.idle2:Play()
                    self.idle2:ChangeVolume(0.1, 0)
                else
                    self.idle1:Play()
                    self.idle2:ChangeVolume(0.1, 1)
                end
            else
                self:EmitSound("buttons/combine_button1.wav", 140, 100 + (self:GetMode() - 1) * 5)
                self.dummy:EmitSound("buttons/combine_button1.wav", 140, 100 + (self:GetMode() - 1) * 5)
            end
            
            activator:Notify("Changed barrier mode to: "..MODES[self:GetMode()][2])

            PLUGIN:SaveForceFields()
        else
            self:EmitSound("ambient/alarms/klaxon1.wav", 80, 80, 0.5)
            self.dummy:EmitSound("ambient/alarms/klaxon1.wav", 80, 80, 0.5)
        end
    end

    hook.Add("ShouldCollide", "ix_forcefields", function(a, b)
        local client
        local entity

        if (a:IsPlayer()) then
            client = a
            entity = b
        elseif (b:IsPlayer()) then
            client = b
            entity = a
        end

        if (IsValid(entity) and entity:GetClass() == "ix_forcefield") then
            if (IsValid(client)) then
                if (client:IsCombine() or client:IsAdministrator()) then
                    return false
                end

                local mode = entity:GetMode() or 1

                return istable(MODES[mode]) and MODES[mode][1](client)
            else
                return entity:GetMode() != 4
            end
        end
    end)
else
    matproxy.Add({
        name = "TextureScroll",
    })

    local SHIELD_MATERIAL = ix.util.GetMaterial("effects/combineshield/comshieldwall3")
    SHIELD_MATERIAL:SetFloat("$alpha", 0.5)
    SHIELD_MATERIAL:SetInt("$ignorez", 1)

    function ENT:Initialize()
        local data = {}
            data.start = self:GetPos() + self:GetRight()*-16
            data.endpos = self:GetPos() + self:GetRight()*-480
            data.filter = self
        local trace = util.TraceLine(data)

        self:EnableCustomCollisions(true)
        self:PhysicsInitConvex({
            vector_origin,
            Vector(0, 0, 150),
            trace.HitPos + Vector(0, 0, 150),
            trace.HitPos
        })
        
        self.distance = self:GetPos():Distance(trace.HitPos)
    end

    function ENT:Draw()
        self:DrawModel()

        if (self:GetMode() == 1) then
            return
        end

        local pos = self:GetPos()
        local angles = self:GetAngles()
        local matrix = Matrix()
        matrix:Translate(self:GetPos() + self:GetUp() * -40)
        matrix:Rotate(angles)

        render.SetMaterial(SHIELD_MATERIAL)

        local dummy = self:GetDummy()

        if (IsValid(dummy)) then
            local dummyPos = dummy:GetPos()
            local vertex = self:WorldToLocal(dummy:GetPos())
            self:SetRenderBounds(vector_origin, vertex + self:GetUp() * 150)

            cam.PushModelMatrix(matrix)
                self:DrawShield(vertex)
            cam.PopModelMatrix()

            matrix:Translate(vertex)
            matrix:Rotate(Angle(0, 180, 0))

            cam.PushModelMatrix(matrix)
                self:DrawShield(vertex)
            cam.PopModelMatrix()
        end
    end

    function ENT:DrawShield(vertex)
        if (self:GetDummy()) then
            local dist = self:GetDummy():GetPos():Distance(self:GetPos())
            local useAlt = false
            local matFac = useAlt and 70 or 45
            local height = useAlt and 3 or 5
            local frac = dist / matFac
            mesh.Begin(MATERIAL_QUADS, 1)
                mesh.Position(vector_origin)
                mesh.TexCoord(0, 0, 0)
                mesh.AdvanceVertex()

                mesh.Position(self:GetUp() * 190)
                mesh.TexCoord(0, 0, height)
                mesh.AdvanceVertex()

                mesh.Position(vertex + self:GetUp() * 190)
                mesh.TexCoord(0, frac, height)
                mesh.AdvanceVertex()

                mesh.Position(vertex)
                mesh.TexCoord(0, frac, 0)
                mesh.AdvanceVertex()
            mesh.End()
        end
    end
end
