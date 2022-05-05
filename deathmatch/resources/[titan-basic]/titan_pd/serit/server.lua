
SERITLER = {}

function findEmptyID(plr)
	local i = 1
	if not SERITLER[plr] then
		SERITLER[plr] = {}
	end
	while (SERITLER[plr][i]) do
		i = i + 1
	end
	return i
end

SERIT_MODE = {}

function reloadPlayers()
	triggerClientEvent(root,"serit.loadSerits",root,SERITLER)
end

function sendToServer(id,data)
	if not SERITLER[source] then
		SERITLER[source] = {}
	end
	SERITLER[source][id] = data
	reloadPlayers()
end
addEvent("serit.sendToServer",true)
addEventHandler("serit.sendToServer",root,sendToServer)

function seritMode(plr)
	local fact = getElementData(plr,"faction") or 0
	if fact == 1 or fact == 23 then
		if SERIT_MODE[plr] then
			local eid = SERIT_MODE[plr]
			triggerClientEvent( plr, "serit.openSeritModeClient", plr, false, eid )
			outputChatBox("[-] #ffffffBaşarıyla şerit ekledin. ID: "..eid,plr,230, 30, 30,true)
			outputChatBox("[-] #ffffffSilmek için /seritsil [id].",plr,230, 30, 30,true)
			SERIT_MODE[plr] = false
			return
		end
		outputChatBox("[-] #ffffffŞerit çekme modu açıldı. Bitirmek için tekrardan /serit yaz.",plr,230, 30, 30,true)
		local eid = findEmptyID(plr)
		SERIT_MODE[plr] = eid
		triggerClientEvent( plr, "serit.openSeritModeClient", plr, true, eid )
	end
end
addCommandHandler("serit",seritMode,false,false)

function seritsil(plr,cmd,id)
	local fact = getElementData(plr,"faction") or 0
	if fact == 1 or fact == 23 then

	if SERITLER[plr] and tonumber(id) and SERITLER[plr][tonumber(id)] then
		SERITLER[plr][tonumber(id)] = nil
		reloadPlayers()
		outputChatBox("[-] #ffffffŞerit silindi.",plr,230, 30, 30,true)
	end
	end
end
addCommandHandler("seritsil",seritsil,false,false)

function quitPlayer ( quitType )
	if SERITLER[source] then
		SERITLER[source] = nil
	end
	reloadPlayers()
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )
