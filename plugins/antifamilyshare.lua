local PLUGIN = PLUGIN

PLUGIN.name = "Anti Family Share"
PLUGIN.description = "Stops people from using family shared accounts"
PLUGIN.author = "Scotnay"

if ( CLIENT ) then
    return
end

function PLUGIN:PlayerAuthed(ply, sid)
    local owner_64 = ply:OwnerSteamID64()
    local s64 = util.SteamIDTo64(sid)

    if ( owner_64 == s64 ) then
        return
    end

    ply:Kick("Sorry! We do not allowed family shared accounts in this server!")
    print(ply:SteamName().." ("..ply:SteamID()..") tried to join, but is using a family shared account.")
    local logTable = {
        steamName = ply:SteamName(),
        ip = ply:IPAddress(),
        steamid = ply:SteamID(),
        steamid64 = ply:SteamID64(),
    }
    file.Write("helix/"..Schema.folder.."/familyshared/"..ply:SteamID64()..".txt", util.TableToJSON(logTable, true))

    for k, v in ipairs(player.GetAll()) do
        if not ( v:IsAdmin() ) then
            continue
        end

        v:ChatNotify(ply:SteamName().." tried to join the server but is using a family shared account. Check RCON for details.")
    end
end