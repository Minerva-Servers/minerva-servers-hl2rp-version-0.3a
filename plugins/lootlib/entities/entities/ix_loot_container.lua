local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Loot Container"
ENT.Author = "Riggs"
ENT.Category = "HL2 RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ContainerClass")
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube075x1x075.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:EnableMotion(false)
            phys:Wake()
        end
    end
    
    function ENT:Use(ply, call)
        local char = ply:GetCharacter()
        local inv = char:GetInventory()
        local loot = PLUGIN.containers[self:GetContainerClass()]

        if not ( IsValid(ply) and ply:Alive() and char ) then
            return
        end

        if not ( loot ) then
            return
        end

        if not ( timer.Exists("ixLootSearch."..self:EntIndex()/* .."."..ply:SteamID64() */) ) then
            local lootTime = loot.lootTime

            if ( istable(lootTime) ) then
                lootTime = lootTime[math.random(1, #lootTime)]
            end

            if ( loot.onStart ) then
                loot.onStart(ply, self)
            end

            ply:SetAction("Looting "..loot.name.."...", lootTime)
            ply:DoStaredAction(self, function()
                if not ( IsValid(ply) and ply:Alive() and char ) then
                    return
                end

                local maxItems = 1
                if ( math.random(1, 5) == 1 ) then
                    maxItems = math.random(1, #loot.maxItems)
                end

                for i = 1, maxItems do
                    local item = loot.items[math.random(1, #loot.items)]
                    if ( loot.rareItems and istable(loot.rareItems) ) and ( math.random(1, 5) == 1 ) then
                        item = loot.rareItems[math.random(1, #loot.rareItems)]
                    end

                    if not ( inv:Add(item, amount) ) then
                        ix.item.Spawn(item, ply:GetEyeTrace().Pos)
                    end

                    ply:Notify("You have found: "..ix.item.list[item].name..".")
                end
            end, lootTime, function()
                if ( IsValid(ply) and IsValid(self) ) then
                    ply:SetAction()

                    timer.Remove("ixLootSearch."..self:EntIndex()/* .."."..ply:SteamID64() */)
                    if ( loot.onEnd ) then
                        loot.onEnd(ply, self)
                    end
                    
                    ply:GiveAchievement("firstloot")
                end
            end)

            timer.Simple(lootTime, function()
                if ( IsValid(self) and loot.onEnd ) then
                    loot.onEnd(ply, self)
                end
            end)

            timer.Create("ixLootSearch."..self:EntIndex()/* .."."..ply:SteamID64() */, loot.delay, 1, function()
            end)
        else
            ply:Notify("You must wait "..string.NiceTime(timer.TimeLeft("ixLootSearch."..self:EntIndex()/* .."."..ply:SteamID64() */)).." before you can search this container again.")
        end
    end
end
