FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "The Overwatch Transhuman Arm are the military wing of the Universal Union's forces. They are highly trained and extensively modified super soldiers, far stronger than any normal human. They are entirely without fear or emotion of any kind, called on to the streets only when circumstances are at their most dire. Otherwise, they remain in the Nexus or guarding hardpoints around the city. They are completely obedient to their commander, following orders without regard to their own safety. Operating in small squads, the Overwatch Transhuman Arm are a force to be reckoned with, and haunt the dreams of any citizen with common sense."
FACTION.color = Color(150, 50, 50)
FACTION.isDefault = true

FACTION.models = {
    "models/player/soldier_stripped.mdl",
}

FACTION.bodyGroups = nil

FACTION.xp = 500

FACTION.rationItems = {"comfort_supplements", "drink_water"}
FACTION.rationMoney = 300

FACTION.ranks = {
    {
        name = "OWS",
        description = "",
        health = 0,
        armor = 0,
        xp = 500,
    },
    {
        name = "EOW",
        description = "",
        health = 20,
        armor = 0,
        xp = 1500,
    },
    {
        name = "LDR",
        description = "",
        health = 40,
        armor = 0,
        xp = 0,
        whitelistUID = "LDR",
    },
    {
        name = "ODL",
        description = "",
        health = 60,
        armor = 0,
        xp = 0,
        whitelistUID = "ODL",
    },
    {
        name = "CPT",
        description = "",
        health = 0,
        armor = 0,
        xp = 0,
        model = "models/minerva/combine_commander.mdl",
        onBecome = function(ply, char, inv, rank)
            // this is needed because the rank become code is called after class become code
            timer.Simple(0, function()
                ply:ResetBodygroups()
                ply:StripWeapons()
                ply:SetSkin(0)
                ply:SetHealth(160)
                ply:SetMaxHealth(160)

                ply:SetModel("models/minerva/combine_commander.mdl")
                
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
                inv:Add("wep_spas12", 1, {["Restricted"] = true})
                inv:Add("wep_ar2", 1, {["Restricted"] = true})
                inv:Add("wep_grenade", 3, {["Restricted"] = true})
            end)
        end,
        whitelistUID = "CPT",
        adminOnly = true,
    },
}

FACTION.classes = {
    {
        name = "Soldier",
        description = "Soldier units are highly trained medium-range combat units. Soldier units are a jack of all trades, master of none. They have access to a mix of close and medium range weaponry.",
        health = 120,
        armor = 0,
        xp = 500,
        model = "models/minerva/combine_soldier.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})

            if ( rank.name == "EOW" or rank.name == "LDR" ) then
                inv:Add("wep_ar2", 1, {["Restricted"] = true})
            else
                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            end

            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "Shotgunner",
        description = "Shotgunner units are close-quaters engagement specialists. They are ineffective at medium and long ranges however they excel at close-quaters due to their SPAS-12 shotgun and heavy armour. Shotgunner units are un-efficient at performing raids and bruteforcing into enemy strongholds. Their strenght is to crouch down and shoot their targets.",
        health = 120,
        armor = 0,
        xp = 1000,
        model = "models/minerva/combine_shotgunner.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
            inv:Add("wep_spas12", 1, {["Restricted"] = true})
            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "Prisonguard",
        description = "Prisonguards are charged with guarding, manning and maintaining prisons of Universal Union facilities. In the detention, they are in charge. And when someone escapes, they are at fault.",
        health = 120,
        armor = 0,
        xp = 1200,
        model = "models/minerva/combine_guard.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel")

            if ( rank.name == "LDR" ) then
                ply:SetSkin(1)
                inv:Add("wep_spas12", 1, {["Restricted"] = true})
            elseif ( rank.name == "EOW" ) then
                inv:Add("wep_ar2", 1, {["Restricted"] = true})
            else
                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            end

            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "Supplier",
        description = "Supplier's are basic Overwatch Soldiers which are allowed to carry a lot more ammo than usual, they can also deploy Turrets and Manhacks during the field. It would not be recommended to bring them to the front of the fights. Although they are very effective in the background. Their weaponry are limited to a H&K MP7 most of the time.",
        health = 120,
        armor = 0,
        xp = 2300,
        model = "models/minerva/combine_beta.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
            inv:Add("wep_mp7", 1, {["Restricted"] = true})
            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "Medic",
        description = "The Medic is one of the most valuable assets in the Overwatch Transhuman Arm as they have the ability to heal other Overwatch Units in battle and aswell as anywhere else. They are equipped with a H&K MP7 but they are able to switch to their SPAS-12 at any time if the wish so. Although they do not carry any grenades on themselves, they have a medical kit to heal other Units. As a downside their armor is very weak.",
        health = 120,
        armor = 0,
        xp = 3800,
        model = "models/minerva/combine_medic.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            ply:Give("weapon_medkit")

            inv:Add("wep_usp", 1, {["Restricted"] = true})
            inv:Add("wep_mp7", 1, {["Restricted"] = true})
            inv:Add("wep_spas12", 1, {["Restricted"] = true})
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
        end,
    },
    {
        name = "Sniper",
        description = "Sniper units are hand-picked from the units in overwatch. They are specialists in long range engagements with the advanced EVR scope attached to their Pulse Sniper. They also have the flexibility to remove this scope to fight efficiently in medium range engagements too. Sniper units are often considered overwatch's greatest strategic asset.",
        health = 120,
        armor = 0,
        xp = 0,
        model = "models/minerva/combine_recon.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_usp", 1, {["Restricted"] = true})
            inv:Add("wep_mp7", 1, {["Restricted"] = true})
            inv:Add("wep_sniper", 1, {["Restricted"] = true})
            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
        whitelistUID = "Sniper",
    },
    {
        name = "Infestation Response",
        description = "Infestation Response Unit's are a downgraded version of the regular Soldier. They are only requiered in situations such as Exogen breaches and 404 Zone Sweeps with the Infestation Control Team. They carry a MP7 with them at all times and rappelling gear.",
        health = 100,
        armor = 0,
        xp = 0,
        model = "models/minerva/combine_infestation.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})

            if ( rank.name == "ODL" ) then
                ply:SetModel("models/minerva/combine_ordinal.mdl")

                inv:Add("wep_ar2", 1, {["Restricted"] = true})
            elseif ( rank.name == "LDR" ) then
                ply:SetSkin(1)

                inv:Add("wep_ar2", 1, {["Restricted"] = true})
            else
                inv:Add("wep_mp7", 1, {["Restricted"] = true})
            end
            
            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
        whitelistUID = "InfestationResponse",
    },
    {
        name = "Infestation Sweeper",
        description = "Infestation Sweeprs are specialized unit's in the infestation response regiment, they are tasked with the same objectives and are more common to be seen helping the infestation control members personally rather than the normal units protecting them. They get an extra grenade. Infestation Sweepers are also allowed to enter the outlands and deal the same situations but jsut in the outlands. Normal Infestation Units may not enter the outlands without approval of a Infestation Sweeper Ordinal.",
        health = 120,
        armor = 0,
        xp = 0,
        model = "models/minerva/combine_infestation.mdl",
        skin = 2,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            
            if ( rank.name == "ODL" ) then
                ply:SetModel("models/minerva/combine_ordinal.mdl")
                ply:SetSkin(1)

                inv:Add("wep_ar2", 1, {["Restricted"] = true})
            else
                inv:Add("wep_mp5a4", 1, {["Restricted"] = true})
            end

            inv:Add("wep_grenade", 2, {["Restricted"] = true})
        end,
        whitelistUID = "InfestationSweeper",
    },
    {
        name = "Super",
        description = "Super soldiers are the best of the best in the Overwatch Arsenal, they are equipped with a Pulse-Rifle or sometimes a SPAS-12. They've gone through so much advanced firearms training that no human can beat theam in a 1 to 1 combat. Their loyalty and advanced training allows them to lead any specific Overwatch Unit at any given time. You do not want to face them up close.",
        health = 140,
        armor = 0,
        xp = 0,
        model = "models/minerva/combine_elite.mdl",
        skin = 0,
        onBecome = function(ply, char, inv, rank)
            inv:Add("wep_rappel", 1, {["Restricted"] = true})
            inv:Add("wep_ar2", 1, {["Restricted"] = true})
            inv:Add("wep_grenade", 1, {["Restricted"] = true})
        end,
        whitelistUID = "Super",
    },
}

