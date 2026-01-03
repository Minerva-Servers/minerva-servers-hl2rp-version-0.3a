local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Cassie"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.cassie = ix.cassie or {}

ix.lang.AddTable("english", {
    optAdminEsp = "Admin ESP",
})

ix.option.Add("adminEsp", ix.type.bool, false, {
    category = PLUGIN.name,
})

ix.cassie.espEntities = {
    ["ix_item"] = "Item",
    ["ix_container"] = "Container",
    ["ix_money"] = "Money",
    ["ix_vendor"] = "Vendor",
    ["ix_ranknpc_cp"] = "Rank NPC CP",
    ["ix_ranknpc_ow"] = "Rank NPC OW",
    ["ix_loot_container"] = "Loot Container",
    ["ix_station_workbench"] = "Workbench",
    ["ix_safebox"] = "Safebox",
    ["ix_rationdispenser"] = "Ration Dispenser",
}
for k, v in pairs(ix.cassie.espEntities) do
    ix.option.Add(v, ix.type.bool, true, {
        category = PLUGIN.name,
    })
end

ix.lang.AddTable("english", {
    optItem = "Admin ESP Item",
    optContainer = "Admin ESP Container",
    optMoney = "Admin ESP Money",
    optVendor = "Admin ESP Vendor",
    optWorkbench = "Admin ESP Workbench",
    optSafebox = "Admin ESP Safebox",
    ["optRank NPC CP"] = "Admin ESP Rank NPC CP",
    ["optRank NPC OW"] = "Admin ESP Rank NPC OW",
    ["optLoot Container"] = "Admin ESP Loot Container",
    ["optRation Dispenser"] = "Admin ESP Ration Dispenser",
})

ix.util.Include("cl_menu.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("CharSpawnItem", {
	description = "Spawns the specific item where you are looking at.",
	superAdminOnly = true,
	arguments = {
		ix.type.string,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, item, amount)
		local uniqueID = item:lower()

		if (!ix.item.list[uniqueID]) then
			for k, v in SortedPairs(ix.item.list) do
				if (ix.util.StringMatches(v.name, uniqueID)) then
					uniqueID = k

					break
				end
			end
		end

		amount = amount or 1

        for i = 1, amount do
            local trace = client:GetEyeTrace()
            ix.item.Spawn(uniqueID, trace.HitPos + Vector(math.random(-4, 4), math.random(-4, 4), 8))
        end
        
        return "@itemCreated"
	end
})
