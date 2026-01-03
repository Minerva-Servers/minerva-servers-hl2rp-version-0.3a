ix.custcrosshair         = ix.custcrosshair or { }
ix.custcrosshair.stored  = ix.custcrosshair.stored or { }
ix.custcrosshair.current = ix.custcrosshair.current

function ix.custcrosshair.LoadFromDirectory( dir )
    ix.custcrosshair.stored = { }
    ix.custcrosshair.current = nil
    local files = file.Find( dir .. "/*.lua", "LUA" )

    if ( #files < 1 ) then
        return
    end

    CROSSHAIR = { }
    for i, v in ipairs( files ) do
        if ( CLIENT ) then
            include( dir .. "/" .. v )
            ix.custcrosshair.stored[ string.StripExtension( v ) ] = table.Copy( CROSSHAIR )
        else
            AddCSLuaFile( dir .. "/" .. v )
        end

        CROSSHAIR = { }
    end

    CROSSHAIR = nil
end

if ( CLIENT ) then
    function ix.custcrosshair.GetCurrent()
        return ix.custcrosshair.current
    end

    function ix.custcrosshair.SetCurrent( crosshair )
        ix.custcrosshair.current = isfunction( crosshair ) and crosshair or ix.custcrosshair.stored[ crosshair ]
    end
end
