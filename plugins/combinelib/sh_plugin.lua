local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Combine Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.combine = ix.combine or {}
ix.combine.terminal = ix.combine.terminal or {}
ix.combine.bslindex = ix.combine.bslindex or {}
ix.combine.bslindex.list = ix.combine.bslindex.list or {}

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

ix.char.RegisterVar("bol", {
    default = false,
    bNoDisplay = true,
    field = "bol",
    fieldType = ix.type.bool,
})

ix.char.RegisterVar("bolReason", {
    default = false,
    bNoDisplay = true,
    field = "bolReason",
    fieldType = ix.type.text,
})

ix.char.RegisterVar("defunct", {
    default = false,
    bNoDisplay = true,
    field = "defunct",
    fieldType = ix.type.bool,
})

ix.char.RegisterVar("informant", {
    default = false,
    bNoDisplay = true,
    field = "informant",
    fieldType = ix.type.bool,
})

ix.command.Add("RemoveBOL", {
    description = "",
    adminOnly = true,
    arguments = {
        ix.type.character,
    },
    OnRun = function(self, ply, target)
        if ( target ) then
            target:SetBol(false)
            target:SetBolReason(nil)

            ply:Notify("Successfully removed BOL status.")
        end
    end,
})

function PLUGIN:IsCameraEnabled(camera)
    return camera:GetSequenceName(camera:GetSequence()) == "idlealert"
end

PLUGIN.VIOLATION_FALLEN_OVER = 0
PLUGIN.VIOLATION_647 = 1

ix.command.Add("RadioToggle", {
	OnRun = function(_, ply)
		if ( ply:IsCombine() ) then
			ply.radioOn = (!ply.radioOn or false)

			if ( ply.nextRadioAttempt or 0 ) < CurTime() then
				if ( ply.radioOn ) then
					ply:ChatPrint("You have turned your radio on!")
				else
					ply:ChatPrint("You have turned your radio off!")
				end
			end
		end
	end
})

ix.command.Add("ForceRadioOff", {
	arguments = {ix.type.character, bit.bor(ix.type.number)},
	OnRun = function(_, ply, char, time)
        if not ( ply:IsCombineCommand() ) then return end
		local mtime
        time = math.Clamp(time, 1, 10)
        
		if ( time ) then
			mtime = time * 60 -- 1 = 60 seconds
		end
        
		local trg = char:GetPlayer()
        
        if not ( IsValid(trg) ) then
            return
        end
        
        trg.radioOn = false

        if ( time ) then
            ply:ChatPrint("You have turned "..trg:Nick().."'s radio off for "..time.. " minutes!")
            trg.nextRadioAttempt = CurTime() + mtime
            trg:ChatPrint("Your radio was turned off for "..time.. " minutes!")
        else
            ply:ChatPrint("You have turned "..trg:Nick().."'s radio off!")
            trg:ChatPrint("Your radio was turned off!")
        end
	end
})
