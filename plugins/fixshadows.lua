PLUGIN.name = "Shadows Overhaul"
PLUGIN.author = "Bilwin"

if ( SERVER ) then
    function PLUGIN:InitPostEntity()
        for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
            if ( IsValid(v) and v:IsDoor() ) then
                v:DrawShadow(false)
                v:SetKeyValue("returndelay", "-1")
            end
        end
    end
end

if ( CLIENT ) then
    timer.Create("FixShadows", 10, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            ply:DrawShadow(false)
        end

        for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
            if ( IsValid(v) and v:IsDoor() ) then
                v:DrawShadow(false)
            end
        end
    end)
end