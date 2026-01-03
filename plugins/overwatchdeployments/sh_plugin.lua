local PLUGIN = PLUGIN

PLUGIN.name = "Overwatch Deployments"
PLUGIN.description = "Deploys Overwatch Transhuman Arm Players to the map."
PLUGIN.author = "Riggs"
PLUGIN.version = "0.4"

ix.od = ix.od or {}
ix.od.queue = ix.od.queue or {}
ix.od.queue.sector1 = ix.od.queue.sector1 or {}
ix.od.queue.sector2 = ix.od.queue.sector2 or {}
ix.od.queue.sector3 = ix.od.queue.sector3 or {}

ix.od.config = {
    ["rp_minerva_city17"] = {
        ["Sector 1"] = {
            [1] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
            [2] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
            [3] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
        },
        ["Sector 2"] = {
            [1] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
            [2] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
            [3] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
        },
        ["Sector 3"] = {
            [1] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
            [2] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
            [3] = {
                pos = Vector(0, 0, 0),
                ang = Angle(0, 90, 0),
            },
        },
    }
}

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("ToggleDropshipDeploymentOW", {
    OnCheckAccess = function(self, ply)
        return ( ply:IsCombineSupervisor() and ply:IsOW() ) or ply:IsAdmin()
    end,
    OnRun = function(self, ply)
        if ( ix.od.enabledOW ) then
            ply:Notify("You have disabled the ability to use the dropship deployment system to all overwatch soldiers.")
            ix.od.enabledOW = nil
        else
            ply:Notify("You have granted the ability to use the dropship deployment system to all overwatch soldiers.")
            ix.od.enabledOW = true
        end
    end,
})

ix.command.Add("ToggleDropshipDeploymentCP", {
    OnCheckAccess = function(self, ply)
        return ( ply:IsCombineSupervisor() and ply:IsCP() ) or ply:IsAdmin()
    end,
    OnRun = function(self, ply)
        if ( ix.od.enabledCP ) then
            ply:Notify("You have disabled the ability to use the dropship deployment system to all civil protection units.")
            ix.od.enabledCP = nil
        else
            ply:Notify("You have granted the ability to use the dropship deployment system to all civil protection units.")
            ix.od.enabledCP = true
        end
    end,
})
