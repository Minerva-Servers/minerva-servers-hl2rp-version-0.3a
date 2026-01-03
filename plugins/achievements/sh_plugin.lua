local PLUGIN = PLUGIN

PLUGIN.name = "Achievement System"
PLUGIN.author = "eon"

ix.achievements = ix.achievements or {}
ix.achievements.achievecol = Color(0, 155, 255)
ix.achievements.list = {
    ["killriggs"] = {
        name = "I am the owner now!",
        desc = "Congratulations, you have killed the owner of Minerva Servers.",
        icon = "minerva/icons/news.png"
    },
    ["killeon"] = {
        name = "Who's gonna code now?",
        desc = "Congratulations, you have killed our developer eon.",
        icon = "minerva/icons/news.png"
    },
    ["killdjgaming"] = {
        name = "Stream Sniped",
        desc = "Eliminate one of our active streamers!",
        icon = "minerva/icons/decision.png"
    },
    ["firstcraft"] = {
        name = "First Craft",
        desc = "Craft your first item!"
    },
    ["richboy"] = {
        name = "Rich Boy",
        desc = "Have more than 5000 tokens",
        customCheck = function(ply)
            return ( ply:GetChar():GetMoney() + ply:GetChar():GetStoredMoney() >= 5000 ) 
        end,
        icon = "minerva/icons/money.png"
    },
    ["firstloot"] = {
        name = "First Loot",
        desc = "Loot for the first time!",
        icon = "minerva/icons/flashlight.png"
    },
    ["firstbrew"] = {
        name = "Alcoholic",
        desc = "Brew for the first time!",
    },
    ["cpbecome"] = {
        name = "Support our Benefactors",
        desc = "Become a Civil Protection Unit for the first time!",
        col = team.GetColor(FACTION_CP),
        icon = "minerva/icons/job.png"
    },
    ["owbecome"] = {
        name = "Transhumanization",
        desc = "Become an Overwatch Unit for the first time!",
        col = team.GetColor(FACTION_OW),
        icon = "minerva/icons/balaclava.png"
    },
    ["cpkill"] = {
        name = "Malignant",
        desc = "Kill a Civil Protection Unit for the first time!",
        col = Color(255, 155, 0),
        icon = "minerva/icons/gun.png"
    },
    ["owkill"] = {
        name = "Anti-Citizen",
        desc = "Kill an Overwatch Unit for the first time!",
        col = Color(255, 105, 0),
        icon = "minerva/icons/kevlar-vest.png"
    },
    ["firstdeath"] = {
        name = "First Death",
        desc = "Die for the first time.",
        icon = "minerva/icons/health.png"
    },
    ["cpcmdkill"] = {
        name = "Anti-Citizen One",
        desc = "Kill one of the Combine Commanders!",
        col = Color(255, 0, 0),
        icon = "minerva/icons/kevlar.png"
    },
    ["firstjoin"] = {
        name = "Relocation",
        desc = "Join the server for the first time!",
        icon = "minerva/icons/broadcast.png"
    },
    ["firstjw"] = {
        name = "RUNNNNNN!",
        desc = "Participate in your first Judgment Waiver",
        icon = "minerva/icons/running.png"
    },
    ["ieddetonatefirst"] = {
        name = "KABOOOOM!",
        desc = "Detonate your first IED",
        icon = "icon16/anchor.png",
    },
    ["supporter"] = {
        name = "Supporter",
        desc = "Donate to the server!",
        customCheck = function(ply)
            return ply.IsDonator and ply:IsDonator()
        end,
        icon = "minerva/icons/banknotes.png"
    },
    ["jwjoin"] = {
        name = "Chaos from the door",
        desc = "Join during a Judgment Waiver.",
        icon = "minerva/icons/exit.png"
    },
    ["fromthegrave"] = {
		name = "From The Grave",
		desc = "Kill a player while dead"
	},
    ["party"] = {
		name = "Party",
		desc = "Dance with 15 other players"
	},
}

ix.util.Include("sv_plugin.lua")

local meta = FindMetaTable("Player")

function meta:HasAchievement(achievement)
    if ( ix.achievements.list[achievement] ) then
        return tobool(ix.data.Get("achievements/"..self:SteamID64().."/"..tostring(achievement), false, false, true, true))
    end
end

if ( CLIENT ) then    
    net.Receive("ixAchievementNotify", function()
        local playersteam = net.ReadString()
        local achievementid = net.ReadString()
        
        local achievement = ix.achievements.list[achievementid]
        
        chat.AddText(Material("icon16/award_star_add.png"), ix.config.Get("color"), "[Achievements] ", color_white, playersteam, ix.achievements.achievecol, " unlocked the achievement: ", achievement.col or color_white, achievement.name)
        
        surface.PlaySound("garrysmod/content_downloaded.wav")
    end)
    
    function PLUGIN:PopulateHelpMenu(categories)
        categories["achievements"] = function(container)
            for k, v in pairs(ix.achievements.list) do
                local color = Color(10, 10, 10, 150)
                
                if ( LocalPlayer():HasAchievement(k) ) then
                    color = Color(0, 0, 0, 66) 
                end
                
                local achievement = container:Add("Panel")
                achievement:Dock(TOP)
                achievement:DockMargin(0, 10, 0, 0)
                achievement:SetTall(100)
                achievement.Paint = function(s, w, h)
                    surface.SetDrawColor(color)
                    surface.DrawRect(0, 0, w, h)
                    
                    draw.DrawText(v.name, "ixBigFont", 10, 5, v.col or color_white, TEXT_ALIGN_LEFT)
                    draw.DrawText(v.desc, "ixMediumFont", 10, 35, color_white, TEXT_ALIGN_LEFT)
                    
                    if ( LocalPlayer():HasAchievement(k) ) then
                        draw.DrawText("Unlocked on: "..os.date("%d/%m/%y - %X%p", ix.data.Get("achievements/"..LocalPlayer():SteamID64().."/"..tostring(k), "", false, true, true)), "ixSmallFont", 10, 75, Color(0, 255, 0), TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("You haven't unlocked this achievement", "ixSmallFont", 10, 75, Color(255, 155, 0), TEXT_ALIGN_LEFT)
                    end
                    
                    if ( v.icon ) then
                        local aicon = Material( v.icon, "noclamp smooth" )
                        surface.SetDrawColor(v.iconcol or color_white)
                        surface.SetMaterial(aicon)
                        surface.DrawTexturedRect(w - 90, h - 90, 80, 80)
                    end
                end
            end
        end
    end
end
