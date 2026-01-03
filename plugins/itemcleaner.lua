local PUGIN = PLUGIN

PLUGIN.name = "Item Cleaner"
PLUGIN.description = "Adds a timer to clean up all dropped items in the map."
PLUGIN.author = "Riggs"

if ( SERVER ) then
    function PLUGIN:CreateTimer()
        timer.Create("ixItemCleaner", ix.config.Get("itemCleanerTimer", 3600), 0, function()
            timer.Simple(30, function()
                for _, v in pairs(ents.FindByClass("ix_item")) do
                    if ( IsValid(v) ) then
                        v:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1, 3)..".wav")

                        local position = v:LocalToWorld(v:OBBCenter())
                        local effect = EffectData()
                            effect:SetStart(position)
                            effect:SetOrigin(position)
                            effect:SetScale(3)
                        util.Effect("GlassImpact", effect)

                        SafeRemoveEntity(v)
                    end
                end

                ix.util.Notify("All dropped items have been removed automatically.")
            end)

            print("[item cleaner] Detected "..#ents.FindByClass("ix_item").." items.")

            ix.util.Notify("All dropped items will be removed automatically, in 30 seconds.")
        end)
    end

    function PLUGIN:InitPostEntity()
        if ( timer.Exists("ixItemCleaner") ) then
            return
        end

        self:CreateTimer()
    end
end

ix.config.Add("itemCleanerTimer", 3600, "Depends how long it should take for dropped items to be removed automatically in the map.", function()
    if ( timer.Exists("ixItemCleaner") ) then
        timer.Remove("ixItemCleaner")

        if ( SERVER ) then
            PLUGIN:CreateTimer()
        end

        print("[item cleaner] Removed old timer and created new one.")
    end
end, {
    category = PLUGIN.name,
    data = {
        decimals = 0,
        min = 60,
        max = 3600,
    },
})
