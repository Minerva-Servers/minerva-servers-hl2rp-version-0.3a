local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Voice Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

ix.voice = ix.voice or {}
ix.voice.list = ix.voice.list or {}
ix.voice.checks = ix.voice.checks or {}
ix.voice.chatTypes = ix.voice.chatTypes or {}

function ix.voice.DefineClass(class, onCheck, onModify, global)
    ix.voice.checks[class] = {class = class:lower(), onCheck = onCheck, onModify = onModify, isGlobal = global}
end

function ix.voice.GetClass(ply)
    local def = {}

    for v,k in pairs(ix.voice.checks) do
        if (k.onCheck(ply)) then
            def[#def + 1] = k
        end
    end

    return def
end

function ix.voice.Register(class, key, replacement, source, max)
    class = class:lower()

    ix.voice.list[class] = ix.voice.list[class] or {}
    ix.voice.list[class][key:lower()] = {replacement = replacement, source = source}
end

function ix.voice.GetVoiceList(class, text, delay)
    local info = ix.voice.list[class]

    if (!info) then
        return
    end

    local output = {}
    local original = string.Explode(" ", text)
    local exploded = string.Explode(" ", text:lower())
    local phrase = ""
    local skip = 0
    local current = 0

    max = max or 10

    for k, v in ipairs(exploded) do
        if (k < skip) then
            continue
        end

        if (current < max) then
            local i = k
            local key = v

            local nextValue, nextKey

            while (true) do
                i = i + 1
                nextValue = exploded[i]

                if (!nextValue) then
                    break
                end

                nextKey = key.." "..nextValue

                if (!info[nextKey]) then
                    i = i + 1

                    local nextValue2 = exploded[i]
                    local nextKey2 = nextKey.." "..(nextValue2 or "")

                    if (!nextValue2 or !info[nextKey2]) then
                        i = i - 1

                        break
                    end

                    nextKey = nextKey2
                end

                key = nextKey
            end

            if (info[key]) then
                local source = info[key].source
                
                if (type(source) == "table") then
                    source = table.Random(source)
                else
                    source = tostring(source)
                end
                
                output[#output + 1] = {source, delay or 0.1}
                phrase = phrase..info[key].replacement.." "
                skip = i
                current = current + 1

                continue
            end
        end

        phrase = phrase..original[k].." "
    end
    
    if (phrase:sub(#phrase, #phrase) == " ") then
        phrase = phrase:sub(1, -2)
    end

    return #output > 0 and output or nil, phrase
end

ix.voice.chatTypes["ic"] = true -- says
ix.voice.chatTypes["y"] = true -- yells
ix.voice.chatTypes["w"] = true -- whisper
ix.voice.chatTypes["radio"] = true -- radio
ix.voice.chatTypes["commandradio"] = true -- radio

ix.voice.DefineClass("combine", function(ply)
    return ply:IsCombine()
end, function(ply, sounds, chatType)
    local beeps = ix.voice.beepSounds[ply:Team()] or ix.voice.beepSounds[FACTION_CP]

    table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
    sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

ix.voice.DefineClass("vort", function(ply)
    return ply:Team() == FACTION_VORTIGAUNT
end)

ix.voice.Register("combine", "0", "0", "npc/metropolice/vo/zero.wav")
ix.voice.Register("combine", "1", "1", "npc/metropolice/vo/one.wav")
ix.voice.Register("combine", "10", "10", "npc/metropolice/vo/ten.wav")
ix.voice.Register("combine", "10-0 HUNTING", "10-0, 10-0, viscerator is hunting!", "npc/metropolice/vo/tenzerovisceratorishunting.wav")
ix.voice.Register("combine", "100", "One-hundred.", "npc/metropolice/vo/onehundred.wav")
ix.voice.Register("combine", "10-103 TAG", "Possible 10-103, my location, alert TAG units.", "npc/metropolice/vo/possible10-103alerttagunits.wav")
ix.voice.Register("combine", "10-107", "I have a 10-107 here, send AirWatch for tag.", "npc/metropolice/vo/gota10-107sendairwatch.wav")
ix.voice.Register("combine", "10-108", "We have a 10-108!", "npc/metropolice/vo/wehavea10-108.wav")
ix.voice.Register("combine", "10-14", "Holding on 10-14 duty, eh, code four.", "npc/metropolice/vo/holdingon10-14duty.wav")
ix.voice.Register("combine", "10-15", "Prepare for 10-15.", "npc/metropolice/vo/preparefor1015.wav")
ix.voice.Register("combine", "10-2", "10-2.", "npc/metropolice/vo/ten2.wav")
ix.voice.Register("combine", "10-25", "Any unit, report in with 10-25 as suspect.", "npc/metropolice/vo/unitreportinwith10-25suspect.wav")
ix.voice.Register("combine", "10-30", "I have a 10-30, my 10-20, responding, code two.", "npc/metropolice/vo/Ihave10-30my10-20responding.wav")
ix.voice.Register("combine", "10-4", "10-4.", "npc/metropolice/vo/ten4.wav")
ix.voice.Register("combine", "10-65", "Unit is 10-65.", "npc/metropolice/vo/unitis10-65.wav")
ix.voice.Register("combine", "10-78", "Dispatch, I need 10-78, officer in trouble!", "npc/metropolice/vo/dispatchIneed10-78.wav")
ix.voice.Register("combine", "10-8 standing by", "10-8, standing by.", "npc/metropolice/vo/ten8standingby.wav")
ix.voice.Register("combine", "10-8", "Unit is on-duty, 10-8.", "npc/metropolice/vo/unitisonduty10-8.wav")
ix.voice.Register("combine", "10-91D", "10-91d count is...", "npc/metropolice/vo/ten91dcountis.wav")
ix.voice.Register("combine", "10-97 GOA", "10-97, that suspect is GOA.", "npc/metropolice/vo/ten97suspectisgoa.wav")
ix.voice.Register("combine", "10-97", "10-97.", "npc/metropolice/vo/ten97.wav")
ix.voice.Register("combine", "10-99", "Officer down, I am 10-99, I repeat, I am 10-99!", "npc/metropolice/vo/officerdownIam10-99.wav")
ix.voice.Register("combine", "11-44", "Get that 11-44 inbound, we're cleaning up now.", "npc/metropolice/vo/get11-44inboundcleaningup.wav")
ix.voice.Register("combine", "11-6", "Suspect 11-6, my 10-20 is...", "npc/metropolice/vo/suspect11-6my1020is.wav")
ix.voice.Register("combine", "11-99", "11-99, officer needs assistance!", "npc/metropolice/vo/11-99officerneedsassistance.wav")
ix.voice.Register("combine", "2", "2", "npc/metropolice/vo/two.wav")
ix.voice.Register("combine", "20", "20", "npc/metropolice/vo/twenty.wav")
ix.voice.Register("combine", "200", "Two-hundred.", "npc/metropolice/vo/twohundred.wav")
ix.voice.Register("combine", "3", "3", "npc/metropolice/vo/three.wav")
ix.voice.Register("combine", "30", "30", "npc/metropolice/vo/thirty.wav")
ix.voice.Register("combine", "300", "Three-hundred.", "npc/metropolice/vo/threehundred.wav")
ix.voice.Register("combine", "34S AT", "All units, BOL, we have 34-S at...", "npc/metropolice/vo/allunitsbol34sat.wav")
ix.voice.Register("combine", "4", "4", "npc/metropolice/vo/four.wav")
ix.voice.Register("combine", "40", "40", "npc/metropolice/vo/fourty.wav")
ix.voice.Register("combine", "404", "404 zone.", "npc/metropolice/vo/404zone.wav")
ix.voice.Register("combine", "408", "I've got a 408 here at location.", "npc/metropolice/vo/Ivegot408hereatlocation.wav")
ix.voice.Register("combine", "415B", "Is 415b.", "npc/metropolice/vo/is415b.wav")
ix.voice.Register("combine", "5", "5", "npc/metropolice/vo/five.wav")
ix.voice.Register("combine", "50", "50", "npc/metropolice/vo/fifty.wav")
ix.voice.Register("combine", "505", "Dispatch, we need AirWatch, subject is 505!", "npc/metropolice/vo/airwatchsubjectis505.wav")
ix.voice.Register("combine", "6", "6", "npc/metropolice/vo/six.wav")
ix.voice.Register("combine", "60", "60", "npc/metropolice/vo/sixty.wav")
ix.voice.Register("combine", "603", "603, unlawful entry.", "npc/metropolice/vo/unlawfulentry603.wav")
ix.voice.Register("combine", "63", "63, criminal trespass.", "npc/metropolice/vo/criminaltrespass63.wav")
ix.voice.Register("combine", "7", "7", "npc/metropolice/vo/seven.wav")
ix.voice.Register("combine", "70", "70", "npc/metropolice/vo/seventy.wav")
ix.voice.Register("combine", "8", "8", "npc/metropolice/vo/eight.wav")
ix.voice.Register("combine", "80", "80", "npc/metropolice/vo/eighty.wav")
ix.voice.Register("combine", "9", "9", "npc/metropolice/vo/nine.wav")
ix.voice.Register("combine", "90", "90", "npc/metropolice/vo/ninety.wav")
ix.voice.Register("combine", "THAT'S A GRENADE", "That's a grenade!", "npc/metropolice/vo/thatsagrenade.wav")
ix.voice.Register("combine", "ACQUIRING", "Acquiring on visual!", "npc/metropolice/vo/acquiringonvisual.wav")
ix.voice.Register("combine", "ADMINISTER", "Administer.", "npc/metropolice/vo/administer.wav")
ix.voice.Register("combine", "CONFIRMED ADW", "Confirmed as ADW on that suspect, 10-0.", "npc/metropolice/vo/confirmadw.wav")
ix.voice.Register("combine", "AFFIRMATIVE", "Affirmative.", "npc/metropolice/vo/affirmative.wav")
ix.voice.Register("combine", "ALL UNITS MOVE", "All units, move in!", "npc/metropolice/vo/allunitsmovein.wav")
ix.voice.Register("combine", "AMPUTATE", "Amputate.", "npc/metropolice/vo/amputate.wav")
ix.voice.Register("combine", "ANTICITIZEN", "Anti-citizen.", "npc/metropolice/vo/anticitizen.wav")
ix.voice.Register("combine", "ANTISEPTIC", "Antiseptic.", "npc/combine_soldier/vo/antiseptic.wav")
ix.voice.Register("combine", "APEX", "Apex.", "npc/combine_soldier/vo/apex.wav")
ix.voice.Register("combine", "APPLY", "Apply.", "npc/metropolice/vo/apply.wav")
ix.voice.Register("combine", "ARREST POSITIONS", "All units, move to arrest positions!", "npc/metropolice/vo/movetoarrestpositions.wav")
ix.voice.Register("combine", "AT CHECKPOINT", "At checkpoint.", "npc/metropolice/vo/atcheckpoint.wav")
ix.voice.Register("combine", "AT LOCATION REPORT", "Protection-teams at location, report in.", "npc/metropolice/vo/ptatlocationreport.wav")
ix.voice.Register("combine", "BACK ME UP", "Back me up, I'm out!", "npc/metropolice/vo/backmeupImout.wav")
ix.voice.Register("combine", "BACKUP", "Backup!", "npc/metropolice/vo/backup.wav")
ix.voice.Register("combine", "BLADE", "Blade.", "npc/combine_soldier/vo/blade.wav")
ix.voice.Register("combine", "BLEEDING", "Suspect is bleeding from multiple wounds!", "npc/metropolice/vo/suspectisbleeding.wav")
ix.voice.Register("combine", "BLIP", "Catch that blip on the stabilization readout?", "npc/metropolice/vo/catchthatbliponstabilization.wav")
ix.voice.Register("combine", "BLOCK HOLDING", "Block is holding, cohesive.", "npc/metropolice/vo/blockisholdingcohesive.wav")
ix.voice.Register("combine", "BLOCK", "Block!", "npc/metropolice/vo/block.wav")
ix.voice.Register("combine", "BOL 243", "CP, we need AirWatch to BOL for that 243.", "npc/metropolice/vo/cpbolforthat243.wav")
ix.voice.Register("combine", "BREAK COVER", "Break his cover!", "npc/metropolice/vo/breakhiscover.wav")
ix.voice.Register("combine", "CAN1", "Pick up that can.", "npc/metropolice/vo/pickupthecan1.wav")
ix.voice.Register("combine", "CAN2", "Pick up the can!", "npc/metropolice/vo/pickupthecan2.wav")
ix.voice.Register("combine", "CAN3", "I said, pick up the can!", "npc/metropolice/vo/pickupthecan3.wav")
ix.voice.Register("combine", "CAN4", "Now, put it in the trash-can.", "npc/metropolice/vo/putitinthetrash1.wav")
ix.voice.Register("combine", "CAN5", "I said, put it in the trash-can!", "npc/metropolice/vo/putitinthetrash2.wav")
ix.voice.Register("combine", "CAN6", "You knocked it over, pick it up!", "npc/metropolice/vo/youknockeditover.wav")
ix.voice.Register("combine", "CANAL", "Canal.", "npc/metropolice/vo/canal.wav")
ix.voice.Register("combine", "CANALBLOCK", "Canalblock!", "npc/metropolice/vo/canalblock.wav")
ix.voice.Register("combine", "CAUTERIZE", "Cauterize.", "npc/metropolice/vo/cauterize.wav")
ix.voice.Register("combine", "CHECK MISCOUNT", "Check for miscount.", "npc/metropolice/vo/checkformiscount.wav")
ix.voice.Register("combine", "CHECKPOINTS", "Proceed to designated checkpoints.", "npc/metropolice/vo/proceedtocheckpoints.wav")
ix.voice.Register("combine", "CITIZEN SUMMONED", "Reporting citizen summoned into voluntary conscription for channel open service detail T94-332.", "npc/metropolice/vo/citizensummoned.wav")
ix.voice.Register("combine", "CITIZEN", "Citizen.", "npc/metropolice/vo/citizen.wav")
ix.voice.Register("combine", "CLASSIFY DB", "Classify subject name as 'DB'; this block ready for clean-out.", "npc/metropolice/vo/classifyasdbthisblockready.wav")
ix.voice.Register("combine", "CLEANED", "Cleaned.", "npc/combine_soldier/vo/cleaned.wav")
ix.voice.Register("combine", "CLEAR CODE 100", "Clear and code one-hundred.", "npc/metropolice/vo/clearandcode100.wav")
ix.voice.Register("combine", "CLOSE ON SUSPECT", "All units, close on suspect!", "npc/metropolice/vo/allunitscloseonsuspect.wav")
ix.voice.Register("combine", "CLOSING", "Closing!", {"npc/combine_soldier/vo/closing.wav", "npc/combine_soldier/vo/closing2.wav"})
ix.voice.Register("combine", "CODE 100", "Code one-hundred.", "npc/metropolice/vo/code100.wav")
ix.voice.Register("combine", "CODE 2", "All units, code two!", "npc/metropolice/vo/allunitscode2.wav")
ix.voice.Register("combine", "CODE 3", "Officer down, request all units, code three to my 10-20!", "npc/metropolice/vo/officerdowncode3tomy10-20.wav")
ix.voice.Register("combine", "CODE 7", "Code seven.", "npc/metropolice/vo/code7.wav")
ix.voice.Register("combine", "CONDEMNED", "Condemned zone!", "npc/metropolice/vo/condemnedzone.wav")
ix.voice.Register("combine", "CONTACT 243", "Contact with 243 suspect, my 10-20 is...", "npc/metropolice/vo/contactwith243suspect.wav")
ix.voice.Register("combine", "CONTACT PRIORITY", "I have contact with a priority two!", "npc/metropolice/vo/contactwithpriority2.wav")
ix.voice.Register("combine", "CONTACT", "Contact!", "npc/combine_soldier/vo/contact.wav")
ix.voice.Register("combine", "CONTAINED", "Contained.", "npc/combine_soldier/vo/contained.wav")
ix.voice.Register("combine", "CONTROL 100", "Control is one-hundred percent this location, no sign of that 647-E.", "npc/metropolice/vo/control100percent.wav")
ix.voice.Register("combine", "CONTROLSECTION", "Control-section!", "npc/metropolice/vo/controlsection.wav")
ix.voice.Register("combine", "CONVERGING", "Converging.", "npc/metropolice/vo/converging.wav")
ix.voice.Register("combine", "COPY THAT", "Copy that.", "npc/combine_soldier/vo/copythat.wav")
ix.voice.Register("combine", "COPY", "Copy.", "npc/metropolice/vo/copy.wav")
ix.voice.Register("combine", "COVER", "Cover!", "npc/combine_soldier/vo/coverhurt.wav")
ix.voice.Register("combine", "CP COMPROMISED", "CP is compromised, re-establish!", "npc/metropolice/vo/cpiscompromised.wav")
ix.voice.Register("combine", "CP ESTABLISH", "CP, we need to establish our perimeter at...", "npc/metropolice/vo/cpweneedtoestablishaperimeterat.wav")
ix.voice.Register("combine", "CP OVERRUN", "CP is overrun, we have no containment!", "npc/metropolice/vo/cpisoverrunwehavenocontainment.wav")
ix.voice.Register("combine", "DAGGER", "Dagger.", "npc/combine_soldier/vo/dagger.wav")
ix.voice.Register("combine", "DASH", "Dash.", "npc/combine_soldier/vo/dash.wav")
ix.voice.Register("combine", "DB COUNT", "DB count is...", "npc/metropolice/vo/dbcountis.wav")
ix.voice.Register("combine", "DEFENDER", "Defender!", "npc/metropolice/vo/defender.wav")
ix.voice.Register("combine", "DESERVICED AREA", "Deserviced area.", "npc/metropolice/vo/deservicedarea.wav")
ix.voice.Register("combine", "DESIGNATE SUSPECT", "Designate suspect as...", "npc/metropolice/vo/designatesuspectas.wav")
ix.voice.Register("combine", "DESTROY COVER", "Destroy that cover!", "npc/metropolice/vo/destroythatcover.wav")
ix.voice.Register("combine", "DISLOCATE INTERPOSE", "Fire to dislocate that interpose!", "npc/metropolice/vo/firetodislocateinterpose.wav")
ix.voice.Register("combine", "DISMOUNTING HARDPOINT", "Dismounting hardpoint.", "npc/metropolice/vo/dismountinghardpoint.wav")
ix.voice.Register("combine", "DISP APB", "Disp updating APB likeness.", "npc/metropolice/vo/dispupdatingapb.wav")
ix.voice.Register("combine", "DISTRIBUTION BLOCK", "Distribution block.", "npc/metropolice/vo/distributionblock.wav")
ix.voice.Register("combine", "DOCUMENT", "Document.", "npc/metropolice/vo/document.wav")
ix.voice.Register("combine", "DONT MOVE", "Don't move!", "npc/metropolice/vo/dontmove.wav")
ix.voice.Register("combine", "ECHO", "Echo.", "npc/combine_soldier/vo/echo.wav")
ix.voice.Register("combine", "ENGAGING", "Engaging!", "npc/combine_soldier/vo/engaging.wav")
ix.voice.Register("combine", "ESTABLISH NEW CP", "Fall down, establish a new CP!", "npc/metropolice/vo/establishnewcp.wav")
ix.voice.Register("combine", "EXPOSE TARGET", "Firing to expose target!", "npc/metropolice/vo/firingtoexposetarget.wav")
ix.voice.Register("combine", "EXTERNAL", "External jurisdiction.", "npc/metropolice/vo/externaljurisdiction.wav")
ix.voice.Register("combine", "FINAL VERDICT", "Final verdict administered.", "npc/metropolice/vo/finalverdictadministered.wav")
ix.voice.Register("combine", "FINAL WARNING", "Final warning!", "npc/metropolice/vo/finalwarning.wav")
ix.voice.Register("combine", "FIRST WARNING", "First warning, move away!", "npc/metropolice/vo/firstwarningmove.wav")
ix.voice.Register("combine", "FIST", "Fist.", "npc/combine_soldier/vo/fist.wav")
ix.voice.Register("combine", "FLASH", "Flash.", "npc/combine_soldier/vo/flash.wav")
ix.voice.Register("combine", "FLATLINE", "Flatline.", "npc/combine_soldier/vo/flatline.wav")
ix.voice.Register("combine", "FLUSH", "Flush.", "npc/combine_soldier/vo/flush.wav")
ix.voice.Register("combine", "FREE NECROTICS", "I have free necrotics!", "npc/metropolice/vo/freenecrotics.wav")
ix.voice.Register("combine", "GET DOWN", "Get down!", "npc/metropolice/vo/getdown.wav")
ix.voice.Register("combine", "GET OUT", "Get out of here!", "npc/metropolice/vo/getoutofhere.wav")
ix.voice.Register("combine", "GETTING 647E", "Still getting that 647-E from local surveillance.", "npc/metropolice/vo/stillgetting647e.wav")
ix.voice.Register("combine", "GHOST", "Ghost.", "npc/combine_soldier/vo/ghost.wav")
ix.voice.Register("combine", "GO AGAIN", "PT, go again.", "npc/metropolice/vo/ptgoagain.wav")
ix.voice.Register("combine", "GO SHARP", "Go sharp!", "npc/combine_soldier/vo/gosharp.wav")
ix.voice.Register("combine", "GOING IN", "Cover me, I'm going in!", "npc/metropolice/vo/covermegoingin.wav")
ix.voice.Register("combine", "GOT A DB", "Uh, we got a DB here, cancel that 11-42.", "npc/metropolice/vo/wegotadbherecancel10-102.wav")
ix.voice.Register("combine", "GOT HIM AGAIN", "Got him again, suspect is 10-20 at...", "npc/metropolice/vo/gothimagainsuspect10-20at.wav")
ix.voice.Register("combine", "GOT ONE ACCOMPLICE", "I got one accomplice here!", "npc/metropolice/vo/gotoneaccompliceherea.wav")
ix.voice.Register("combine", "GOT SUSPECT ONE", "I got suspect one here!", "npc/metropolice/vo/gotsuspect1here.wav")
ix.voice.Register("combine", "GRENADE", "Grenade!", "npc/metropolice/vo/grenade.wav")
ix.voice.Register("combine", "GRID", "Grid.", "npc/combine_soldier/vo/grid.wav")
ix.voice.Register("combine", "HAHA", "Haha.", "npc/metropolice/vo/chuckle.wav")
ix.voice.Register("combine", "HAMMER", "Hammer.", "npc/combine_soldier/vo/hammer.wav")
ix.voice.Register("combine", "HARDPOINT PROSECUTE", "Is at hardpoint, ready to prosecute!", "npc/metropolice/vo/isathardpointreadytoprosecute.wav")
ix.voice.Register("combine", "HARDPOINT SCANNING", "Hardpoint scanning.", "npc/metropolice/vo/hardpointscanning.wav")
ix.voice.Register("combine", "HELIX", "Helix.", "npc/combine_soldier/vo/helix.wav")
ix.voice.Register("combine", "HELP", "Help!", "npc/metropolice/vo/help.wav")
ix.voice.Register("combine", "HERO", "Hero!", "npc/metropolice/vo/hero.wav")
ix.voice.Register("combine", "HES 148", "He's gone 148!", "npc/metropolice/vo/hesgone148.wav")
ix.voice.Register("combine", "HIGH PRIORITY", "High-priority region.", "npc/metropolice/vo/highpriorityregion.wav")
ix.voice.Register("combine", "HOLD IT", "Hold it right there!", "npc/metropolice/vo/holditrightthere.wav")
ix.voice.Register("combine", "HOLD POSITION", "Protection-team, hold this position.", "npc/metropolice/vo/holdthisposition.wav")
ix.voice.Register("combine", "HOLD", "Hold it!", "npc/metropolice/vo/holdit.wav")
ix.voice.Register("combine", "HUNTER", "Hunter.", "npc/combine_soldier/vo/hunter.wav")
ix.voice.Register("combine", "HURRICANE", "Hurricane.", "npc/combine_soldier/vo/hurricane.wav")
ix.voice.Register("combine", "I SAID MOVE", "I said move along.", "npc/metropolice/vo/Isaidmovealong.wav")
ix.voice.Register("combine", "ICE", "Ice.", "npc/combine_soldier/vo/ice.wav")
ix.voice.Register("combine", "IN POSITION", "In position.", "npc/metropolice/vo/inposition.wav")
ix.voice.Register("combine", "INBOUND", "Inbound.", "npc/combine_soldier/vo/inbound.wav")
ix.voice.Register("combine", "INFECTED", "Infected.", "npc/combine_soldier/vo/infected.wav")
ix.voice.Register("combine", "INFECTION", "Infection!", "npc/metropolice/vo/infection.wav")
ix.voice.Register("combine", "INFESTED", "Infested zone.", "npc/metropolice/vo/infestedzone.wav")
ix.voice.Register("combine", "INJECT", "Inject!", "npc/metropolice/vo/inject.wav")
ix.voice.Register("combine", "INOCULATE", "Inoculate.", "npc/metropolice/vo/innoculate.wav")
ix.voice.Register("combine", "INTERCEDE", "Intercede!", "npc/metropolice/vo/intercede.wav")
ix.voice.Register("combine", "INTERLOCK", "Interlock!", "npc/metropolice/vo/interlock.wav")
ix.voice.Register("combine", "INVESTIGATE", "Investigate.", "npc/metropolice/vo/investigate.wav")
ix.voice.Register("combine", "INVESTIGATING", "Investigating 10-103.", "npc/metropolice/vo/investigating10-103.wav")
ix.voice.Register("combine", "ION", "Ion.", "npc/combine_soldier/vo/ion.wav")
ix.voice.Register("combine", "IS 10-108", "Is 10-108!", "npc/metropolice/vo/is10-108.wav")
ix.voice.Register("combine", "IS 10-8", "Unit is 10-8, standing by.", "npc/metropolice/vo/unitis10-8standingby.wav")
ix.voice.Register("combine", "IS CLOSING", "Is closing on suspect!", "npc/metropolice/vo/isclosingonsuspect.wav")
ix.voice.Register("combine", "IS DOWN", "Is down!", "npc/metropolice/vo/isdown.wav")
ix.voice.Register("combine", "IS INBOUND", "Unit is inbound.", "npc/combine_soldier/vo/unitisinbound.wav")
ix.voice.Register("combine", "IS MOVING IN", "Unit is moving in.", "npc/combine_soldier/vo/unitismovingin.wav")
ix.voice.Register("combine", "IS MOVING", "Unit is moving in!", "npc/metropolice/vo/ismovingin.wav")
ix.voice.Register("combine", "IS PASSIVE", "Is passive.", "npc/metropolice/vo/ispassive.wav")
ix.voice.Register("combine", "IS READY TO GO", "Is ready to go!", "npc/metropolice/vo/isreadytogo.wav")
ix.voice.Register("combine", "ISOLATE", "Isolate!", "npc/metropolice/vo/isolate.wav")
ix.voice.Register("combine", "JET", "Jet.", "npc/combine_soldier/vo/jet.wav")
ix.voice.Register("combine", "JUDGE", "Judge!", "npc/combine_soldier/vo/judge.wav")
ix.voice.Register("combine", "JUDGE", "Judge.", "npc/combine_soldier/vo/judge.wav")
ix.voice.Register("combine", "JUDGEMENT", "Suspect, prepare to receive civil judgement!", "npc/metropolice/vo/prepareforjudgement.wav")
ix.voice.Register("combine", "JUDGMENT", "Suspect, prepare to receive civil judgement!", "npc/metropolice/vo/prepareforjudgement.wav")
ix.voice.Register("combine", "JURISDICTION", "Stabilization-jurisdiction.", "npc/metropolice/vo/stabilizationjurisdiction.wav")
ix.voice.Register("combine", "JURY", "Jury!", "npc/metropolice/vo/jury.wav")
ix.voice.Register("combine", "KEEP MOVING", "Keep moving!", "npc/metropolice/vo/keepmoving.wav")
ix.voice.Register("combine", "KILO", "Kilo.", "npc/combine_soldier/vo/kilo.wav")
ix.voice.Register("combine", "KING", "King!", "npc/metropolice/vo/king.wav")
ix.voice.Register("combine", "LAST SEEN AT", "Hiding, last seen at range...", "npc/metropolice/vo/hidinglastseenatrange.wav")
ix.voice.Register("combine", "LEADER", "Leader.", "npc/combine_soldier/vo/leader.wav")
ix.voice.Register("combine", "LEVEL 3", "I have a level three civil-privacy violator here!", "npc/metropolice/vo/level3civilprivacyviolator.wav")
ix.voice.Register("combine", "LINE", "Line!", "npc/metropolice/vo/line.wav")
ix.voice.Register("combine", "LOCATION", "Location?", "npc/metropolice/vo/location.wav")
ix.voice.Register("combine", "LOCK POSITION", "All units, lock your position!", "npc/metropolice/vo/lockyourposition.wav")
ix.voice.Register("combine", "LOCK", "Lock!", "npc/metropolice/vo/lock.wav")
ix.voice.Register("combine", "LOOK OUT", "Look out!", "npc/metropolice/vo/lookout.wav")
ix.voice.Register("combine", "LOOSE PARASITICS", "Loose parasitics!", "npc/metropolice/vo/looseparasitics.wav")
ix.voice.Register("combine", "LOST CONTACT", "Lost contact!", "npc/combine_soldier/vo/lostcontact.wav")
ix.voice.Register("combine", "LOW ON", "Running low on verdicts, taking cover!", "npc/metropolice/vo/runninglowonverdicts.wav")
ix.voice.Register("combine", "MACE", "Mace.", "npc/combine_soldier/vo/mace.wav")
ix.voice.Register("combine", "MAINTAIN CP", "All units, maintain this CP!", "npc/metropolice/vo/allunitsmaintainthiscp.wav")
ix.voice.Register("combine", "MALCOMPLIANCE", "Issuing malcompliance citation.", "npc/metropolice/vo/issuingmalcompliantcitation.wav")
ix.voice.Register("combine", "MALCOMPLIANT 10-107", "Malcompliant 10-107 at my 10-20, preparing to prosecute.", "npc/metropolice/vo/malcompliant10107my1020.wav")
ix.voice.Register("combine", "MALIGNANT", "Malignant!", "npc/metropolice/vo/malignant.wav")
ix.voice.Register("combine", "MATCH ON APB", "I have a match on APB likeness.", "npc/metropolice/vo/matchonapblikeness.wav")
ix.voice.Register("combine", "MINOR HITS", "Minor hits, continuing prosecution!", "npc/metropolice/vo/minorhitscontinuing.wav")
ix.voice.Register("combine", "MOVE ALONG", "Move along!", "npc/metropolice/vo/movealong.wav")
ix.voice.Register("combine", "MOVE BACK", "Move back, right now!", "npc/metropolice/vo/movebackrightnow.wav")
ix.voice.Register("combine", "MOVE IN", "Move in!", "npc/combine_soldier/vo/movein.wav")
ix.voice.Register("combine", "MOVE IT", "Move it!", "npc/metropolice/vo/moveit.wav")
ix.voice.Register("combine", "MOVE", "Move!", "npc/metropolice/vo/move.wav")
ix.voice.Register("combine", "MOVING TO COVER", "Moving to cover!", "npc/metropolice/vo/movingtocover.wav")
ix.voice.Register("combine", "MOVING TO HARDPOINT", "Moving to hardpoint!", "npc/metropolice/vo/movingtohardpoint.wav")
ix.voice.Register("combine", "NECROTICS", "Necrotics!", "npc/metropolice/vo/necrotics.wav")
ix.voice.Register("combine", "NEED ANY HELP", "Need any help with this one?", "npc/metropolice/vo/needanyhelpwiththisone.wav")
ix.voice.Register("combine", "NEEDS ASSISTANCE", "Officer needs assistance, I am 11-99!", "npc/metropolice/vo/officerneedsassistance.wav")
ix.voice.Register("combine", "NEEDS HELP", "Officer needs help!", "npc/metropolice/vo/officerneedshelp.wav")
ix.voice.Register("combine", "NO 647", "Clear, no 647, no 10-107.", "npc/metropolice/vo/clearno647no10-107.wav")
ix.voice.Register("combine", "NO CONTACT", "No contact!", "npc/metropolice/vo/nocontact.wav")
ix.voice.Register("combine", "NO I'M GOOD", "No, I'm good.", "vo/trainyard/ba_noimgood.wav")
ix.voice.Register("combine", "NO VISUAL ON", "No visual on UPI at this time.", "npc/metropolice/vo/novisualonupi.wav")
ix.voice.Register("combine", "NOMAD", "Nomad.", "npc/combine_soldier/vo/nomad.wav")
ix.voice.Register("combine", "NONCITIZEN", "Noncitizen.", "npc/metropolice/vo/noncitizen.wav")
ix.voice.Register("combine", "NONPATROL", "Non-patrol region.", "npc/metropolice/vo/nonpatrolregion.wav")
ix.voice.Register("combine", "NONTAGGED VIROMES", "Non-tagged viromes here!", "npc/metropolice/vo/non-taggedviromeshere.wav")
ix.voice.Register("combine", "NOVA", "Nova.", "npc/combine_soldier/vo/nova.wav")
ix.voice.Register("combine", "NOW GET OUT", "Now, get out of here!", "npc/metropolice/vo/nowgetoutofhere.wav")
ix.voice.Register("combine", "NOW", "Now.", "vo/trainyard/ba_thatbeer01.wav")
ix.voice.Register("combine", "OUTBREAK", "Outbreak!", "npc/combine_soldier/vo/outbreak.wav")
ix.voice.Register("combine", "OUTBREAK", "Outbreak!", "npc/metropolice/vo/outbreak.wav")
ix.voice.Register("combine", "OVERWATCH", "Overwatch.", "npc/combine_soldier/vo/overwatch.wav")
ix.voice.Register("combine", "PACIFYING", "Pacifying!", "npc/metropolice/vo/pacifying.wav")
ix.voice.Register("combine", "PAIN1", "Ugh!", "npc/metropolice/pain1.wav")
ix.voice.Register("combine", "PAIN2", "Uagh!", "npc/metropolice/pain2.wav")
ix.voice.Register("combine", "PAIN3", "Augh!", "npc/metropolice/pain3.wav")
ix.voice.Register("combine", "PAIN4", "Agh!", "npc/metropolice/pain4.wav")
ix.voice.Register("combine", "PATROL", "Patrol!", "npc/metropolice/vo/patrol.wav")
ix.voice.Register("combine", "PAYBACK", "Payback.", "npc/combine_soldier/vo/payback.wav")
ix.voice.Register("combine", "PHANTOM", "Phantom.", "npc/combine_soldier/vo/phantom.wav")
ix.voice.Register("combine", "PICKUP 647E", "Anyone else pick up a, uh... 647-E reading?", "npc/metropolice/vo/anyonepickup647e.wav")
ix.voice.Register("combine", "POSITION AT HARDPOINT", "In position at hardpoint.", "npc/metropolice/vo/inpositionathardpoint.wav")
ix.voice.Register("combine", "POSITION TO CONTAIN", "Position to contain.", "npc/metropolice/vo/positiontocontain.wav")
ix.voice.Register("combine", "POSSIBLE 404", "Possible 404 here!", "npc/metropolice/vo/possible404here.wav")
ix.voice.Register("combine", "POSSIBLE 647E", "Possible 647-E here, request AirWatch tag.", "npc/metropolice/vo/possible647erequestairwatch.wav")
ix.voice.Register("combine", "POSSIBLE ACCOMPLICE", "Report sightings of possible accomplice.", "npc/metropolice/vo/reportsightingsaccomplices.wav")
ix.voice.Register("combine", "POSSIBLE LEVEL 3", "Possible level three civil-privacy violator here!", "npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav")
ix.voice.Register("combine", "PREPARING TO JUDGE", "Preparing to judge a 10-107, be advised.", "npc/metropolice/vo/preparingtojudge10-107.wav")
ix.voice.Register("combine", "PRESERVE", "Preserve!", "npc/metropolice/vo/preserve.wav")
ix.voice.Register("combine", "PRESSURE", "Pressure!", "npc/metropolice/vo/pressure.wav")
ix.voice.Register("combine", "PRIORITY 1", "Confirm, priority-one sighted.", "npc/metropolice/vo/confirmpriority1sighted.wav")
ix.voice.Register("combine", "PRIORITY 2", "I have a priority-two anti-citizen here!", "npc/metropolice/vo/priority2anticitizenhere.wav")
ix.voice.Register("combine", "PRODUCTION BLOCK", "Production-block.", "npc/metropolice/vo/productionblock.wav")
ix.voice.Register("combine", "PROSECUTE MALCOMPLIANT", "Ready to prosecute malcompliant citizen, final warning issued!", "npc/metropolice/vo/readytoprosecutefinalwarning.wav")
ix.voice.Register("combine", "PROSECUTE", "Prosecute!", "npc/metropolice/vo/prosecute.wav")
ix.voice.Register("combine", "PROSECUTING", "Prosecuting.", "npc/combine_soldier/vo/procecuting.")
ix.voice.Register("combine", "PROTECTION COMPLETE", "Protection complete.", "npc/metropolice/vo/protectioncomplete.wav")
ix.voice.Register("combine", "QUICK", "Quick!", "npc/metropolice/vo/quick.wav")
ix.voice.Register("combine", "QUICKSAND", "Quicksand.", "npc/combine_soldier/vo/quicksand.wav")
ix.voice.Register("combine", "RANGE", "Range.", "npc/combine_soldier/vo/range.wav")
ix.voice.Register("combine", "RANGER", "Ranger.", "npc/combine_soldier/vo/ranger.wav")
ix.voice.Register("combine", "RAZOR", "Razor.", "npc/combine_soldier/vo/razor.wav")
ix.voice.Register("combine", "READY AMPUTATE", "Ready to amputate!", "npc/metropolice/vo/readytoamputate.wav")
ix.voice.Register("combine", "READY CHARGES", "Ready charges!", "npc/combine_soldier/vo/readycharges.wav")
ix.voice.Register("combine", "READY JUDGE", "Ready to judge.", "npc/metropolice/vo/readytojudge.wav")
ix.voice.Register("combine", "READY PROSECUTE", "Ready to prosecute!", "npc/metropolice/vo/readytoprosecute.wav")
ix.voice.Register("combine", "READY WEAPONS", "Ready weapons!", "npc/combine_soldier/vo/readyweapons.wav")
ix.voice.Register("combine", "REAPER", "Reaper.", "npc/combine_soldier/vo/reaper.wav")
ix.voice.Register("combine", "REINFORCEMENT TEAMS", "Reinforcement-teams, code three!", "npc/metropolice/vo/reinforcementteamscode3.wav")
ix.voice.Register("combine", "REPORT CLEAR", "Reporting clear.", "npc/combine_soldier/vo/reportingclear.wav")
ix.voice.Register("combine", "REPORT IN", "CP requests all units, uhh... Location report-in.", "npc/metropolice/vo/cprequestsallunitsreportin.wav")
ix.voice.Register("combine", "REPORT LOCATION", "All units, report location suspect!", "npc/metropolice/vo/allunitsreportlocationsuspect.wav")
ix.voice.Register("combine", "REPORT STATUS", "Local CP-teams, report status.", "npc/metropolice/vo/localcptreportstatus.wav")
ix.voice.Register("combine", "REPURPOSED", "Repurposed area.", "npc/metropolice/vo/repurposedarea.wav")
ix.voice.Register("combine", "RESIDENTIAL BLOCK", "Residential block.", "npc/metropolice/vo/residentialblock.wav")
ix.voice.Register("combine", "RESPOND CODE 3", "All units at location, responding code three!", "npc/metropolice/vo/allunitsrespondcode3.wav")
ix.voice.Register("combine", "RESPONDING", "Responding.", "npc/metropolice/vo/responding2.wav")
ix.voice.Register("combine", "RESTRICT", "Restrict!", "npc/metropolice/vo/restrict.wav")
ix.voice.Register("combine", "RESTRICTED", "Restricted block.", "npc/metropolice/vo/restrictedblock.wav")
ix.voice.Register("combine", "RESTRICTION ZONE", "Terminal restriction-zone!", "npc/metropolice/vo/terminalrestrictionzone.wav")
ix.voice.Register("combine", "RIPCORD", "Ripcord!", "npc/combine_soldier/vo/ripcord.wav")
ix.voice.Register("combine", "RODGER THAT", "Rodger that!", "npc/metropolice/vo/rodgerthat.wav")
ix.voice.Register("combine", "ROLLER", "Roller!", "npc/metropolice/vo/roller.wav")
ix.voice.Register("combine", "RUNNING", "He's running!", "npc/metropolice/vo/hesrunning.wav")
ix.voice.Register("combine", "SACRIFICE CODE", "All units, sacrifice code one and maintain this CP!", "npc/metropolice/vo/sacrificecode1maintaincp.wav")
ix.voice.Register("combine", "SAVAGE", "Savage.", "npc/combine_soldier/vo/savage.wav")
ix.voice.Register("combine", "SCAR", "Scar.", "npc/combine_soldier/vo/scar.wav")
ix.voice.Register("combine", "SEARCH", "Search!", "npc/metropolice/vo/search.wav")
ix.voice.Register("combine", "SEARCHING FOR SUSPECT", "Searching for suspect.", "npc/metropolice/vo/searchingforsuspect.wav")
ix.voice.Register("combine", "SECOND WARNING", "This is your second warning!", "npc/metropolice/vo/thisisyoursecondwarning.wav")
ix.voice.Register("combine", "SECTOR NOT STERILE", "Confirmed- sector not sterile.", "npc/combine_soldier/vo/confirmsectornotsterile.wav")
ix.voice.Register("combine", "SECTOR NOT SECURE", "Sector is not secure.", "npc/combine_soldier/vo/sectorisnotsecure.wav")
ix.voice.Register("combine", "SECTOR", "Sector", "npc/combine_soldier/vo/sector.wav")
ix.voice.Register("combine", "SECURE ADVANCE", "Assault-point secured, advance!", "npc/metropolice/vo/assaultpointsecureadvance.wav")
ix.voice.Register("combine", "SECURE", "Secure.", "npc/combine_soldier/vo/secure.wav")
ix.voice.Register("combine", "SENTENCE", "Sentence delivered.", "npc/metropolice/vo/sentencedelivered.wav")
ix.voice.Register("combine", "SERVE", "Serve.", "npc/metropolice/vo/serve.wav")
ix.voice.Register("combine", "SHADOW", "Shadow.", "npc/combine_soldier/vo/shadow.wav")
ix.voice.Register("combine", "SHARPZONE", "Sharpzone.", "npc/combine_soldier/vo/sharpzone.wav")
ix.voice.Register("combine", "SHIT", "Shit!", "npc/metropolice/vo/shit.wav")
ix.voice.Register("combine", "SHOTS FIRED", "Shots fired, hostile malignants here!", "npc/metropolice/vo/shotsfiredhostilemalignants.wav")
ix.voice.Register("combine", "SLAM", "Slam.", "npc/combine_soldier/vo/slam.wav")
ix.voice.Register("combine", "SLASH", "Slash.", "npc/combine_soldier/vo/slash.wav")
ix.voice.Register("combine", "SOCIOCIDE", "Sociocide.", "npc/metropolice/vo/sociocide.wav")
ix.voice.Register("combine", "SOCIOSTABLE", "We are socio-stable at this location.", "npc/metropolice/vo/wearesociostablethislocation.wav")
ix.voice.Register("combine", "SPEAR", "Spear.", "npc/combine_soldier/vo/spear.wav")
ix.voice.Register("combine", "STAB", "Stab.", "npc/combine_soldier/vo/stab.wav")
ix.voice.Register("combine", "STANDING BY", "Standing by.", "npc/combine_soldier/vo/standingby].wav")
ix.voice.Register("combine", "STAR", "Star.", "npc/combine_soldier/vo/star.wav")
ix.voice.Register("combine", "STATIONBLOCK", "Stationblock.", "npc/metropolice/vo/stationblock.wav")
ix.voice.Register("combine", "STAY ALERT", "Stay alert.", "npc/combine_soldier/vo/stayalert.wav")
ix.voice.Register("combine", "STERILIZE", "Sterilize!", "npc/metropolice/vo/sterilize.wav")
ix.voice.Register("combine", "STINGER", "Stinger.", "npc/combine_soldier/vo/stinger.wav")
ix.voice.Register("combine", "STORM", "Storm.", "npc/combine_soldier/vo/storm.wav")
ix.voice.Register("combine", "STRIKE", "Striker.", "npc/combine_soldier/vo/striker.wav")
ix.voice.Register("combine", "SUBJECT 505", "Subject is 505!", "npc/metropolice/vo/subjectis505.wav")
ix.voice.Register("combine", "SUBJECT HIGH SPEED", "All units, be advised, subject is now high-speed!", "npc/metropolice/vo/subjectisnowhighspeed.wav")
ix.voice.Register("combine", "SUBJECT", "Subject!", "npc/metropolice/vo/subject.wav")
ix.voice.Register("combine", "SUNDOWN", "Sundown.", "npc/combine_soldier/vo/sundown.wav")
ix.voice.Register("combine", "SUSPECT INCURSION", "Disp reports suspect-incursion at location.", "npc/metropolice/vo/dispreportssuspectincursion.wav")
ix.voice.Register("combine", "SUSPECT MOVED TO", "Suspect has moved now to...", "npc/metropolice/vo/supsecthasnowmovedto.wav")
ix.voice.Register("combine", "SUSPECT RESTRICTED CANALS", "Suspect is using restricted canals at...", "npc/metropolice/vo/suspectusingrestrictedcanals.wav")
ix.voice.Register("combine", "SUSPEND", "Suspend!", "npc/metropolice/vo/suspend.wav")
ix.voice.Register("combine", "SWEEPER", "Sweeper.", "npc/combine_soldier/vo/sweeper.wav")
ix.voice.Register("combine", "SWEEPING IN", "Sweeping in!", "npc/combine_soldier/vo/sweepingin.wav")
ix.voice.Register("combine", "SWEEPING SUSPECT", "Sweeping for suspect!", "npc/metropolice/vo/sweepingforsuspect.wav")
ix.voice.Register("combine", "SWIFT", "Swift.", "npc/combine_soldier/vo/swift.wav")
ix.voice.Register("combine", "SWORD", "Sword.", "npc/combine_soldier/vo/sword.wav")
ix.voice.Register("combine", "TAG 10-91D", "Tag 10-91d!", "npc/metropolice/vo/tag10-91d.wav")
ix.voice.Register("combine", "TAG BUG", "Tag one bug!", "npc/metropolice/vo/tagonebug.wav")
ix.voice.Register("combine", "TAG NECROTIC", "Tag one necrotic!", "npc/metropolice/vo/tagonenecrotic.wav")
ix.voice.Register("combine", "TAG PARASITIC", "Tag one parasitic!", "npc/metropolice/vo/tagoneparasitic.wav")
ix.voice.Register("combine", "TAKE A LOOK", "Going to take a look!", "npc/metropolice/vo/goingtotakealook.wav")
ix.voice.Register("combine", "TAKE COVER", "Take cover!", "npc/metropolice/vo/takecover.wav")
ix.voice.Register("combine", "TAP", "Tap!", "npc/metropolice/vo/tap.wav")
ix.voice.Register("combine", "TARGET", "Target.", "npc/combine_soldier/vo/target.wav")
ix.voice.Register("combine", "TEAM ADVANCE", "Team in position, advance!.", "npc/metropolice/vo/teaminpositionadvance.wav")
ix.voice.Register("combine", "TEAM HOLDING", "Stabilization team holding in position.", "npc/combine_soldier/vo/stabilizationteamholding.wav")
ix.voice.Register("combine", "THERE HE GOES", "There he goes! He's at...", "npc/metropolice/vo/therehegoeshesat.wav")
ix.voice.Register("combine", "THERE HE IS", "There he is!", "npc/metropolice/vo/thereheis.wav")
ix.voice.Register("combine", "TRACKER", "Tracker.", "npc/combine_soldier/vo/tracker.wav")
ix.voice.Register("combine", "TRANSITBLOCK", "Transit-block.", "npc/metropolice/vo/transitblock.wav")
ix.voice.Register("combine", "TROUBLE", "Lookin' for trouble?", "npc/metropolice/vo/lookingfortrouble.wav")
ix.voice.Register("combine", "UNDER FIRE", "Officer under fire, taking cover!", "npc/metropolice/vo/officerunderfiretakingcover.wav")
ix.voice.Register("combine", "UNIFORM", "Uniform.", "npc/combine_soldier/vo/uniform.wav")
ix.voice.Register("combine", "UNION", "Union!", "npc/metropolice/vo/union.wav")
ix.voice.Register("combine", "UNKNOWN", "Suspect location unknown.", "npc/metropolice/vo/suspectlocationunknown.wav")
ix.voice.Register("combine", "UP THERE", "He's up there!", "npc/metropolice/vo/hesupthere.wav")
ix.voice.Register("combine", "UPI", "UPI.", "npc/metropolice/vo/upi.wav")
ix.voice.Register("combine", "UTL SUSPECT", "UTL that suspect.", "npc/metropolice/vo/utlthatsuspect.wav")
ix.voice.Register("combine", "UTL", "UTL suspect.", "npc/metropolice/vo/utlsuspect.wav")
ix.voice.Register("combine", "VACATE", "Vacate, citizen!", "npc/metropolice/vo/vacatecitizen.wav")
ix.voice.Register("combine", "VAMP", "Vamp.", "npc/combine_soldier/vo/vamp.wav")
ix.voice.Register("combine", "VERDICT", "You want a malcompliance verdict?", "npc/metropolice/vo/youwantamalcomplianceverdict.wav")
ix.voice.Register("combine", "VICE", "Vice!", "npc/metropolice/vo/vice.wav")
ix.voice.Register("combine", "VICTOR", "Victor!", "npc/metropolice/vo/victor.wav")
ix.voice.Register("combine", "VISCON", "Viscon.", "npc/combine_soldier/vo/viscon.wav")
ix.voice.Register("combine", "VISUAL EXOGEN", "Visual on exogen.", "npc/combine_soldier/vo/visualonexogen.wav")
ix.voice.Register("combine", "WARNING GIVEN", "Second warning given!", "npc/metropolice/vo/secondwarning.wav")
ix.voice.Register("combine", "WASTERIVER", "Wasteriver.", "npc/metropolice/vo/wasteriver.wav")
ix.voice.Register("combine", "WATCH IT", "Watch it!", "npc/metropolice/vo/watchit.wav")
ix.voice.Register("combine", "WINDER", "Winder.", "npc/combine_soldier/vo/winder.wav")
ix.voice.Register("combine", "WORKFORCE", "Workforce intake.", "npc/metropolice/vo/workforceintake.wav")
ix.voice.Register("combine", "WRAP IT UP", "That's it, wrap it up.", "npc/combine_soldier/vo/thatsitwrapitup.wav")
ix.voice.Register("combine", "XRAY", "XRay!", "npc/metropolice/vo/xray.wav")
ix.voice.Register("combine", "YEAH", "Yeah.", "npc/metropolice/mc1ans_yeah.wav")
ix.voice.Register("combine", "YELLOW", "Yellow!", "npc/metropolice/vo/yellow.wav")
ix.voice.Register("combine", "YOU CAN GO", "Alright, you can go.", "npc/metropolice/vo/allrightyoucango.wav")
ix.voice.Register("combine", "ZONE", "Zone!", "npc/metropolice/vo/zone.wav")
ix.voice.Register("combine", "DEGREES", "Degrees", "npc/combine_soldier/vo/degrees.wav")
ix.voice.Register("combine", "BEARING", "Bearing", "npc/combine_soldier/vo/bearing.wav")
ix.voice.Register("combine", "METERS", "Meters", "npc/combine_soldier/vo/meters.wav")
ix.voice.Register("combine", "FLARE DOWN", "Flare down!", "npc/combine_soldier/vo/flaredown.wav")
ix.voice.Register("combine", "TARGET BLACKOUT", "Target blackout, sweep to resume.", "npc/combine_soldier/vo/targetblackout.wav")
ix.voice.Register("combine", "OVERTWATCH REQUEST RESERVE ACTIVATION", "Overwatch request reserve activation.", "npc/combine_soldier/vo/overwatchrequestreserveactivation.wav")
ix.voice.Register("combine", "TARGET IS AT", "Target is at", "npc/combine_soldier/vo/targetisat.wav")
ix.voice.Register("combine", "BOUNCER", "Bouncer bouncer!", "npc/combine_soldier/vo/bouncerbouncer.wav")
ix.voice.Register("combine", "REQUEST MEDICAL", "Request medical.", "npc/combine_soldier/vo/requestmedical.wav")
ix.voice.Register("combine", "REQUEST STIM", "Request stim dose.", "npc/combine_soldier/vo/requeststimdose.wav")
ix.voice.Register("combine", "COME WITH ME", "You, citizen, come with me.", "vo/trainyard/ba_youcomewith.wav")
ix.voice.Register("combine", "GET IN", "Get in.", "vo/trainyard/ba_getin.wav")
ix.voice.Register("combine", "GO ACTIVE INTERCEPT", "Go active intercept.", "npc/combine_soldier/vo/goactiveintercept.wav")
ix.voice.Register("combine", "FULL ACTIVE", "Full active.", "npc/combine_soldier/vo/fullactive.wav")
ix.voice.Register("combine", "SIGHT LINES", "Stay alert report sightlines.", "npc/combine_soldier/vo/stayalertreportsightlines.wav")
ix.voice.Register("combine", "HEAVY RESISTANCE", "Overwatch, be advised, we have heavy resistance.", "npc/combine_soldier/vo/heavyresistance.wav")

ix.voice.Register("vort", "ACCOMPANY", "Gladly we accompany.", "vo/npc/vortigaunt/accompany.wav")
ix.voice.Register("vort", "AFFIRMED", "Affirmed.", "vo/npc/vortigaunt/affirmed.wav")
ix.voice.Register("vort", "ALL IN ONE", "All in one then one in all.", "vo/npc/vortigaunt/allinoneinall.wav")
ix.voice.Register("vort", "ALLOW ME", "Allow me.", "vo/npc/vortigaunt/allowme.wav")
ix.voice.Register("vort", "AS YOU WISH", "As you wish.", "vo/npc/vortigaunt/asyouwish.wav")
ix.voice.Register("vort", "BE OF SERVICE", "Can we be of service?", "vo/npc/vortigaunt/beofservice.wav")
ix.voice.Register("vort", "CAUTION", "Caution.", "vo/npc/vortigaunt/caution.wav")
ix.voice.Register("vort", "CERTAINLY", "Certainly.", "vo/npc/vortigaunt/certainly.wav")
ix.voice.Register("vort", "DONE", "Done.", "vo/npc/vortigaunt/done.wav")
ix.voice.Register("vort", "DREAMED", "We have dreamed of this moment.", "vo/npc/vortigaunt/dreamed.wav")
ix.voice.Register("vort", "EMPOWER US", "Empower us.", "vo/npc/vortigaunt/empowerus.wav")
ix.voice.Register("vort", "GLADLY", "Gladly.", "vo/npc/vortigaunt/gladly.wav")
ix.voice.Register("vort", "HALT", "Halt.", "vo/npc/vortigaunt/halt.wav")
ix.voice.Register("vort", "HERE", "Here.", "vo/npc/vortigaunt/here.wav")
ix.voice.Register("vort", "FEAR FAILED", "We fear we have failed.", "vo/npc/vortigaunt/fearfailed.wav")
ix.voice.Register("vort", "FREEMAN", "Freeman.", "vo/npc/vortigaunt/freeman.wav")
ix.voice.Register("vort", "GLADLY", "Gladly.", "vo/npc/vortigaunt/gladly.wav")
ix.voice.Register("vort", "AN HONOR", "It is an honor.", "vo/npc/vortigaunt/itishonor.wav")
ix.voice.Register("vort", "YES", "Yes.", "vo/npc/vortigaunt/yes.wav")
ix.voice.Register("vort", "TAKE US", "Freeman take us with you.", "vo/npc/vortigaunt/takeus.wav")
ix.voice.Register("vort", "FOR FREEDOM", "For freedom.", "vo/npc/vortigaunt/forfreedom.wav")
ix.voice.Register("vort", "WITH PLEASURE", "With pleasure.", "vo/npc/vortigaunt/pleasure.wav")
ix.voice.Register("vort", "GLORIOUS END", "To our glorious end.", "vo/npc/vortigaunt/gloriousend.wav")
ix.voice.Register("vort", "HOLD STILL", "Hold still.", "vo/npc/vortigaunt/holdstill.wav")
ix.voice.Register("vort", "LEAD US", "Lead us.", "vo/npc/vortigaunt/leadus.wav")
ix.voice.Register("vort", "HONOR FOLLOW", "To our honor we follow you.", "vo/npc/vortigaunt/honorfollow.wav")
ix.voice.Register("vort", "TO THE VOID", "To the void with you.", "vo/npc/vortigaunt/tothevoid.wav")
ix.voice.Register("vort", "VORT1", "Ahg lah.", "vo/npc/vortigaunt/vortigese02.wav")
ix.voice.Register("vort", "VORT2", "Targh.", "vo/npc/vortigaunt/vortigese03.wav")
ix.voice.Register("vort", "VORT3", "Langh.", "vo/npc/vortigaunt/vortigese05.wav")
ix.voice.Register("vort", "VORT4", "Gahn.", "vo/npc/vortigaunt/vortigese07.wav")
ix.voice.Register("vort", "VORT5", "Galanga.", "vo/npc/vortigaunt/vortigese08.wav")
ix.voice.Register("vort", "VORT6", "Galalangh.", "vo/npc/vortigaunt/vortigese09.wav")
ix.voice.Register("vort", "VORT7", "Cher ganlahn cher alagahn.", "vo/npc/vortigaunt/vortigese11.wav")
ix.voice.Register("vort", "VORT8", "Cher langh gahn chaleng gur.", "vo/npc/vortigaunt/vortigese12.wav")
ix.voice.Register("vort", "VORT9", "Ter langh gur chaleng chur langh lerr.", "vo/npc/vortigaunt/vortigese13.wav")


if ( CLIENT ) then
    concommand.Add("ix_printvcs", function(ply, cmd, args)
        if not ( args[1] ) then
            return print("Enter class as argument 1. (E.G. 'combine' or 'vort')")
        end

        if not ( ix.voice.list[args[1]] ) then
            return print("Class invalid.")
        end

        for k, v in pairs(ix.voice.list[args[1]]) do
            print(k:upper())
        end
    end)
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
