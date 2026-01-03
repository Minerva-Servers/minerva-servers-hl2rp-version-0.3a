ALWAYS_RAISED["swep_construction_kit"] = true
ALWAYS_RAISED["ix_grenade"] = true
ALWAYS_RAISED["ix_pipebomb"] = true
ALWAYS_RAISED["cityworker_pliers"] = true
ALWAYS_RAISED["cityworker_shovel"] = true
ALWAYS_RAISED["cityworker_wrench"] = true

ix.lang.AddTable("english", {
    optShowVoiceBoxes = "Show voice boxes",
    optShowVignette = "Show vignette",
})

ix.option.Add("showVoiceBoxes", ix.type.bool, true, {
    category = "Appearance",
})

ix.option.Add("showVignette", ix.type.bool, true, {
    category = "Appearance",
})

ix.config.Add("cityName", "Seventeen", "", nil, {
    category = "Appearance",
})

ix.config.Add("cityNumber", "17", "", nil, {
    category = "Appearance",
})

ix.config.Add("cityIndex", "c17", "", nil, {
    category = "Appearance",
})

ix.config.Add("sectorIndex", "s17", "", nil, {
    category = "Appearance",
})

ix.config.Add("currencyPlural", "tokens", "", nil, {
    category = "Appearance",
})

ix.config.Add("currencySingular", "token", "", nil, {
    category = "Appearance",
})

ix.config.Add("currencySymbol", "T", "", nil, {
    category = "Appearance",
})

ix.config.Add("discordURL", "https://discord.gg/dnXSHNBwbP", "", nil, {
    category = "Appearance",
})

ix.config.Add("contentURL", "https://steamcommunity.com/sharedfiles/filedetails/?id=2884206618", "", nil, {
    category = "Appearance",
})

ix.config.Add("rulesURL", "https://docs.google.com/document/d/1BF82QLNwS76gHMAmLNhCtWVhejsjXG2Nc02peUwmyqY/edit", "", nil, {
    category = "Appearance",
})

ix.config.Add("rulesEmbedURL", "https://docs.google.com/document/d/e/2PACX-1vQsL-ZSXjEqy-zUeIF2ctyyTNiGD_c3OW_4ZCcPIEChbYwy2c6WA5Sr195xJ0a0VrvaptaJOgKj2aNw/pub", "", nil, {
    category = "Appearance",
})

ix.config.Add("shouldShowWatermark", true, "", nil, {
    category = "Appearance",
})

ix.config.Add("shoveTime", 20, "How long should a character be unconscious after being knocked out?", nil, {
    data = {min = 5, max = 60},
})

ix.config.Add("overwatchBalance", true, "", nil)
ix.config.Add("colorDim", Color(100, 100, 100), "", nil, {
    category = "Appearance",
})

ix.config.SetDefault("color", Color(150, 150, 150))
ix.config.SetDefault("communityText", "Discord Invite")
ix.config.SetDefault("communityURL", ix.config.Get("discordURL"))
ix.config.SetDefault("music", "music/hl1_song26.mp3")
ix.config.SetDefault("font", "Futura Std Medium")
ix.config.SetDefault("genericFont", "Futura Std Light")
ix.config.SetDefault("allowVoice", true)
ix.config.SetDefault("inventoryHeight", 4)
ix.config.SetDefault("inventoryWidth", 8)
ix.config.SetDefault("allowPush", true)
ix.config.SetDefault("loocDelay", 2)
ix.config.SetDefault("oocDelay", 5)
ix.config.SetDefault("itemPickupTime", 0.2)
ix.config.SetDefault("weaponRaiseTime", 0.2)
ix.config.SetDefault("spawnTime", 30)
ix.config.SetDefault("walkRatio", 0.8)
ix.config.SetDefault("walkSpeed", 100)
ix.config.SetDefault("runSpeed", 220)
ix.config.SetDefault("ATM Model", "models/props_combine/combine_intwallunit.mdl")
ix.config.SetDefault("voiceDistance", 800)
ix.config.SetDefault("staminaCrouchRegeneration", 10)
ix.config.SetDefault("staminaDrain", 0)
ix.config.SetDefault("staminaRegeneration", 10)
ix.config.SetDefault("thirdperson", true)

ix.config.ForceSet("thirdperson", true)

ix.anim.citizen_male.smg[ACT_MP_RUN] = {ACT_RUN_RPG_RELAXED, ACT_RUN_RIFLE_RELAXED}
ix.anim.citizen_male.shotgun[ACT_MP_RUN] = {ACT_RUN_RPG_RELAXED, ACT_RUN_RIFLE_RELAXED}

ix.anim.metrocop.smg[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_RIFLE}
ix.anim.metrocop.shotgun[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_RIFLE}

ix.anim.overwatch.smg[ACT_MP_WALK] = {"walkEasy_All", ACT_WALK_AIM_RIFLE}
ix.anim.overwatch.smg[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_RIFLE}

