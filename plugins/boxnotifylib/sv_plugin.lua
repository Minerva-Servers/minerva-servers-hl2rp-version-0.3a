util.AddNetworkString("ixBoxNotify.NewMessage")

concommand.Add("ix_boxnotify", function(ply, cmd, args)
    if not ( ply:IsSuperAdmin() ) then
        return
    end
    
    if ( args[1] == "" ) then
        return
    end

    net.Start("ixBoxNotify.NewMessage")
        net.WriteString(args[1])
        net.WriteColor(color_white)
    net.Broadcast()
end)

local PLAYER = FindMetaTable("Player")

function PLAYER:BoxNotify(message, color)
    net.Start("ixBoxNotify.NewMessage")
        net.WriteString(message)
        net.WriteColor(color or color_white)
    net.Send(self)
end

function ix.boxNotify.BoxNotify(message, color)
    net.Start("ixBoxNotify.NewMessage")
        net.WriteString(message)
        net.WriteColor(color or color_white)
    net.Broadcast()
end