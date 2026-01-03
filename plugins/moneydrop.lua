local PLUGIN = PLUGIN

PLUGIN.name = "Drop All Money On Death"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

if ( CLIENT ) then
	return
end

function PLUGIN:DoPlayerDeath(ply, inflicter, attacker)
    local char = ply:GetCharacter()

    if not ( char ) then
        return
    end

    if not ( char:GetMoney() == 0 ) then
        local droppedTokens = ents.Create("ix_money")
        droppedTokens:SetModel(ix.currency.model)
        droppedTokens:SetPos(ply:GetPos())
        droppedTokens:SetAngles(ply:GetAngles())
        droppedTokens:SetAmount(char:GetMoney())
        droppedTokens:Spawn()

        char:SetMoney(0)                                 
    end
end
