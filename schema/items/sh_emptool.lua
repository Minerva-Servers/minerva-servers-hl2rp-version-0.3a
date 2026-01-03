ITEM.name = "EMP Tool"
ITEM.description = "A multi-tool that could be used to brute force certain electronic systems to give the user unauthorized access."
ITEM.model = "models/alyx_emptool_prop.mdl"
ITEM.category = "Tools"

ITEM.functions.EMP = {
    name = "Overload",
    OnRun = function(itm)
        local ply = itm.player

        local data = {}
			data.start = ply:GetShootPos()
			data.endpos = data.start + ply:GetAimVector() * 96
			data.filter = ply
		local target = util.TraceLine(data).Entity

        if ( target and IsValid(target) ) then
            ply:SetAction("Using the EMP", 5)
            ply:DoStaredAction(target, function()
                if ( target:GetClass() == "ix_combinelock" ) then
                    if ( target ) then
                        if ( target:GetLocked() ) then
                            target:SetLocked(false)

                            target:EmitSound("weapons/stunstick/alyx_stunner1.wav")

                            target.sparks = EffectData()
                            target.sparks:SetOrigin(ply:GetEyeTrace().HitPos)
                            target.sparks:SetNormal(-ply:GetAngles():Forward())
                            target.sparks:SetMagnitude(2)
                            target.sparks:SetEntity(target)

                            util.Effect( "ElectricSpark", target.sparks, true, true )
                        else
                            ply:Notify("This lock is already disabled.")
                        end
                    end
                elseif ( target:GetClass() == "ix_forcefield" ) then
                    if ( target:GetMode() != 1 ) then
                        target:SetMode(1)
                        target:EmitSound("weapons/stunstick/alyx_stunner1.wav")

                        target.sparks = EffectData()
                        target.sparks:SetOrigin(ply:GetEyeTrace().HitPos)
                        target.sparks:SetNormal(-ply:GetAngles():Forward())
                        target.sparks:SetMagnitude(2)
                        target.sparks:SetEntity(target)

                    util.Effect( "ElectricSpark", target.sparks, true, true )
                    else
                        ply:Notify("This forcefield is already disabled.")
                    end
                elseif ( target:GetClass() == "func_door" ) then
                    if (!target:HasSpawnFlags(256) and !target:HasSpawnFlags(1024)) then
                        target:Fire("open")

                        target:EmitSound("weapons/stunstick/alyx_stunner1.wav")

                        target.sparks = EffectData()
                        target.sparks:SetOrigin(ply:GetEyeTrace().HitPos)
                        target.sparks:SetNormal(-ply:GetAngles():Forward())
                        target.sparks:SetMagnitude(2)
                        target.sparks:SetEntity(target)

                        util.Effect( "ElectricSpark", target.sparks, true, true )
                    end
                end


            end, 5)
        end

        return false
    end,
    OnCanRun = function(itm)
        local ply = itm.player

        local data = {}
			data.start = ply:GetShootPos()
			data.endpos = data.start + ply:GetAimVector() * 96
			data.filter = ply
		local target = util.TraceLine(data).Entity

        if ( target and IsValid(target) ) then
            if ( target:GetClass() == "ix_combinelock" ) then
                if ( target ) then
                    return true
                end
            elseif ( target:GetClass() == "ix_forcefield" ) then
                if ( target:GetMode() != 1 ) then
                    return true
                end
            elseif ( target:GetClass() == "func_door" ) then
                if (!target:HasSpawnFlags(256) and !target:HasSpawnFlags(1024)) then
                    return true
                end
            end
        end

        return false
    end
}