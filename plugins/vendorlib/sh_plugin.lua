local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Vendor Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.vendor = ix.vendor or {}
ix.vendor.data = ix.vendor.data or {}
ix.vendor.config = {
	// You need to set map config!
    ["rp_apex_industrial17_b10"] = {
        dealerTeleportTimeMin = 1500,
        dealerTeleportTimeMax = 1900,
        dealerLocations = {
            {pos = Vector(4719.53125, 8009.875, 320.03125), ang = Angle(0, 98.61328125, 0)},
            {pos = Vector(2734.5625, 1959.09375, -135.96875), ang = Angle(0, -129.7705078125, 0)},
            {pos = Vector(6254.875, 3753.9375, -23.96875), ang = Angle(0, -178.0224609375, 0)},
            {pos = Vector(6524.46875, 2294.75, 224.03125), ang = Angle(0, -142.9541015625, 0)},
        },
    },
    ["rp_minerva_city17"] = {
        dealerTeleportTimeMin = 1500,
        dealerTeleportTimeMax = 1900,
        dealerLocations = {
            {pos = Vector(3606.1215820313, 4015.2961425781, -335.96875), ang = Angle(0, 177.97210693359, 0)},
            {pos = Vector(2661.9851074219, 2336.91015625, -207.96875), ang = Angle(0, 142.56015014648, 0)},
            {pos = Vector(3136.7038574219, 320.03125, -207.96875), ang = Angle(0, 67.328269958496, 0)},
            {pos = Vector(-1004.9654541016, 2275.4733886719, -127.97015380859), ang = Angle(0, -89.391151428223, 0)},
            {pos = Vector(-3749.5200195313, 1152.3853759766, 0.03125), ang = Angle(0, -80.855308532715, 0)},
        },
    },
    ["rp_minerva_city8"] = {
        dealerTeleportTimeMin = 1500,
        dealerTeleportTimeMax = 1900,
        dealerLocations = {
            {pos = Vector(-10145.180664063, 8969.6376953125, -463.98178100586), ang = Angle(0, -90, 0)},
        },
    },
    ["rp_city24_v3"] = {
        dealerTeleportTimeMin = 1500,
        dealerTeleportTimeMax = 1900,
        dealerLocations = {
            {pos = Vector(8376.8603515625, 6608.1474609375, -1887.96875), Angle(0, -180, 0)},
            {pos = Vector(10400.89453125, 4920.30078125, -1175.96875), Angle(0, 130, 0)},
            {pos = Vector(7527.7275390625, 9312.2763671875, -1183.96875), Angle(0, -45, 0)},
        },
    },
}

function ix.vendor.RegisterVendor(vendor)
	ix.vendor.data[vendor.UniqueID] = vendor
end

local idleVO = {
    "question23.wav",
    "question25.wav",
    "question09.wav",
    "question06.wav",
    "question05.wav"
}

local idleCPVO = {
    "copy.wav",
    "needanyhelpwiththisone.wav",
    "unitis10-8standingby.wav",
    "affirmative.wav",
    "affirmative2.wav",
    "rodgerthat.wav",
    "checkformiscount.wav"
}

local idleFishVO = {
    "fish_crabpot01.wav",
    "fish_likeleeches.wav",
    "fish_oldleg.wav",
    "fish_resumetalk02.wav",
    "fish_stayoutwater.wav",
    "fish_wipeouttown01.wav",
    "fish_resumetalk01.wav",
    "fish_resumetalk02.wav",
    "fish_resumetalk03.wav"
}

local idleZombVO = {
    "npc/zombie/zombie_voice_idle9.wav",
    "npc/zombie/zombie_voice_idle4.wav",
    "npc/zombie/zombie_voice_idle10.wav",
    "npc/zombie/zombie_voice_idle13.wav",
    "npc/zombie/zombie_voice_idle6.wav",
    "npc/zombie/zombie_voice_idle7.wav"
}

function ix.vendor.GetRandomAmbientVO(gender)
    if gender == "male" then
        return "vo/npc/male01/"..idleVO[math.random(1, #idleVO)]
    elseif gender == "fisherman" then
        return "lostcoast/vo/fisherman/"..idleFishVO[math.random(1, #idleFishVO)]
    elseif gender == "cp" then
        return "npc/metropolice/vo/"..idleCPVO[math.random(1, #idleCPVO)]
    elseif gender == "zombie" then
        return idleZombVO[math.random(1, #idleZombVO)]
    else
        return "vo/npc/female01/"..idleVO[math.random(1, #idleVO)]
    end
end

properties.Add("vendor_setclass", {
    MenuLabel = "Set Vendor Class",
    MenuIcon = "icon16/wrench.png",
    Order = 5,

    Filter = function(self, ent, ply)
        if not ( IsValid(ent) and ent:GetClass() == "ix_vendor" ) then return false end

        return ply:IsAdmin()
    end,

    Action = function(self, ent)
    end,

    VendorClassSet = function(self, ent, class)
        self:MsgStart()
            net.WriteEntity(ent)
            net.WriteString(class)
        self:MsgEnd()
    end,

    MenuOpen = function(self, option, ent, trace)
        local subMenu = option:AddSubMenu()

        for k, v in SortedPairs(ix.vendor.data) do
            subMenu:AddOption(v.Name, function()
                self:VendorClassSet(ent, k)
            end)
        end
    end,

    Receive = function(self, len, ply)
        local ent = net.ReadEntity()

        if not ( IsValid(ent) ) then return end
        if not ( self:Filter(ent, ply) ) then return end

        local class = net.ReadString()
        local vendor = ix.vendor.data[class]
        ent.vendor = vendor

        -- safety check, just to make sure if it really exists in both realms.
        if not ( class or vendor ) then
            ply:Notify("You did not specify a valid vendor class!")
            return
        end

        ent:SetVendor(tostring(class))
        ent:SetModel(vendor.Model)
        ent:SetSkin(vendor.Skin or 0)

        ent:SetHullType(HULL_HUMAN)
        ent:SetHullSizeNormal()
        ent:SetSolid(SOLID_BBOX)
        ent:SetUseType(SIMPLE_USE)
        ent:DropToFloor()

        if ( ent.vendor.Initialize ) then
            ent.vendor.Initialize(ent)
        end

        if ( vendor ) then
            if ( vendor.Bodygroups ) then
                for k, value in pairs(vendor.Bodygroups) do
                    local index = ent:FindBodygroupByName(k)
        
                    if ( index > -1 ) then
                        ent:SetBodygroup(index, value)
                    end
                end
            end
        end

        ply.nextVendorUse = 0

        PLUGIN:SaveData()
    end
})

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.IncludeDir(PLUGIN.folder.."/vendors", true)
