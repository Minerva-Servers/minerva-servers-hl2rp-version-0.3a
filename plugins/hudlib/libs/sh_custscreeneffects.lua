ix.custscreeneffect         = ix.custscreeneffect or { }
ix.custscreeneffect.stored  = ix.custscreeneffect.stored or { }
ix.custscreeneffect.current = ix.custscreeneffect.current

function ix.custscreeneffect.LoadFromDirectory( dir )
    ix.custscreeneffect.stored = { }
    ix.custscreeneffect.current = nil
    local files = file.Find( dir .. "/*.lua", "LUA" )

    if ( #files < 1 ) then
        return
    end

    SCREENEFFECT = { }
    for i, v in ipairs( files ) do
        if ( CLIENT ) then
            include( dir .. "/" .. v )
            ix.custscreeneffect.stored[ string.StripExtension( v ) ] = table.Copy( SCREENEFFECT )
        else
            AddCSLuaFile( dir .. "/" .. v )
        end

        SCREENEFFECT = { }
    end

    SCREENEFFECT = nil
end

if ( CLIENT ) then
    function ix.custscreeneffect.GetCurrent()
        return ix.custscreeneffect.current
    end

    function ix.custscreeneffect.SetCurrent( screeneffect )
        ix.custscreeneffect.current = isfunction( screeneffect ) and screeneffect or ix.custscreeneffect.stored[ screeneffect ]
    end
end
