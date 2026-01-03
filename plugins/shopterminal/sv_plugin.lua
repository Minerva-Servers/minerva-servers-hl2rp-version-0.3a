local PLUGIN = PLUGIN

function PLUGIN:SaveShopTerminals()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_shopterminal")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("shopTerminals", data)
end

function PLUGIN:LoadShopTerminals()
    for _, v in ipairs(ix.data.Get("shopTerminals") or {}) do
        local shopTerminals = ents.Create("ix_shopterminal")

        shopTerminals:SetPos(v[1])
        shopTerminals:SetAngles(v[2])
        shopTerminals:Spawn()
    end
end

function PLUGIN:SaveData()
    self:SaveShopTerminals()
end

function PLUGIN:LoadData()
    self:LoadShopTerminals()
end

util.AddNetworkString("ixShopTerminal.Open")
util.AddNetworkString("ixShopTerminal.Close")
util.AddNetworkString("ixShopTerminal.Checkout")

net.Receive("ixShopTerminal.Close", function(len, ply)
    if not ( IsValid(ply) and IsValid(ply:GetEyeTrace().Entity) and ply:GetEyeTrace().Entity:GetClass() == "ix_shopterminal" ) then
        return
    end

    ply:GetEyeTrace().Entity:SetNetVar("InUse", false)
end)

net.Receive("ixShopTerminal.Checkout", function(len, ply)
    local char = ply:GetCharacter()
    if not ( IsValid(ply) and char and PLUGIN.allowedFactions[ply:Team()] and PLUGIN.allowedClasses[ply:GetTeamClass()] ) then
        return
    end

    local indicies = net.ReadUInt(8)
    local items = {}

    for _ = 1, indicies do
        items[net.ReadString()] = net.ReadUInt(8)
    end

    if ( table.IsEmpty(items) ) then
        return
    end

    local cost = 0

    for k, v in pairs(items) do
        local itemTable = ix.item.list[k]

        if (itemTable) then
            local amount = math.Clamp(tonumber(v) or 0, 0, 10)
            items[k] = amount

            if (amount == 0) then
                items[k] = nil
            else
                cost = cost + (amount * (itemTable.price or 0))
            end
        else
            items[k] = nil
        end
    end

    if ( table.IsEmpty(items) ) then
        return
    end

    if ( char:HasMoney(cost) ) then
        char:TakeMoney(cost)
        ply:Notify(ix.config.Get("shipmentDeliverMessage"))

        // this might be messy and horrid, but meh. in the future i will find a better way..
        local deliverPos = ix.config.Get("shipmentDeliverPositions", ply:EyePos() + ply:GetForward() * 2)

        local entity = ents.Create("ix_shopterminal_shipment")
        entity:Spawn()
        entity:SetPos(deliverPos)
        entity:SetItems(items)
        entity:SetNetVar("owner", char:GetID())

        local shipments = char:GetVar("charEnts") or {}
        table.insert(shipments, entity)
        char:SetVar("charEnts", shipments, true)

        hook.Run("CreateShipment", ply, entity)
    else
        ply:Notify("You do not have enough "..ix.currency.plural.." to buy your cart!")
    end
end)