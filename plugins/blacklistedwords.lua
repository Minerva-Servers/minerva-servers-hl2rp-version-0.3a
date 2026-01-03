local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Combine Hud"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN.config = {
    "fag",
    "nigg",
    "niger",
    "niga",
    "pedo",
    "phile",
    "pornhub",
    "rule34",
    "r34"
}

if ( CLIENT ) then
    return
end

ix.log.AddType("blacklistedWord", function(ply, word, text)
    return "Blacklisted word found from user '"..ply:SteamName().." / "..ply:Nick().."', with the word '"..tostring(word).."' with the message being '"..tostring(text).."'. Prevented from sending!"
end, FLAG_WARNING)

function PLUGIN:PrePlayerMessageSend(ply, chatType, text)
    for k, v in pairs(self.config) do
        if ( string.find(string.upper(text), string.upper(v)) ) then
            ix.log.Add(ply, "blacklistedWord", v, text)
            
            Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has attempted to say a blacklisted word.\nWord: "..v.."\nSteamID: "..ply:SteamID(), Schema.discordLogWebhook, Color(255, 0, 0))
            
            return false
        end
    end
    
    if ( chatType == "ooc" ) then
        Schema:SendDiscordMessage("Out Of Character Chat - "..ply:SteamName(), message, Schema.discordLogWebhookPublic, ix.config.Get("color"))
    end
end
