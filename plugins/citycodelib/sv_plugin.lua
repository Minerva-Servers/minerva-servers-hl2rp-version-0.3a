local PLUGIN = PLUGIN

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.Set()
    Desc: Sets a code.
---------------------------------------------------------------------------]]--

function ix.cityCode.Set(ply, code)
    if ( IsValid(ply) and ply:GetCharacter() ) then
        for k, v in pairs(player.GetAll()) do
            if ( v:IsAdmin() ) then
                ix.log.AddRaw(ply:Nick().." has set the code to "..ix.cityCode.codes[code].name..".")
            end
        end

        if ( ix.cityCode.Get(code) and ix.cityCode.Get(code).onCheckAccess ) then
            if ( ( ix.cityCode.coolDown or 0 ) < CurTime() ) then
                ix.cityCode.coolDown = CurTime() + 3
                if not ( ix.cityCode.Get(code).onCheckAccess(ply) ) then
                    ply:Notify("You do not have access to change the city code.")
                    return false
                end
            else
                ply:Notify("You must wait before using changing codes.")
                return false
            end
        end
    end

    -- stops all current codes which are active.
    for k, v in pairs(ix.cityCode.GetAll()) do
        if ( ix.cityCode.Get(k) and ix.cityCode.Get(k).onEnd ) then
            if ( ix.cityCode.GetCurrent() == k ) then
                ix.cityCode.Get(k).onEnd()
            end
        end
    end

    if ( ix.cityCode.Get(code) and ix.cityCode.Get(code).onStart ) then
        if not ( ix.cityCode.GetCurrent() == code ) then
            ix.cityCode.Get(code).onStart()
            ix.boxNotify.BoxNotify("City Code Status has been changed to "..ix.cityCode.Get(code).name, ix.cityCode.Get(code).color or color_white)
        end
    end
    
    SetGlobalString("ixCityCode", code)
end

concommand.Add("ix_code_set", function(ply, cmd, args)
    if not ( args[1] ) then
        ix.log.AddRaw("You haven't provided an argument.Usage: ix_code_set <code>")

        for k, v in SortedPairs(ix.cityCode.GetAll()) do
            ix.log.AddRaw(k)
        end

        return
    end
    
    if ( IsValid(ply) and not ix.cityCode.Get(args[1]).onCheckAccess(ply) ) then
        ix.log.AddRaw(ply:Nick().." has attempted to set the code to "..ix.cityCode.Get(args[1]).name, false)
        return
    end

    ix.log.AddRaw(ply:Nick().." has set the city code to "..ix.cityCode.Get(args[1]).name, false)
    ix.cityCode.Set(ply, tostring(args[1]) or "civil")  
end)