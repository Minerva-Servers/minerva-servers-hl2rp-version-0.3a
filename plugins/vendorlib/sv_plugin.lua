local PLUGIN = PLUGIN

function PLUGIN:SaveVendors()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_vendor")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetVendor(), v:GetModel()}
    end

    ix.data.Set("vendors", data)
end

function PLUGIN:LoadVendors()
    for _, v in ipairs(ix.data.Get("vendors") or {}) do
        local vendors = ents.Create("ix_vendor")

        vendors:SetPos(v[1])
        vendors:SetAngles(v[2])
        vendors:Spawn()

        vendors:SetVendor(v[3])
        vendors:SetModel(v[4])

        local vendor = ix.vendor.data[v[3]]
        vendors.vendor = vendor

        if ( vendor ) then
            if ( vendor.Skin ) then
                vendors:SetSkin(vendor.Skin)
            end

            if ( vendor.Bodygroups ) then
                vendors:SetBodyGroups(vendor.Bodygroups)
            end

            if ( vendor.Initialize ) then
                vendor.Initialize(vendors)
            end
        end
    end
end

function PLUGIN:SaveData()
    self:SaveVendors()
end

function PLUGIN:LoadData()
    self:LoadVendors()
end

util.AddNetworkString("ixVendorUse")
util.AddNetworkString("ixVendorUseDownload")
util.AddNetworkString("ixVendorBuy")
util.AddNetworkString("ixVendorSell")

net.Receive("ixVendorBuy", function(len, ply)
    if (ply.nextVendorBuy or 0) > CurTime() then return end
    ply.nextVendorBuy = CurTime() + 0.01

    if not ply.currentVendor or not IsValid(ply.currentVendor) then
        return
    end

    local vendor = ply.currentVendor

    if (ply:GetPos() - vendor:GetPos()):LengthSqr() > (120 ^ 2) then 
        return
    end

    if not ply:Alive() then
        return
    end

    local canUse = hook.Run("CanUseInventory", ply)

    if canUse != nil and canUse == false then
        return
    end

    if vendor.vendor.CanUse and vendor.vendor.CanUse(vendor, ply) == false then
        return
    end

    local itemclass = net.ReadString()

    if string.len(itemclass) > 128 then
        return
    end

    local sellData = vendor.vendor.Sell[itemclass]

    if not sellData then
        return
    end
    
    if sellData.Cost and not ply:GetCharacter():HasMoney(sellData.Cost) then
        return
    end

    if sellData.Max then
        local hasItem, amount = ply:GetCharacter():GetInventory():HasItem(itemclass), ply:GetCharacter():GetInventory():GetItemCount(itemclass, false)

        if hasItem and amount >= sellData.Max then
            return
        end
    end

    if sellData.CanBuy and sellData.CanBuy(ply) == false then
        return
    end

    if not ply:GetCharacter():GetInventory():FindEmptySlot(ix.item.Get(itemclass).w, ix.item.Get(itemclass).h) then
        return ply:Notify("You don't have enough inventory space to hold this item.")
    end

    if sellData.Cooldown then
        ply.vendorCooldowns = ply.vendorCooldowns or {}
        local cooldown = ply.vendorCooldowns[itemclass]

        if cooldown and cooldown > CurTime() then
            return ply:Notify("Please wait "..string.NiceTime(cooldown - CurTime()).." before attempting to purchase this item again.")
        else
            ply.vendorCooldowns[itemclass] = CurTime() + sellData.Cooldown
        end
    end

    if sellData.BuyMax then
        ply.vendorBuyMax = ply.vendorBuyMax or {}
        local tMax = ply.vendorBuyMax[itemclass]
        
        if tMax then
            if tMax.Cooldown and tMax.Cooldown > CurTime() then
                local cooldown = tMax.Cooldown

                return ply:Notify("This vendor has no more of this item to give you. Come back in "..string.NiceTime(cooldown - CurTime()).." for more.")
            elseif tMax.Cooldown then
                ply.vendorBuyMax[itemclass] = {
                    Count = 0,
                    Cooldown = nil
                }
            end

            if ply.vendorBuyMax[itemclass].Count >= sellData.BuyMax then
                local cooldown = CurTime() + sellData.TempCooldown
                ply.vendorBuyMax[itemclass].Cooldown = cooldown

                return ply:Notify("This vendor has no more of this item to give you. Come back in "..string.NiceTime(cooldown - CurTime()).." for more.")
            end
        else
            ply.vendorBuyMax[itemclass] = {
                Count = 0
            }
        end

        tMax = ply.vendorBuyMax[itemclass]

        ply.vendorBuyMax[itemclass].Count = ((tMax and tMax.Count) or 0) + 1

        if tMax then
            if ply.vendorBuyMax[itemclass].Count >= sellData.BuyMax then
                local cooldown = CurTime() + sellData.TempCooldown
                ply.vendorBuyMax[itemclass].Cooldown = cooldown
            end 
        end
    end
    
    local item = ix.item.Get(itemclass)

    if sellData.Cost then
        ply:GetCharacter():SetMoney(ply:GetCharacter():GetMoney() - sellData.Cost)
        ply:Notify("You have purchased "..item.name.." for "..ix.currency.symbol..sellData.Cost..".")
    else
        ply:Notify("You have acquired a "..item.name..".")
    end

    ply:GetCharacter():GetInventory():Add(itemclass, 1, {["Restricted"] = sellData.Restricted or nil})

    if vendor.vendor.OnItemPurchased then
        vendor.vendor.OnItemPurchased(vendor, itemclass, ply)
    end

    hook.Run("PlayerVendorBuy", ply, vendor, itemclass, sellData.Cost or 0)
end)

