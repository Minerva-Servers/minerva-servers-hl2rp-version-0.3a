local PLUGIN = PLUGIN

PLUGIN.name = "Shop Terminal"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

PLUGIN.allowedFactions = {
    [FACTION_CWU] = true,
}

// changed them from char:GetClass() to ply:GetTeamClass()
PLUGIN.allowedClasses = {
    [CLASS_CWU_MEDIC] = true,
    [CLASS_CWU_COOK] = true,
}

ix.config.Add("shipmentDeliverMessage", "Your shipment has been successfully bought and has been sent to a nearby warehouse!", "", nil, {
    category = PLUGIN.name,
})

ix.config.Add("shipmentDeliverPositionXValue", "0", "The X Position of where the Shipment would spawn. Get the Y Position by using the /GetXPos command.", nil, {
    category = PLUGIN.name,
})

ix.config.Add("shipmentDeliverPositionYValue", "0", "The Y Position of where the Shipment would spawn. Get the Y Position by using the /GetYPos command.", nil, {
    category = PLUGIN.name,
})

ix.config.Add("shipmentDeliverPositionZValue", "0", "The Z Position of where the Shipment would spawn. Get the Z Position by using the /GetZPos command.", nil, {
    category = PLUGIN.name,
})

ix.command.Add("SetShipmentDeliverPosition", {
    description = "Sets the "..PLUGIN.name.." Shipment Deliver Position.",
    adminOnly = true,
    OnRun = function(self, ply)
        ix.data.Set("shipmentDeliverPositions", ply:GetPos())

        ply:Notify("Successfully Set!")
    end,
})

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
