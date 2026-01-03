FACTION.name = "Civil Protection"
FACTION.description = "The Civil Protection are the Universal Union's human police force. They are responsible for the enforcement of the Universal Union's laws, and controlling the population. The Civil Protection consists of multiple divisions, each with a specific role. Many join the Civil Protection in hopes of getting better rations, or simply for the power it brings over their fellow citizens."
FACTION.color = Color(20, 120, 180)
FACTION.isDefault = true

FACTION.models = {
    "models/minerva/metrocop.mdl",
}

FACTION.bodyGroups = nil

FACTION.xp = 50

FACTION.rationItems = {"comfort_supplements", "drink_water"}
FACTION.rationMoney = 250

FACTION.ranks = {
    {
        name = "i4",
        description = "i4 happen to be little more than citizens inside of an existing uniform. Most i4 happen to be inside of the process that belongs to receiving basic training as well as happen to be kept within the bounds that belongs to the nexus at every single one times, unless partnered with another unit.",
        health = 0,
        armor = 0,
        xp = 50,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "i3",
        description = "i3 happen to be the last trainee ranks that belongs to the civil protection. They have almost completed basic training, as well as have an existing good knowledge that belongs to civil protection procedure.",
        health = 0,
        armor = 0,
        xp = 110,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "i2",
        description = "i2 have completed civil protection basic training, as well as happen to be ready to begin their official duties. They happen to be the first that belongs to the frontline civil protection forces as well as work with other ground units to perform their duties. They as well as every single one higher units happen to be fitted with biosignals.",
        health = 0,
        armor = 0,
        xp = 320,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "i1",
        description = "i1 have been promoted that was by i2 after proving their competence as well as loyalty to their superiors. i1 happen to be frequently given training inside of advanced techniques, such during the same time that breaching.",
        health = 0,
        armor = 0,
        xp = 500,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "SqL",
        description = "Squad Leaders happen to be civil protection units that have been chosen to join the high command that belongs to the civil protection. They have undergone leadership training as well as happen to be often tasked with commanding small squads that belongs to civil protection officers, as well as training recruits as well as other low ranked units. They have undergone significant memory modification, removing almost every single one negative thoughts about the universal union.",
        health = 0,
        armor = 0,
        xp = 0,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
        end,
        whitelistUID = "SqL",
    },
    {
        name = "DvL",
        description = "The Division Leader happens to be an existing exceptional unit, chosen to become the leader that belongs to an existing particular division. They happen to be responsible that is going to belong to the activities that belongs to every single one units assigned to their division. Often, they is going to select an existing Squad Leader to act during the same time that their second inside of command as well as is going to frequently organise training sessions that is going to belong to their own division.",
        health = 0,
        armor = 0,
        xp = 0,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
        end,
        whitelistUID = "DvL",
    },
    {
        name = "RL",
        description = "Units of this rank are amazing at commanding and being able to command large groups of civil protection with high proficiency. Units usually become Rank Leader if they have amazing commanding abilities and are able to come up with plans to assist in the locating of anti-citizens and usually organize Judgement Waivers. Rank Leaders are rarely seen outside of Plaza and if they are, they are typically highly guarded much like the Commander.",
        health = 0,
        armor = 0,
        xp = 0,
        onBecome = function(ply, char, inv, class)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_stunstick", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
        end,
        whitelistUID = "RL",
    },
    {
        name = "CPC",
        description = "",
        health = 0,
        armor = 0,
        xp = 0,
        onBecome = function(ply, char, inv, rank)
            // this is needed because the rank become code is called after class become code
            timer.Simple(0, function()
                ply:ResetBodygroups()
                ply:StripWeapons()
                ply:SetSkin(0)

                for k, v in pairs({"ix_hands", "ix_keys", "weapon_physgun", "gmod_tool"}) do
                    ply:Give(v)
                end
                
                for k, v in pairs(inv:GetItems()) do
                    if ( v:GetData("equip") ) then
                        v:SetData("equip", nil)
                    end
                    v:Remove()
                end
                
                inv:Add("wep_rappel", 1, {["Restricted"] = true})
                inv:Add("wep_stunstick", 1, {["Restricted"] = true})
                inv:Add("wep_usp", 1, {["Restricted"] = true})
                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            end)
        end,
        whitelistUID = "CPC",
        adminOnly = true,
    },
}

