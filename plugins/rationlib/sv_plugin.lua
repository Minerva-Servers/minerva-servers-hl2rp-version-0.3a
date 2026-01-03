local PLUGIN = PLUGIN

util.AddNetworkString("ixRations.UpdateClient")

function PLUGIN:SaveRationDispensers()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_rationdispenser")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("rationDispensers", data)
end

function PLUGIN:LoadRationDispensers()
    for _, v in ipairs(ix.data.Get("rationDispensers") or {}) do
        local rationDispensers = ents.Create("ix_rationdispenser")

        rationDispensers:SetPos(v[1])
        rationDispensers:SetAngles(v[2])
        rationDispensers:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveRationDispensers()
end

function PLUGIN:LoadData()
    self:LoadRationDispensers()
end

function PLUGIN:InitializedPlugins()
    if ( timer.Exists("ixRations.NextGlobalRations") ) then
        return
    end

    timer.Create("ixRations.NextGlobalRations", 3600, 0, function()
        timer.Simple(290, function()
            ix.event.PlaySoundGlobal({
                sound = "minerva/global/music/other/rations.mp3",
                volume = 0.5,
            })
        end)

        timer.Simple(300, function()
            ix.rations.globalRationsEnabled = true
            ix.rations.globalRationsClaimed = {}

            ix.boxNotify.BoxNotify("Rations are now available!")
            ix.dispatch.announce("All local residents, your hourly intake of rations are now available, please proceed to the nearest ration center to claim your hourly ration.")

            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav",
                volume = 0.5,
            })

            timer.Simple(300, function()
                ix.rations.globalRationsEnabled = false
                ix.rations.globalRationsClaimed = {}

                ix.boxNotify.BoxNotify("Rations are no longer available!")

                ix.event.PlaySoundGlobal({
                    sound = "npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav",
                    volume = 0.5,
                })
            end)
        end)
    end)
end