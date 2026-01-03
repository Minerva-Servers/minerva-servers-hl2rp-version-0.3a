local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Badges Library"
PLUGIN.description = ""
PLUGIN.author = "eon"

PLUGIN.testers = {
    
}

PLUGIN.list = {
    ["donator"] = {
        function(ply)
            return ply:SteamName().." is a Minerva Servers Donator"
        end,
        "icon16/coins.png", 
        function(ply)        
            return ply:IsDonator()
        end,
    },
    ["developer"] = {
        function(ply)
            return ply:SteamName().." is a Minerva Servers Developer"
        end,
        "icon16/keyboard.png", 
        function(ply)        
            return ply:IsDeveloper()
        end,
    },
    ["tester"] = {
        function(ply)
            return ply:SteamName().." is a Minerva Servers Tester"
        end,
        "icon16/cog.png", 
        function(ply)        
            return ( PLUGIN.testers[ply:SteamID64()] )
        end,
    },
    ["staff"] = {
        function(ply)
            return ply:SteamName().." is a Minerva Servers Staff Member"
        end,
        "icon16/feed.png", 
        function(ply)        
            return ( ply:IsAdmin() )
        end,
    },
    ["commanager"] = {
        function(ply)
            return ply:SteamName().." is a Minerva Servers Community Manager"
        end,
        "minerva/icons/talk.png", 
        function(ply)        
            return ( ply:SteamID() == "STEAM_0:0:468912677" )
        end,
    }
}