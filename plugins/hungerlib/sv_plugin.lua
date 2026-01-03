local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if ( char ) and ( timer.Exists(char:GetID()..".HungerTimer") ) then
        timer.Remove(char:GetID()..".HungerTimer")
    end

    if ( oldChar ) and ( timer.Exists(oldChar:GetID()..".HungerTimer") ) then
        timer.Remove(oldChar:GetID()..".HungerTimer")
    end

    timer.Simple(0, function()
        if not ( ply:IsValid() and ply:Alive() and char ) then
            return
        end
        
        if ( PLUGIN.factionIgnore[char:GetFaction()] ) or ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
            return
        end

        timer.Create(char:GetID()..".HungerTimer", ix.config.Get("hungerTime", 120), 0, function()
            if not ( ply:IsValid() and ply:Alive() and char ) then
                return
            end

            if ( PLUGIN.factionIgnore[char:GetFaction()] ) or ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
                return
            end

            if ( char:GetHunger() == 0 ) then
                ply:TakeDamage(5)
                ply:EmitSound("npc/barnacle/barnacle_digesting"..math.random(1,2)..".wav", 50, 100, 0.5)
                ply:Notify("You are starving!")
            else
                local amount = 1
                if ( ply:KeyDown(IN_SPEED) ) then
                    amount = amount * 2
                end
                char:SetHunger(math.Clamp(char:GetHunger() - amount, 0, 100))
            end
        end)
    end)
end

function PLUGIN:PlayerDisconnected(ply)
    local char = ply:GetCharacter()
    if ( char ) and ( timer.Exists(char:GetID()..".HungerTimer") ) then
        timer.Remove(char:GetID()..".HungerTimer")
    end
end

-- disabled feature
/*
function PLUGIN:OnPlayerHitGround(ply)
    local char = ply:GetCharacter()
    if not ( ply:IsValid() and ply:Alive() and char ) then return end
    if ( PLUGIN.factionIgnore[char:GetFaction()] ) or ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end
    
    if ( math.random(1, 20) == math.random(1, 20) ) then
        if not ( char:GetHunger() == 0 ) then
            char:SetHunger(char:GetHunger() - 1)
            ply:Notify("You lost some hunger due to your landing!")
        end
    end
end
*/