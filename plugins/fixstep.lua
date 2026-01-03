PLUGIN.name     = 'Third-person double step fix'
PLUGIN.author   = 'Bilwin'

if CLIENT then
    local steps = {'.stepleft', '.stepright'}
    function PLUGIN:EntityEmitSound(data)
        if not IsValid(data.Entity) and not data.Entity:IsPlayer() then return end

        local sName = data.OriginalSoundName
        if sName:find(steps[1]) || sName:find(steps[2]) then
            return false
        end
    end
end
