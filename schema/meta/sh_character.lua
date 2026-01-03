local CHAR = ix.meta.character

function CHAR:IsCP()
    return self:GetFaction() == FACTION_CP
end

function CHAR:IsOW()
    return self:GetFaction() == FACTION_OW
end

function CHAR:IsCombine()
    return self:IsCP() or self:IsOW()
end

function CHAR:IsAdministrator()
    return self:GetFaction() == FACTION_ADMINISTRATOR
end

function CHAR:IsVortigaunt()
    return self:GetFaction() == FACTION_VORTIGAUNT
end

function CHAR:IsCombineCommand()
    if ( self:IsCP() and ( self:GetPlayer():GetTeamRank() >= RANK_CP_SQL ) ) then
        return true
    end

    if ( self:IsOW() and self:GetPlayer():GetTeamRank() == RANK_OW_LDR ) then
        return true
    end

    return false
end

function CHAR:IsCombineSupervisor()
    if ( self:IsCP() and self:GetPlayer():GetTeamRank() >= RANK_CP_RL ) then
        return true
    end

    if ( self:IsOW() and self:GetPlayer():GetTeamClass() == CLASS_COMMANDER ) then
        return true
    end

    return false
end