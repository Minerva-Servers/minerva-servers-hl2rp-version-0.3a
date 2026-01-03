local PLUGIN = PLUGIN

ix.cityCode = ix.cityCode or {}
ix.cityCode.codes = ix.cityCode.codes or {}

--[[---------------------------------------------------------------------------
    City Code List
---------------------------------------------------------------------------]]--

ix.cityCode.codes = {
    ["void"] = {
        color = Color(0, 255, 255),
        name = "Void",
        description = [[Unfinished Description.]],
        onCheckAccess = function(ply)
            return ( ply:IsSuperAdmin() )
        end,
        onStart = function()
            ix.event.PlaySoundGlobal({
                sound = "minerva/hl2rp/ambience/emergency_code_void.wav",
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens3.wav",
                delay = 1,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/strange_talk"..math.random(1, 11)..".wav",
                delay = 3,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/strange_talk"..math.random(1, 11)..".wav",
                delay = 6,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/portal_open1_adpcm.wav",
                delay = 10,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/core_partialcontain_loop1.wav",
                volume = 0.1,
                delay = 12,
            })
            ix.event.PlaySoundGlobal({
                sound = "minerva/hl2rp/ambience/void.wav",
                delay = 12,
            })
            ix.event.PlaySoundGlobal({
                sound = "minerva/hl2rp/ambience/voidmuffled.wav",
                delay = 12,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_sickdrone_loop4.wav",
                volume = 0.1,
                delay = 12,
            })

            timer.Simple(12, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/hole_hit"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/terrain_rumble1.wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_weird_voices"..math.random(1, 2)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_postblast_thunder1.wav",
                })
            
                ix.event.EmitShake(5, 5, 5)
            
                for k, v in pairs(player.GetAll()) do
                    v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
                end
            
                local pos = Vector(-7261.7890625, -6851.3237304688, -15268.021484375)
            
                local portalStormClouds = ents.Create("prop_dynamic")
                portalStormClouds:SetPos(pos)
                portalStormClouds:SetModel("models/props_combine/combine_citadelcloud001c.mdl")
                portalStormClouds:SetModelScale(2)
                portalStormClouds:Spawn()
                
                local portalStorm = ents.Create("prop_dynamic")
                portalStorm:SetPos(pos + Vector(0, 0, 100))
                portalStorm:SetModel("models/props_combine/combine_citadelcloudcenter.mdl")
                portalStorm:SetModelScale(1)
                portalStorm:Spawn()

                SetGlobalBool("voidactive", true)

                timer.Create("void_ambience1", 7, 0, function()
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/atmosphere/hole_hit"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/city/citadel_cloudhit"..math.random(1, 5)..".wav",
                    })
                    
                    ix.event.EmitShake(5, 5, 5)
                end)
            
                timer.Create("void_ambience2", 3, 0, function()
                    ix.event.PlaySoundGlobal({
                        sound = table.Random({
                            "ambient/levels/streetwar/city_battle1.wav",
                            "ambient/levels/streetwar/city_battle2.wav",
                            "ambient/levels/streetwar/city_battle3.wav",
                            "ambient/levels/streetwar/city_battle4.wav",
                            "ambient/levels/streetwar/city_battle5.wav",
                            "ambient/levels/streetwar/city_battle6.wav",
                            "ambient/levels/streetwar/city_battle7.wav",
                            "ambient/levels/streetwar/city_battle8.wav",
                            "ambient/levels/streetwar/city_battle9.wav",
                            "ambient/levels/streetwar/city_battle10.wav",
                            "ambient/levels/streetwar/city_battle11.wav",
                            "ambient/levels/streetwar/city_battle12.wav",
                            "ambient/levels/streetwar/city_battle13.wav",
                            "ambient/levels/streetwar/city_battle14.wav",
                            "ambient/levels/streetwar/city_battle15.wav",
                            "ambient/levels/streetwar/city_battle16.wav",
                            "ambient/levels/streetwar/city_battle17.wav",
                            "ambient/levels/streetwar/city_battle18.wav",
                            "ambient/levels/streetwar/city_battle19.wav",
                            "ambient/levels/streetwar/strider_1.wav",
                            "ambient/levels/streetwar/strider_2.wav",
                            "ambient/levels/streetwar/strider_3.wav",
                            "minerva/hl2rp/ambience/distant_battle_dropship01.wav",
                            "minerva/hl2rp/ambience/distant_battle_dropship02.wav",
                            "minerva/hl2rp/ambience/distant_battle_dropship03.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire01.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire02.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire03.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire04.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire05.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire06.wav",
                            "minerva/hl2rp/ambience/distant_battle_gunfire07.wav",
                            "minerva/hl2rp/ambience/distant_battle_shotgun01.wav",
                            "minerva/hl2rp/ambience/distant_battle_soldier01.wav",
                            "ambient/levels/streetwar/gunship_distant1.wav",
                            "ambient/levels/streetwar/heli_distant1.wav",
                            "ambient/machines/heli_pass1.wav",
                            "ambient/machines/heli_pass2.wav",
                            "ambient/machines/heli_pass_distant1.wav",
                            "ambient/machines/heli_pass_quick1.wav",
                            "ambient/machines/heli_pass_quick2.wav",
                            "ambient/overhead/hel1.wav",
                            "ambient/overhead/hel2.wav",
                            "ambient/overhead/plane1.wav",
                            "ambient/overhead/plane2.wav",
                            "ambient/overhead/plane3.wav",
                        })
                    })
                end)
            
                timer.Create("void_ambience3", 120, 0, function()
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1, 6)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/citadel/strange_talk"..math.random(1, 11)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/citadel/strange_talk"..math.random(1, 11)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/atmosphere/hole_hit"..math.random(1, 5)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/atmosphere/terrain_rumble1.wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/labs/teleport_weird_voices"..math.random(1, 2)..".wav",
                    })
                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/labs/teleport_postblast_thunder1.wav",
                    })
            
                    ix.event.EmitShake(5, 5, 5)
            
                    for k, v in pairs(player.GetAll()) do
                        v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
                    end
                end)
            end)
        end,
        onEnd = function()
            timer.Remove("void_ambience1")
            timer.Remove("void_ambience2")
            timer.Remove("void_ambience3")
            
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_flyer1.wav",
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens.wav",
                delay = 3,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/stalk_traindooropen.wav",
                delay = 4,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1, 6)..".wav",
                delay = 6,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1, 6)..".wav",
                delay = 8,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/labs/teleport_mechanism_windup5.wav",
                delay = 9,
            })

            timer.Simple(17, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/hole_hit"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/terrain_rumble1.wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1, 6)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1, 6)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_winddown1.wav",
                    delay = 1,
                })
            
                ix.event.EmitShake(5, 5, 5)
        
                for k, v in pairs(player.GetAll()) do
                    v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
                end
        
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_weird_voices"..math.random(1, 2)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_postblast_thunder1.wav",
                })

                for _, v in pairs(ents.FindByClass("prop_dynamic")) do
                    if ( v:GetModel() == "models/props_combine/combine_citadelcloudcenter.mdl" or v:GetModel() == "models/props_combine/combine_citadelcloud001c.mdl" ) then
                        SafeRemoveEntity(v)
                    end
                end

                SetGlobalBool("voidactive", nil)
            end)

            timer.Simple(6, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/hole_hit"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/terrain_rumble1.wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_weird_voices"..math.random(1, 2)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_postblast_thunder1.wav",
                })
        
                ix.event.EmitShake(5, 5, 5)
        
                for k, v in pairs(player.GetAll()) do
                    v:ScreenFade(SCREENFADE.IN, ColorAlpha(color_white, 100), 5, 0)
                end
            end)
        
            timer.Simple(8, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/hole_hit"..math.random(1, 5)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/atmosphere/terrain_rumble1.wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_weird_voices"..math.random(1, 2)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/labs/teleport_postblast_thunder1.wav",
                })
        
                ix.event.EmitShake(5, 5, 5)
        
                for k, v in pairs(player.GetAll()) do
                    v:ScreenFade(SCREENFADE.IN, ColorAlpha(color_white, 100), 5, 0)
                end
            end)
            
            ix.event.StopSoundGlobal("ambient/levels/citadel/core_partialcontain_loop1.wav")
            ix.event.StopSoundGlobal("ambient/levels/citadel/citadel_sickdrone_loop4.wav")
            ix.event.StopSoundGlobal("ambient/levels/citadel/citadel_drone_loop1.wav")
        end,
    },
    ["aj"] = {
        color = Color(250, 200, 0),
        name = "Autonomous Judgement",
        description = [[Unfinished Description.]],
        onCheckAccess = function(ply)
            return ( ply:IsCombineSupervisor() or ply:IsAdmin() )
        end,
        onStart = function()
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav",
            })
            ix.dispatch.announce("Attention, all ground-protection teams, Autonomous Judgement is now in effect. Sentencing is now discretionary. Code, AMPUTATE, ZERO, CONFIRM.")

            timer.Create("aj_ambience1", 60, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/alarms/citadel_alert_loop2.wav",
                    pitch = 70,
                    volume = 0.8,
                })
                ix.event.EmitShake(2, 2, 4, 0.5)
                ix.event.EmitShake(1, 1, 5, 4.5)
            end)

            timer.Create("aj_ambience2", 3, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/city_battle"..math.random(1, 19)..".wav",
                    volume = math.random(0.10, 0.30),
                    delay = math.random(0, 2.0),
                })
            end)
        end,
        onEnd = function()
            ix.event.StopSoundGlobal("ambient/levels/citadel/citadel_drone_loop1.wav")

            timer.Remove("aj_ambience1")
            timer.Remove("aj_ambience2")
        end,
    },
    ["jw"] = {
        color = Color(150, 0, 0),
        name = "Judgement Waiver",
        description = [[Unfinished Description.]],
        onCheckAccess = function(ply)
            return ( ply:IsCombineCommand() or ply:IsAdmin() )
        end,
        onStart = function()
            for k, v in ipairs(player.GetAll()) do
                v:GiveAchievement("firstjw") 
            end

            if ( game.GetMap() == "rp_minerva_city8" ) then
                for _, v in pairs(ents.FindByModel("combine_citadel")) do
                    v:Fire("SetAnimation", "open")
                end

                ix.event.EmitShake(5, 5, 5)
                ix.event.EmitShake(5, 5, 5, 11.5)
                ix.event.EmitShake(5, 5, 5, 16)
                ix.event.EmitShake(5, 5, 5, 32)
                ix.event.EmitShake(5, 5, 5, 36)

                ix.event.PlaySoundGlobal({
                    sound = "city8/city8-citadel.wav",
                })

                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/citadel_drone_loop2.wav",
                    volume = 0.3,
                    delay = 36,
                })
            
                timer.Create("ixJWBuzz", 10, 0, function()
                    ix.event.EmitShake(5, 5, 1)
                    
                    ix.event.PlaySoundGlobal({
                        sound = "city8/city8-jwbuzzer.wav",
                    })

                    ix.event.PlaySoundGlobal({
                        sound = "ambient/levels/city/citadeloutsidefx0"..math.random(1, 9)..".wav",
                        delay = math.random(3, 15),
                    })
                end)

                return
            elseif ( game.GetMap() == "rp_city24_v3" ) then
                ix.dispatch.announce("Attention, all ground-protection teams, Judgement Waiver now in effect. Capital prosecution is discretionary.", 1)
                ix.event.PlaySoundGlobal({
                    sound = "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav",
                    delay = 1,
                })

                for _, v in pairs(ents.FindByName("night_events")) do
                    v:Fire("trigger")
                end

                for _, v in pairs(ents.FindByName("jw_on_logic")) do
                    v:Fire("trigger")
                end

                return
            end

            for _, v in pairs(ents.FindByName("citadel")) do
                v:Fire("SetAnimation", "open")
            end

            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 90,
            })
            ix.event.EmitShake(5, 5, 0.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 80,
                delay = 0.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 0.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 70,
                delay = 1,
            })
            ix.event.EmitShake(5, 5, 0.5, 1)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 60,
                delay = 1.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 1.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 50,
                delay = 2,
            })
            ix.event.EmitShake(5, 5, 0.5, 2)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 40,
                delay = 2.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 2.5)
            ix.event.PlaySoundGlobal({
                sound = "ambient/weather/thunder1.wav",
                volume = 1,
                delay = 3,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/weather/thunder1.wav",
                volume = 1,
                delay = 3,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_drone_loop2.wav",
                volume = 0.3,
                delay = 3.5,
            })
            ix.event.EmitShake(7, 5, 5, 3)
            ix.dispatch.announce("Attention, all ground-protection teams, Judgement Waiver now in effect. Capital prosecution is discretionary.", 4)
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav",
                delay = 4,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1,6)..".wav",
                delay = 30,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens2.wav",
                pitch = 80,
                delay = 32,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens.wav",
                pitch = 80,
                delay = 40,
            })

            ix.event.PlaySoundGlobal({
                sound = "ambient/alarms/citadel_alert_loop2.wav",
                volume = 0.8,
                delay = 5,
            })
            ix.event.EmitShake(3, 3, 4, 0.5)
            ix.event.EmitShake(2, 2, 5, 4.5)

            timer.Create("jw_ambience1", 50, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/alarms/citadel_alert_loop2.wav",
                    volume = 0.8,
                })
                ix.event.EmitShake(3, 3, 4, 0.5)
                ix.event.EmitShake(2, 2, 5, 4.5)
            end)

            timer.Create("jw_ambience2", 30, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/citadel_5sirens2.wav",
                    pitch = 80,
                })
                ix.event.EmitShake(1, 1, 5)
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/citadel_5sirens.wav",
                    pitch = 80,
                    delay = 8,
                })
                ix.event.EmitShake(1, 1, 5, 8)
            end)

            timer.Create("jw_ambience3", 5, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/city_battle"..math.random(1, 19)..".wav",
                    volume = math.random(0.10, 0.30),
                    delay = math.random(0, 2.0),
                })
            end)

            timer.Create("jw_ambience4", 300, 0, function()
                ix.dispatch.announce("Judgement Waiver is still on-going. Capital prosecution is discretionary.")
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1,6)..".wav",
                })
            end)
        end,
        onEnd = function()
            if ( game.GetMap() == "rp_minerva_city8" ) then
                for _, v in pairs(ents.FindByModel("combine_citadel")) do
                    v:Fire("SetAnimation", "open")
                end
                
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/citadel_5sirens3.wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/city/citadeloutsidefx0"..math.random(1, 9)..".wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/machines/wall_ambient1.wav",
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/machines/wall_move2.wav",
                    delay = 4,
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/machines/wall_crash1.wav",
                    delay = 10,
                })
                ix.event.EmitShake(4, 4, 10, 0)
                ix.event.EmitShake(5, 5, 7, 10)
                ix.event.EmitViewPunch(Angle(4, 0, 0), 10)
                ix.event.StopSoundGlobal("ambient/levels/citadel/citadel_drone_loop2.wav", 10)

                ix.event.PlaySoundGlobal({
                    sound = "ambient/machines/wall_move5.wav",
                    delay = 12,
                })
                ix.event.PlaySoundGlobal({
                    sound = "doors/door_metal_large_chamber_close1.wav",
                    delay = 15,
                })
                ix.event.EmitShake(2, 2, 5, 15)
                ix.event.EmitViewPunch(Angle(2, 0, 0), 15)
                ix.event.StopSoundGlobal("ambient/machines/wall_move5.wav", 15)

                ix.event.PlaySoundGlobal({
                    sound = "ambient/machines/wall_move5.wav",
                    delay = 17,
                })
                ix.event.PlaySoundGlobal({
                    sound = "doors/door_metal_large_chamber_close1.wav",
                    delay = 20,
                })
                ix.event.EmitShake(2, 2, 5, 20)
                ix.event.EmitViewPunch(Angle(2, 0, 0), 20)
                ix.event.StopSoundGlobal("ambient/machines/wall_move5.wav", 20)

                timer.Remove("ixJWBuzz")

                return
            elseif ( game.GetMap() == "rp_city24_v3" ) then
                for _, v in pairs(ents.FindByName("day_events")) do
                    v:Fire("trigger")
                end

                for _, v in pairs(ents.FindByName("jw_off_logic")) do
                    v:Fire("trigger")
                end

                return
            end

            for _, v in pairs(ents.FindByName("citadel")) do
                v:Fire("SetAnimation", "idle")
            end

            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/portal_beam_shoot"..math.random(1,6)..".wav",
            })

            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens2.wav",
                pitch = 80,
            })

            ix.event.StopSoundGlobal("ambient/levels/citadel/citadel_drone_loop2.wav")

            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 40,
            })
            ix.event.EmitShake(5, 5, 0.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 50,
                delay = 0.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 0.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 60,
                delay = 1,
            })
            ix.event.EmitShake(5, 5, 0.5, 1)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 70,
                delay = 1.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 1.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 80,
                delay = 2,
            })
            ix.event.EmitShake(5, 5, 0.5, 2)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 90,
                delay = 2.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 2.5)

            timer.Remove("jw_ambience1")
            timer.Remove("jw_ambience2")
            timer.Remove("jw_ambience3")
            timer.Remove("jw_ambience4")
        end,
    },
    ["turmoil"] = {
        color = Color(250, 100, 0),
        name = "City Turmoil",
        description = [[The Sociostatus has taken moderate damage, units are to have weapons ready at all times and to stay vigilant. Overwatch Delegates may deploy but must'nt enter the 404 Zone Sewers.]],
        onCheckAccess = function(ply)
            return ( ply:IsCombineCommand() or ply:IsAdmin() )
        end,
        onStart = function()
            for i = 1, 3 do
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav",
                    volume = 1,
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav",
                    volume = 1,
                    delay = 4,
                })
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav",
                    volume = 1,
                    delay = 7,
                })
            end
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/advisor_lift.wav",
                volume = 1,
            })
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav",
                volume = 1,
                delay = 5,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens3.wav",
                volume = 1,
                delay = 6,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens3.wav",
                volume = 1,
                delay = 7,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/advisor_lift.wav",
                volume = 1,
                delay = 7,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/drone1lp.wav",
                volume = 0.5,
                delay = 7,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/stalk_traindooropen.wav",
                volume = 1,
                delay = 9,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/streetwar/city_riot2.wav",
                volume = 1,
                delay = 9,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens3.wav",
                volume = 1,
                delay = 12,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/streetwar/heli_distant1.wav",
                volume = 1,
                delay = 19,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/streetwar/gunship_distant1.wav",
                volume = 1,
                delay = 25,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/streetwar/gunship_distant2.wav",
                volume = 1,
                delay = 30,
            })
            ix.event.EmitShake(5, 5, 3)
            ix.event.EmitShake(5, 5, 3, 4)
            ix.event.EmitShake(5, 5, 3, 7)

            timer.Simple(5, function()
                ix.dispatch.announce("Attention Protection Team: status evasion in progress in this community. Respond, isolate, inquire.")
            end)

            timer.Create("turmoil_ambience1", 3, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = table.Random({
                        "ambient/levels/streetwar/city_battle1.wav",
                        "ambient/levels/streetwar/city_battle2.wav",
                        "ambient/levels/streetwar/city_battle3.wav",
                        "ambient/levels/streetwar/city_battle4.wav",
                        "ambient/levels/streetwar/city_battle5.wav",
                        "ambient/levels/streetwar/city_battle6.wav",
                        "ambient/levels/streetwar/city_battle7.wav",
                        "ambient/levels/streetwar/city_battle8.wav",
                        "ambient/levels/streetwar/city_battle9.wav",
                        "ambient/levels/streetwar/city_battle10.wav",
                        "ambient/levels/streetwar/city_battle11.wav",
                        "ambient/levels/streetwar/city_battle12.wav",
                        "ambient/levels/streetwar/city_battle13.wav",
                        "ambient/levels/streetwar/city_battle14.wav",
                        "ambient/levels/streetwar/city_battle15.wav",
                        "ambient/levels/streetwar/city_battle16.wav",
                        "ambient/levels/streetwar/city_battle17.wav",
                        "ambient/levels/streetwar/city_battle18.wav",
                        "ambient/levels/streetwar/city_battle19.wav",
                        "ambient/levels/streetwar/city_battle17.wav",
                        "minerva/hl2rp/ambience/distant_battle_citizen01.wav",
                        "minerva/hl2rp/ambience/distant_battle_dropship01.wav",
                        "minerva/hl2rp/ambience/distant_battle_dropship02.wav",
                        "minerva/hl2rp/ambience/distant_battle_explosion01.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire01.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire02.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire03.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire04.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire05.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire06.wav",
                        "minerva/hl2rp/ambience/distant_battle_gunfire07.wav",
                        "minerva/hl2rp/ambience/distant_battle_shotgun01.wav",
                        "minerva/hl2rp/ambience/distant_battle_soldier01.wav",
                    }),
                    volume = math.random(0.1, 0.3),
                    delay = math.random(0, 2.0),
                })
            end)

            timer.Create("turmoil_ambience2", 20, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = table.Random({
                        "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav",
                        "npc/overwatch/cityvoice/f_anticivil1_5_spkr.wav",
                        "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav",
                        "npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav",
                        "npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav",
                        "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav",
                    }),
                    volume = 0.2,
                    delay = math.random(0, 5.0),
                })
            end)
        end,
        onEnd = function()
            ix.event.StopSoundGlobal("ambient/levels/citadel/drone1lp.wav")
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/advisor_leave.wav",
                volume = 1,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/stalk_stalkertrainstartup.wav",
                volume = 0.3,
                delay = 1,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/stalk_stalkershakes_1_04_24.wav",
                volume = 1,
                delay = 4,
            })
            ix.event.EmitShake(5, 5, 3)

            timer.Remove("turmoil_ambience1")
            timer.Remove("turmoil_ambience2")
        end,
    },
    ["unrest"] = {
        color = Color(250, 200, 0),
        name = "Unrest Procedure",
        description = [[Unfinished Description.]],
        onCheckAccess = function(ply)
            return ( ply:IsCombineCommand() or ply:IsAdmin() )
        end,
        onStart = function()
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav",
            })

            ix.dispatch.announce("Attention community: unrest procedure code is now in effect. Inoculate, shield, pacify. Code: pressure, sword, sterilize.")
        end,
        onEnd = function()
        end,
    },
    ["civil"] = {
        color = Color(0, 250, 0),
        name = "Civil",
        description = [[Unfinished Description.]],
        onCheckAccess = function(ply)
            return ( ply:IsCombineCommand() or ply:IsAdmin() )
        end,
        onStart = function()
        end,
        onEnd = function()
        end,
    },
}