ix.chat.Register("announcement", {
    description = "",
    prefix = {"/Announce", "/A"},
    font = "ixSmallBoldFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    CanSay = function(self, speaker, text)
        return speaker:IsSuperAdmin()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(ix.config.Get("color"), '[Minerva Servers - Announcement] ', color_white, text)
    end,
    CanHear = function(self, speaker, listener)
        return true
    end,
})

ix.chat.Register("radio", {
    description = "",
    prefix = {"/Radio", "/R"},
    font = "ixRadioFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(55, 146, 21),
    CanSay = function(self, speaker, text)
        return speaker:IsCombine() or speaker:IsAdministrator()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end

        chat.AddText(Color(55, 146, 21), "[RADIO] "..speaker:Nick().." <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return receiver:IsCombine() or receiver:IsAdministrator()
    end,
})

ix.chat.Register("radioannounce", {
    description = "",
    prefix = {"/RadioAnnounce", "/RA"},
    font = "ixRadioFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(146, 55, 21),
    CanSay = function(self, speaker, text)
        return speaker:IsCombineCommand() or speaker:IsAdministrator()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end

        chat.AddText(Color(146, 55, 21), "[RADIO-ANNOUNCEMENT] "..speaker:Nick().." <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return receiver:IsCombine() or receiver:IsAdministrator()
    end,
})

ix.chat.Register("radioooc", {
    description = "",
    prefix = {"/RadioOOC", "/RO"},
    font = "ixTinyFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(55, 146, 21),
    CanSay = function(self, speaker, text)
        return speaker:IsCombine() or speaker:IsAdministrator()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end

        chat.AddText(Color(55, 146, 21), "[RADIO-OOC] "..speaker:Nick().." ", text)
    end,
    CanHear = function(self, speaker, receiver)
        return receiver:IsCombine() or receiver:IsAdministrator()
    end,
})

ix.chat.Register("overwatchradio", {
    description = "",
    prefix = {"/OverwatchRadio", "/OWR"},
    font = "ixRadioFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(24, 55, 146),
    CanSay = function(self, speaker, text)
        return speaker:IsOW() or speaker:IsAdministrator()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end

        chat.AddText(Color(24, 55, 146), "[OVERWATCH-RADIO] "..speaker:Nick().." <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return receiver:IsOW() or receiver:IsAdministrator()
    end,
})

ix.chat.Register("commandradio", {
    description = "",
    prefix = {"/CommandRadio", "/CR"},
    font = "ixRadioFont",
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(201, 82, 26),
    CanSay = function(self, speaker, text)
        return speaker:IsCombineCommand()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(Color(201, 82, 26), "[COMMAND-RADIO] "..speaker:Nick().." <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return receiver:IsCombineCommand()
    end,
})

ix.chat.Register("dispatchradiopersonnal", {
    font = "ixRadioFont",
    deadCanChat = true,
    color = Color(21, 23, 146),
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(Color(21, 23, 146), "[RADIO] Dispatch (to you) <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return receiver == speaker
    end,
})

ix.chat.Register("dispatchradio", {
    font = "ixRadioFont",
    deadCanChat = true,
    color = Color(21, 23, 146),
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(Color(21, 23, 146), "[RADIO] Dispatch <:: ", text, " ::>")
    end,
    CanHear = function(self, speaker, receiver)
        return receiver:IsCombine() or receiver:IsAdministrator()
    end,
})

ix.chat.Register("dispatch", {
    description = "",
    prefix = {"/Dispatch", "/D"},
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(21, 23, 146),
    CanSay = function(self, speaker, text)
        return speaker:IsCombineSupervisor() or speaker:IsAdmin()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(Color(21, 23, 146), 'Dispatch Announces "'..text..'"')
    end,
    CanHear = function(self, speaker, listener)
        return true
    end,
})

ix.chat.Register("broadcast", {
    description = "Broadcast something to the city.",
    prefix = {"/Broadcast", "/BR"},
    indicator = "chatPerforming",
    deadCanChat = false,
    color = Color(150, 0, 0),
    CanSay = function(self, speaker, text)
        if not ( speaker:GetPos():Distance(Vector(8975.66796875, 3518.1665039063, 6912.03125)) < 384 ) then
            speaker:Notify("You need to be near the broadcast station to use this command!")
            return false
        end
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(Color(150, 0, 0), speaker:Nick()..' broadcasts ', ix.config.Get("chatColor"), '"'..text..'"')
    end,
    CanHear = function(self, speaker, listener)
        return true
    end,
})

ix.chat.Register("adminchat", {
    prefix = {"/AdminChat", "/AC"},
    indicator = "chatPerforming",
    deadCanChat = true,
    adminOnly = true,
    color = ix.config.Get("color"),
    CanSay = function(self, speaker, text)
        return speaker:IsGamemaster() or speaker:IsAdmin()
    end,
    OnChatAdd = function(self, speaker, text)
        if not ( IsValid(speaker) ) then
            return
        end
        
        chat.AddText(ix.config.Get("color"), "[ADMIN-CHAT] ", color_white, speaker:SteamName(), team.GetColor(speaker:Team()), " ("..speaker:Nick()..")", color_white, ": "..text)
    end,
    CanHear = function(self, speaker, listener)
        return listener:IsGamemaster() or listener:IsAdmin() // gets all admins anyway so we dont need to add IsAdmin etc...
    end,
})