local PLUGIN = PLUGIN

PLUGIN.name = "Event Manager"
PLUGIN.description = ""
PLUGIN.author = "Riggs & vingard"

file.CreateDir("minerva/eventmanager")

ix.ops = ix.ops or {}
ix.ops.eventManager = ix.ops.eventManager or {}
ix.ops.eventManager.sequences = ix.ops.eventManager.sequences or {}
ix.ops.eventManager.scenes = ix.ops.eventManager.scenes or {}
ix.ops.eventManager.data = ix.ops.eventManager.data or {}
ix.ops.eventManager.config = ix.ops.eventManager.config or {}

ix.command.Add("EventManager", {
    description = "",
    superAdminOnly = true,
    OnRun = function(self, ply)
        local c = table.Count(ix.ops.eventManager.sequences)
    
        net.Start("ixOpsEMMenu")
            net.WriteUInt(c, 8)
            for k, v in pairs(ix.ops.eventManager.sequences) do
                net.WriteString(k)    
            end
        net.Send(ply)
    end,
})

ix.command.Add("EventMode", {
    description = "",
    superAdminOnly = true,
    OnRun = function(self, ply)
        if ( GetGlobalBool("opsEventMode") ) then
            ix.ops.eventManager.SetEventMode(true)
        else
            ix.ops.eventManager.SetEventMode(false)
        end
    end,
})

function ix.ops.eventManager.GetEventMode()
    return GetGlobalBool("opsEventMode", false)
end

function ix.ops.eventManager.GetSequence()
    local val = GetGlobalString("opsEventSequence", "")

    if val == "" then
        return
    end

    return val
end

function ix.ops.eventManager.SetEventMode(val)
    return SetGlobalBool("opsEventMode", val)
end

function ix.ops.eventManager.SetSequence(val)
    return SetGlobalString("opsEventSequence", val)
end

function ix.ops.eventManager.GetCurEvents()
    return ix_OpsEM_CurEvents
end

local meta = FindMetaTable("Player")
function meta:IsEventAdmin()
    return self:IsSuperAdmin() or ( self:IsGamemaster() and ix.ops.eventManager.GetEventMode() )
end

if ( SERVER ) then
    function meta:AllowScenePVSControl(bool)
        self.allowPVS = bool

        if not bool then
            self.extraPVS = nil
            self.extraPVS2 = nil
        end
    end
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("sv_plugin.lua")
