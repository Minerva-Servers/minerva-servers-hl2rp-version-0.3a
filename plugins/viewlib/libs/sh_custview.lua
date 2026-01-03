ix.custview         = ix.custview or { }
ix.custview.stored  = ix.custview.stored or { }
ix.custview.current = ix.custview.current

function ix.custview.LoadFromDirectory( dir )
    ix.custview.stored = { }
    ix.custview.current = nil
    local files = file.Find( dir .. "/*.lua", "LUA" )

    if ( #files < 1 ) then
        return
    end

    VIEW = { }
    for i, v in ipairs( files ) do
        if ( CLIENT ) then
            include( dir .. "/" .. v )
            ix.custview.stored[ string.StripExtension( v ) ] = table.Copy( VIEW )
        else
            AddCSLuaFile( dir .. "/" .. v )
        end

        VIEW = { }
    end

    VIEW = nil
end

if ( CLIENT ) then
    function ix.custview.GetCurrent()
        return ix.custview.current
    end

    function ix.custview.SetCurrent( hud )
        ix.custview.current = isfunction( hud ) and hud or ix.custview.stored[ hud ]
    end
end
