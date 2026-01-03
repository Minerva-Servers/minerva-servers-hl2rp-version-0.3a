local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers View Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs & Scotnay"

ix.util.Include( "cl_hooks.lua" )

ix.custview.LoadFromDirectory( PLUGIN.folder .. "/views" )

ix.lang.AddTable( "english", {
    optViewDesign = "View Design",
    optdViewDesign = "What type of View Design you would want.",

    optSmoothView = "Smooth View",
    optdSmoothView = "Wether or not smooth mouse view should be enabled for yourself.",
} )

ix.option.Add( "viewDesign", ix.type.array, "longsword", {
    category = PLUGIN.name,
    populate = function()
        local entries = { }

        for i, v in pairs( ix.custview.stored ) do
            entries[ i ] = v.name
        end

        return entries
    end,
    OnChanged = function( old, new )
        ix.custview.SetCurrent( new )
    end
} )

ix.option.Add("smoothView", ix.type.bool, true, {
    category = PLUGIN.name,
} )
