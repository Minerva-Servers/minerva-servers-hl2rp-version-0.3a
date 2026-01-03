local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Hud Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs & Scotnay"

ix.util.Include( "cl_hooks.lua" )

ix.custhud.LoadFromDirectory( PLUGIN.folder .. "/huds" )
ix.custcrosshair.LoadFromDirectory( PLUGIN.folder .. "/crosshairs" )
ix.custscreeneffect.LoadFromDirectory( PLUGIN.folder .. "/screeneffects" )

ix.lang.AddTable( "english", {
    optHudDesign = "Hud Design",
    optdHudDesign = "What type of Hud Design you would want.",
    
    optHudIconColor = "Hud Icon Color",
    optdHudIconColor = "Wether or not some icons should have color.",

    optScreeneffectDesign = "Screen Effect Design",
    optdScreeneffectDesign = "What type of Screen Effect Design you would want.",

    optCrosshairDesign = "Crosshair Design",
    optdCrosshairDesign = "What type of Crosshair Design you would want.",

    optCrosshairColor = "Crosshair Color",
    optdCrosshairColor = "What type of color you would want for your crosshair.",

    optCrosshairGap = "Crosshair Gap",
    optdCrosshairGap = "How big the gap should be on some crosshairs.",

    optCrosshairLength = "Crosshair Length",
    optdCrosshairLength = "How long the Length should be on some crosshairs.",
} )

ix.option.Add( "hudDesign", ix.type.array, "minerva", {
    category = PLUGIN.name,
    populate = function()
        local entries = { }


        for i, v in pairs( ix.custhud.stored ) do
            entries[ i ] = v.name
        end

        return entries
    end,
    OnChanged = function( old, new )
        ix.custhud.SetCurrent( new )
    end
} )

ix.option.Add( "crosshairDesign", ix.type.array, "circle", {
    category = PLUGIN.name,
    populate = function()
        local entries = { }


        for i, v in pairs( ix.custcrosshair.stored ) do
            entries[ i ] = v.name
        end

        return entries
    end,
    OnChanged = function( old, new )
        ix.custcrosshair.SetCurrent( new )
    end
} )

ix.option.Add( "screeneffectDesign", ix.type.array, "hl2rp", {
    category = PLUGIN.name,
    populate = function()
        local entries = { }


        for i, v in pairs( ix.custscreeneffect.stored ) do
            entries[ i ] = v.name
        end

        return entries
    end,
    OnChanged = function( old, new )
        ix.custscreeneffect.SetCurrent( new )
    end
} )

ix.option.Add( "hudIconColor", ix.type.bool, false, {
    category = PLUGIN.name,
} )

ix.option.Add( "crosshairColor", ix.type.color, Color( 255, 255, 255 ), {
    category = PLUGIN.name,
} )

ix.option.Add( "hudIconColor", ix.type.bool, false, {
    category = PLUGIN.name,
} )

ix.option.Add( "crosshairGap", ix.type.number, 5, {
    category = PLUGIN.name,
    min = 0,
    max = 30,
    decimals = 0,
} )

ix.option.Add( "crosshairLength", ix.type.number, 10, {
    category = PLUGIN.name,
    min = 0,
    max = 30,
    decimals = 0,
} )
