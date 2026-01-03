-- Here is where all clientside hooks should go.

function GAMEMODE:PopulateImportantCharacterInfo(client, character, container)
    local color = team.GetColor(client:Team())
    container:SetArrowColor(color)

    -- name
    local name = container:AddRow("name")
    name:SetImportant()
    name:SetText(hook.Run("GetCharacterName", client) or character:GetName())
    name:SetBackgroundColor(color)
    name:SizeToContents()

    -- injured text
    local injureText, injureTextColor = hook.Run("GetInjuredText", client)

    if (injureText) then
        local injure = container:AddRow("injureText")

        injure:SetText(L(injureText))
        injure:SetBackgroundColor(injureTextColor)
        injure:SizeToContents()
    end
end

function Schema:PopulateCharacterInfo(client, character, container)
    return false
end

local whitelistedEnts = {
    ["ix_loot_container"] = true,
}
local configColor = ix.config.Get("color", Color(255, 255, 255))
function Schema:PreDrawHalos()
    local client = LocalPlayer()
    if not ( IsValid(client) ) then
        return
    end

    local character = client:GetCharacter()
    if not ( character ) then
        return
    end

    local items = {}
    for k, v in pairs(ents.FindInSphere(client:EyePos(), 256)) do
        if not ( whitelistedEnts[v:GetClass()] ) then
            continue
        end

        items[#items + 1] = v
    end

    halo.Add(items, configColor)
end

surface.CreateFont("ixWatermarkTitleFont", {
    font = ix.config.Get("font"),
    size = 40,
    antialias = true,
    additive = true,
    outline = true,
    shadow = true,
})

surface.CreateFont("ixWatermarkSubTitleFont", {
    font = ix.config.Get("font"),
    size = 25,
    antialias = true,
    additive = true,
    outline = true,
    shadow = true,
})

local scrW, scrH = ScrW(), ScrH()
function Schema:HUDPaintBackground()
    local ply, char = LocalPlayer(), LocalPlayer():GetCharacter()
    
    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then return end
    if not ( IsValid(ply) and char ) then
        return
    end

    if ( ply:Alive() ) then
        local maxHealth = ply:GetMaxHealth()
        local health = ply:Health()
        
        if ( health < maxHealth ) then
            self:DrawPlayerScreenDamage(ply, 1 - ((1 / maxHealth) * health))
        end
    else
        return
    end
    
    if ( ix.config.Get("vignette", true) and ix.option.Get("showVignette", true) ) then
        self:DrawPlayerVignette()
    end

    if not ( ix.config.Get("shouldShowWatermark") ) then
        return
    end

    local timeProcrastinating = os.date("%H:%M:%S", os.clock())

    draw.DrawText(Schema.author.." | "..Schema.name.." | User: "..ply:SteamName().." | Version: "..Schema.currentVersion, "ixWatermarkTitleFont", scrW / 4, scrH / 1.2 - 30, ColorAlpha(ix.config.Get("color"), 200), TEXT_ALIGN_LEFT)
    draw.DrawText("User Group: "..ply:GetUserGroup(), "ixWatermarkSubTitleFont", scrW / 4, scrH / 1.2, ColorAlpha(color_white, 200), TEXT_ALIGN_LEFT)
    draw.DrawText("Time Procrastinating: "..timeProcrastinating, "ixWatermarkSubTitleFont", scrW / 4, scrH / 1.2 + 20, ColorAlpha(color_white, 200), TEXT_ALIGN_LEFT)
    draw.DrawText("Discord: "..ix.config.Get("discordURL"), "ixWatermarkSubTitleFont", scrW / 4, scrH / 1.2 + 40, ColorAlpha(color_white, 200), TEXT_ALIGN_LEFT)
end

local damageOverlay = ix.util.GetMaterial("minerva/screendamage.png")
local vignette1 = ix.util.GetMaterial("minerva/vignette.png")
local vignette2 = ix.util.GetMaterial("minerva/vignette_cw.png")

function Schema:DrawPlayerScreenDamage(ply, damageFraction)
    surface.SetDrawColor(255, 0, 0, math.Clamp(255 * damageFraction, 0, 255))
    surface.SetMaterial(vignette2)
    surface.DrawTexturedRect(0, 0, scrW, scrH)

    surface.SetDrawColor(255, 255, 255, math.Clamp(255 * damageFraction, 0, 255))
    surface.SetMaterial(damageOverlay)
    surface.DrawTexturedRect(0, 0, scrW, scrH)
end

function Schema:DrawPlayerVignette()
    surface.SetDrawColor(0, 0, 0, 200)
    surface.SetMaterial(vignette1)
    surface.DrawTexturedRect(0, 0, scrW, scrH)

    surface.SetDrawColor(0, 0, 0, 200)
    surface.SetMaterial(vignette2)
    surface.DrawTexturedRect(0, 0, scrW, scrH)
end

function Schema:BuildBusinessMenu()
    return false
end

function Schema:PopulateHelpMenu(categories, panel)
    categories["rules"] = function(container)
        local dhtml = container:Add("HTML")
        dhtml:Dock(FILL)
        dhtml:SetTall(ScrH() / 1.2)
        dhtml:OpenURL(ix.config.Get("rulesEmbedURL"))
    end
    categories["content"] = function(container)
        local dhtml = container:Add("HTML")
        dhtml:Dock(FILL)
        dhtml:SetTall(ScrH() / 1.2)
        dhtml:OpenURL(ix.config.Get("contentURL"))
    end
end

function Schema:CanPlayerViewInventory()
    local ply = LocalPlayer()
    
    if not ( IsValid(ply) and ply:Alive() ) then
        return false
    end
    
    if ( ply:IsArrested() ) then
        return false
    end
    
    if ( ply:GetLocalVar("ragdoll") ) then
        return false
    end
end

/*function Schema:LoadNewIntro()
    if not ( IsValid(ix.gui.intro) ) then
        if ( IsValid(ix.gui.characterMenu) ) then
            ix.gui.characterMenu:Remove()
        end

        if not ( ix.data.Get("introSequence") ) then
            ix.gui.characterMenu = vgui.Create("ixCharMenu")
        end
        
        vgui.Create("ixIntro")
    end
end*/

function Schema:InitializedConfig()
    if ( ix.config.Get("intro", true) ) then
        hook.Run("LoadNewIntro")
    end
end