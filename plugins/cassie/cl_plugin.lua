local PLUGIN = PLUGIN

net.Receive("ixCassieOpenMenu", function()
    vgui.Create("ixCassieMenu")
end)

// admin hud
local configColor = ColorAlpha(ix.config.Get("color") or color_white, 100)
local textColor = ColorAlpha(color_white, 100)
function PLUGIN:HUDPaintAlternate(client, character)
    if not ( client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle() ) then
        return
    end

    if not ( ( ix.option.Get("adminEsp", false) or ix.option.Get("observerESP", true) ) and CAMI.PlayerHasAccess(client, "Helix - Observer", nil) ) then
        return
    end

    local adminsOnline = 0

    local players = player.GetAll()

    for k, v in pairs(players) do
        if not ( v:IsAdmin() ) then
            continue
        end
            
        adminsOnline = adminsOnline + 1
    end

    draw.DrawText("OBSERVER MODE ACTIVE", "ixBigFont", 20, 10, configColor, TEXT_ALIGN_LEFT)
    draw.DrawText("Entity Count: "..ents.GetCount(), "ixSmallFont", 30, 45, textColor, TEXT_ALIGN_LEFT)
    draw.DrawText("Player Count: "..player.GetCount(), "ixSmallFont", 30, 65, textColor, TEXT_ALIGN_LEFT)
    draw.DrawText("Admins Online: "..adminsOnline, "ixSmallFont", 30, 85, textColor, TEXT_ALIGN_LEFT)
    draw.DrawText("City Status: "..ix.cityCode.GetName(), "ixSmallFont", 30, 105, ColorAlpha(ix.cityCode.GetColor(), 100), TEXT_ALIGN_LEFT)

    local y = 125
    for k, v in pairs(ix.faction.indices) do
        draw.DrawText(team.GetName(k)..": "..team.NumPlayers(k), "ixSmallFont", 30, y, ColorAlpha(v.color, 100) or textColor, TEXT_ALIGN_LEFT)
        y = y + 20
    end

    for k, v in pairs(players) do
        if ( v == LocalPlayer() ) then
            continue
        end
        
        local pos = (v:GetPos() + v:OBBCenter()):ToScreen()
        local teamColor = team.GetColor(v:Team())
        local teamName = team.GetName(v:Team())

        if ( v:GetMoveType() == MOVETYPE_NOCLIP and !v:InVehicle() and CAMI.PlayerHasAccess(v, "Helix - Observer", nil) ) then
            draw.DrawText("** In Observer Mode **", "ixTinyFont", pos.x, pos.y - 10, Color(255, 0, 0), TEXT_ALIGN_CENTER)
        end

        draw.DrawText(v:Nick().." - "..teamName, "ixTinyFont", pos.x, pos.y, teamColor, TEXT_ALIGN_CENTER)
        draw.DrawText(v:SteamName().." - "..v:SteamID64(), "ixTinyFont", pos.x, pos.y + 10, color_white, TEXT_ALIGN_CENTER)
    end

    for k, v in pairs(ents.GetAll()) do
        if not ( IsValid(v) and ix.cassie.espEntities[v:GetClass()] ) then
            continue
        end

        if not ( ix.option.Get(ix.cassie.espEntities[v:GetClass()]) ) then
            continue
        end
        
        local pos = (v:GetPos() + v:OBBCenter()):ToScreen()
        local name = ix.cassie.espEntities[v:GetClass()]
        if ( v:GetClass() == "ix_item" ) then
            local itemTable = v:GetItemTable()

            name = itemTable.name or ""
        elseif ( v:GetClass() == "ix_container" ) then
            name = v:GetDisplayName() or ""
        elseif ( v:GetClass() == "ix_money" ) then
            name = ix.currency.Get(v:GetAmount()) or ""
        elseif ( v:GetClass() == "ix_vendor" ) then
            name = v.HUDName or ""
        elseif ( v.HUDName ) then
            name = v.HUDName or ""
        end

        draw.DrawText(name, "ixSmallFont", pos.x, pos.y, ix.config.Get("color"), TEXT_ALIGN_CENTER)
        draw.DrawText(v:GetClass(), "ixSmallFont", pos.x, pos.y + 15, color_white, TEXT_ALIGN_CENTER)
    end
end

function PLUGIN:PopulateScoreboardPlayerMenu(client, menu)
    local ply = LocalPlayer()

    menu:AddOption("Copy Steam Name", function()
        SetClipboardText(client:SteamName())
    end)

    if ( ply:IsAdmin() ) then
        menu:AddSpacer()

        menu:AddOption("Copy Current Name", function()
            SetClipboardText(client:Nick())
        end)

        menu:AddOption("Copy Current Model", function()
            SetClipboardText(client:GetModel())
        end)

        menu:AddOption("Copy Permanent Name", function()
            if ( client:GetCharacter():GetData("originalName") ) then
                SetClipboardText(client:GetCharacter():GetData("originalName"))
            else
                ix.util.Notify("Nonset Name...")
            end
        end)

        menu:AddOption("Copy Permanent Model", function()
            if ( client:GetCharacter():GetData("originalModel") ) then
                SetClipboardText(client:GetCharacter():GetData("originalModel"))
            else
                ix.util.Notify("Nonset Model...")
            end
        end)

        menu:AddSpacer()
        
        menu:AddOption("Set Current Name", function()
            Derma_StringRequest("Set Current Name", "", client:Nick(), function(text)
                RunConsoleCommand("ix", "charsetname", client:Nick(), text)
            end)
        end)
        
        menu:AddOption("Set Current Model", function()
            Derma_StringRequest("Set Current Model", "", client:GetModel(), function(text)
                RunConsoleCommand("sam", "setmodel", client:Nick(), text)
            end)
        end)
        
        menu:AddOption("Set Permanent Name", function()
            Derma_StringRequest("Set Permanent Name", "", client:GetCharacter():GetData("originalName"), function(text)
                RunConsoleCommand("ix", "ForceRoleplayName", client:Nick(), text)
            end)
        end)
        
        menu:AddOption("Set Permanent Model", function()
            Derma_StringRequest("Set Permanent Model", "", client:GetCharacter():GetData("originalModel"), function(text)
                RunConsoleCommand("ix", "SetPermaModel", client:Nick(), text)
            end)
        end)

        menu:AddSpacer()

        menu:AddOption("Goto", function()
            RunConsoleCommand("sam", "goto", client:Nick())
        end)
        
        menu:AddOption("Bring", function()
            RunConsoleCommand("sam", "bring", client:Nick())
        end)

        menu:AddSpacer()
        
        menu:AddOption("Set Health", function()
            Derma_StringRequest("Set Health", "", "100", function(amount)
                RunConsoleCommand("sam", "hp", client:Nick(), amount)
            end)
        end)
        
        menu:AddOption("Set Armor", function()
            Derma_StringRequest("Set Armor", "", "100", function(amount)
                RunConsoleCommand("sam", "armor", client:Nick(), amount)
            end)
        end)

        menu:AddSpacer()
        
        menu:AddOption("Give Warning", function()
            Derma_StringRequest("Give Warning", "", "", function(text)
                RunConsoleCommand("ix", "GiveWarning", client:Nick(), text)
            end)
        end)
        
        menu:AddOption("Get Warnings", function()
            RunConsoleCommand("ix", "GetWarnings", client:Nick())
        end)
        
        menu:AddOption("List Warnings", function()
            RunConsoleCommand("ix", "ListWarnings", client:Nick())
        end)
    end
end