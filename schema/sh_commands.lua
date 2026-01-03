local function ToggleGate(ply, v)
    if ( v.moving ) then
        ply:Notify("The Gate is already moving!")
        return
    end

    if ( !v.opened ) then
        v:Fire("SetAnimation", "open")
        v:EmitSound("ambient/machines/wall_move1.wav", 120)

        v:EmitSound("ambient/alarms/combine_bank_alarm_loop4.wav", 120, 70)

        timer.Simple(4, function()
            v:StopSound("ambient/alarms/combine_bank_alarm_loop4.wav")
        end)

        timer.Simple(2.5, function()
            v:EmitSound("plats/hall_elev_stop.wav", 120)
            v.moving = false
        end)

        ply:Notify("The Gate is now opening!")

        v.opened = true
        v.moving = true
    else
        v:Fire("SetAnimation", "close")
        v:EmitSound("ambient/machines/wall_move2.wav", 120)

        v:EmitSound("ambient/alarms/combine_bank_alarm_loop4.wav", 120, 70)

        timer.Simple(8, function()
            v:StopSound("ambient/alarms/combine_bank_alarm_loop4.wav")
        end)

        timer.Simple(5, function()
            v:EmitSound("plats/tram_hit4.wav", 120)
            v.moving = false
        end)

        ply:Notify("The Gate is now closing!")

        v.opened = false
        v.moving = true
    end
end

ix.command.Add("CharFallOver", {
    description = "@cmdCharFallOver",
    arguments = bit.bor(ix.type.number, ix.type.optional),
    OnRun = function(self, client, time)
        if (!client:Alive() or client:GetMoveType() == MOVETYPE_NOCLIP) then
            return "@notNow"
        end

        if (client:GetNetVar("actEnterAngle")) then
            return "@notNow"
        end

        if (time and time > 0) then
            time = math.Clamp(time, 1, 60)
        end

        if (!IsValid(client.ixRagdoll)) then
            client:SetRagdolled(true, time)
        end
    end
})

ix.command.Add("Shove", {
    description = "",
    OnRun = function(self, ply)
        if not ( ply:IsOW() ) then
            return false, "You need to be an Overwatch Unit to run this command."
        end

        local ent = ply:GetEyeTraceNoCursor().Entity

        if not ( ent:IsPlayer() ) then 
            return false, "You must be looking at someone!"    
        end

        if ( ent and ent:GetPos():Distance(ply:GetPos()) >= 50 ) then
            return false, "You need to be close to your target!"
        end 

        ply:ForceSequence("melee_gunhit", function()
            if ( IsValid(ent) and IsValid(ply) ) then
                ply:EmitSound("physics/body/body_medium_impact_hard6.wav")
                ent:SetRagdolled(true, ix.config.Get("shoveTime", 20))
            end
        end, 0.3)
        ent:SetVelocity(ply:GetAimVector() * 512)
    end,
})

ix.command.Add("ChangeRoleplayName", {
    description = "Change your roleplay name, but as a cost of 25 XP.",
    arguments = {
        ix.type.text,
    },
    OnCheckAccess = function(self, ply)
        return ply:Team() == FACTION_CITIZEN or ply:Team() == FACTION_CWU
    end,
    OnRun = function(self, ply, newName)
        if ( string.len(newName) <= 4 ) then
            ply:Notify("Your new name is too short!")
            return
        end

        if ( string.len(newName) >= 32 ) then
            ply:Notify("Your new name is too long!")
            return
        end

        local char = ply:GetCharacter()
        char:SetName(newName)
        char:SetData("originalName", newName)
        ply:Notify("You changed your roleplay name to "..newName..".")
    end,
})

ix.command.Add("ForceRoleplayName", {
    description = "Forcefully change a roleplay name of someone.",
    arguments = {
        ix.type.player,
        ix.type.text,
    },
    OnCheckAccess = function(self, ply)
        return ply:IsAdmin()
    end,
    OnRun = function(self, ply, target, newName)
        target:GetCharacter():SetName(newName)
        target:GetCharacter():SetData("originalName", newName)

        ply:Notify("You forced "..target:Nick().." to change their roleplay name to "..newName..".")
        target:Notify("You were forced to change your roleplay name to "..newName..".")
    end,
})

ix.command.Add("SetPermaModel", {
    description = "Set a player's permanent model.",
    arguments = {
        ix.type.player,
        ix.type.text,
    },
    OnCheckAccess = function(self, ply)
        return ply:IsAdmin()
    end,
    OnRun = function(self, ply, target, newModel)
        target:GetCharacter():SetModel(newModel)
        target:GetCharacter():SetData("originalModel", newModel)

        ply:Notify("You set "..target:Nick().."'s permanent model to "..newModel..".")
    end,
})

