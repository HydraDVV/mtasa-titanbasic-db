IHBARNO = 1
local hotCallings = {}
local timers = {}

addCommandHandler("baglan",
	function(player, cmd, id)
		if getElementData(player, "loggedin") == 1 and getElementData(player, "faction") == 1 or getElementData(player, "faction") == 59 or getElementData(player, "faction") == 116 then
			local id = tonumber(id)
			if hotCallings[id] and hotCallings[id][2] == false then
				local targetElement = hotCallings[id][1]
				killTimer(hotCallings[id][3])
				for i, callingElement in ipairs({player, targetElement}) do
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6"..getPlayerName(player):gsub("_", " ").." [Telefon]: Nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
				end
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Operatöre başarıyla bağlandın konuşmak için /oi <mesaj>", player, 0, 125, 250, true)
				hotCallings[id][2] = player;
				setElementData(targetElement, "callprogress", 4)
				setElementData(player, "opID", id)
			end
		end
	end
)

addCommandHandler("oi",
	function(player, cmd, ...)
		if getElementData(player, "loggedin") == 1 and getElementData(player, "faction") == 1 or getElementData(player, "faction") == 59 or getElementData(player, "faction") == 116 then
			local message = table.concat({...}, " ")
			if message then
				local operatorID = tonumber(getElementData(player, "opID"))
				if hotCallings[operatorID] and hotCallings[operatorID][2] == player then
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6"..getPlayerName(player):gsub("_", " ").." [Telefon]: "..message, player, 0, 125, 250, true)
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6"..getPlayerName(player):gsub("_", " ").." [Telefon]: "..message, hotCallings[operatorID][1], 0, 125, 250, true)
				end
			end
		end
	end
)

addEvent("endPhoneOperator", true)
addEventHandler("endPhoneOperator", root,
	function(callingElement)
		local indexID = tonumber(getElementData(callingElement, "ihbarID"))
		if hotCallings[indexID] then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Bağlı olduğunuz kişi çağrıyı kapattı.", hotCallings[indexID][2], 0, 125, 250, true)
			
			setElementData(hotCallings[indexID][2], "opID", false)
			hotCallings[indexID] = nil;
		end
	end
)

