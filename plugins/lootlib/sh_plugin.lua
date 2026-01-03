local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Loot Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

CAMI.RegisterPrivilege({
    Name = "Helix - Manage Loot Containers",
    MinAccess = "admin"
})

local defaultloottable = {
    "cloth",
    "cloth",
    "cloth",
    "plastic",
    "plastic",
    "plastic",
    "metalplate",
    "metalplate",
    "gunpowder",
    "gunpowder",
    "aidfluid",
    "wood",
    "glue",
    "pipe",
    "gear",
}

local defaultrareloottable = {
    "bulletcasing",
    "bulletcasing",
    "gunpowder",
    "gunpowder",
    "refinedmetal",
    "refinedmetal",
    "refinedmetal",
    "refinedmetal",
    "electronics",
    "electronics",
    "explosive",
}

PLUGIN.containers = {
    ["crate"] = {
        name = "Wooden Crate",
        description = "A crate made of wood.",
        model = "models/props_junk/wood_crate001a_damaged.mdl",
        skin = 1,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["longcrate"] = {
        name = "Long Wooden Crate",
        description = "A long wooden crate.",
        model = "models/props_junk/wood_crate002a.mdl",
        skin = 0,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["dumpster"] = {
        name = "Dumpster",
        description = "A dumpster.",
        model = "models/props_junk/TrashDumpster01a.mdl",
        skin = 0,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["oildrum"] = {
        name = "Oil Drum",
        description = "An oil drum.",
        model = "models/props_c17/oildrum001.mdl",
        skin = 0,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["filecabinet"] = {
        name = "File Cabinet",
        description = "A file cabinet.",
        model = "models/props_lab/filecabinet02.mdl",
        skin = 0,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["locker"] = {
        name = "Locker",
        description = "A locker.",
        model = "models/props_c17/Lockers001a.mdl",
        skin = 0,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["fridge"] = {
        name = "Fridge",
        description = "A fridge.",
        model = "models/props_c17/FurnitureFridge001a.mdl",
        skin = 0,
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = defaultloottable,
        rareItems = defaultrareloottable,
    },
    ["ammocrate"] = {
        name = "Ammo Crate",
        description = "An ammo crate.",
        model = "models/Items/ammocrate_smg1.mdl",
        skin = 0,
        delay = 600, -- time in seconds before it can be looted again
        lootTime = {5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {3, 4, 5, 6}, -- how many items can be in the container
        items = defaultrareloottable,
        rareItems = defaultrareloottable,
    },
}

properties.Add("loot_setclass", {
    MenuLabel = "Set Loot Class",
    MenuIcon = "icon16/wrench.png",
    Order = 5,

    Filter = function(self, ent, ply)
        if not ( IsValid(ent) and ent:GetClass() == "ix_loot_container" ) then
            return false
        end

        return CAMI.PlayerHasAccess(ply, "Helix - Manage Loot Containers", nil)
    end,

    Action = function(self, ent)
    end,

    LootClassSet = function(self, ent, class)
        self:MsgStart()
            net.WriteEntity(ent)
            net.WriteString(class)
        self:MsgEnd()
    end,

    MenuOpen = function(self, option, ent, trace)
        local subMenu = option:AddSubMenu()

        for k, v in SortedPairs(PLUGIN.containers) do
            subMenu:AddOption(v.name.." ("..k..")", function()
                self:LootClassSet(ent, k)
            end)
        end
    end,

    Receive = function(self, len, ply)
        local ent = net.ReadEntity()

        if not ( IsValid(ent) ) then
            return
        end

        if not ( self:Filter(ent, ply) ) then
            return
        end

        local class = net.ReadString()
        local loot = PLUGIN.containers[class]

        // safety check, just to make sure if it really exists in both realms.
        if not ( class or loot ) then
            ply:Notify("You did not specify a valid container class!")
            return
        end

        ent:SetContainerClass(tostring(class))
        ent:SetModel(loot.model)
        ent:SetSkin(loot.skin or 0)
        ent:PhysicsInit(SOLID_VPHYSICS)
        ent:SetSolid(SOLID_VPHYSICS)
        ent:SetUseType(SIMPLE_USE)
        ent:DropToFloor()

        PLUGIN:SaveLootContainers()
    end
})

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
