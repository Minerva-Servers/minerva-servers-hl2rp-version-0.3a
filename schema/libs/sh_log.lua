if (SERVER) then
    function ix.log.AddRaw(logString, bNoSave, color)
        CAMI.GetPlayersWithAccess("Helix - Logs", function(receivers)
            ix.log.Send(receivers, logString)
        end)

        MsgC(ix.config.Get("color"), "[Minerva] ", color or color_white, logString.."\n")
        -- Msg("[LOG] ", logString .. "\n")

        if (!bNoSave) then
            ix.log.CallHandler("Write", nil, logString)
        end
    end

    --- Add a log message
    -- @realm server
    -- @player client Player who instigated the log
    -- @string logType Log category
    -- @param ... Arguments to pass to the log
    function ix.log.Add(client, logType, ...)
        local logString, logFlag = ix.log.Parse(client, logType, ...)
        if (logString == -1) then return end

        CAMI.GetPlayersWithAccess("Helix - Logs", function(receivers)
            ix.log.Send(receivers, logString, logFlag)
        end)

        MsgC(ix.config.Get("color"), "[Minerva] ", color_white, logString.."\n")

        ix.log.CallHandler("Write", client, logString, logFlag, logType, {...})
    end
else
    function ix.log.AddRaw(logString, _, color)
        if (isstring(logString)) then
            MsgC(ix.config.Get("color"), "[Minerva] ", color or color_white, logString.."\n")
        end
    end
    
    net.Receive("ixLogStream", function(length)
        local logString = net.ReadString()
        local flag = net.ReadUInt(4)

        if (isstring(logString) and isnumber(flag)) then
            MsgC(ix.config.Get("color"), "[Minerva] ", ix.log.color[flag], logString.."\n")
        end
    end)
end
