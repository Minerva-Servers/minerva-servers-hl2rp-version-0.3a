SWEP.PrintName              = "Configurator"
SWEP.Author                 = "Silhouhat"
SWEP.Purpose                = "HL2 RP"
SWEP.Instructions           = "LMB to add a new position\nRMB to delete an existing position\nReload to update existing positions."

SWEP.Category               = "HL2 RP"
SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.Weight			        = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.Slot			        = 2
SWEP.SlotPos			    = 1
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = true

SWEP.ViewModel	    	    = "models/weapons/c_toolgun.mdl"
SWEP.WorldModel	        	= "models/weapons/w_toolgun.mdl"


function SWEP:Initialize()
    self:SetHoldType( "revolver" )
end

local cwEnts = {
    ["Fire Hydrant"] = "cityworker_hydrant",
    ["Leak"] = "cityworker_leak",
    ["Rubble"] = "cityworker_rubble",
    ["Electrical"] = "cityworker_electric"
}

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextPrimaryFire( CurTime() + 0.2 )

    if CLIENT and not self.spawnmenu then
        self.spawnmenu = vgui.Create( "DMenu" )
        self.spawnmenu:Center()

        for name, class in pairs( cwEnts ) do
            local entry = self.spawnmenu:AddOption( name )
            entry.cwClass = class
            entry:SetIcon( "icon16/add.png" )
        end

        self.spawnmenu.OptionSelected = function( pnl, option, optionText )
            local class = option.cwClass

            net.Start( "CITYWORKER.Add" )
                net.WriteString( class )
            net.SendToServer()
        end

        self.spawnmenu.OnRemove = function()
            gui.EnableScreenClicker( false )
            self.spawnmenu = false
        end

        gui.EnableScreenClicker( true )
    end
end

local reloadDelay = 0

function SWEP:Reload()
    if SERVER then
        if reloadDelay > CurTime() then return end

        reloadDelay = CurTime() + 1

        CITYWORKER.SendData( self.Owner )
    end
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    self:SetNextSecondaryFire( CurTime() + 0.2 )

    if CLIENT then
        Derma_StringRequest( "Remove HL2 RP task position.", "What is the id of the HL2 RP task you'd like to remove?", "1", function( str )
            if not str then return end
            local id = tonumber( str )
            if not id then return end

            if id > 255 then return end
        
            net.Start( "CITYWORKER.Remove" )
                net.WriteUInt( id, 8 )
            net.SendToServer()
        end )
    end
end

function SWEP:Think()
    -- Because SWEP:Initialize() doesn't seem to work with this.
    if SERVER and not self.hasSendCWData then
        self.hasSendCWData = true
        CITYWORKER.SendData( self.Owner )
    end
end

if CLIENT then

    local CW_DEFINITIONS = {
        ["cityworker_rubble"] = "Rubble",
        ["cityworker_hydrant"] = "Fire Hydrant",
        ["cityworker_leak"] = "Leak",
        ["cityworker_electric"] = "Electrical",
    }

    local jobPositions = {}

    function SWEP:DrawHUD()
        for k, v in pairs( jobPositions ) do
            local scrPos = v.pos:ToScreen()

            draw.SimpleTextOutlined( "ID: "..k, "Trebuchet18", scrPos.x, scrPos.y - 15, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            draw.SimpleTextOutlined( CW_DEFINITIONS[v.class], "Trebuchet18", scrPos.x, scrPos.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
            --draw.SimpleTextOutlined( math.ceil( ( LocalPlayer():GetPos():Distance( v.pos ) / 16 ) / 3.28084 ).."m", "Trebuchet18", scrPos.x, scrPos.y + 15, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
        end
    end

    net.Receive( "CITYWORKER.SendData", function()
        jobPositions = net.ReadTable()
    end )

end