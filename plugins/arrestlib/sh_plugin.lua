local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Arrest Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.arrest = ix.arrest or {}
ix.arrest.config = {
	["minJailTime"] = 60,
	["maxArrestCharges"] = 4,
	["arrestCharges"] = {
		{name = "10-103m, disturbance by mentally unfit", severity = 5, sound = "npc/overwatch/radiovoice/disturbancemental10-103m.wav"},
		{name = "27, attempted crime", severity = 2, sound = "npc/overwatch/radiovoice/attemptedcrime27.wav"},
		{name = "51, non-sanctioned arson", severity = 5, sound = "npc/overwatch/radiovoice/nonsanctionedarson51.wav"},
		{name = "51B, threat to property", severity = 3, sound = "npc/overwatch/radiovoice/threattoproperty51b.wav"},
		{name = "63, criminal trespass", severity = 5, sound = "npc/overwatch/radiovoice/criminaltrespass63.wav"},
		{name = "69, possession of (contraband) resources", severity = 3, sound = "npc/overwatch/radiovoice/posession69.wav"},
		{name = "95, illegal carrying (weaponry)", severity = 6, sound = "npc/overwatch/radiovoice/illegalcarrying95.wav"},
		{name = "99, reckless operation", severity = 2, sound = "npc/overwatch/radiovoice/recklessoperation99.wav"},
		{name = "148, resisting arrest", severity = 4, sound = "npc/overwatch/radiovoice/resistingpacification148.wav"},
		{name = "243, assault on protection team", severity = 14, sound = "npc/overwatch/radiovoice/assault243.wav"},
		{name = "404, riot", severity = 4, sound = "npc/overwatch/radiovoice/riot404.wav"},
		{name = "507, public non-compliance", severity = 2, sound = "npc/overwatch/radiovoice/publicnoncompliance507.wav"},
		{name = "603, unlawful entry", severity = 4, sound = "npc/overwatch/radiovoice/unlawfulentry603.wav"},
		{name = "Disassociation from the civic populous", severity = 7, sound = "npc/overwatch/radiovoice/disassociationfromcivic.wav"},
		{name = "Promoting communal unrest", severity = 7, sound = "npc/overwatch/radiovoice/promotingcommunalunrest.wav"},
	},
	["maps"] = {
		// You need to set map config!
		["rp_apex_industrial17_b10"] = {
			["prisonAngle"] = Angle(1.4399926662445, -178.77975463867, 0),
			["prisonCells"] = {
				Vector(2652.556640625, 3765.2084960938, -303.96875),
				Vector(2651.4819335938, 3946.5244140625, -303.96875),
				Vector(2650.3229980469, 4142.0708007813, -303.96875),
			},
		},
		["rp_minerva_city17"] = {
			["prisonAngle"] = Angle(0, 90, 0),
			["prisonCells"] = {
				Vector(6815.810547, 3346.626221, -205.968750),
				Vector(6962.8237304688, 3346.703125, -271.96875),
				Vector(7106.2729492188, 3345.94140625, -271.96875),
			},
		},
		["rp_minerva_city8"] = {
			["prisonAngle"] = Angle(0, 90, 0),
			["prisonCells"] = {
				Vector(-7896.4677734375, 10250.01953125, -223.96875),
				Vector(-7878.5571289063, 10382.709960938, -223.96875),
				Vector(-7883.73828125, 10511.294921875, -223.96875),
				Vector(-8358.548828125, 10521.663085938, -223.96875)	
			}
		},
		["rp_city24_v3"] = {
			["prisonAngle"] = Angle(0, -90, 0),
			["prisonCells"] = {
				Vector(13539, 9591.345703125, 456.03125),
				Vector(13265.236328125, 9592.8291015625, 456.03125),	
			},
		},
	},
}

local meta = FindMetaTable("Player")

// Sets if players hands are behind their back, this can be called on the server but always be called on the client to avoid lag
// @realm shared
// @bool state
function meta:SetHandsBehindBack(state)
	local L_UPPERARM = self:LookupBone("ValveBiped.Bip01_L_UpperArm")
	local R_UPPERARM = self:LookupBone("ValveBiped.Bip01_R_UpperArm")
	local L_FOREARM = self:LookupBone("ValveBiped.Bip01_L_Forearm")
	local R_FOREARM = self:LookupBone("ValveBiped.Bip01_R_Forearm")
	local L_HAND = self:LookupBone("ValveBiped.Bip01_L_Hand") 
	local R_HAND = self:LookupBone("ValveBiped.Bip01_R_Hand")
			
	if L_UPPERARM and R_UPPERARM and L_FOREARM and R_FOREARM and L_HAND and R_HAND then
		if state then
			if self:IsFemale() then
				self:ManipulateBoneAngles(L_UPPERARM, Angle(5, 5, 0))
				self:ManipulateBoneAngles(R_UPPERARM, Angle(-5, 10, 0))
				self:ManipulateBoneAngles(L_FOREARM, Angle(16, 5, 0))
				self:ManipulateBoneAngles(R_FOREARM, Angle(-16, 5, 0))         
				self:ManipulateBoneAngles(L_HAND, Angle(-25, -10, 0))
				self:ManipulateBoneAngles(R_HAND, Angle(25, -10, 0))
			else
				self:ManipulateBoneAngles(L_UPPERARM, Angle(5, 5, 0))
				self:ManipulateBoneAngles(R_UPPERARM, Angle(-5, 10, 0))
				self:ManipulateBoneAngles(L_FOREARM, Angle(25, 5, 0))
				self:ManipulateBoneAngles(R_FOREARM, Angle(-25, 5, 0))
				self:ManipulateBoneAngles(L_HAND, Angle(-25, -10, 0))                  
				self:ManipulateBoneAngles(R_HAND, Angle(25, -10, 0))           
			end
		else
			self:ManipulateBoneAngles(L_UPPERARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(R_UPPERARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(L_FOREARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(R_FOREARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(L_HAND, Angle(0, 0, 0))  
			self:ManipulateBoneAngles(R_HAND, Angle(0, 0, 0))  
		end
	end
end

// Returns if a player can arrest the target
// @realm shared
// @entity target The target who would be arrested
function meta:CanArrest(arrested)
	if arrested:IsCombine() then
		return false
	end

	return self:IsCombine()
end

// Returns if a player is arrested
// @realm shared
// @return bool Is arrested
function meta:IsArrested()
	return self:GetCharacter():GetData("arrested", false)
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("RemoveCuffs", {
    description = "Remove the cuffs of the person infront of you.",
    OnRun = function(self, ply)
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity
		
        if ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            if ( !target:GetNetVar("tying") and target:IsArrested() ) then
                ply:SetAction("Removing Cuffs...", 1.5)
                ply:EmitSound("npc/vort/claw_swing2.wav")
				ix.chat.Send(ply, "me", "begins removing the cuffs from "..target:Nick()..".")

                ply:DoStaredAction(target, function()
                    target:UnArrest()
                    target:SetNetVar("tying")

					ix.chat.Send(target, "me", "is now freed from their cuffs.")
					ply:EmitSound("npc/vort/claw_swing1.wav")
                    ply:Notify("You have released "..target:Nick()..".")
                    target:Notify("You have been released.")
                end, 1.5, function()
                    ply:SetAction()

                    target:SetAction()
                    target:SetNetVar("tying")
                end)

                target:SetNetVar("tying", true)
                target:SetAction("You are being tied up.", 0.6)
			end
		end
    end,
})