net.Receive("ixVendorSell", function(len, ply)
    if (ply.nextVendorSell or 0) > CurTime() then return end
    ply.nextVendorSell = CurTime() + 0.01

    if not ply.currentVendor or not IsValid(ply.currentVendor) then
        return
    end

    local vendor = ply.currentVendor

    if (ply:GetPos() - vendor:GetPos()):LengthSqr() > (120 ^ 2) then 
        return
    end

    if not ply:Alive() then
        return
    end

    local canUse = hook.Run("CanUseInventory", ply)

    if canUse != nil and canUse == false then
        return
    end

    if vendor.vendor.CanUse and vendor.vendor.CanUse(vendor, ply) == false then
        return
    end

    if vendor.vendor.MaxBuys and (vendor.Buys or 0) >= vendor.vendor.MaxBuys then
        return ply:Notify("This vendor can not afford to purchase this item.")
    end

    local itemid = net.ReadString()
    local item = ix.item.Get(itemid)
    local hasItem = ply:GetCharacter():GetInventory():HasItem(itemid)

    if not hasItem then
        print("not hasItem")
        return
    end

    if item.restricted then
        print("not restricted")
        return
    end

    local buyData = vendor.vendor.Buy[itemid]
    local itemName = item.name

    if not buyData then
        print("not buyData")
        return
    end

    if buyData.CanBuy and buyData.CanBuy(ply) == false then
        print("not CanBuy")
        return
    end

    if vendor.vendor.MaxBuys then
        vendor.Buys = (vendor.Buys or 0) + 1
    end

    ply:GetCharacter():GetInventory():HasItem(itemid):Remove()

    if buyData.Cost then
        ply:GetCharacter():SetMoney(ply:GetCharacter():GetMoney() + buyData.Cost)
        ply:Notify("You have sold a "..itemName.." for "..ix.currency.symbol..buyData.Cost..".")
    else
        ply:Notify("You have handed over a "..itemName..".")
    end

    hook.Run("PlayerVendorSell", ply, vendor, itemid, buyData.Cost or "free")
end)