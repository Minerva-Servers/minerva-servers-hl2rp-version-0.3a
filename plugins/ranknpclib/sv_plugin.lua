local PLUGIN = PLUGIN

util.AddNetworkString("ixRankNPC.OpenMenu")
util.AddNetworkString("ixRankNPC.OpenMenuNoClose")

function PLUGIN:SaveRankNPCs()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_ranknpc_*")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel(), v:GetClass()}
    end

    ix.data.Set("rankNPCs", data)
end

function PLUGIN:LoadRankNPCs()
    for _, v in ipairs(ix.data.Get("rankNPCs") or {}) do
        local rankNPCs = ents.Create(v[4])

        rankNPCs:SetPos(v[1])
        rankNPCs:SetAngles(v[2])
        rankNPCs:SetModel(v[3])
        rankNPCs:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveRankNPCs()
end

function PLUGIN:LoadData()
    self:LoadRankNPCs()
end

function ix.rankNPC.Become(ply, classID, rankID, bShouldBypass, bShouldRefill, bShouldPlayNoSound, tagline)
    local oldClassID = ply:GetTeamClass()
    local oldRankID = ply:GetTeamRank()

    local char = ply:GetCharacter()

    local classes = ix.faction.Get(ply:Team()).classes
    local ranks = ix.faction.Get(ply:Team()).ranks

    local class = classes[classID]
    local rank = ranks[rankID]

    if not ( bShouldBypass ) then
        if not ( ply:CanBecomeTeamClass(classID, true) ) then
            return
        end

        if ( rankID ) then
            if not ( ply:CanBecomeTeamRank(rankID, true) ) then
                return
            end
        end
    end

    if ( class.name == "Super" and rank and rank.name == "OWS" ) then
        ply:Notify("You cannot become an OWS in the Super class!")
        return false
    end

    if ( rankID ) then
        ix.log.AddRaw(ply:Nick().." switched to "..class.name.." "..rank.name.."!")
        Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." switched to "..class.name.." "..rank.name.."!", Schema.discordLogWebhook)
    else
        ix.log.AddRaw(ply:Nick().." switched to "..class.name.."!")
        Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." switched to "..class.name.."!", Schema.discordLogWebhook)
    end

    local model = class.model or table.Random(ix.faction.Get(ply:Team()).models)
    if ( string.find(model, "/hl2rp/") ) then
        model = char:GetData("originalModel", table.Random(ix.faction.Get(ply:Team()).models))
    end

    local health = (class.health or 100) + (rank and rank.health or 0)
    local armor = (class.armor or 0) + (rank and rank.armor or 0)
    local skin = class.skin or 0
    local onBecomeRank = rank and rank.onBecome or nil
    local onBecomeClass = class.onBecome or nil

    local randomNumber = Schema:ZeroNumber(math.random(1, 9999), 4)
    local randomTagline = tagline or table.Random(ix.faction.Get(ply:Team()).taglines or {})

    local newName = nil
    if ( ply:IsCP() ) then
        newName = ix.config.Get("cityIndex")..".CP:"..randomTagline.."-"..rank.name.."-"..randomNumber
    elseif ( ply:IsOW() ) then
        newName = ix.config.Get("sectorIndex")..".OW:"..randomTagline.."-"..rank.name.."-"..randomNumber
    end

    if not ( bShouldRefill ) then
        ply:ResetBodygroups()
        
        if ( newName ) then
            char:SetName(newName)
        end
        
        if not ( bShouldPlayNoSound ) then
            ply:EmitSound("minerva/global/clothingunequip.mp3")
            
            timer.Simple(0.6, function()
                if ( IsValid(ply) ) then
                    ply:EmitSound("minerva/global/clothingequip.mp3")
                end
            end)
        end

        if ( model ) then
            char:SetModel(model)
        end

        if ( skin ) then
            ply:SetSkin(skin)
        end

        for i = 0, 10 do
            ply:SetSubMaterial(i, "")
        end

        for k, v in pairs(char:GetInventory():GetItems()) do
            if ( v:GetData("equip") ) then
                v:SetData("equip", nil)
            end
            v:Remove()
        end
        
        ply.carryWeapons = {}

        ply:StripWeapons()
        ply:StripAmmo()
    else
        if not ( bShouldPlayNoSound ) then
            ply:EmitSound("minerva/hl2rp/miscellaneous/battery_pickup.wav")
            
            timer.Simple(0.6, function()
                if ( IsValid(ply) ) then
                    ply:EmitSound("minerva/hl2rp/miscellaneous/ez1_nvg.wav")
                end
            end)
        end
    end

    ply:SetHealth(health)
    ply:SetArmor(armor)

    ply:SetMaxHealth(ply:Health())
    ply:SetMaxArmor(ply:Armor())
    
    if not ( bShouldRefill ) then
        if ( onBecomeRank ) then
            onBecomeRank(ply, char, char:GetInventory(), class)
        end

        if ( onBecomeClass ) then
            onBecomeClass(ply, char, char:GetInventory(), rank)
        end

        for k, v in pairs({"ix_hands", "ix_keys", "weapon_physgun", "gmod_tool"}) do
            ply:Give(v)
        end

        ply:SetNetVar("ixClass", classID)
        ply:SetNetVar("ixRank", rankID)
    end

    ply:SetupHands()
    ply:AllowFlashlight(true)

    hook.Run("PlayerChangedClass", ply, oldClassID, classID)
    hook.Run("PlayerChangedRank", ply, oldRankID, rankID)
end

util.AddNetworkString("ixRankNPC.Become")
net.Receive("ixRankNPC.Become", function(len, ply)
    if ( ( ply.ixRankNPCdelay or 0 ) >= CurTime() ) then
        ply:Notify("You need to wait before switching classes or ranks!")
        return
    end

    local classID = net.ReadUInt(8)
    local rankID = net.ReadUInt(8)
    local tagline = net.ReadString()

    if ( tagline == "" ) then
        tagline = nil
    end

    ix.rankNPC.Become(ply, classID, rankID, false, false, false, tagline)

    local delay = 30
    if ( ply:IsAdmin() ) then
        delay = 3
    end

    ply.ixRankNPCdelay = CurTime() + delay
end)

util.AddNetworkString("ixRankNPC.BecomeNoRank")
net.Receive("ixRankNPC.BecomeNoRank", function(len, ply)
    if ( ( ply.ixRankNPCdelay or 0 ) >= CurTime() ) then
        ply:Notify("You need to wait before switching classes!")
        return
    end

    local classID = net.ReadUInt(8)
    local tagline = net.ReadString()

    if ( tagline == "" ) then
        tagline = nil
    end
    
    ix.rankNPC.Become(ply, classID, nil, false, false, false, tagline)

    local delay = 30
    if ( ply:IsAdmin() ) then
        delay = 3
    end

    ply.ixRankNPCdelay = CurTime() + delay
end)

util.AddNetworkString("ixRankNPC.Refill")
net.Receive("ixRankNPC.Refill", function(len, ply)
    if ( ( ply.ixRankNPCRefilldelay or 0 ) >= CurTime() ) then
        ply:Notify("You need to wait before refilling!")
        return
    end

    ix.rankNPC.Become(ply, ply:GetTeamClass(), ply:GetTeamRank(), nil, true)

    local delay = 10
    if ( ply:IsAdmin() ) then
        delay = 1
    end

    ply.ixRankNPCRefilldelay = CurTime() + delay
end)