ix.anim.overwatch.shotgun[ACT_MP_WALK] = {"walkEasy_All", ACT_WALK_AIM_SHOTGUN}
ix.anim.overwatch.shotgun[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_RIFLE}

ix.anim.customMetrocop = ix.anim.metrocop
ix.anim.customMetrocop.pistol["reload"] = ACT_HL2MP_GESTURE_RELOAD_PISTOL
ix.anim.customMetrocop.smg["reload"] = ACT_HL2MP_GESTURE_RELOAD_AR2

ix.anim.customOverwatch = ix.anim.overwatch
ix.anim.customOverwatch.normal[ACT_MP_STAND_IDLE] = {"idle_unarmed", ACT_HL2MP_IDLE_FIST}
ix.anim.customOverwatch.normal[ACT_MP_CROUCH_IDLE] = {ACT_HL2MP_IDLE_CROUCH, ACT_HL2MP_IDLE_CROUCH_FIST}
ix.anim.customOverwatch.normal[ACT_MP_WALK] = {"walkunarmed_all", ACT_HL2MP_WALK_FIST}
ix.anim.customOverwatch.normal[ACT_MP_CROUCHWALK] = {ACT_HL2MP_WALK_CROUCH, ACT_HL2MP_WALK_CROUCH_FIST}
ix.anim.customOverwatch.normal[ACT_MP_RUN] = {ACT_HL2MP_RUN, ACT_HL2MP_RUN_FIST}

ix.anim.customOverwatch.pistol[ACT_MP_STAND_IDLE] = {"idle_unarmed", ACT_HL2MP_IDLE_REVOLVER}
ix.anim.customOverwatch.pistol[ACT_MP_CROUCH_IDLE] = {ACT_HL2MP_IDLE_CROUCH_REVOLVER, ACT_HL2MP_IDLE_CROUCH_REVOLVER}
ix.anim.customOverwatch.pistol[ACT_MP_WALK] = {"walkunarmed_all", ACT_HL2MP_WALK_REVOLVER}
ix.anim.customOverwatch.pistol[ACT_MP_CROUCHWALK] = {ACT_HL2MP_WALK_CROUCH_REVOLVER, ACT_HL2MP_WALK_CROUCH_REVOLVER}
ix.anim.customOverwatch.pistol[ACT_MP_RUN] = {ACT_HL2MP_RUN_PASSIVE, ACT_HL2MP_RUN_REVOLVER}
ix.anim.customOverwatch.pistol["reload"] = ACT_HL2MP_GESTURE_RELOAD_PISTOL

ix.anim.customOverwatch.smg["reload"] = ACT_HL2MP_GESTURE_RELOAD_AR2

ix.anim.SetModelClass("models/minerva/metrocop.mdl", "customMetrocop")
ix.anim.SetModelClass("models/minerva/combine_beta.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_border_patrol.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_commander.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_coordinator.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_elite.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_elite_wpu.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_guard.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_infestation.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_ordinal.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_recon.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_medic.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_shotgunner.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_soldier.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_suppressor.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_urban.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_urban_shotgunner.mdl", "customOverwatch")
ix.anim.SetModelClass("models/minerva/combine_wallhammer.mdl", "customOverwatch")

ix.currency.plural = ix.config.Get("currencyPlural")
ix.currency.singular = ix.config.Get("currencySingular")
ix.currency.symbol = ix.config.Get("currencySymbol")

player_manager.AddValidModel("CombineSoldierHands", "models/minerva/metrocop.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_beta.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_border_patrol.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_commander.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_coordinator.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_elite.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_elite_wpu.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_guard.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_infestation.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_ordinal.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_recon.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_medic.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_shotgunner.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_suppressor.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_urban.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_urban_shotgunner.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/minerva/combine_wallhammer.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_super_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldier_prisonguard.mdl")
player_manager.AddValidHands("CombineSoldierHands", "models/weapons/c_arms_combine.mdl", 1, "0000000")

if ( SERVER ) then
    if not ( game.IsDedicated() ) then
        RunConsoleCommand("hostname", "Minerva Servers: Half-Life 2 Roleplay (Private)")
        RunConsoleCommand("sv_loadingurl", "https://falco.wtf/minerva/")
    end

    RunConsoleCommand("arccw_mult_defaultammo", "0")
    RunConsoleCommand("arccw_mult_hipfire", "0.5")
    RunConsoleCommand("arccw_mult_damage", "0.66")
    RunConsoleCommand("arccw_override_hud_off", "1")
    RunConsoleCommand("arccw_override_crosshair_off", "1")

    if ( game.GetMap() == "rp_minerva_city17" ) then
        --RunConsoleCommand("sv_skyname", "sky_day02_01")

        for k, v in pairs(ents.FindByName("citadel")) do
            v:SetModelScale(2)
            v:SetPos(Vector(-8727.8505859375, -13123.782226563, -7562.2358398438))
        end
    end
end