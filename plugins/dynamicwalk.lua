local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Dynamic Walk"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

if ( CLIENT ) then
    return
end

function PLUGIN:Move(ply, mv)
    local walkSpeed = ix.config.Get("walkSpeed")
    local runSpeed = ix.config.Get("runSpeed")

    if ( IsValid(ply) and ply:GetCharacter() ) then
        if ( ply.IsArrested and ply:IsArrested() ) then
            walkSpeed = ix.config.Get("walkSpeed") - 10
            runSpeed = ix.config.Get("walkSpeed") - 10
        end

        if ( ply:GetCharacter():GetData("ixHigh") ) then
            walkSpeed = ix.config.Get("walkSpeed") + 10
            runSpeed = ix.config.Get("runSpeed") + 30
        end

        if ( ply.IsNecrotic and ply:IsNecrotic() ) then
            if ( ply:GetTeamClass() == CLASS_NECROTIC_FAST ) then
                walkSpeed = ix.config.Get("walkSpeed") - 5
                runSpeed = ix.config.Get("runSpeed") + 80
            elseif ( ply:GetTeamClass() == CLASS_NECROTIC_SOLDIER ) then
                walkSpeed = ix.config.Get("walkSpeed") - 20
                runSpeed = ix.config.Get("runSpeed") - 20
            else
                walkSpeed = ix.config.Get("walkSpeed") - 15
                runSpeed = ix.config.Get("walkSpeed") - 15
            end
        end

        if ( ply.IsHunter and ply:IsHunter() ) then
            walkSpeed = ix.config.Get("walkSpeed") + 25
            runSpeed = ix.config.Get("runSpeed") + 150
        end

        if ( ply.IsAntlion and ply:IsAntlion() ) then
            walkSpeed = ix.config.Get("walkSpeed") + 25
            runSpeed = ix.config.Get("runSpeed") + 100
        end
    end

    ply:SetDuckSpeed(0.4)
    ply:SetUnDuckSpeed(0.4)
    ply:SetSlowWalkSpeed(70)
    ply:SetCrouchedWalkSpeed(0.7)

    if ( ( ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) ) and ply:KeyDown(IN_MOVELEFT) ) then
        walkSpeed = walkSpeed - 10
        runSpeed = runSpeed - 15
    elseif ( ( ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) ) and ply:KeyDown(IN_MOVERIGHT) ) then
        walkSpeed = walkSpeed - 10
        runSpeed = runSpeed - 15
    elseif ( ply:KeyDown(IN_FORWARD) and not ( ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) ) ) then
        walkSpeed = walkSpeed
        runSpeed = runSpeed
    elseif ( ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) ) then
        walkSpeed = walkSpeed - 5
        runSpeed = runSpeed - 10
    elseif ( ply:KeyDown(IN_BACK) ) then
        walkSpeed = walkSpeed - 20
        runSpeed = runSpeed - 20
    end

    ply:SetWalkSpeed(walkSpeed)
    ply:SetRunSpeed(runSpeed)
end
