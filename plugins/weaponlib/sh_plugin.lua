local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Weapon Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.weapon = ix.weapon or {}

function RPM(rpm)
	return 60 / rpm
end

ix.util.Include("sv_plugin.lua")

if ( CLIENT ) then
	function PLUGIN:Think()
		for k, v in pairs(ents.FindByClass("ls_projectile")) do
			if not ( v:GetModel() == "models/weapons/w_grenade.mdl" or v:GetModel() == "models/wick/weapons/l4d1/w_pipebomb.mdl" ) then
				continue
			end
			
			local dlight = DynamicLight(v:EntIndex())
			if ( dlight ) then
				dlight.pos = v:GetPos()
				dlight.r = 255
				dlight.g = 0
				dlight.b = 0
				dlight.brightness = 1
				dlight.Decay = 1000
				dlight.Size = 128
				dlight.DieTime = CurTime() + 1
			end
		end
	end
end
