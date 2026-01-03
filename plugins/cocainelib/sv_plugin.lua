local PLUGIN = PLUGIN

--[[---------------------------------------------------------------------------
    PLUGIN Functionality
---------------------------------------------------------------------------]]--

function PLUGIN.BecomeCracked(ply)
    ply.originalHealth = ply:Health()
    ply:GetCharacter():SetData("ixHigh", true)
    ply:SetHealth(ply:GetMaxHealth() * 2)
    ply:SurfacePlaySound("ambient/levels/labs/teleport_rings_loop2.wav")

    timer.Create("ixCocaineCrackedAmbienceTimer."..ply:SteamID64(), 5, 1, function()
        ply:SurfacePlaySound("ambient/levels/labs/teleport_mechanism_windup"..math.random(1, 5)..".wav")
    end)

    timer.Create("ixCocaineCrackedTimer."..ply:SteamID64(), 240, 1, function()
        PLUGIN.BecomeUnCracked(ply, true)
    end)
end

function PLUGIN.BecomeUnCracked(ply, bNotDead)
    ply:GetCharacter():SetData("ixHigh", false)

    ply:StopSound("ambient/levels/labs/teleport_rings_loop2.wav")
    if ( bNotDead ) then
        ply:SetHealth(ply.originalHealth)
        ply:TakeDamage(math.random(5, 15))
    end
end

function PLUGIN:DoPlayerDeath(ply)
    PLUGIN.BecomeUnCracked(ply, false)
    timer.Remove("ixCocaineCrackedAmbienceTimer."..ply:SteamID64())
    timer.Remove("ixCocaineCrackedTimer."..ply:SteamID64())
end

PLUGIN.PotThink = true

function PLUGIN:PotThink(ent)
    local cleaned = ent:GetNWInt("cleaned")
    local ingnited = ent:GetNWBool("ingnited")
    local maxAmount = ent:GetNWInt("max_amount")
    if ent.nextTick < CurTime() then
        local temp = ent:GetNWInt("temperature")

        if ingnited and cleaned == maxAmount then
            ent:SetNWInt("temperature", temp+math.random(1,2))
            ent:PlaySound()
        end
        ent.nextTick = CurTime() + 1
        ent:SetNWBool("ingnited", false)
        if !ingnited then
            ent:StopPlay()
        end

        if !ingnited and temp > PLUGIN.Pot.Temperature then
            ent:SetNWInt("temperature", temp-math.random(0,1))
        end

        if temp > PLUGIN.Pot.ExplodeTemperature then
            ent:StopPlay()
            ent:Explode()
        end
    end
end

PLUGIN.StoveThink = true

function PLUGIN:StoveThink(ent)
    local Ang = ent:GetAngles()
    Ang:RotateAroundAxis(Ang:Forward(), 90)

    local poses
    if ( PLUGIN.CustomModels ) and ( PLUGIN.CustomModels.Stove ) then
        poses = {[1] = ent:GetPos()+Ang:Right()*-3.8+Ang:Forward()*-0.255+Ang:Up()*1.82}
    else
        poses = {
            [1] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*-9.75+Ang:Up()*11.5,
            [3] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*2.75+Ang:Up()*11.5,
            [2] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*-9.75+Ang:Up()*-11.2,
            [4] = ent:GetPos()+Ang:Right()*-19.8+Ang:Forward()*2.75+Ang:Up()*-11.2
        }
    end

    local plates = {
        [1] = ent:GetNWBool("left-top"),
        [2] = ent:GetNWBool("right-top"),
        [3] = ent:GetNWBool("left-bottom"),
        [4] = ent:GetNWBool("right-bottom"),
    }
    
    local unabled = 0
    for k, v in pairs(plates) do
        if v then
            unabled = unabled + 1
            local pos = poses[k]
            local entities = ents.FindInSphere(pos,2)
            for k2, ent in pairs(entities) do
                local class = ent:GetClass()

                if class == "ecl_pot" then
                    ent:SetNWBool("ingnited", true)
                end
            end
        end
    end

    if unabled > 0 then
        local gas = ent:GetNWInt("gas")
        if gas > 0 then
            ent:SetNWInt("gas", math.Round(gas - 1.5*unabled))
        else
            ent:SetNWBool("left-top", false)
            ent:SetNWBool("left-bottom", false)
            ent:SetNWBool("right-top", false)
            ent:SetNWBool("right-bottom", false)
            if (PLUGIN.CustomModels) and (PLUGIN.CustomModels.Stove) then
                ent:SetBodygroup(2, 1)
            end
        end
    end
end

timer.Simple(10, function()
    local filepathes = {
            "models/srcocainelab/portablestove.mdl",
            "models/srcocainelab/gascan.mdl",
            "models/srcocainelab/cocainebrick.mdl",
            "models/srcocainelab/cocaplant.mdl",
            "models/srcocainelab/cocaplant_nopot.mdl"
    }

    for k, v in pairs(filepathes) do
        if !util.IsValidModel(v) then
            if id then
                PLUGIN:Log("Warning! Model '"..v.." isn't loaded.")
            end
        end
    end
end)

function PLUGIN:CanPlayerHoldObject(ply, ent)
    if ( string.find(ent:GetClass(), "ecl_*") ) then
        return true
    end
end