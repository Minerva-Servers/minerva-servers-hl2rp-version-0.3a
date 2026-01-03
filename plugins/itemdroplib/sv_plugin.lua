local PLUGIN = PLUGIN

local dropAbleWeapons = {
    ["arccw_minerva_akm"] = {"wep_akm", "ammo_rile"},
    ["arccw_minerva_m16"] = {"wep_m16", "ammo_rile"},
    ["arccw_minerva_329"] = {"wep_357", "ammo_357"},
    ["arccw_minerva_ar2"] = {"wep_ar2", "ammo_pulse"},
    ["arccw_minerva_mp7"] = {"wep_mp7", "ammo_smg"},
    ["arccw_minerva_mp5a4"] = {"wep_mp5a4", "ammo_pistol"},
    ["arccw_minerva_spas12"] = {"wep_spas12", "spas12ammo"},
    ["arccw_minerva_usp"] = {"wep_usp", "ammo_pistol"},
    ["arccw_minerva_uzi"] = {"wep_uzi", "ammo_pistol"},
    ["ix_stunstick"] = {"wep_stunstick", "wep_stunstick"},
    ["ix_crowbar"] = {"wep_crowbar", "wep_crowbar"},
    ["ix_grenade"] = {"wep_grenade", "wep_grenade"},
    ["weapon_crossbow"] = {"wep_crossbow", "ammo_crossbow"},
}

local function DropRandomWeapon(ply, held, dropAmmoInstead)
    if ( IsValid(held) and dropAbleWeapons[ply:GetActiveWeapon():GetClass()] ) then
        local wep = dropAbleWeapons[held:GetClass()][1]
        local wepAmmo = dropAbleWeapons[held:GetClass()][2]

        if ( dropAmmoInstead ) then
            if ( wepAmmo ) then
                ix.item.Spawn(wepAmmo, ply:GetPos() + Vector(0, 0, 8), nil, ply:GetAngles())
            end
        else
            if ( wep ) then
                ix.item.Spawn(wep, ply:GetPos() + Vector(0, 0, 8), nil, ply:GetAngles(), {
					[ "durability" ] = math.random( 1, 100 )
				})
            end
        end
    else
        local weapons = {}

        for i, v in ipairs(ply:GetWeapons()) do
            local class = v:GetClass()

            if ( dropAbleWeapons[class] ) then
                if ( dropAmmoInstead and not ( dropAbleWeapons[class][2] == dropAbleWeapons[class][1] ) ) then
                    weapons[#weapons + 1] = dropAbleWeapons[class][2]
                else
                    weapons[#weapons + 1] = dropAbleWeapons[class][1]
                end
            end
        end

        if ( #weapons > 0 ) then
            local randWeapon = table.Random(weapons)

            ix.item.Spawn(randWeapon, ply:GetPos() + Vector(0, 0, 8), nil, ply:GetAngles(), {
				[ "durability" ] = math.random( 1, 100 )
			})
        end
    end
end

function PLUGIN:DoPlayerDeath(ply)
    local randomChance = math.random(1, 3)
    local randomChance100 = math.random(0, 100)
    local held = ply:GetActiveWeapon()

    if ( self.config[ply:Team()] ) then
        if ( self.config[ply:Team()]["guaranteed"] ) then
            for k, v in pairs(self.config[ply:Team()]["guaranteed"]) do
                ix.item.Spawn(v, ply:GetPos() + Vector(0, 0, 8), nil, ply:GetAngles())
            end
        end

        if ( self.config[ply:Team()]["random"] ) then
            if ( randomChance100 >= 50 ) then
                ix.item.Spawn(table.Random(self.config[ply:Team()]["random"]), ply:GetPos() + Vector(0, 0, 8), nil, ply:GetAngles())
            else
                DropRandomWeapon(ply, held, true)
            end
        end
    end

	local rand_chance = math.random( 1, 3 )

	if ( rand_chance == 1 ) then
    	DropRandomWeapon(ply, held)
	end

    local char = ply:GetCharacter()

    for k, v in pairs(char:GetInventory():GetItems()) do
        if ( v:GetData("equip") ) then
            v:SetData("equip", nil)
        end
        v:Remove()
    end

    ply:ResetBodygroups()
end
