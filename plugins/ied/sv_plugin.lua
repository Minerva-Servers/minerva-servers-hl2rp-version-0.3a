local PLUGIN = PLUGIN

function PLUGIN:SaveIEDRadios()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_radio")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel()}
    end

    ix.data.Set("iedRadios", data)
end

function PLUGIN:LoadIEDRadios()
    for _, v in ipairs(ix.data.Get("iedRadios") or {}) do
        local iedRadios = ents.Create("ix_radio")

        iedRadios:SetPos(v[1])
        iedRadios:SetAngles(v[2])
        iedRadios:SetModel(v[3])
        iedRadios:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveIEDRadios()
end

function PLUGIN:LoadData()
    self:LoadIEDRadios()
end

util.AddNetworkString("ixIEDStartClientside")
net.Receive("ixIEDStartClientside", function(len, ply)
    local frequency = net.ReadString()

    for k, v in pairs(ents.FindByClass("ix_radioied")) do
        if not ( tonumber(v.frequency) == tonumber(frequency) ) then
            ply:Notify("Invalid IED Frequency!")
            return
        end

        v:Kaboom()
        
        timer.Simple(2, function()
            if not ( IsValid(ply) ) then
                return
            end
            
            ply:GiveAchievement("ieddetonatefirst")
        end)
    end
end)