function FACTION:PreBecome(ply, char, factionTable)
    if ( ix.config.Get("overwatchBalance") ) then
        local amount = 3
        
        if ( ix.cityCode.GetCurrent() != "civil" ) then
            amount = 2
        end

        local cpCount = team.NumPlayers(FACTION_CP)
        local otaCount = team.NumPlayers(FACTION_OW)
        local canBe = math.floor(cpCount / amount)

        if ( otaCount >= canBe ) then
            ply:Notify("There needs to be more Civil Protection Online to be able to join this Faction!")
            return false
        end
    end
    
    if ( ply:GetCBanTime() ) then
        if ( os.time() > ply:GetCBanTime() ) then
            ply:RemoveCBan()
        end
    end
    
    if ( ply:HasActiveCBan() ) then
        ply:Notify("You are unable to join this team due to you having an active Combine Ban! You are combine banned until - "..ply:GetCBanTimeReal())
        
        return false
    end
end

function FACTION:OnSpawn(ply)
    timer.Simple(0, function()
        if not ( IsValid(ply) and ply:GetCharacter() ) then
            return
        end
        
        ply:SetModelScale(1.05)
        ply:SetViewOffset(Vector(0, 0, 68))
    end)
end

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

FACTION.taglines = {
    "FLUSH",
    "RANGER",
    "HUNTER",
    "BLADE",
    "SCAR",
    "HAMMER",
    "SWEEPER",
    "SWIFT",
    "FIST",
    "SWORD",
    "SAVAGE",
    "TRACKER",
    "SLASH",
    "RAZOR",
    "STAB",
    "SPEAR",
    "STRIKER",
    "DAGGER",
}

FACTION_OW = FACTION.index

RANK_OW_OWS = 1
RANK_OW_EOW = 2
RANK_OW_LDR = 3
RANK_OW_ORD = 4
RANK_OW_CPT = 5

CLASS_OW_SOLDIER = 1
CLASS_OW_SHOTGUNNER = 2
CLASS_OW_GUARD = 3
CLASS_OW_SUPPLIER = 4
CLASS_OW_MEDICAL = 5
CLASS_OW_SNIPER = 6
CLASS_OW_INFESTATION = 7
CLASS_OW_SUPER = 8