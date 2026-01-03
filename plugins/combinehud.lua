local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Combine Hud"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

if ( SERVER ) then
    return
end

surface.CreateFont("ixCombineHudFontMedium", {
    font = "Consolas",
    size = ScreenScale(8),
    scanlines = 2,
    antialias = true,
    shadow = true,
})

surface.CreateFont("ixCombineHudFontSmall", {
    font = "Consolas",
    size = ScreenScale(6),
    scanlines = 2,
    antialias = true,
    shadow = true,
})

surface.CreateFont("ixWaypointFont", {
    font = "Consolas",
    size = ScreenScale(8),
    outline = true,
})

function PLUGIN:HUDPaintAlternate(client, character)
    if not ( client:IsCombine() and character:IsCombine() ) then
        return
    end

    local players = player.GetAll()

    local teamCol = team.GetColor(client:Team())

    draw.DrawText("// LOCAL ASSET //", "ixCombineHudFontMedium", 10, 5, teamCol)
    draw.DrawText("/- "..client:Nick(), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8), color_white)
    draw.DrawText("/- VITALS: "..client:Health().."%", "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 2, color_white)

    local weapon = client:GetActiveWeapon()
    local weaponName = string.upper(language.GetPhrase(weapon:GetPrintName()))

    local weaponAmmo1 = weapon:Clip1()
    if ( weaponAmmo1 <= 0 ) then
        weaponAmmo1 = "N/A"
    end
    
    local weaponAmmo2 = client:GetAmmoCount(weapon:GetPrimaryAmmoType())
    if ( weaponAmmo2 <= 0 ) then
        weaponAmmo2 = "N/A"
    end
    
    local weaponAmmo3 = client:GetAmmoCount(weapon:GetSecondaryAmmoType())
    if ( weaponAmmo3 <= 0 ) then
        weaponAmmo3 = "N/A"
    end

    draw.DrawText("// LOCAL WEAPONRY //", "ixCombineHudFontMedium", 10, 5 + ScreenScale(8) * 4, teamCol)
    draw.DrawText("/- FIREARM: "..weaponName, "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 5, color_white)
    draw.DrawText("/- AM: ["..weaponAmmo1.."] | ["..weaponAmmo2.."]", "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 6, color_white)
    draw.DrawText("/- SC: ["..weaponAmmo3.."]", "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 7, color_white)

    draw.DrawText("// LOCAL INFORMATION //", "ixCombineHudFontMedium", 10, 5 + ScreenScale(8) * 9, teamCol)
    local cityCodeName = string.upper(ix.cityCode.GetName(ix.cityCode.GetCurrent()))
    local cityCodeColor = ix.cityCode.GetColor(ix.cityCode.GetCurrent())
    draw.DrawText("/- CODE: "..cityCodeName, "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 10, cityCodeColor)
    local area = client:GetArea() or "<UNDOCUMENTED ZONE>"
    draw.DrawText("/- LOCATION: "..area, "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 11, color_white)

    draw.DrawText("// LOCAL ASSETS //", "ixCombineHudFontMedium", 10, 5 + ScreenScale(8) * 13, teamCol)
    
    local y1 = 0
    for k, v in pairs(players) do
        if ( v:IsCP() and client:IsCP() ) then
            if ( v:GetCharacter() and v:GetCharacter():GetDefunct() ) then
                draw.DrawText("/- DEFUNCT - "..string.upper(v:Nick()), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 14 + y1, Color(255, 0, 0))
            else
                draw.DrawText("/- "..string.upper(v:Nick()), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 14 + y1, color_white)
            end
            y1 = y1 + ScreenScale(8)
        elseif ( v:IsOW() and client:IsOW() ) then
            if ( v:GetCharacter() and v:GetCharacter():GetDefunct() ) then
                draw.DrawText("/- DEFUNCT - "..string.upper(v:Nick()), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 14 + y1, Color(255, 0, 0))
            else
                draw.DrawText("/- "..string.upper(v:Nick()), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 14 + y1, color_white)
            end
            y1 = y1 + ScreenScale(8)
        end
    end

    local activeBols = {}
    
    local y2 = 0
    for k, v in pairs(players) do
        if ( v:GetCharacter() and v:GetCharacter():GetBol() ) then
            draw.DrawText("/- "..string.upper(v:Nick()), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 16 + y1 + y2, Color(255, 0, 0))
            activeBols[#activeBols + 1] = v
            y2 = y2 + ScreenScale(8)
        end
    end

    if ( #activeBols != 0 ) then
        draw.DrawText("// LOCAL BOLS //", "ixCombineHudFontMedium", 10, 5 + ScreenScale(8) * 15 + y1, teamCol)
        y1 = y1 + ScreenScale(8)
    end

    local activeInformants = {}
    
    local y3 = 0
    if ( #activeBols == 0 ) then
        y3 = y3 - ScreenScale(8)
    end

    for k, v in pairs(players) do
        if ( v:GetCharacter() and v:GetCharacter():GetInformant() ) then
            draw.DrawText("/- "..string.upper(v:Nick()), "ixCombineHudFontSmall", 10, 5 + ScreenScale(8) * 17 + y1 + y2 + y3, Color(0, 255, 0))
            activeInformants[#activeInformants + 1] = v
            y3 = y3 + ScreenScale(8)
        end
    end

    if ( #activeInformants != 0 ) then
        if ( #activeBols == 0 ) then
            y2 = y2 - ScreenScale(8)
            y3 = y3 - ScreenScale(8)
        end

        draw.DrawText("// LOCAL INFORMANTS //", "ixCombineHudFontMedium", 10, 5 + ScreenScale(8) * 16 + y1 + y2, teamCol)
        y2 = y2 + ScreenScale(8)
    end

    for k, v in pairs(ents.FindInSphere(client:GetPos(), 256)) do
        if ( IsValid(v) and v:IsPlayer() and v:Alive() ) and not ( v == client ) and not ( v:GetMoveType() == MOVETYPE_NOCLIP or v:GetNoDraw() ) then
            if not ( v:LookupBone("ValveBiped.Bip01_Spine2") ) then
                continue
            end
            
            local attachment = !v:IsVortigaunt() and v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Spine2")) or v:EyePos() - Vector(0, 0, 15)
            local pos = (attachment or v:GetPos() + Vector(0, 0, 15))
            local bone = pos:ToScreen()
            local name = string.upper(v:Nick())

            if ( v:GetCharacter() and v:GetCharacter():GetInformant() ) then
                if ( v:GetCharacter():GetBol() ) then
                    draw.DrawText("<:: MARKED INFORMANT ::>", "ixCombineHudFontSmall", bone.x, bone.y - 50, Color(0, 255, 0), TEXT_ALIGN_CENTER)
                else
                    draw.DrawText("<:: MARKED INFORMANT ::>", "ixCombineHudFontSmall", bone.x, bone.y - 25, Color(0, 255, 0), TEXT_ALIGN_CENTER)
                end
            end
            
            if ( v:GetCharacter() and v:GetCharacter():GetBol() ) then
                draw.DrawText("<:: MARKED BOL ::>", "ixCombineHudFontSmall", bone.x, bone.y - 25, Color(255, 0, 0), TEXT_ALIGN_CENTER)
            end
            
            if ( v:GetCharacter() and v:GetCharacter():GetDefunct() ) then
                draw.DrawText("<:: MARKED DEFUNCT ::>", "ixCombineHudFontSmall", bone.x, bone.y - 25, Color(255, 0, 0), TEXT_ALIGN_CENTER)
            end

            if ( v:IsCombine() ) then
                draw.DrawText("<:: "..name.." ::>", "ixCombineHudFontSmall", bone.x, bone.y, color_white, TEXT_ALIGN_CENTER)
                local className = v:GetTeamClassTable() and v:GetTeamClassTable().name or "UNKNOWN CLASS"
                draw.DrawText("<:: "..string.upper(className).." ::>", "ixCombineHudFontSmall", bone.x, bone.y + 25, color_white, TEXT_ALIGN_CENTER)
            end

            if ( ( client:IsCP() and client:GetTeamClass() == CLASS_CP_MEDICAL ) or ( client:IsOW() and client:GetTeamClass() == CLASS_OW_MEDICAL ) ) then
                draw.DrawText("<:: VITALS: "..v:Health().." ::>", "ixCombineHudFontSmall", bone.x, bone.y + 50, color_white, TEXT_ALIGN_CENTER)
            end
        end
    end
end