ix.command.Add("KickDoor", {
    OnRun = function(self, ply)
        local ent = ply:GetEyeTrace().Entity

        if ( ( ply.nextKickdoor or 0 ) > CurTime() ) then return end

        if not ( ix.anim.GetModelClass(ply:GetModel()) == "metrocop" ) then
            ply:Notify("Your model is not allowed to use this command!")
            return
        end

        if ( ent:GetClass() == "func_door" ) then
            return ply:Notify("You cannot kick down these type of doors!")
        end

        if not ( IsValid(ent) and ent:IsDoor() ) or ent:GetNetVar("disabled") then
            return ply:Notify("You are not looking at a door!")
        end

        if not ( ply:GetPos():Distance(ent:GetPos()) < 100 ) then
            return ply:Notify("You are not close enough!")
        end

        if ( IsValid(ent.ixLock) ) then
            ply:Notify("You cannot kick down a combine lock!")
            return false
        end        

        ply:ForceSequence("kickdoorbaton", function()
            if ( IsValid(ply) ) then
                ply:Freeze(false)
            end
        end, 1.7)
        
        timer.Simple(1, function()
            if ( IsValid(ent) ) then 
                ent:EmitSound("physics/wood/wood_plank_break1.wav", 100)
                ent:Fire("setspeed", 350)
                ent:Fire("unlock")
                ent:Fire("openawayfrom", ply:SteamID64())

                timer.Simple(0.5, function()
                    if ( IsValid(ent) ) then
                        ent:Fire("setspeed", 120)
                    end
                end)
            end
        end)

        ply.nextKickdoor = CurTime() + 2
    end,
})

ix.command.Add("Discord", {
    description = "Join our Discord Server!",
    OnRun = function(self, ply)
        ply:SendLua([[gui.OpenURL("]]..ix.config.Get("discordURL")..[[")]])
    end,
})

ix.command.Add("Content", {
    description = "View our server content!",
    OnRun = function(self, ply)
        ply:SendLua([[gui.OpenURL("]]..ix.config.Get("contentURL")..[[")]])
    end,
})

ix.command.Add("Rules", {
    description = "View our server rules!",
    OnRun = function(self, ply)
        ply:SendLua([[gui.OpenURL("]]..ix.config.Get("rulesURL")..[[")]])
    end,
})

ix.command.Add("Apply", {
    description = "Tell your name.",
    OnRun = function(self, ply)
        ix.chat.Send(ply, "me", "shows their ID card, it reads the name "..ply:Nick())
    end,
})

ix.command.Add("Search", {
    description = "Search the person tied infront of you.",
    OnRun = function(self, ply)
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() and target:IsArrested() ) then
            if not ( ply:IsArrested() ) then
                Schema:SearchPlayer(ply, target)
            else
                return "@notNow"
            end
        end
    end,
})

ix.command.Add("Request", {
    description = "Request local civil protection teams towards your location.",
    arguments = {
        bit.bor(ix.type.optional, ix.type.text),
    },
    OnCheckAccess = function(self, ply)
        return ply:Team() == FACTION_CITIZEN or ply:Team() == FACTION_CWU
    end,
    OnRun = function(self, ply, text)
        if ( timer.Exists("ixRequestDelay."..ply:SteamID64()) ) then
            ply:Notify("You need to wait "..string.NiceTime(timer.TimeLeft("ixRequestDelay."..ply:SteamID64())).." before you can use this command again.")
            return
        end

        if ( text ) then
            Schema:AddWaypoint(ply:GetPos(), text, Color(250, 150, 50), 180, ply)
        else
            Schema:AddWaypoint(ply:GetPos(), "Request Marked", Color(250, 150, 50), 180, ply)
        end

        for k, v in pairs(player.GetAll()) do
            if not ( v:IsCombine() ) then
                continue
            end
            
            ix.util.EmitQueuedSounds(v, {
                "npc/overwatch/radiovoice/on3.wav",
                "npc/overwatch/radiovoice/politistablizationmarginal.wav",
                "npc/overwatch/radiovoice/off2.wav"
            }, nil, 0.05, 70)
        end

        timer.Create("ixRequestDelay."..ply:SteamID64(), 300, 1, function() end)
    end,
})

ix.command.Add("Panic", {
    description = "A Panic Button for Civil Protection.",
    arguments = {
        bit.bor(ix.type.optional, ix.type.text),
    },
    OnCheckAccess = function(self, ply)
        return ply:IsCombine()
    end,
    OnRun = function(self, ply, text)
        if ( timer.Exists("ixPanicButtonDelay."..ply:SteamID64()) ) then
            ply:Notify("You need to wait "..string.NiceTime(timer.TimeLeft("ixPanicButtonDelay."..ply:SteamID64())).." before you can use this command again.")
            return
        end

        if ( text ) then
            Schema:AddWaypoint(ply:GetPos(), text, Color(250, 50, 50), 180, ply)
        else
            Schema:AddWaypoint(ply:GetPos(), "Panic Button Activated!", Color(250, 50, 50), 180, ply)
        end

        for k, v in pairs(player.GetAll()) do
            if not ( v:IsCombine() ) then
                continue
            end

            ix.util.EmitQueuedSounds(v, {
                "npc/overwatch/radiovoice/on3.wav",
                "nnpc/overwatch/radiovoice/officerclosingonsuspect.wav",
                "npc/overwatch/radiovoice/off2.wav"
            }, nil, 0.05, 70)
        end

        timer.Create("ixPanicButtonDelay."..ply:SteamID64(), 200, 1, function() end)
    end,
})

ix.command.Add("Code2", {
    description = "Sends a waypoint with the marker code 2.",
    OnCheckAccess = function(self, ply)
        return ply:IsCombine()
    end,
    OnRun = function(self, ply)
        if ( timer.Exists("ixCode2Delay."..ply:SteamID64()) ) then
            ply:Notify("You need to wait "..string.NiceTime(timer.TimeLeft("ixCode2Delay."..ply:SteamID64())).." before you can use this command again.")
            return
        end

        Schema:AddWaypoint(ply:GetPos(), "Code 2", Color(250, 200, 50), 180, ply)

        for k, v in pairs(player.GetAll()) do
            if not ( v:IsCombine() ) then
                continue
            end

            ix.util.EmitQueuedSounds(v, {
                "npc/overwatch/radiovoice/on3.wav",
                "npc/overwatch/radiovoice/allunitsapplyforwardpressure.wav",
                "npc/overwatch/radiovoice/off2.wav"
            }, nil, 0.05, 70)
        end

        timer.Create("ixCode2Delay."..ply:SteamID64(), 120, 1, function() end)
    end,
})

ix.command.Add("Code3", {
    description = "Sends a waypoint with the marker code 3.",
    OnCheckAccess = function(self, ply)
        return ply:IsCombine()
    end,
    OnRun = function(self, ply)
        if ( timer.Exists("ixCode3Delay."..ply:SteamID64()) ) then
            ply:Notify("You need to wait "..string.NiceTime(timer.TimeLeft("ixCode3Delay."..ply:SteamID64())).." before you can use this command again.")
            return
        end

        Schema:AddWaypoint(ply:GetPos(), "Code 3", Color(250, 50, 50), 180, ply)

        for k, v in pairs(player.GetAll()) do
            if not ( v:IsCombine() ) then
                continue
            end

            ix.util.EmitQueuedSounds(v, {
                "npc/overwatch/radiovoice/on3.wav",
                "npc/overwatch/radiovoice/allteamsrespondcode3.wav",
                "npc/overwatch/radiovoice/off2.wav"
            }, nil, 0.05, 70)
        end
        timer.Create("ixCode3Delay."..ply:SteamID64(), 200, 1, function() end)
    end,
})

ix.command.Add("DispatchRadio", {
    arguments = {
        ix.type.text,
    },
    adminOnly = true,
    OnRun = function(self, ply, text)
        ix.chat.Send(ply, "dispatchradio", text)
    end,
})

if (  string.find(game.GetMap(), "rp_minerva_city17") ) then
    ix.command.Add("Toggle404Gate", {
        description = "Toggles the gate of the 404 Zone.",
        OnRun = function(self, ply)
            if not ( ply:IsAdmin() or ply:IsCombineCommand() ) then
                ply:Notify("You don't have access to this command.")
                return
            end
    
            for k, v in pairs(ents.FindByName("zone2_404zone_gate_1")) do
                ToggleGate(ply, v)
            end
        end
    })
    
    ix.command.Add("ToggleZone2Gate", {
        description = "Toggles the gate of the Overwatch Nexus Garage in Zone 2.",
        OnRun = function(self, ply)
            if not ( ply:IsAdmin() or ply:IsCombineCommand() ) then
                ply:Notify("You don't have access to this command.")
                return
            end
    
            for k, v in pairs(ents.FindByName("zone_2_apcgarage_gate_1")) do
                ToggleGate(ply, v)
            end
        end
    })
    
    ix.command.Add("ToggleZone3Gate", {
        description = "Toggles the gate of the Overwatch Nexus Garage in Zone 3.",
        OnRun = function(self, ply)
            if not ( ply:IsAdmin() or ply:IsCombineCommand() ) then
                ply:Notify("You don't have access to this command.")
                return
            end
    
            for k, v in pairs(ents.FindByName("zone_3_apcgarage_gate_1")) do
                ToggleGate(ply, v)
            end
        end
    })
    
    ix.command.Add("ToggleZone3OutlandsGate", {
        description = "Toggles the gate of the Overwatch Nexus Garage in Zone 3.",
        OnRun = function(self, ply)
            if not ( ply:IsAdmin() or ply:IsGamemaster() ) then
                ply:Notify("You don't have access to this command.")
                return
            end
    
            for k, v in pairs(ents.FindByName("zone_3_gate_1")) do
                ToggleGate(ply, v)
            end
        end
    })
end