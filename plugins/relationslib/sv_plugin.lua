local PLUGIN = PLUGIN

ix.relations.rebelNPCs = {
    ["npc_citizen"] = true,
    ["npc_vortigaunt"] = true,
}

ix.relations.combineNPCs = {
    ["npc_cscanner"] = true,
    ["npc_stalker"] = true,
    ["npc_clawscanner"] = true,
    ["npc_turret_floor"] = true,
    ["npc_combine_camera"] = true,
    ["npc_turret_ceiling"] = true,
    ["npc_metropolice"] = true,
    ["npc_combine_s"] = true,
    ["npc_manhack"] = true,
    ["npc_rollermine"] = true,
    ["npc_strider"] = true,
    ["npc_hunter"] = true,
    ["npc_stalker"] = true,
    ["ix_ranknpc_cp"] = true,
    ["ix_ranknpc_ow"] = true,
}

ix.relations.zombieNPCs = {
    ["npc_zombie"] = true,
    ["npc_fastzombie"] = true,
    ["npc_poisonzombie"] = true,
    ["npc_zombie_torso"] = true,
    ["npc_fastzombie_torso"] = true,
    ["npc_zombine"] = true,
    ["npc_headcrab"] = true,
    ["npc_headcrab_fast"] = true,
    ["npc_headcrab_black"] = true,
    ["npc_barnacle"] = true,
}

ix.relations.antlionNPCs = {
    ["npc_antlion"] = true,
    ["npc_antlionguard"] = true,
    ["npc_antlionguardian"] = true,
    ["npc_antlion_worker"] = true,
    ["npc_antlion_grub"] = true,
}

function ix.relations.UpdateRelationShip(ent)
    for k, v in pairs(player.GetAll()) do
        if ( v:IsCombine() or v:IsAdministrator() or v:IsHunter() ) then
            if ( ix.relations.combineNPCs[ent:GetClass()] and not v:GetCharacter():GetDefunct() ) then
                ent:AddEntityRelationship(v, D_LI, 99)
            elseif ( ix.relations.rebelNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_HT, 99)
            end
        elseif ( v.IsNecrotic and v:IsNecrotic() ) then
            if ( ix.relations.zombieNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_LI, 99)
            else
                ent:AddEntityRelationship(v, D_HT, 99)
            end
        elseif ( v.IsAntlion and v:IsAntlion() ) then
            if ( ix.relations.antlionNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_LI, 99)
            else
                ent:AddEntityRelationship(v, D_HT, 99)
            end
        else
            if ( ix.relations.combineNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_HT, 99)
            elseif ( ix.relations.rebelNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_LI, 99)
            end
        end
    end
end

local npcHealthValues = {
    ["npc_antlionguard"] = 2000,
    ["npc_antlion"] = 150,
    ["npc_hunter"] = 500,
    ["npc_combine_s"] = 160,
    ["npc_metropolice"] = 130,
    ["npc_citizen"] = 100,
    ["npc_zombie"] = 200,
    ["npc_fastzombie"] = 100,
    ["npc_poisonzombie"] = 350,
}
function PLUGIN:OnEntityCreated(ent)
    if not ( ent:IsNPC() ) then
        return
    end

    if ( ent.SetCurrentWeaponProficiency ) then
        ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
    end

    if ( ent.SetHealth and npcHealthValues[ent:GetClass()] ) then
        ent:SetHealth(npcHealthValues[ent:GetClass()])
    end

    ix.relations.UpdateRelationShip(ent)
end

function PLUGIN:PlayerChangedTeam()
    for k, v in pairs(ents.GetAll()) do
        if not ( v:IsNPC() or ix.relations.zombieNPCs[v:GetClass()] or ix.relations.rebelNPCs[v:GetClass()] or ix.relations.combineNPCs[v:GetClass()] ) then
            continue
        end

        ix.relations.UpdateRelationShip(v)
    end
end