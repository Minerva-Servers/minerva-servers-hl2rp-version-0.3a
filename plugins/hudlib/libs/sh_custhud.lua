ix.custhud         = ix.custhud or { }
ix.custhud.stored  = ix.custhud.stored or { }
ix.custhud.current = ix.custhud.current

function ix.custhud.LoadFromDirectory( dir )
    ix.custhud.stored = { }
    ix.custhud.current = nil
    local files = file.Find( dir .. "/*.lua", "LUA" )

    if ( #files < 1 ) then
        return
    end

    HUD = { }
    for i, v in ipairs( files ) do
        if ( CLIENT ) then
            include( dir .. "/" .. v )
            ix.custhud.stored[ string.StripExtension( v ) ] = table.Copy( HUD )
        else
            AddCSLuaFile( dir .. "/" .. v )
        end

        HUD = { }
    end

    HUD = nil
end

if ( CLIENT ) then
    function ix.custhud.GetCurrent()
        return ix.custhud.current
    end

    function ix.custhud.SetCurrent( hud )
        ix.custhud.current = isfunction( hud ) and hud or ix.custhud.stored[ hud ]
    end
end