function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
local callprogress = getElementData(callingElement, "callprogress")	
	if callingPhoneNumber == 155 then
		if startingCall then
			exports.titan_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Acil Servisler [Telefon]: Hangi servise bağlanmak istersiniz?", callingElement, 0, 125, 250, true)
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Örnekleme: /p Polis'e bağlanmak istiyorum.", callingElement, 0, 125, 250, true)
		else
			if (callprogress==4) then
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6"..getPlayerName(callingElement):gsub("_", " ").." [Telefon]: "..message, callingElement, 0, 125, 250, true)
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6"..getPlayerName(callingElement):gsub("_", " ").." [Telefon]: "..message, hotCallings[getElementData(callingElement, "ihbarID")][2], 0, 125, 250, true)
				--exports.titan_global:sendLocalText(targetOperator, getPlayerName(hotCallings[getElementData(callingElement, "ihbarID")][2]) .. " [Telefon]: " .. message, nil, nil, nil, 10, {[targetOperator] = true})
			elseif (callprogress==1) then
				callingID = #hotCallings + 1
				setElementData(callingElement, "ihbarID", callingID)
				hotCallings[callingID] = {callingElement, false}
				if string.find(message:lower(), "polis") or string.find(message:lower(), "ambulans") then
					for key, value in ipairs(getPlayersInTeam(getTeamFromName( "Los Santos Police Department"))) do
						if getElementData(value, "loggedin") == 1 and getElementData(value, "duty") > 0 then
							triggerClientEvent(value, "addNotify", value, "police", "Acil Arama", "Operatöre bağlanmak için /baglan "..callingID.." kullanın.")
							outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Operatöre bağlanmak için /baglan "..callingID.." kullanın.", value, 0, 125, 250, true)
						end
					end
				elseif string.find(message:lower(), "şerif") then
					for key, value in ipairs(getPlayersInTeam(getTeamFromName( "Los Santos County Sheriff Department"))) do
						if getElementData(value, "loggedin") == 1 and getElementData(value, "duty") > 0 then
							triggerClientEvent(value, "addNotify", value, "police", "Acil Arama", "Operatöre bağlanmak için /baglan "..callingID.." kullanın.")
							outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Operatöre bağlanmak için /baglan "..callingID.." kullanın.", value, 0, 125, 250, true)
						end
					end
				
				end
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Acil Servisler [Telefon]: Sizi ilgili operatöre bağlıyorum, lütfen bekleyin.", callingElement, 0, 125, 250, true)
				triggerClientEvent(callingElement, "playPhoneSound", callingElement, "dialing_tone")
				hotCallings[callingID][3] = setTimer(
					function(callingElement)
						outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Acil Servisler [Telefon]: Aktif operatör bulunmadığı için size ben yardım edeceğim, konumunuzu yazar mısınız?.", callingElement, 0, 125, 250, true)
						exports.titan_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
						hotCallings[callingID] = nil;
						timers[callingID] = nil;
					end,
				7500, 1, callingElement)
			elseif (callprogress==2) then
				setElementData(callingElement, "call.location", message)
				exports.titan_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 3, false)
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6Acil Servisler [Telefon]: Ne sorun yaşıyorsunuz?", callingElement, 0, 125, 250, true)
			elseif (callprogress==3) then
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #90a3b6LSPD Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					for _, itemRow in ipairs(exports['titan_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end



				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Police Department")) or getPlayersInTeam(getTeamFromName("San Andreas Highway Patrol"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'. İhbar No: ".. IHBARNO, player, 0, 125, 255)
				end
				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos County Sheriff's Department")) ) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'. İhbar No: ".. IHBARNO, player, 0, 125, 255)
				end
				IHBARNO = IHBARNO + 1
				triggerEvent("phone:cancelPhoneCall", callingElement)
				--triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 8294 then
		if startingCall then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #f1c40fYellow Cab Company [Telefon]: Yellow Cab Company, nasıl yardımcı olabiliriz?", callingElement, 243, 156, 18, true)
			exports.titan_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.titan_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.titan_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #f1c40fYellow Cab Company [Telefon]: Konumunuzu belirtir misiniz?", callingElement, 243, 156, 18, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..": #f1c40fYellow Cab Company [Telefon]: Aradığınız için teşekkürler, bir taksi yönlendiriyoruz.", callingElement, 243, 156, 18, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for _, player in ipairs(getElementsByType("player")) do
					if tonumber(getElementData(player, "job")) == 2 then
						outputChatBox("[TAXI] Arayan kişinin numarası #e6a902'" .. outboundPhoneNumber .. "'#fbc531 taksi talep ediyor.", player, 251, 197, 49, true)
						outputChatBox("[TAXI] Açıklama: #e6a902'" .. message .. "'.", player, 251, 197, 49, true)
						outputChatBox("[TAXI] Lokasyon: #e6a902'" .. tostring(location) .. "'.", player, 251, 197, 49, true)
					end
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
				--triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	end
end

function log911( message )
	local logMeBuffer = getElementData(getRootElement(), "911log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "911log", logMeBuffer)
end

function read911Log(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factiontype = getElementData(theTeam, "type")
	if exports.titan_ed_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_ed_integration:isPlayerSupporter(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "911log") or { }
		outputChatBox("Recent 911 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show911", read911Log)

function checkService(callingElement)
	t = { "both",
		  "pd",
		  "police",
		  "lspd",
		  "sahp",
		  "sasd", -- PD ends here
		  "es",
		  "medic",
		  "ems",
		  "lsfd",
	}
	local found = false
	for row, names in ipairs(t) do
		if names == string.lower(getElementData(callingElement, "call.service")) then
			if row == 1 then
				local found = true
				return 1 -- Both!
			elseif row >= 2 and row <= 6 then
				local found = true
				return 2 -- Just the PD please
			elseif row >= 7 and row <= 10 then
				local found = true
				return 3 -- ES
			end
		end
	end
	if not found then
		return 4 -- Not found!
	end
end
