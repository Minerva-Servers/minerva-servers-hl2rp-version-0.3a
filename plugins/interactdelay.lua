local PUGIN = PLUGIN

PLUGIN.name = "Item Interaction Delay"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.config.Add("interactDelay", 0.1, "The Delay of taking items in seconds.", nil, {
    category = PLUGIN.name,
    data = {
        decimals = 2,
        min = 0,
        max = 10,
    },
})

if ( SERVER ) then
    function PLUGIN:PlayerInteractItem(ply, action, item)
        ply.interactDelay = true

        timer.Create("ixInteractDelay."..ply:SteamID64(), ix.config.Get("takeDelay", 0.1), 1, function()
            if ( IsValid(ply) ) then
                ply.interactDelay = nil
            end
        end)
    end

    function PLUGIN:CanPlayerInteractItem(ply)
        if ( ply.interactDelay ) then
            ply:Notify("You need to wait a bit before interacting with an item again!")
            return false
        end
    end
end
