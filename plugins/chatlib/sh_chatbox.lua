local PLUGIN = PLUGIN

function PLUGIN:InitializedChatClasses()
    ix.chat.Register("ic", {
        format = " \"%s\"",
        indicator = "chatTalking",
        font = "ixChatFont",
        GetColor = function(self, speaker, text)
            if (LocalPlayer():GetEyeTrace().Entity == speaker) then
                return ix.config.Get("chatListenColor")
            end

            return ix.config.Get("chatColor")
        end,
        OnChatAdd = function(self, speaker, text, anonymous, info)
            if not ( IsValid(speaker) ) then
                return
            end

            local color = self:GetColor(speaker, text, info)
            local name = (IsValid(speaker) and speaker:Name() or "Console")

            chat.AddText(team.GetColor(speaker:Team()), name, color, " says", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280)
    })

    -- Actions and such.
    ix.chat.Register("me", {
        format = "** %s %s",
        GetColor = ix.chat.classes.ic.GetColor,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/Me", "/Action"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        deadCanChat = true
    })

    -- Actions and such.
    ix.chat.Register("it", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(ix.config.Get("chatColor"), "** "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/It"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        deadCanChat = true
    })

    -- Whisper chat.
    ix.chat.Register("w", {
        format = " \"%s\"",
        indicator = "chatWhispering",
        font = "ixChatWhisperFont",
        description = "@cmdW",
        prefix = {"/W", "/Whisper"},
        color = Color(0, 150, 255),
        OnChatAdd = function(self, speaker, text, anonymous, info)
            if not ( IsValid(speaker) ) then
                return
            end
            
            local color = self.color
            local name = (IsValid(speaker) and speaker:Name() or "Console")

            chat.AddText(team.GetColor(speaker:Team()), name, color, " whispers", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280) * 0.5
    })

    -- Yelling out loud.
    ix.chat.Register("y", {
        format = " \"%s\"",
        indicator = "chatYelling",
        font = "ixChatYellFont",
        description = "@cmdY",
        prefix = {"/Y", "/Yell"},
        color = Color(250, 100, 0),
        OnChatAdd = function(self, speaker, text, anonymous, info)
            if not ( IsValid(speaker) ) then
                return
            end
            
            local color = self.color
            local name = (IsValid(speaker) and speaker:Nick() or "Console")

            chat.AddText(team.GetColor(speaker:Team()), name, color, " yells", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2
    })

    -- Out of character.
    ix.chat.Register("ooc", {
        CanSay = function(self, speaker, text)
            if ( speaker:IsAdmin() ) then
                return true
            end

            if (!ix.config.Get("allowGlobalOOC")) then
                speaker:Notify("Global OOC is disabled currently!")
                return false
            else
                local delay = ix.config.Get("oocDelay", 10)

                -- Only need to check the time if they have spoken in OOC chat before.
                if (delay > 0 and speaker.ixLastOOC) then
                    local lastOOC = CurTime() - speaker.ixLastOOC

                    -- Use this method of checking time in case the oocDelay config changes.
                    if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
                        speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

                        return false
                    end
                end

                -- Save the last time they spoke in OOC.
                speaker.ixLastOOC = CurTime()
            end
        end,
        OnChatAdd = function(self, speaker, text)
            -- @todo remove and fix actual cause of speaker being nil
            if (!IsValid(speaker)) then
                return
            end

            local icon = "icon16/user.png"
            local color = Color(240, 240, 240)

            if (speaker:SteamID64() == "76561197963057641") then
                icon = "icon16/page_edit.png"
                color = Color(255, 0, 0)
            elseif (speaker:IsSuperAdmin()) then
                icon = "icon16/shield.png"
                color = Color(0, 255, 255)
            elseif( speaker:IsDeveloper() ) then
                icon = "icon16/keyboard.png"
                color = Color(70, 255, 0)
            elseif (speaker:IsGamemaster()) then
                icon = "icon16/box.png"
                color = Color(219, 112, 25)
            elseif (speaker:IsAdmin()) then
                icon = "icon16/wrench.png"
                color = Color(25, 83, 219)
            elseif (speaker:IsUserGroup("helper")) then
                icon = "icon16/chart_bar.png"
                color = Color(50, 200, 50)
            elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
                icon = "icon16/coins.png"
                color = Color(200, 170, 0)
            end

            icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

            chat.AddText(icon, Color(255, 50, 50), "[OOC] ", color, speaker:SteamName(), color_white, ": "..text)
        end,
        prefix = {"//", "/OOC"},
        description = "@cmdOOC",
        noSpaceAfter = true
    })

    -- Local out of character.
    ix.chat.Register("looc", {
        CanSay = function(self, speaker, text)
            if ( speaker:IsAdmin() ) then
                return true
            end

            local delay = ix.config.Get("loocDelay", 0)

            -- Only need to check the time if they have spoken in OOC chat before.
            if (delay > 0 and speaker.ixLastLOOC) then
                local lastLOOC = CurTime() - speaker.ixLastLOOC

                -- Use this method of checking time in case the oocDelay config changes.
                if (lastLOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
                    speaker:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

                    return false
                end
            end

            -- Save the last time they spoke in OOC.
            speaker.ixLastLOOC = CurTime()
        end,
        OnChatAdd = function(self, speaker, text)
            if not ( IsValid(speaker) ) then
                return
            end
            
            local name = speaker:Nick()
            local icon = "icon16/user.png"
            local color = Color(240, 240, 240)

            if (speaker:SteamID64() == "76561197963057641") then
                icon = "icon16/page_edit.png"
                color = Color(255, 0, 0)
            elseif (speaker:IsSuperAdmin()) then
                icon = "icon16/shield.png"
                color = Color(0, 255, 255)
            elseif( speaker:IsDeveloper() ) then
                icon = "icon16/keyboard.png"
                color = Color(70, 255, 0)
            elseif (speaker:IsGamemaster()) then
                icon = "icon16/box.png"
                color = Color(219, 112, 25)
            elseif (speaker:IsAdmin()) then
                icon = "icon16/wrench.png"
                color = Color(25, 83, 219)
            elseif (speaker:IsUserGroup("helper")) then
                icon = "icon16/chart_bar.png"
                color = Color(50, 200, 50)
            elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
                icon = "icon16/coins.png"
                color = Color(200, 170, 0)
            end

            icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

            chat.AddText(icon, Color(255, 50, 50), "[LOOC] ", color, speaker:SteamName(), team.GetColor(speaker:Team()), " ("..name..")", color_white, ": "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280),
        prefix = {".//", "[[", "/LOOC"},
        description = "@cmdLOOC",
        noSpaceAfter = true
    })

    -- Roll information in chat.
    ix.chat.Register("roll", {
        format = "** %s has rolled %s out of %s.",
        color = Color(155, 111, 176),
        CanHear = ix.config.Get("chatRange", 280),
        deadCanChat = true,
        OnChatAdd = function(self, speaker, text, bAnonymous, data)
            if not ( IsValid(speaker) ) then
                return
            end
            
            local max = data.max or 100
            local translated = L2(self.uniqueID.."Format", speaker:Name(), text, max)

            chat.AddText(self.color, translated and "** "..translated or string.format(self.format,
                speaker:Name(), text, max
            ))
        end
    })

    -- Private messages between players.
    ix.chat.Register("pm", {
        format = "[PM] %s -> %s: %s",
        color = Color(25, 100, 25, 255),
        deadCanChat = true,

        OnChatAdd = function(self, speaker, text, bAnonymous, data)
            if not ( IsValid(speaker) ) then
                return
            end
            
            chat.AddText(self.color, string.format(self.format, speaker:GetName(), data.target:GetName(), text))

            if (LocalPlayer() != speaker) then
                surface.PlaySound("buttons/blip1.wav")
            end
        end
    })

    -- Global events.
    ix.chat.Register("event", {
        CanHear = 1000000,
        OnChatAdd = function(self, speaker, text)
            if not ( IsValid(speaker) ) then
                return
            end
            
            chat.AddText(Color(250, 100, 0), text)
        end,
        indicator = "chatPerforming"
    })

    ix.chat.Register("connect", {
        CanSay = function(self, speaker, text)
            return !IsValid(speaker)
        end,
        OnChatAdd = function(self, speaker, text)
            if not ( IsValid(speaker) and speaker:IsDonator() ) then
                return
            end
            
            local icon = ix.util.GetMaterial("icon16/user_add.png")

            chat.AddText(icon, Color(0, 200, 0), L("playerConnected", text))
        end,
        noSpaceAfter = true
    })

    ix.chat.Register("disconnect", {
        CanSay = function(self, speaker, text)
            return !IsValid(speaker)
        end,
        OnChatAdd = function(self, speaker, text)
            if not ( IsValid(speaker) and speaker:IsDonator() ) then
                return
            end

            local icon = ix.util.GetMaterial("icon16/user_delete.png")

            chat.AddText(icon, Color(200, 0, 0), L("playerDisconnected", text))
        end,
        noSpaceAfter = true
    })

    ix.chat.Register("notice", {
        CanSay = function(self, speaker, text)
            return !IsValid(speaker)
        end,
        OnChatAdd = function(self, speaker, text, bAnonymous, data)
            local icon = ix.util.GetMaterial(data.bError and "icon16/comment_delete.png" or "icon16/comment.png")
            chat.AddText(icon, data.bError and Color(200, 175, 200, 255) or Color(175, 200, 255), text)
        end,
        noSpaceAfter = true
    })
    
    ix.chat.Register("radio_pt", {
        CanSay = function(self, speaker, text)
            if not ( speaker:IsCombine() ) then
                speaker:Notify("Only the Combine can radio stuff!")
                return false
            end

            if not ( speaker.curTeam ) then
                speaker:Notify("You must be in a PT to use this!")
                return false
            end
        end,
        OnChatAdd = function(self, speaker, text)
            if ( speaker ) then
                chat.AddText(Color(55, 146, 21), "[RADIO-PT] "..speaker:Nick().." ", text)
            end
        end,
        CanHear = function(self, speaker, listener)           
            if not (listener:IsCombine()) then
                return false
            end

            if not ( listener.curTeam ) then
                return false 
            end

            if not ( speaker.curTeam ) then
                return false 
            end

            if ( speaker.curTeam == listener.curTeam ) then 
                return true 
            end
        end,
        prefix = {"/PTRadio", "/PTR"},
        description = "Radio to your Patrol Team.",
        indicator = "chatPerforming",
        font = "ixRadioFont",
        deadCanChat = false
    })
end

function PLUGIN:OnReloaded()
    self:InitializedChatClasses()
end