FACTION.classes = {
    {
        name = "Patrol Unit",
        description = "Patrol units happen to be the main patrol force that belongs to the civil protection. Patrol units happen to be often tasked with block searches, patrolling as well as general policing. Inside of the event that belongs to civil unrest they has the ability act during the same time that riot control units. That is going to belong to this reason patrol units happen to be provided the most powerful weaponry out that belongs to every single one divisions.",
        health = 100,
        armor = 0,
        xp = 50,
        model = "models/minerva/metrocop.mdl",
        onBecome = function(ply, char, inv, rank)
            if ( rank.name == "RL" or rank.name == "DvL" or rank.name == "SqL" ) then
                ply:SetSkin(5)

                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            elseif ( rank.name == "i1" ) then
                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            end
        end,
    },
    {
        name = "Medical Unit",
        description = "Medical units happen to be an existing specialist medical division. It happens to be members happen to be fully trained officers, however they have received additional medical training. Medical units happen to be often tasked with acting during the same time that an existing supporting officer inside of an existing patrol or providing medical assistance to injured officers. Due to these requirements medical units carry specialist medical equipment.",
        health = 100,
        armor = 0,
        xp = 200,
        model = "models/minerva/metrocop.mdl",
        skin = 1,
        limit = 0.3,
        onBecome = function(ply, char, inv, rank)
            ply:Give("weapon_medkit")

            if ( rank.name == "RL" or rank.name == "DvL" or rank.name == "SqL" ) then
                ply:SetSkin(5)

                inv:Add("wep_mp5a4", 1, {["Restricted"] = true})
            elseif ( rank.name == "i1" ) then
                inv:Add("wep_mp5a4", 1, {["Restricted"] = true})
            end
        end,
    },
    {
        name = "Technician",
        description = "Technician units happen to be an existing specialist support division. Technician units' job happens to be to support patrol units/patrol teams, this includes activities such during the same time that guarding or blocking public spaces while patrol units conduct an existing search or raid. Technician units happen to be given additional civil unrest training as well as equipment. Furthermore they have the capability to operate remote scanners.",
        health = 100,
        armor = 0,
        xp = 0,
        model = "models/minerva/metrocop.mdl",
        skin = 4,
        onBecome = function(ply, char, inv, rank)
            if ( rank.name == "RL" or rank.name == "DvL" or rank.name == "SqL" ) then
                ply:SetSkin(5)

                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            elseif ( rank.name == "i1" ) then
                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            end
        end,
        whitelistUID = "Technician",
    },
    {
        name = "Reconnaissance",
        description = "Reconnaissance units are tasked with recon of the 404 Zone and other operations. They wield a SPAS-12 Shotgun starting at the rank of i1. Most of the units are handpicked or some have passed training to earn it. Reconnaissance units get much more armor and more combat experience, for situations where it is absolutely required.",
        health = 100,
        armor = 0,
        xp = 0,
        model = "models/minerva/metrocop.mdl",
        skin = 2,
        onBecome = function(ply, char, inv, rank)
            ply:SetBodygroup(1, 1)
            ply:SetBodygroup(4, 1)
            ply:SetBodygroup(6, 1)

            if ( rank.name == "RL" or rank.name == "DvL" or rank.name == "SqL" or rank.name == "i1" ) then
                ply:SetSkin(5)
                ply:SetBodygroup(2, 4)
                ply:SetBodygroup(3, 2)

                inv:Add("wep_spas12", 1, {["Restricted"] = true})
            elseif ( rank.name == "i1" ) then
                ply:SetBodygroup(2, 1)

                inv:Add("wep_mp5a4", 1, {["Restricted"] = true})
            end
        end,
        whitelistUID = "Reconnaissance",
    },
}

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

FACTION.taglines = {
    "DEFENDER",
    "HERO",
    "JURY",
    "KING",
    "LINE",
    "QUICK",
    "ROLLER",
    "STICK",
    "UNION",
    "VICTOR",
    "XRAY",
    "YELLOW",
}

function FACTION:PreBecome(ply, char, factionTable)
    if ( ply:GetCBanTime() ) then
        if ( os.time() > ply:GetCBanTime() ) then
            ply:RemoveCBan()
        end
    end
    
    if ( ply:HasActiveCBan() ) then
        ply:Notify("You are unable to join this team due to you having an active Combine Ban! You are combine banned until - "..ply:GetCBanTimeReal())
        
        return false
    end
    
    return true
end

FACTION_CP = FACTION.index

RANK_CP_I4 = 1
RANK_CP_I3 = 2
RANK_CP_I2 = 3
RANK_CP_I1 = 4
RANK_CP_SQL = 5
RANK_CP_DVL = 6
RANK_CP_RL = 7
RANK_CP_CPC = 8

CLASS_CP_PATROL = 1
CLASS_CP_MEDICAL = 2
CLASS_CP_TECHNICIAN = 3
CLASS_CP_RECONNAISSANCE = 4