local PLUGIN = PLUGIN

PLUGIN.name = "ATM"
PLUGIN.author = "Scotnay"
PLUGIN.description = "A simple ATM system for use in any schema"

ix.util.Include("sv_plugin.lua")

ix.config.Add("ATM Model", "models/props_combine/breenconsole.mdl", "The model of the ATM", nil, {
    category = PLUGIN.name,
})

local charmet = ix.meta.character

function charmet:GetStoredMoney()
    return self:GetData("storedMoney", 0)
end

function charmet:SetStoredMoney(amount)
    self:SetData("storedMoney", amount)
end

function charmet:CanDeposit( amount )
	if ( amount < 0 ) then
		return false
	end

	return amount <= self:GetMoney()
end

function charmet:CanWithdraw( amount )
	if ( amount < 0 ) then
		return false
	end

	return amount <= self:GetStoredMoney()
end

function charmet:WithdrawMoney( amount )
	self:SetStoredMoney( self:GetStoredMoney() - amount )
	self:SetMoney( self:GetMoney() + amount )
end

function charmet:DespositMoney( amount )
	self:SetStoredMoney( self:GetStoredMoney() + amount )
	self:SetMoney( self:GetMoney() - amount )
end

if CLIENT then

    netstream.Hook("ixATMUse", function(data)
        local ply = data[1]

        Derma_Query("Choose type\nYou currently have " .. ply:GetCharacter():GetMoney() .. " " .. ix.currency.plural .. " on you.", "ATM", "Withdraw", function()
            LocalPlayer():EmitSound("buttons/blip1.wav")
            Derma_StringRequest("ATM", "Please input how much you wish to withdraw\n" .. "You currently have: " .. ply:GetCharacter():GetStoredMoney() .. " " .. ix.currency.plural, "", function(text)
                local textToNum = tonumber(text, 10)
                LocalPlayer():EmitSound("buttons/button14.wav")
                if isnumber(textToNum) then
                    if ply:GetCharacter():GetStoredMoney() >= textToNum and textToNum >= 0 then
                        net.Start("ixATMMoney")
			    net.WriteBool( true )
                            net.WriteUInt(math.abs(textToNum), 32)
                        net.SendToServer()
                        ply:Notify("You have withdrawn " .. textToNum .. " " .. ix.currency.plural)
                    else
                        ply:Notify("You do not have enough saved to withdraw")
                    end
                else
                    ply:Notify("You have not inputed a number")
                end
            end)
        end,
        "Deposit", function()
            LocalPlayer():EmitSound("buttons/blip1.wav")
            Derma_StringRequest("ATM", "Please input how much you wish to deposit\n" .. "You currently have: " .. ply:GetCharacter():GetStoredMoney() .. " " .. ix.currency.plural, "", function(text)
                local textToNum = tonumber(text, 10)
                LocalPlayer():EmitSound("buttons/button14.wav")
                if isnumber(textToNum) then
                    if ply:GetCharacter():GetMoney() >= textToNum and textToNum >= 0 then
                        net.Start("ixATMMoney")
			    net.WriteBool( false )
                            net.WriteUInt(math.abs(textToNum), 32)
                        net.SendToServer()
                        ply:Notify("You have deposited " .. textToNum .. " " .. ix.currency.plural)
                    else
                        ply:Notify("You do not have enough on you to deposit")
                    end
                else
                    ply:Notify("You have not inputed a number")
                end
            end)
        end, "Cancel")
    end)


    function PLUGIN:PopulateEntityInfo(ent, tooltip)
        if ent:GetClass() == "ix_atm" then
            local pop = tooltip:AddRow("name")
            pop:SetText("ATM Machine")
            pop:SetImportant()
            pop:SizeToContents()

            local desc = tooltip:AddRowAfter("name", "desc")
            desc:SetText("An ATM machine to store your hard earned money in")
            desc:SizeToContents()
        end
    end
end
