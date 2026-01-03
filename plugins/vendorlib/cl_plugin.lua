net.Receive("ixVendorUse", function()
    if ix_vendor and IsValid(ix_vendor) then
        return
    end

    ix_vendor = vgui.Create("ixVendorMenu")
    ix_vendor:SetupVendor()
end)

net.Receive("ixVendorUseDownload", function()
    local vendor = net.ReadString()
    local buyLen = net.ReadUInt(32)
    local buy = pon.decode(net.ReadData(buyLen))
    local sellLen = net.ReadUInt(32)
    local sell = pon.decode(net.ReadData(sellLen))

    ix.vendor.data[vendor].Buy = buy
    ix.vendor.data[vendor].Sell = sell

    if ix_vendor and IsValid(ix_vendor) then
        return
    end

    ix_vendor = vgui.Create("ixVendorMenu")
    ix_vendor:SetupVendor()
end)