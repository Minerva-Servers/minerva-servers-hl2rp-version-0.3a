local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Spawner Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.spawner = ix.spawner or {}
ix.spawner.active = {}
ix.spawner.config = {
    ["rp_minerva_city17"] = {
        ["npc_zombie"] = {
            max = 10,
            delay = 60,
            spawns = {
                {
                    pos = Vector(2335.6171875, 2701.5229492188, -306.02481079102),
                    ang = Angle(0, -131.89595031738, 0),
                },
                {
                    pos = Vector(2301.5498046875, 1119.2648925781, -317.37701416016),
                    ang = Angle(0, 112.17190551758, 0),
                },
                {
                    pos = Vector(-1390.1793212891, 1236.7740478516, -127.96875),
                    ang = Angle(0, 138.71212768555, 0),
                },
            }
        },
    },
    ["rp_minerva_city8"] = {
        ["npc_zombie"] = {
            max = 10,
            delay = 60,
            spawns = {
                {
                    pos = Vector(-7206.5048828125, 8333.35546875, -479.96875),
                    ang = Angle(0, 46.544124603271, 0),
                },
                {
                    pos = Vector(-10013.323242188, 7303.5947265625, -479.96875),
                    ang = Angle(0, 114.54602050781, 0),
                },
                {
                    pos = Vector(-8359.708984375, 6904.38671875, -479.96875),
                    ang = Angle(5.6759781837463, 178.94007873535, 0),
                },
            }
        },
    },
    ["rp_city24_v3"] = {
        ["npc_zombie"] = {
            max = 30,
            delay = 60,
            spawns = {
                {
                    pos = Vector(8025.93359375, 6718.2680664063, -1443.8903808594),
                    ang = Angle(0, 7, 0),
                },
                {
                    pos = Vector(7598.25390625, 6084.8720703125, -1178.5373535156),
                    ang = Angle(0, -57.256031036377, 0),
                },
                {
                    pos = Vector(6312.7338867188, 9135.765625, -1310.6802978516),
                    ang = Angle(0, -48.060043334961, 0),
                },
                {
                    pos = Vector(8362.162109375, 4055.7663574219, -1181.8100585938),
                    ang = Angle(0, 115.47992706299, 0),
                },
                {
                    pos = Vector(8334.7822265625, 9465.490234375, -1183.96875),
                    ang = Angle(0, -134.38812255859, 0),
                },
                {
                    pos = Vector(5851.1650390625, 8878.8310546875, -1306.4050292969),
                    ang = Angle(2.0239872932434, -85.152076721191, 0),
                },
                {
                    pos = Vector(5994.46484375, 6123.4477539063, -1702.96875),
                    ang = Angle(0.87996864318848, -96.124114990234, 0),
                },
            }
        },
    }
}

ix.util.Include("sv_plugin.lua")
