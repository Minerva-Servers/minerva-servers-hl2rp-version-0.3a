local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers City Code Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.cityCode = ix.cityCode or {}
ix.cityCode.codes = ix.cityCode.codes or {}

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetAll()
    Desc: Returns a table of all codes.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetAll()
    return ix.cityCode.codes
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetCurrent()
    Desc: Returns the current code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetCurrent()
    return GetGlobalString("ixCityCode", "civil")
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.Get()
    Desc: Returns a table of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.Get(id)
    return ix.cityCode.codes[id or ix.cityCode.GetCurrent()]
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetColor()
    Desc: Returns a color of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetColor(id)
    return ix.cityCode.codes[id or ix.cityCode.GetCurrent()].color
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetName()
    Desc: Returns a name of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetName(id)
    return ix.cityCode.codes[id or ix.cityCode.GetCurrent()].name
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetDescription()
    Desc: Returns a description of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetDescription(id)
    return ix.cityCode.codes[id or ix.cityCode.GetCurrent()].description
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetAccess()
    Desc: Returns a access function of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetAccess(id)
    return ix.cityCode.codes[id or ix.cityCode.GetCurrent()].OnCheckAccess
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_citycodes.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("ChangeCityCode", {
    description = "Change text Code.",
    arguments = ix.type.text,
    superAdminOnly = true,
    OnRun = function(self, ply, code)
        if not ( ix.cityCode.codes[code] ) then
            for k, v in SortedPairs(ix.cityCode.codes) do
                ply:ChatNotify(k.." < "..v.name)
            end

            ply:Notify("You have provided a non-existent code. (All codes printed in chat)")
            return false
        end
        
        ply:SendLua("RunConsoleCommand('ix_code_set', '"..code.."')")
    end
})
