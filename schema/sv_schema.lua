Schema.discordLogWebhook = "https://discord.com/api/webhooks/1051481495979708446/X_g_5gHmhV9LcaU1eYmyzOlFIxJzRn_kDHIJgW93FGANeL4OOT92_moXglxEwyQEbrm7"
Schema.discordLogWebhookPublic = "https://discord.com/api/webhooks/1061282759567495218/W5DKWK1I2KGBGg6sW2edQCJBfz_myuSNebeeCmddAqxZDy40YtyIZVBMOp7SYSwe65lF"

-- Here is where all serverside functions should go.

util.AddNetworkString("ixSurfaceSound")
util.AddNetworkString("ixOpenVGUI")

function Schema:SearchPlayer(ply, target)
    if not ( target:GetCharacter() or target:GetCharacter():GetInventory()) then
        return false
    end

    local name = hook.Run("GetDisplayedName", target) or target:Nick()
    local inventory = target:GetCharacter():GetInventory()

    ix.storage.Open(ply, inventory, {
        entity = target,
        name = name,
    })
    
    Schema:SendDiscordMessage(ply:SteamName(), ply:Nick().." has searched.\nTarget: "..target:Nick().."("..target:SteamName()..")", Schema.discordLogWebhook, Color(255, 190, 0))

    return true
end

local workshop_items = engine.GetAddons()

for i = 1, #workshop_items do
    local addon_id = workshop_items[i].wsid

    resource.AddWorkshop(addon_id)
end

concommand.Add("ix_savedata", function(ply)
    if not ( ply:IsSuperAdmin() ) then
        return
    end

    hook.Run("SaveData")
end)

concommand.Add("ix_loaddata", function(ply)
    if not ( ply:IsSuperAdmin() ) then
        return
    end

    hook.Run("LoadData")
end)

local function discordPrint(...)
    local args = {...}
    ix.log.AddRaw(unpack(args))
end

function Schema:SendDiscordMessage(title, content, relay, color)
    http.Post("https://falco.wtf/minerva/post.php", {
        title = GetHostName().." - "..title,
        content = content,
        color = string.format("%.2X%.2X%.2X", color and color.r or ix.config.Get("color").r, color and color.g or ix.config.Get("color").g, color and color.b or ix.config.Get("color").b),
        relay = relay,
    }, function(r)
        --discordPrint(r)
    end, function(f)
        --discordPrint(f)
    end)
end