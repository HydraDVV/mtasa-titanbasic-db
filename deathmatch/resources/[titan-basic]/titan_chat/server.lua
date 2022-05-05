mysql = exports.titan_mysql

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or getElementData(p, "name") or gpn(p)
	return string.gsub(name, "_", " ")
end

function trunklateText(thePlayer, text, factor)
	return (tostring(text):gsub("^%l", string.upper))
end

function getElementDistance( a, b )
	if not isElement(a) or not isElement(b) or getElementDimension(a) ~= getElementDimension(b) then
		return math.huge
	else
		local x, y, z = getElementPosition( a )
		return getDistanceBetweenPoints3D( x, y, z, getElementPosition( b ) )
	end
end

function icChatsToVoice(audience, msg, from) -- Hanz
	if getElementData(audience, "text2speech_ic_chats") ~= "0" then 
	end
end

function tryChance(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 ~= nil then 
		if pa2 == nil and p1 ~= nil then
			if p1 <= 100 and p1 >=0 then
				if math.random(100) >= p1 then
					exports.titan_global:sendLocalText(thePlayer, "((OOC Şans - %"..p1..")) "..getPlayerName(thePlayer):gsub("_", " ").." isimli kişinin denemesi başarısız oldu.", 255, 51, 102, 30, {}, true)
				else
					exports.titan_global:sendLocalText(thePlayer, "((OOC Şans - %"..p1..")) "..getPlayerName(thePlayer):gsub("_", " ").." isimli kişinin denemesi başarılı oldu.", 255, 51, 102, 30, {}, true)
				end
			else
				outputChatBox("İhtimaller 0 ile 100% arasında olmalıdır.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName.." [0-100%] ihtimalle başarabilme şansınız", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName.." [0-100%] ihtimalle başarabilme şansınız", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("chance", tryChance)
addCommandHandler("sans2", tryChance)

function oocCoin(thePlayer)
	if getElementData(thePlayer, "money") > 0 then
		if  math.random( 1, 2 ) == 2 then
			exports.titan_global:sendLocalText(thePlayer, " ((OOC Yazı Tura)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " bir madeni para fırlatır, para yazıdır.", 255, 51, 102)
		else
			exports.titan_global:sendLocalText(thePlayer, " ((OOC Yazı Tura)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " bir madeni para fırlatır, para turadır.", 255, 51, 102)
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bozuk paran olmadığı için yazı tura atamazsın.", 255, 30, 30, true)
	end
end
addCommandHandler("flipcoin", oocCoin)
addCommandHandler("yazitura", oocCoin)

-- Main chat: Local IC, Me Actions & Faction IC Radio
function localIC(source, message, language, element)
	if exports['titan_freecam']:isPlayerFreecamEnabled(source) then return end
	local affectedElements = { }
	table.insert(affectedElements, source)
	local x, y, z = getElementPosition(source)
	local playerName = getPlayerName(source)

	message = string.gsub(message, "#%x%x%x%x%x%x", "") -- Remove colour codes
	message = trunklateText( source, message )

	
	-- google:translate:api:@Hanz --triggerClientEvent("client_textToSpeech", source, message)

	local languagename = call(getResourceFromName("titan_languages"), "getLanguageName", language)

	local color = {0xEE,0xEE,0xEE}

	local focus = getElementData(source, "focus")
	local focusColor = false
	if type(focus) == "table" then
		for player, color2 in pairs(focus) do
			if player == source then
				color = color2
			end
		end
	end
	

	-- @Hanz
	if message == ":)" then
		exports.titan_global:sendLocalMeAction(source, "gülümser.")
		return
	elseif message == ":D" then
		exports.titan_global:sendLocalMeAction(source, "kahkaha atar.")
		return
	elseif message == ";)" then
		exports.titan_global:sendLocalMeAction(source, "göz kırpar.")
		return
	elseif message == "O.o" then
		exports.titan_global:sendLocalMeAction(source, "sol kaşını havaya kaldırır.")
		return
	elseif message == "O.O" then
		exports.titan_global:sendLocalMeAction(source, "sağ kaşını havaya kaldırır.")
		return
	elseif message == "X.x" then
		exports.titan_global:sendLocalMeAction(source, "gözlerini kapatır.")
	elseif string.find(message, "selamın") or string.find(message, "aleyküm") or string.find(message, "eyvallah") or string.find(message, "Selamın") or string.find(message, "Aleyküm") or string.find(message, "Eyvallah") or string.find(message, "Selamun") or string.find(message, "selamun") or string.find(message, "Allah") or string.find(message, "allah") or message=="lan" or message=="Lan" then
		outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9 Sunucuda Türkçe terim kullanmak yasak dostum.", source, 255, 0, 0, true)
		return
	end
	-- End of Smiling Emotes
	
	local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
	
	local playerVehicle = getPedOccupiedVehicle(source)
	if playerVehicle then
		if (exports['titan_vehicle']:isVehicleWindowUp(playerVehicle)) then
			table.insert(affectedElements, playerVehicle)
			outputChatBox( " ["..realTime.."] " .. playerName .. " ((Araçta)) konuşuyor: " .. message, source, unpack(color))
		else
			outputChatBox("  ["..realTime.."] " .. playerName .. " konuşuyor: " .. message, source, unpack(color))
		end
		icChatsToVoice(source, message, source)
	else
		--setPedAnimation(source, "GANGS", "prtial_gngtlkA", 1, false, true, true)
		if getElementData(source, "talk_anim") == "1" then
			exports.titan_global:applyAnimation(source, "GANGS", "prtial_gngtlkA", 1, false, true, false)
		end
		outputChatBox( " ["..realTime.."] " .. playerName .. " konuşuyor: " .. message, source, unpack(color))
		icChatsToVoice(source, message, source)
	end

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)

	if dimension ~= 0 then
		table.insert(affectedElements, "in"..tostring(dimension))
	end

	-- Chat Commands tooltip
	--[[
	if(getResourceFromName("titan_tooltips"))then
		triggerClientEvent(source,"tooltips:showHelp", source,17)
	end
--]]

	for key, nearbyPlayer in ipairs(getElementsByType( "player" )) do
		local dist = getElementDistance( source, nearbyPlayer )

		if dist < 20 then
			local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
			local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

			if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
				local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
				if not (isPedDead(nearbyPlayer)) and (logged==1) and (nearbyPlayer~=source) then
					local message2 = call(getResourceFromName("titan_languages"), "applyLanguage", source, nearbyPlayer, message, language)
					message2 = trunklateText( nearbyPlayer, message2 )

					local pveh = getPedOccupiedVehicle(source)
					local nbpveh = getPedOccupiedVehicle(nearbyPlayer)
					local color = {0xEE,0xEE,0xEE}

					local focus = getElementData(nearbyPlayer, "focus")
					local focusColor = false
					if type(focus) == "table" then
						for player, color2 in pairs(focus) do
							if player == source then
								focusColor = true
								color = color2
							end
						end
					end

					if pveh then
						if (exports['titan_vehicle']:isVehicleWindowUp(pveh)) then
							for i = 0, getVehicleMaxPassengers(pveh) do
								local lp = getVehicleOccupant(pveh, i)

								if (lp) and (lp~=source) then
									outputChatBox(" ["..realTime.."] " .. playerName .. " ((araç)): ".. message2, lp, unpack(color))
									table.insert(affectedElements, lp)
									icChatsToVoice(lp, message2, source)
								end
							end
							table.insert(affectedElements, pveh)
							exports.titan_logs:dbLog(source, 7, affectedElements, languagename..": INCAR ".. message)
							exports['titan_freecam']:add(affectedElements)
							return
						end
					end

					if nbpveh and exports['titan_vehicle']:isVehicleWindowUp(nbpveh) == true then

					else
						if not focusColor then
							if dist < 4 then
							elseif dist < 8 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 12 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 16 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						outputChatBox(" ["..realTime.."] " .. playerName .. " : " ..  message2, nearbyPlayer, unpack(color))
						table.insert(affectedElements, nearbyPlayer)
						icChatsToVoice(nearbyPlayer, message2, source)
					end
				end
			end
		end
	end
	exports.titan_logs:dbLog(source, 7, affectedElements, languagename..": ".. message)
	exports['titan_freecam']:add(affectedElements)
end

for i = 1, 3 do
	addCommandHandler( tostring( i ),
		function( thePlayer, commandName, ... )
			local lang = tonumber( getElementData( thePlayer, "languages.lang" .. i ) )
			if lang ~= 0 then
				localIC( thePlayer, table.concat({...}, " "), lang )
			end
		end
	)
end

function meEmote(source, cmd, ...)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local message = table.concat({...}, " ")
		if not (...) then
			outputChatBox("KULLANIM: /me [Uygulama]", source, 255, 194, 14)
		else
			local result, affectedPlayers = exports.titan_global:sendLocalMeAction(source, message, true, true)
			exports.titan_logs:dbLog(source, 12, affectedPlayers, message)
			triggerClientEvent(root,"addChatBubblee",source,message)
		end
	end
end
addCommandHandler("ME", meEmote, false, true)
addCommandHandler("Me", meEmote, false, true)



function outputChatBoxCar( vehicle, target, text1, text2, color )
	if vehicle and exports['titan_vehicle']:isVehicleWindowUp( vehicle ) then
		if getPedOccupiedVehicle( target ) == vehicle then
			outputChatBox( text1 .. " ((araç))" .. text2, target, unpack(color))
			return true
		else
			return false
		end
	end
	outputChatBox( text1 .. text2, target, unpack(color))
	return true
end

function radio(source, radioID, message)
	local restrained = getElementData(source, "restrain")
	local death = getElementData(source, "dead")

	if restrained == 1 or death == 1 then 
		exports["titan_infobox"]:addBox(source, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
	return end
	local customSound = false
	local affectedElements = { }
	local indirectlyAffectedElements = { }
	table.insert(affectedElements, source)
	radioID = tonumber(radioID) or 1
	local hasRadio, itemKey, itemValue, itemID = exports.titan_global:hasItem(source, 6)
	if hasRadio or getElementType(source) == "ped" or radioID == -2 then
		local theChannel = itemValue
		if radioID < 0 then
			theChannel = radioID
		elseif radioID == 1 and exports.titan_integration:isPlayerTrialAdmin(source) and tonumber(message) and tonumber(message) >= 1 and tonumber(message) <= 10 then
			return
		elseif radioID ~= 1 then
			local count = 0
			local items = exports['titan_items']:getItems(source)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == radioID then
						theChannel = v[2]
						break
					end
				end
			end
		end

		local isRestricted, factionID = isThisFreqRestricted(theChannel)
		local playerFaction = getElementData(source, "faction")
		
		if theChannel == 1 or theChannel == 0 then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Radyo kanalını değiştirmek için lütfen telsize tıkla envanterinden.", source, 255, 194, 14)
		elseif isRestricted and tonumber(playerFaction) ~= tonumber(factionID) then
			outputChatBox("You are not allowed to access this channel. Please retune your radio.", source, 255, 194, 14)
		elseif theChannel > 1 or radioID < 0 then
			--triggerClientEvent (source, "playRadioSound", getRootElement())
			local username = getPlayerName(source)
			local languageslot = getElementData(source, "languages.current")
			local language = getElementData(source, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("titan_languages"), "getLanguageName", language)
			local channelName = "#" .. theChannel

			message = trunklateText( source, message )
			local r, g, b = 0, 102, 255
			local focus = getElementData(source, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == source then
						r, g, b = unpack(color)
					end
				end
			end

			if radioID == -1 then
				local teams = {
					getTeamFromName("Los Santos Police Department"),
					getTeamFromName("Los Santos Medical Department"),
					getTeamFromName("Los Santos Government"),
				}

				for _, faction in ipairs(teams) do
					if faction and isElement(faction) then
						for key, value in ipairs(getPlayersInTeam(faction)) do
							for _, itemRow in ipairs(exports['titan_items']:getItems(value)) do
								--outputDebugString(tostring(itemRow[1]).." - "..tostring(itemRow[2]))
								if tonumber(itemRow[1]) and tonumber(itemRow[2]) and tonumber(itemRow[1]) == 6 and tonumber(itemRow[2]) > 0 then
									table.insert(affectedElements, value)
									break
								end
							end
						end
					end
				end

				channelName = "DEPARTMENT"
			elseif radioID == -2 then
				local a = {}

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "paraVer" ) ) ) do
					if not a[value] then
						for _, itemRow in ipairs(exports['titan_items']:getItems(value)) do
							if (itemRow[1] == 6 and itemRow[2] > 0) then
								table.insert(affectedElements, value)
								break
							end
						end
					end
				end

				channelName = "AIR"
			elseif radioID == -3 then --PA (speakers) in vehicles and interiors // Exciter
				local outputDim = getElementDimension(source)
				local vehicle
				if isPedInVehicle(source) then
					vehicle = getPedOccupiedVehicle(source)
					outputDim = tonumber(getElementData(vehicle, "dbid")) + 20000
				end
				if(outputDim > 0) then
					local canUsePA = false
					if(outputDim > 20000) then --vehicle interior
						local dbid = outputDim - 20000
						if not vehicle then
							for k,v in ipairs(exports.titan_pool:getPoolElementsByType("vehicle")) do
								if getElementData( v, "dbid" ) == dbid then
									vehicle = v
									break
								end
							end
						end
						if vehicle then
							canUsePA = getElementData(source, "adminduty") == 1 or exports.titan_global:hasItem(source, 3, tonumber(dbid)) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(vehicle, "faction"))
						end
					else
						canUsePA = getElementData(source, "adminduty") == 1 or exports.titan_global:hasItem(source, 4, outputDim) or exports.titan_global:hasItem(source, 5,outputDim)
					end
					--outputDebugString("canUsePA="..tostring(canUsePA))
					if not canUsePA then
						return false
					end

					local outputInt = getElementInterior(source)
					for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
						if(getElementDimension(value) == outputDim) then
							if(getElementInterior(value) == outputInt or vehicle) then
								table.insert(affectedElements, value)
							end
						end
					end
					if vehicle then
						for i = 0, getVehicleMaxPassengers( vehicle ) do
							local player = getVehicleOccupant( vehicle, i )
							if player then
								table.insert(affectedElements, player)
							end
						end
					end
					r, g, b = 0,149,255
					channelName = "SPEAKERS"
					customSound = "pa.mp3"
				else
					return false
				end
			elseif radioID == -4 then --PA (speakers) at airports // Exciter
				local x,y,z = getElementPosition(source)
				local zonename = getZoneName(x,y,z,false)
				local outputDim = getElementDimension(source)
				local allowedFactions = {
					47, --FAA
				}
				local allowedAirports = {
					["Easter Bay Airport"]=true,
					["Los Santos International"]=true,
					["Las Venturas Airport"]=true
				}
				allowedAirportDimensions = {
					[1317]=true, --LSA terminal
					[2337]=true, --LSA deaprture hall
					[2340]=true, --LSA terminal 2
				}
				airportDimensionsSF = {}
				airportDimensionsLS = {
					[1317]=true, --terminal
					[2337]=true, --deaprture hall
					[2340]=true, --terminal 2
				}
				airportDimensionsLV = {}
				local airportDimensions = {}
				local targetAirport = zonename
				if(zonename == "Easter Bay Airport" or airportDimensionsSF[outputDim]) then
					airportDimensions = airportDimensionsSF
				elseif(zonename == "Los Santos International" or airportDimensionsLS[outputDim]) then
					airportDimensions = airportDimensionsLS
				elseif(zonename == "Las Venturas Airport" or airportDimensionsLV[outputDim]) then
					airportDimensions = airportDimensionsLV
				end

				local inAllowedFaction = false
				for k,v in ipairs(allowedFactions) do
					if exports.titan_factions:isPlayerInFaction(source, v) then
						inAllowedFaction = true
					end
				end

				if(inAllowedFaction) then
					if(allowedAirportDimensions[outputDim] or outputDim == 0 and allowedAirports[zonename]) then
						for key, value in ipairs(getElementsByType("player")) do
							x,y,z = getElementPosition(value)
							zonename = getZoneName(x,y,z,false)
							local dim = getElementDimension(value)
							if(airportDimensions[dim] or dim == 0 and zonename == targetAirport) then
								table.insert(affectedElements, value)
							end
						end
						r, g, b = 0,149,255
						channelName = "AIRPORT SPEAKERS"
						customSound = "pa.mp3"
					else
						return false
					end
				else
					return false
				end
			else
				for key, value in ipairs(getElementsByType( "player" )) do
					if exports.titan_global:hasItem(value, 6, theChannel) then
						local isRestricted, factionID = isThisFreqRestricted(theChannel)
						local playerFaction = getElementData(value, "faction")
						if (isRestricted and tonumber(playerFaction) == tonumber(factionID)) or not isRestricted then
							table.insert(affectedElements, value)
						end
					end
				end
			end
				local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")

			if channelName == "DEPARTMENT" then
			outputChatBoxCar(getPedOccupiedVehicle( source ), source, "["..realTime.."] [" .. channelName .. "] " .. username, " konuşuyor: " .. message, {r,162,b})
			else
			outputChatBoxCar(getPedOccupiedVehicle( source ), source, "["..realTime.."] [" .. channelName .. "] " .. username, " konuşuyor: " .. message, {r,g,b})
			end

			for i = #affectedElements, 1, -1 do
				if getElementData(affectedElements[i], "loggedin") ~= 1 then
					table.remove( affectedElements, i )
				end
			end

			for key, value in ipairs(affectedElements) do
				if customSound then
					triggerClientEvent(value, "playCustomChatSound", getRootElement(), customSound)
				else
					triggerClientEvent (value, "playRadioSound", getRootElement())
				end
				if value ~= source then
					local message2 = call(getResourceFromName("titan_languages"), "applyLanguage", source, value, message, language)
					local r, g, b = 0, 102, 255
					local focus = getElementData(value, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == source then
								r, g, b = unpack(color)
							end
						end
					end
					if channelName == "DEPARTMENT" then
					outputChatBoxCar( getPedOccupiedVehicle( value ), value, "["..realTime.."] [" .. channelName .. "] " .. username, " konuşuyor: " .. trunklateText( value, message2 ), {r,162,b} )
					else
					outputChatBoxCar( getPedOccupiedVehicle( value ), value, "["..realTime.."] [" .. channelName .. "] " .. username, " konuşuyor: " .. trunklateText( value, message2 ), {r,g,b} )
					end

					--if not exports.titan_global:hasItem(value, 88) == false then  ***Earpiece Fix***
					if exports.titan_global:hasItem(value, 88) == false then
						-- Show it to people near who can hear his radio
						for k, v in ipairs(exports.titan_global:getNearbyElements(value, "player",7)) do
							local logged2 = getElementData(v, "loggedin")
							if (logged2==1) then
								local found = false
								for kx, vx in ipairs(affectedElements) do
									if v == vx then
										found = true
										break
									end
								end

								if not found then
									local message2 = call(getResourceFromName("titan_languages"), "applyLanguage", source, v, message, language)
									local text1 = "["..realTime.."] " .. getPlayerName(value) .. " telsiz konuşması"
									local text2 = ": " .. trunklateText( v, message2 )

									if outputChatBoxCar( getPedOccupiedVehicle( value ), v, text1, text2, {255, 255, 255} ) then
										table.insert(indirectlyAffectedElements, v)
									end
								end
							end
						end
					end
				end
			end
			--
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDistance(source, value) < 10 then
					if (value~=source) then
						local message2 = call(getResourceFromName("titan_languages"), "applyLanguage", source, value, message, language)
						local text1 = "["..realTime.."] " .. getPlayerName(source) .. " [TELSİZ KONUŞMASI]"
						local text2 = " konuşuyor: " .. trunklateText( value, message2 )

						if outputChatBoxCar( getPedOccupiedVehicle( source ), value, text1, text2, {255, 255, 255} ) then
							table.insert(indirectlyAffectedElements, value)
						end
					end
				end
			end

			if #indirectlyAffectedElements > 0 then
				table.insert(affectedElements, "Indirectly Affected:")
				for k, v in ipairs(indirectlyAffectedElements) do
					table.insert(affectedElements, v)
				end
			end
			exports.titan_logs:dbLog(source, radioID < 0 and 10 or 9, affectedElements, ( radioID < 0 and "" or ( theChannel .. " " ) ) ..languagename.." "..message)
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Radyonuz kapalı.", source, 255, 0, 0)
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Radyonuz bulunmamaktadır.", source, 255, 0, 0)
	end
end


function CevreIC(thePlayer, cmd, ...)
	if not exports.titan_integration:isPlayerLeadAdmin( thePlayer) then
		return
	end
	if not (...) then
		outputChatBox("SÖZDİZİMİ: /" .. cmd .. " [Mesaj]", thePlayer)
		return
	end
	local mesaj = table.concat({ ... }, " ")
	outputChatBox("#FFFFFF[#99FF00ÇEVRE#ffffff] : " .. mesaj .. " " , getRootElement(), 196, 255, 255, true)
end
addCommandHandler("cevre", CevreIC)

function chatMain(message, messageType)
	if exports['titan_freecam']:isPlayerFreecamEnabled(source) then cancelEvent() return end

	local logged = getElementData(source, "loggedin")

	if (messageType == 1 or not (isPedDead(source))) and (logged==1) and not (messageType==2) then -- Player cannot chat while dead or not logged in, unless its OOC
	if getElementData(source, "bantli") then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bantlıyken konuşamazsınız.", source, 255, 0, 0, true) return end 
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)
		if (messageType==0) then
			local languageslot = getElementData(source, "languages.current")
			local language = getElementData(source, "languages.lang" .. languageslot)
			localIC(source, message, language)
			--triggerClientEvent(root,"addChatBubble",source,message)
		elseif (messageType==1) then -- Local /me action
			meEmote(source, "me", message)
		end
	elseif (messageType==2) and (logged==1) then -- Radio
		radio(source, 1, message)
	end
end
addEventHandler("onPlayerChat", getRootElement(), chatMain)

function msgRadio(thePlayer, commandName, ...)
	
	local restrained = getElementData(thePlayer, "restrain")
	local death = getElementData(thePlayer, "dead")

	if restrained == 1 or death == 1 then 
		exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
	return end

	if (...) then
		local message = table.concat({...}, " ")
		radio(thePlayer, 1, message)
	else
		outputChatBox("Kullanım:#f9f9f9 /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14, true)
	end
end
addCommandHandler("r", msgRadio, false, false)
addCommandHandler("radio", msgRadio, false, false)

for i = 1, 20 do
	addCommandHandler( "r" .. tostring( i ),
		function( thePlayer, commandName, ... )
			if i <= exports['titan_items']:countItems(thePlayer, 6) then
	local restrained = getElementData(thePlayer, "restrain")
	local death = getElementData(thePlayer, "dead")

	if restrained == 1 or death == 1 then 
		exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
	return end
				if (...) then
					radio( thePlayer, i, table.concat({...}, " ") )
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
				end
			end
		end
	)
end

function govAnnouncement(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)

	if (theTeam) then
		local teamID = tonumber(getElementData(theTeam, "id"))

		if (teamID==1 or teamID==2 or teamID==3 or teamID==23) then
			local message = table.concat({...}, " ")
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionLeader = getElementData(thePlayer,"factionleader")

			if #message == 0 then
				outputChatBox("KULLANIM: /" .. commandName .. " [message]", thePlayer, 255, 194, 14)
				return false
			end

			if factionLeader>0 then
				local ranks = getElementData(theTeam,"ranks")
				local factionRankTitle = ranks[factionRank]

				--exports.titan_logs:logMessage("[IC: Government Message] " .. factionRankTitle .. " " .. getPlayerName(thePlayer) .. ": " .. message, 6)
				exports.titan_logs:dbLog(source, 16, source, message)
				for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
					local logged = getElementData(value, "loggedin")

					if (logged==1) then
						outputChatBox("Government Duyurusu " .. factionRankTitle .. " " .. getPlayerName(thePlayer), value, 0, 183, 239)
						outputChatBox(">> #f9f9f9"..message, value, 0, 183, 239, true)
					end
				end
			else
				outputChatBox("You do not have permission to use this command.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gov", govAnnouncement)


function departmentradio(thePlayer, commandName, ...)
	local theTeam = getElementType(thePlayer) == "player" and getPlayerTeam(thePlayer)
	local tollped = getElementType(thePlayer) == "ped" and getElementData(thePlayer, "toll:key")
	if (theTeam)  or (tollped) then
		local teamID = nil
		if not tollped then
			teamID = tonumber(getElementData(theTeam, "id"))
		end

		if (teamID==1 or teamID==2 or teamID==3 or teamID==4 or teamID==23 or tollped) then --47=FAA 64=SAPT
			if (...) then
				local message = table.concat({...}, " ")
				radio(thePlayer, -1, message)
			elseif not tollped then
				outputChatBox("KULLANIM: /" .. commandName .. " [İçerik]", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("dep", departmentradio, false, false)
addCommandHandler("department", departmentradio, false, false)

 --PA (speakers) in vehicles and interiors // Exciter
function ICpublicAnnouncement(thePlayer, commandName, ...)
	if not ... then
		outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
	else
		radio(thePlayer, -3, table.concat({...}, " "))
	end
end
addCommandHandler("pa", ICpublicAnnouncement, false, false)

 --PA (speakers) at airports // Exciter
function ICAirportAnnouncement(thePlayer, commandName, ...)
	if not ... then
		outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
	else
		radio(thePlayer, -4, table.concat({...}, " "))
	end
end
addCommandHandler("airportpa", ICAirportAnnouncement, false, false)

function blockChatMessage()
	cancelEvent()
end
addEventHandler("onPlayerChat", getRootElement(), blockChatMessage)
-- End of Main Chat


function globalOOC(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local oocEnabled = exports.titan_global:getOOCState()
			message = table.concat({...}, " ")
			local muted = getElementData(thePlayer, "muted")
			if (oocEnabled==0) and not exports.titan_integration:isPlayerTrialAdmin(thePlayer) and not exports.titan_integration:isPlayerScripter(thePlayer) then
				outputChatBox("OOC Chat is currently disabled.", thePlayer, 255, 0, 0)
			elseif (muted==1) then
				outputChatBox("You are currently muted from the OOC Chat.", thePlayer, 255, 0, 0)
			else
				local affectedElements = { }
				local players = exports.titan_pool:getPoolElementsByType("player")
				local playerName = getPlayerName(thePlayer)
				local playerID = getElementData(thePlayer, "playerid")

				--exports.titan_logs:logMessage("[OOC: Global Chat] " .. playerName .. ": " .. message, 1)
				for k, arrayPlayer in ipairs(players) do
					local logged = tonumber(getElementData(arrayPlayer, "loggedin"))
					local targetOOCEnabled = getElementData(arrayPlayer, "globalooc")

					if (logged==1) and (targetOOCEnabled==1) then
						table.insert(affectedElements, arrayPlayer)
						if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
                            local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
							if getElementData(thePlayer, "hiddenadmin") then
								exports["titan_infobox"]:addBox(arrayPlayer, "mod", exports.titan_global:getPlayerFullIdentity(thePlayer)..": "..message)
								--outputChatBox("(( "..exports.titan_global:getPlayerFullIdentity(thePlayer)..": " .. message .. " ))", arrayPlayer, 196, 255, 255)
							else
								exports["titan_infobox"]:addBox(arrayPlayer, "mod", exports.titan_global:getPlayerFullIdentity(thePlayer)..": "..message)
							end
                        else
								exports["titan_infobox"]:addBox(arrayPlayer, "mod", exports.titan_global:getPlayerFullIdentity(thePlayer)..": "..message)
                       end
					end
				end
				exports.titan_logs:dbLog(thePlayer, 18, affectedElements, message)
			end
		end
	end
end
addCommandHandler("ooc", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)


function playerToggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local playerOOCEnabled = getElementData(thePlayer, "globalooc")

		if (playerOOCEnabled==1) then
			outputChatBox("Artık Global OOC Sohbetini gizlediniz.", thePlayer, 255, 194, 14)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "globalooc", 0, false)
		else
			outputChatBox("Global OOC Chat'i şimdi etkinleştirdiniz.", thePlayer, 255, 194, 14)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "globalooc", 1, false)
		end
		dbExec(mysql:getConnection(),"UPDATE accounts SET globalooc=" .. (getElementData(thePlayer, "globalooc")) .. " WHERE id = " .. (getElementData(thePlayer, "account:id")))
	end
end
addCommandHandler("toggleooc", playerToggleOOC, false, false)

local advertisementMessages = { "samp", "SA-MP", "Kye", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "www.", ".com", "co.cc", ".net", ".co.uk", "roleplay", "sunucu", "www.everlastgaming.com", "Arya", "Safari", "mtarp", "mta:rp", "mta-rp"}

function isFriendOf(thePlayer, targetPlayer)
	return exports['titan_social']:isFriendOf( getElementData( thePlayer, "account:id"), getElementData( targetPlayer, "account:id" ))
end

function scripterChat(thePlayer, commandName, ...)
    local logged = getElementData(thePlayer, "loggedin")

    if(logged==1) and (exports.titan_integration:isPlayerScripter(thePlayer))  then
        if not (...) then
            outputChatBox("KULLANIM: /ss [Message]", thePlayer, 255, 194, 14)
        else
            local message = table.concat({...}, " ")
            local players = exports.titan_pool:getPoolElementsByType("player")
            local username = getElementData(thePlayer,"account:username")

            for k, arrayPlayer in ipairs(players) do
                local logged = getElementData(arrayPlayer, "loggedin")

                if(exports.titan_integration:isPlayerScripter(arrayPlayer)) and (logged==1) then
                    outputChatBox("[Scripter] ("..getElementData(thePlayer, "playerid")..") " .. username .. " : " .. message, arrayPlayer, 222, 222, 31)
                end
            end
        end
    end
end
addCommandHandler("ss", scripterChat, false, false)
addCommandHandler("sc", scripterChat, false, false)
addCommandHandler("u", scripterChat, false, false)

function vctChat(thePlayer, commandName, ...)
    local logged = getElementData(thePlayer, "loggedin")

    if(logged==1) and (exports.titan_integration:isPlayerVCTMember(thePlayer))  then
        if not (...) then
            outputChatBox("KULLANIM: /v [Message]", thePlayer, 255, 194, 14)
        else
            local message = table.concat({...}, " ")
            local players = exports.titan_pool:getPoolElementsByType("player")
            local username = getElementData(thePlayer,"account:username")

            for k, arrayPlayer in ipairs(players) do
                local logged = getElementData(arrayPlayer, "loggedin")

                if exports.titan_integration:isPlayerVCTMember(arrayPlayer) and (logged==1) then
                    outputChatBox("[VCT] ("..getElementData(thePlayer, "playerid")..") "..(exports.titan_integration:isPlayerVehicleConsultant(thePlayer) and "Leader" or "Member" ).." " .. username .. " : " .. message, arrayPlayer, 222, 222, 31)
                end
            end
        end
    end
end
addCommandHandler("v", vctChat, false, false)
addCommandHandler("vct", vctChat, false, false)

function mappingTeamChat(thePlayer, commandName, ...)
    local logged = getElementData(thePlayer, "loggedin")

    if(logged==1) and (exports.titan_integration:isPlayerMappingTeamMember(thePlayer))  then
        if not (...) then
            outputChatBox("KULLANIM: /v [Message]", thePlayer, 255, 194, 14)
        else
            local message = table.concat({...}, " ")
            local players = exports.titan_pool:getPoolElementsByType("player")
            local username = getElementData(thePlayer,"account:username")

            for k, arrayPlayer in ipairs(players) do
                local logged = getElementData(arrayPlayer, "loggedin")

                if exports.titan_integration:isPlayerMappingTeamMember(arrayPlayer) and (logged==1) then
                    outputChatBox("[MT] ("..getElementData(thePlayer, "playerid")..") "..(exports.titan_integration:isPlayerMappingTeamLeader(thePlayer) and "Leader" or "Member" ).." " .. username .. " : " .. message, arrayPlayer, 222, 222, 31)
                end
            end
        end
    end
end
addCommandHandler("mt", mappingTeamChat, false, false)


ignoreList = {}
function ignoreOnePlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if not (targetPlayerNick) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Kişinin ismi / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			if exports.titan_integration:isPlayerTrialAdmin(targetPlayer) then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Adminleri engelliyemezsiniz!", thePlayer, 255, 0, 0)
				return
			end

			local existed = false
			for k, v in ipairs(ignoreList) do
				if v[2] == targetPlayer then
					table.remove(ignoreList, k)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Kişiden gelen PM'leri artık görmezden gelmektesiniz." .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
					existed = true
					break
				end
			end
			if not existed then
				table.insert(ignoreList, {thePlayer, targetPlayer})
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Fısıltıları görmezden geliyorsun" .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Engellediğiniz oyuncuların listesi için. /engelliler", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("engelle", ignoreOnePlayer)

function checkifiamfucked(thePlayer, commandName)
	outputChatBox(" ~~~~~~~~~ Engelliler Listesi ~~~~~~~~~ ", thePlayer, 237, 172, 19)
	outputChatBox("    --  --", thePlayer, 2, 172, 19)
	for k, v in ipairs(ignoreList) do
		if v[1] == thePlayer then
			outputChatBox(getPlayerName(v[2]):gsub("_"," "), thePlayer, 255, 255, 255)
		end
	end
	outputChatBox(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ", thePlayer, 237, 172, 19)
end
addCommandHandler("engelliler", checkifiamfucked)

addEventHandler('onPlayerQuit', root,
	function()
		ignoreList[source] = nil
		for k, v in pairs(ignoreList) do
			for kx, vx in ipairs(v) do
				if vx == source then
					table.remove(vx, kx)
					break
				end
			end
		end
	end)

-- QUICK PM REPLY + PM SOUND FX / Hanz
function pmPlayer(thePlayer, commandName, who, ...)
	local message = nil
	if tostring(commandName):lower() == "quickreply" and who then
		local target = getElementData(thePlayer, "targetPMer")
		if not target or not isElement(target) or not (getElementType(target) == "player") or not (getElementData(target, "loggedin") == 1) then
			outputChatBox("Kimse size geri dönüş yapmamış.", thePlayer, 200,200,200)
			return false
		end
		message = who.." "..table.concat({...}, " ")
		who = target
	else
		if not (who) or not (...) then
			outputChatBox("Kullanım:#f9f9f9 /" .. commandName .. " [ID] [Mesaj]", thePlayer, 255, 194, 14,true)
			outputChatBox("Ya da:#f9f9f9 /" .. commandName .. " [yardim]", thePlayer, 255, 194, 14,true)
			return false
		end
		message = table.concat({...}, " ")
	end



	if who and message then

		local loggedIn = getElementData(thePlayer, "loggedin")
		if (loggedIn==0) then
			return
		end

		local targetPlayer, targetPlayerName
		if (isElement(who)) then
			if (getElementType(who)=="player") then
				targetPlayer = who
				targetPlayerName = getPlayerName(who)
				message = string.gsub(message, string.gsub(targetPlayerName, " ", "_", 1) .. " ", "", 1)
			end
		else
			targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, who)
		end

		if (targetPlayer) then
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				outputChatBox("Oyuncu giriş yapmamış.", thePlayer, 255, 255, 0)
				return false
			end


			if tonumber(targetPmState) == 1 then -- if target has pms off.
				if not exports.titan_global:isStaffOnDuty(thePlayer) and not (getElementData(thePlayer, "reportadmin") == targetPlayer) and not call(getResourceFromName("titan_social"), "isFriendOf", getElementData(thePlayer, 'account:id'), getElementData(targetPlayer, 'account:id')) then
					outputChatBox("İletişim kurmaya çalıştığınız kişi Rolde ya da AFK.", thePlayer, 255, 255, 0)
					return false
				end
			end

			-- check if ignored
			for k, v in ipairs(ignoreList) do
				if v[2] == targetPlayer and v[1] == thePlayer then
					outputChatBox('You are currently ignoring ' .. targetPlayerName .. '. Remove him from your ignore list to PM.', thePlayer, 255, 0, 0)
					return false
				end
			end
			for k, v in ipairs(ignoreList) do
				if v[1] == thePlayer and v[2] == thePlayer then
					outputChatBox(targetPlayerName .. ' ignoring private messages from you.', thePlayer, 255, 0, 0)
					return false
				end
			end
			if getElementData(thePlayer, "PMDurumuVIP") == 1 and not exports.titan_integration:isPlayerAdmin(thePlayer) then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffPM özelliğini tamamen kapattığın için bu alanı kullanamazsın.", thePlayer, 255, 0, 0, true)
				return false
			end
			
			if getElementData(targetPlayer, "PMDurumuVIP") == 1 and not exports.titan_integration:isPlayerAdmin(thePlayer) then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffff"..getPlayerName(targetPlayer).." isimli oyuncunun PM'i kapalı. Fakat ona mesaj göndermeye çalıştığın iletildi.", thePlayer, 255, 0, 0, true)
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffff"..getPlayerName(thePlayer).." isimli oyuncu sana PM atmaya çalışıyor fakat PM'lerin kapalı.", targetPlayer, 255, 0, 0, true)
				return false
			end
			setElementData(targetPlayer, "targetPMer", thePlayer, false)

			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			local targetUsername1, username1 = getElementData(targetPlayer, "account:username"), getElementData(thePlayer, "account:username")

			local targetUsername = " ("..targetUsername1..")"
			local username = " ("..username1..")"

			if not exports.titan_integration:isPlayerTrialAdmin(targetPlayer) and not exports.titan_integration:isPlayerScripter(targetPlayer) then
				username = ""
			end

			if not exports.titan_integration:isPlayerTrialAdmin(thePlayer) and not exports.titan_integration:isPlayerScripter(thePlayer) then
				targetUsername = ""
			end

			if not exports.titan_integration:isPlayerSeniorAdmin(thePlayer) and not exports.titan_integration:isPlayerSeniorAdmin(targetPlayer) then
				-- Check for advertisements
				for k,v in ipairs(advertisementMessages) do
					local found = string.find(string.lower(message), "%s" .. tostring(v))
					local found2 = string.find(string.lower(message), tostring(v) .. "%s")
					if (found) or (found2) or (string.lower(message)==tostring(v)) then
						exports.titan_global:sendMessageToAdmins("AdmWrn: " .. tostring(playerName) .. " sent a possible advertisement PM to " .. tostring(targetPlayerName) .. ".")
						exports.titan_global:sendMessageToAdmins("AdmWrn: Message: " .. tostring(message))
						break
					end
				end
			end

			-- Send the message
			local playerid = getElementData(thePlayer, "playerid")
			local targetid = getElementData(targetPlayer, "playerid")
			outputChatBox("#e8e8e8Gelen PM: #d4d400(" .. playerid .. ") " .. playerName ..username..": " .. message, targetPlayer, 234, 234, 0, true)
			outputChatBox("#e8e8e8Gönderilen PM: #e9e900(" .. targetid .. ") " .. targetPlayerName ..targetUsername.. ": " .. message, thePlayer, 234, 234, 0, true)

			triggerClientEvent(targetPlayer,"pmSoundFX",targetPlayer)
			triggerClientEvent(thePlayer,"pmSoundFX",thePlayer)


			exports.titan_logs:dbLog(thePlayer, 15, { thePlayer, targetPlayer }, message)

			local received = {}
			received[thePlayer] = true
			received[targetPlayer] = true
			for key, value in pairs( getElementsByType( "player" ) ) do
				if isElement( value ) and not received[value] then
					local listening = getElementData( value, "bigears" )
					if listening == thePlayer or listening == targetPlayer then
						received[value] = true
						outputChatBox("(" .. playerid .. ") " .. playerName .. " -> (" .. targetid .. ") " .. targetPlayerName .. ": " .. message, value, 255, 255, 0)
						triggerClientEvent(value,"pmSoundFX",value)
					end
				end
			end

		end
	end
end
addCommandHandler("pm", pmPlayer, false, false)
addCommandHandler("quickreply", pmPlayer, false, false)


function localOOC(thePlayer, commandName, ...)
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if (logged==1) and not (isPedDead(thePlayer)) then
		local muted = getElementData(thePlayer, "muted")
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		elseif (muted==1) then
			outputChatBox("You are muted from Global OOC.", thePlayer, 255, 0, 0)
		else
			-- Hanz
			local r,b,g = 196, 255, 255

			if exports.titan_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and not getElementData(thePlayer, "supervising") then
				r,b,g = 255, 194, 14
				setElementData(thePlayer, "supervisorBchat", false)
			elseif exports.titan_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and getElementData(thePlayer, "supervising") then
				r,b,g = 100, 149, 237
				setElementData(thePlayer, "supervisorBchat", true)
			elseif exports.titan_integration:isPlayerSupporter(thePlayer) then--and getElementData(thePlayer, "supervising") then
				r,b,g = 100, 149, 237
				setElementData(thePlayer, "supervisorBchat", true)
			end

			local message = table.concat({...}, " ")
			if getElementData(thePlayer, "supervisorBchat") == false or nil then -- The below locals were contained in the if, else statements. Therefore returned nil to the export db //Chaos
				if exports.titan_integration:isPlayerDeveloper(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and  getElementData(thePlayer, "account:username") == "nivorra" then
					result, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[OOC] H " .. getElementData(thePlayer, "account:username") .. "#f9f9f9: " .. message, r, b, g)
				elseif exports.titan_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and not getElementData(thePlayer, "supervising") then
					result, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[OOC] " .. exports.titan_global:getPlayerFullIdentity(thePlayer).. "#f9f9f9: " .. message, 201, 77, 77)
				elseif exports.titan_integration:isPlayerSupporter(thePlayer) and getElementData(thePlayer, "duty_supporter") == 1 then
					result, affectedElements = exports.titan_global:sendLocalText(thePlayer, "#2ecc71[OOC] " .. getPlayerName(thePlayer) .. "#f9f9f9: " .. message, r,b,g)
				else
					result, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[OOC] " .. getPlayerName(thePlayer) .. "#f9f9f9: " .. message, 139, 195, 201)
				end
			else
				result, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[OOC] " .. exports.titan_global:getPlayerFullIdentity(thePlayer) .. "#f9f9f9: " .. message, r,b,g,20,nil,true)
			end
			exports.titan_logs:dbLog(thePlayer, 8, affectedElements, message)
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)

function localDo(thePlayer, commandName, ...)
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if logged==1 then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Uygulama / Duygu ]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			--exports.titan_logs:logMessage("[IC: Local Do] * " .. message .. " *      ((" .. getPlayerName(thePlayer) .. "))", 19)
			local result, affectedElements = exports.titan_global:sendLocalDoAction(thePlayer, message, true)
			exports.titan_logs:dbLog(thePlayer, 14, affectedElements, message)
			triggerClientEvent(root,"addChatBubbleee",thePlayer,message)			
		end
	end
end
addCommandHandler("do", localDo, false, false)


function localShout(thePlayer, commandName, ...)
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end
	local affectedElements = { }
	table.insert(affectedElements, thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
		
			local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
			local playerName = getPlayerName(thePlayer)

			local languageslot = getElementData(thePlayer, "languages.current")
			local language = getElementData(thePlayer, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("titan_languages"), "getLanguageName", language)

			local message = trunklateText(thePlayer, table.concat({...}, " "))
			local r, g, b = 255, 255, 255
			local focus = getElementData(thePlayer, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == thePlayer then
						r, g, b = unpack(color)
					end
				end
			end
			outputChatBox("["..realTime.."] " .. playerName .. " bağırıyor : " .. message .. "!", thePlayer, r, g, b)
			exports.titan_global:applyAnimation(thePlayer, "ON_LOOKERS","shout_01", 8000, false, true, false)			
			icChatsToVoice(thePlayer, message, thePlayer)
			--exports.titan_logs:logMessage("[IC: Local Shout] " .. playerName .. ": " .. message, 1)
			-- triggerClientEvent(root,"addChatBubble",source,message)
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if getElementDistance( thePlayer, nearbyPlayer ) < 40 then
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) and (nearbyPlayer~=thePlayer) then
						local logged = getElementData(nearbyPlayer, "loggedin")

						if (logged==1) and not (isPedDead(nearbyPlayer)) then
							table.insert(affectedElements, nearbyPlayer)
							local message2 = call(getResourceFromName("titan_languages"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
							message2 = trunklateText(nearbyPlayer, message2)
							local r, g, b = 255, 255, 255
							local focus = getElementData(nearbyPlayer, "focus")
							if type(focus) == "table" then
								for player, color in pairs(focus) do
									if player == thePlayer then
										r, g, b = unpack(color)
									end
								end
							end
							outputChatBox("["..realTime.."] " .. playerName .. " ((Bağırma)) : " .. message2 .. "!", nearbyPlayer, r, g, b)
							icChatsToVoice(nearbyPlayer, message2, thePlayer)
							-- triggerClientEvent(root,"addChatBubble",source,message)
						end
					end
				end
			end
			exports.titan_logs:dbLog(thePlayer, 19, affectedElements, languagename.." "..message)
		end
	end
end
addCommandHandler("s", localShout, false, false)

function megaphoneShout(thePlayer, commandName, ...)
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if not (isPedDead(thePlayer)) and (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local factiontype = getElementData(faction, "type")

		if (factiontype==2) or (factiontype==3) or (factiontype==4) or (exports.titan_global:hasItem(thePlayer, 141)) or ( isElement(vehicle) and exports.titan_global:hasItem(vehicle, 141) and (seat==1 or seat==0)) then
			local affectedElements = { }

			if not (...) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
			else
				local playerName = getPlayerName(thePlayer)
				local message = trunklateText(thePlayer, table.concat({...}, " "))

				local languageslot = getElementData(thePlayer, "languages.current")
				local language = getElementData(thePlayer, "languages.lang" .. languageslot)
				local langname = call(getResourceFromName("titan_languages"), "getLanguageName", language)

				for index, nearbyPlayer in ipairs(getElementsByType("player")) do
					if getElementDistance( thePlayer, nearbyPlayer ) < 40 then
						local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
						local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

						if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
							local logged = getElementData(nearbyPlayer, "loggedin")

							if (logged==1) and not (isPedDead(nearbyPlayer)) then
								local message2 = message
								if nearbyPlayer ~= thePlayer then
									message2 = call(getResourceFromName("titan_languages"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
								end
								table.insert(affectedElements, nearbyPlayer)
								outputChatBox(" [" .. langname .. "] ((" .. playerName .. ")) Megafon <O: " .. trunklateText(nearbyPlayer, message2), nearbyPlayer, 255, 255, 0)
								icChatsToVoice(nearbyPlayer, message2, thePlayer)
							end
						end
					end
				end
				exports.titan_logs:dbLog(thePlayer, 20, affectedElements, langname.." "..message)
			end
		else
			outputChatBox("Megafon kullanman pek mümkün değil.", thePlayer, 255, 0 , 0)
		end
	end
end
addCommandHandler("m", megaphoneShout, false, false)

local togState = { }
function toggleFaction(thePlayer, commandName, State)
	local pF = getElementData(thePlayer, "faction")
	local fL = getElementData(thePlayer, "factionleader")
	local theTeam = getPlayerTeam(thePlayer)

	if fL == 1 then
		if togState[pF] == false or not togState[pF] then
			togState[pF] = true
			outputChatBox("Faction sohbeti kapatıldı.", thePlayer)
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("OOC Faction Sohbet Kapalı", arrayPlayer, 255, 0, 0)
					end
				end
			end
		else
			togState[pF] = false
			outputChatBox("Faction sohbeti aktif edildi.", thePlayer)
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("OOC Faction Sohbet Aktif", arrayPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("togglef", toggleFaction)
addCommandHandler("togf", toggleFaction)

function toggleFactionSelf(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) then
		local factionBlocked = getElementData(thePlayer, "chat-system:blockF")

		if (factionBlocked==1) then
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "chat-system:blockF", 0, false)
			outputChatBox("Faction chat is now enabled for yourself.", thePlayer, 0, 255, 0)
		else
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "chat-system:blockF", 1, false)
			outputChatBox("Faction chat is now disabled for yourself.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togglefactionchat", toggleFactionSelf)
addCommandHandler("togglefaction", toggleFactionSelf)
addCommandHandler("togfaction", toggleFactionSelf)

function factionOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local factionRank = tonumber(getElementData(thePlayer,"factionrank"))

	if (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = getPlayerName(thePlayer)
			local playerFaction = getElementData(thePlayer, "faction")
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]


			if not(theTeam) or (theTeamName=="Citizen") then
				outputChatBox("Bir birlikte değilsin.", thePlayer)
			else
				local affectedElements = { }
				table.insert(affectedElements, theTeam)
				local message = table.concat({...}, " ")

				if (togState[playerFaction]) == true then
					return
				end
				--exports.titan_logs:logMessage("[OOC: " .. theTeamName .. "] " .. playerName .. ": " .. message, 6)

				for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
					if isElement( arrayPlayer ) then
						if getElementData( arrayPlayer, "bigearsfaction" ) == theTeam then
							outputChatBox("((" .. theTeamName .. ")) " .. playerName .. ": " .. message, arrayPlayer, 3, 157, 157)
						elseif getPlayerTeam( arrayPlayer ) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("#FF4E0EBirlik: [" .. factionRankTitle .. "] - " .. playerName .. ": " .. message, arrayPlayer, 3, 237, 237, true)
						end
					end
				end
				exports.titan_logs:dbLog(thePlayer, 11, affectedElements, message)
			end
		end
	end
end
addCommandHandler("f", factionOOC, false, false)

function factionLeaderOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = getPlayerName(thePlayer)
			local playerLeader = getElementData(thePlayer, "factionleader")


			if not(theTeam) or (theTeamName=="Citizen") then
				outputChatBox("Bir birliğin yok.", thePlayer, 255, 0, 0)
			elseif tonumber(playerLeader) ~= 1 then
				outputChatBox("Birlik lideri değilsin.", thePlayer, 255, 0, 0)
			else
				local affectedElements = { }
				table.insert(affectedElements, theTeam)
				local message = table.concat({...}, " ")

				if (togState[playerFaction]) == true then
					return
				end
				--exports.titan_logs:logMessage("[OOC: " .. theTeamName .. "] " .. playerName .. ": " .. message, 6)

				for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
					if isElement( arrayPlayer ) then
						if getElementData( arrayPlayer, "bigearsfaction" ) == theTeam then
							outputChatBox("((" .. theTeamName .. " Lider )) " .. playerName .. ": " .. message, arrayPlayer, 3, 157, 157)
						elseif getPlayerTeam( arrayPlayer ) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 and getElementData(arrayPlayer, "factionleader") == 1 then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("((Birlik Lideri)) " .. playerName .. ": " .. message, arrayPlayer, 3, 180, 200)
						end
					end
				end
				exports.titan_logs:dbLog(thePlayer, 11, affectedElements, "Lider: " .. message)
			end
		end
	end
end
addCommandHandler("fl", factionLeaderOOC, false, false)

function setRadioChannel(thePlayer, commandName, slot, channel)
	slot = tonumber( slot )
	channel = tonumber( channel )

	if not channel then
		channel = slot
		slot = 1
	end

	if not (channel) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Radyo Kanalı] [Kanal Numarası]", thePlayer, 255, 194, 14)
	else
		if (exports.titan_global:hasItem(thePlayer, 6)) then
			local count = 0
			local items = exports['titan_items']:getItems(thePlayer)
			for k, v in ipairs( items ) do
				if v[1] == 6 then
					count = count + 1
					if count == slot then
						if v[2] > 0 then
							local isRestricted, factionID = isThisFreqRestricted(channel)
							local playerFaction = getElementData(thePlayer, "faction")

							if channel > 1 and channel < 1000000000 and (not isRestricted or (tonumber(playerFaction) == tonumber(factionID) ) )then
								if exports['titan_items']:updateItemValue(thePlayer, k, channel) then
									--outputChatBox("You retuned your radio to channel #" .. channel .. ".", thePlayer)
									exports["titan_infobox"]:addBox(thePlayer, "success", "Radyo kanalını #"..channel.." olarak değiştirdin.")
									triggerEvent('sendAme', thePlayer, "Radyo frekansını değiştirdi.")
									setElementData(thePlayer, "voiceChannel", channel)
								end
							else
								exports["titan_infobox"]:addBox(thePlayer, "error", "Bu frekansa erişemezsin.")
							end
						else
							exports["titan_infobox"]:addBox(thePlayer, "error", "Telsizin kapalı, /toggleradio.")
						end
						return
					end
				end
			end
		exports["titan_infobox"]:addBox(thePlayer, "error", "Bir telsize sahip değilsin.")
		else
		exports["titan_infobox"]:addBox(thePlayer, "error", "Bir telsizin yok.")
		end
	end
end
addEvent("telsizkanal", true)
addEventHandler("telsizkanal", root, setRadioChannel)

function setRadioChannel(thePlayer, commandName, slot, channel)
	slot = tonumber( slot )
	channel = tonumber( channel )

	if not channel then
		channel = slot
		slot = 1
	end

	if not (channel) then
		exports["titan_infobox"]:addBox(thePlayer, "info", "Kullanım: "..commandName.." [Frekans] [Numara]")
	else
		if (exports.titan_global:hasItem(thePlayer, 6)) then
			local count = 0
			local items = exports['titan_items']:getItems(thePlayer)
			for k, v in ipairs( items ) do
				if v[1] == 6 then
					count = count + 1
					if count == slot then
						if v[2] > 0 then
							local isRestricted, factionID = isThisFreqRestricted(channel)
							local playerFaction = getElementData(thePlayer, "faction")

							if channel > 1 and channel < 1000000000 and (not isRestricted or (tonumber(playerFaction) == tonumber(factionID) ) )then
								if exports['titan_items']:updateItemValue(thePlayer, k, channel) then
									exports["titan_infobox"]:addBox(thePlayer, "success", "Telsizinizi #"..channel.." numaralı frekansa ayarladınız.")
								end
							else
							exports["titan_infobox"]:addBox(thePlayer, "error", "Bu frekans değerine katılamazsınız.")
							end
						else
							exports["titan_infobox"]:addBox(thePlayer, "error", "Telsizinin seslerin kapalı ( /toggleradio )")
						end
						return
					end
				end
			end
			exports["titan_infobox"]:addBox(thePlayer, "error", "Bir tane telsizin var.")
		else
			exports["titan_infobox"]:addBox(thePlayer, "error", "Telsizin yok.")
		end
	end
end
addCommandHandler("tuneradio", setRadioChannel, false, false)
addCommandHandler("telsiz", setRadioChannel, false, false)

function toggleRadio(thePlayer, commandName, slot)
	if (exports.titan_global:hasItem(thePlayer, 6)) then
		local slot = tonumber( slot )
		local items = exports['titan_items']:getItems(thePlayer)
		local titemValue = false
		local count = 0
		for k, v in ipairs( items ) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						titemValue = v[2]
						break
					end
				else
					titemValue = v[2]
					break
				end
			end
		end

		-- gender switch for /me
		local genderm = getElementData(thePlayer, "gender") == 1 and "her" or "his"

		if titemValue < 0 then
			outputChatBox("You turned your radio on.", thePlayer, 255, 194, 14)
			triggerEvent('sendAme', thePlayer, "turns " .. genderm .. " radio on.")
		else
			outputChatBox("You turned your radio off.", thePlayer, 255, 194, 14)
			triggerEvent('sendAme', thePlayer, "turns " .. genderm .. " radio off.")
		end

		local count = 0
		for k, v in ipairs( items ) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						exports['titan_items']:updateItemValue(thePlayer, k, ( titemValue < 0 and 1 or -1 ) * math.abs( v[2] or 1))
						break
					end
				else
					exports['titan_items']:updateItemValue(thePlayer, k, ( titemValue < 0 and 1 or -1 ) * math.abs( v[2] or 1))
				end
			end
		end
	else
		outputChatBox("You do not have a radio!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toggleradio", toggleRadio, false, false)

function adminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.titan_integration:isPlayerTrialAdmin(thePlayer))  then
		if not (...) then
			outputChatBox("Kullanım: /a [Mesajınız]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.titan_pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
			local account = getPlayerAccount(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local dude = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				local hiddena = getElementData(arrayPlayer, "hidea") or "false"

				if(exports.titan_integration:isPlayerTrialAdmin(arrayPlayer)) and (logged==1) and (hiddena ~= "true") then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("[Yetkili Sohbeti] ("..playerid..") ".. adminTitle .." ".. dude .."#f9f9f9: " .. message, arrayPlayer, 245, 83, 83, true)
				end
			end
			exports.titan_logs:dbLog(thePlayer, 3, affectedElements, message)
		end
	end
end
addCommandHandler("a", adminChat, false, false)


-- Misc
local function sortTable( a, b )
	if b[2] < a[2] then
		return true
	end

	if b[2] == a[2] and b[4] > a[4] then
		return true
	end

	return false
end

function gmChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.titan_integration:isPlayerTrialAdmin(thePlayer)  or exports.titan_integration:isPlayerSupporter(thePlayer))  then
		if not (...) then
			outputChatBox("Kullanım: /".. commandName .. " [Mesajınız]", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "hideg") then
				setElementData(thePlayer, "hideg", false)
				outputChatBox("Gamemaster Chat - SHOWING",thePlayer)
			end
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.titan_pool:getPoolElementsByType("player")
			local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local accountName = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				if logged==1 and (exports.titan_integration:isPlayerTrialAdmin(arrayPlayer) or exports.titan_integration:isPlayerSupporter(arrayPlayer)) then
					local hideg = getElementData(arrayPlayer, "hideg")
					if hideg then
						local string = string.lower(message)
						local account = string.lower(getElementData(arrayPlayer, "account:username"))
						if string.find(string, account) then
							table.insert(affectedElements, arrayPlayer)
							triggerClientEvent ( "playNudgeSound", arrayPlayer)
							outputChatBox("Mentionned in /g chat - "..accountName..": "..message, arrayPlayer)
						end
					else
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("[Rehber Sohbeti] ("..playerid..") "..adminTitle .. " " .. accountName.."#f9f9f9: " .. message, arrayPlayer,  72, 250, 114, true)
					end
				end
			end
			exports.titan_logs:dbLog(thePlayer, 24, affectedElements, message)
		end
	end
end
addCommandHandler("g", gmChat, false, false)

function toggleAdminChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if logged==1 and exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
		local hidea = getElementData(thePlayer, "hidea")
		if not hidea or hidea == "false" then
			setElementData(thePlayer, "hidea", "true")
			outputChatBox("Admin Chat stopped showing on your screen, /toga again to enable it.",thePlayer, 0,255,0)
		elseif hidea=="true" then
			setElementData(thePlayer, "hidea", "false")
			outputChatBox("Admin Chat started showing on your screen, /toga again to disable it.",thePlayer, 0,255,0)
		end
	end
end
addCommandHandler("toga", toggleAdminChat, false, false)
addCommandHandler("togglea", toggleAdminChat, false, false)

function toggleGMChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if logged==1 and (exports["titan_integration"]:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
		local hideg = getElementData(thePlayer, "hideg") or false
		setElementData(thePlayer, "hideg", not hideg)
		outputChatBox("Gamemaster Chat - "..(hideg and "SHOWING" or "HIDDEN").." /togg to toggle it.",thePlayer)
	end
end
addCommandHandler("togg", toggleGMChat, false, false)
addCommandHandler("toggleg", toggleGMChat, false, false)


function toggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
		local players = exports.titan_pool:getPoolElementsByType("player")
		local oocEnabled = exports.titan_global:getOOCState()
		if (commandName == "togooc") then
			if (oocEnabled==0) then
				exports.titan_global:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")

					if	(logged==1) then
						outputChatBox("OOC Chat, Admin Tarafından Açıldı..", arrayPlayer, 0, 255, 0)
					end
				end
			elseif (oocEnabled==1) then
				exports.titan_global:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")

					if	(logged==1) then
						outputChatBox("OOC Chat, Admin Tarafından Kapatıldı.", arrayPlayer, 255, 0, 0)
					end
				end
			end
		elseif (commandName == "stogooc") then
			if (oocEnabled==0) then
				exports.titan_global:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "admin_level")

					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("OOC Chat Enabled Silently by Admin " .. getPlayerName(thePlayer) .. ".", arrayPlayer, 0, 255, 0)
					end
				end
			elseif (oocEnabled==1) then
				exports.titan_global:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "admin_level")

					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("OOC Chat Disabled Silently by Admin " .. getPlayerName(thePlayer) .. ".", arrayPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

addCommandHandler("togooc", toggleOOC, false, false)
addCommandHandler("stogooc", toggleOOC, false, false)



-- /pay
function payPlayer(thePlayer, commandName, targetPlayerNick, amount)
if getElementData(thePlayer, "KafesDovusu") then return end
if getElementData(thePlayer, "kumar") == 1 then return end
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (targetPlayerNick) or not (amount) or not tonumber(amount) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Kişinin ID] [Miktar]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)

				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=10) then
					amount = math.floor(math.abs(tonumber(amount)))
					

					local hoursplayed = getElementData(thePlayer, "hoursplayed")

					if (targetPlayer==thePlayer) then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Kendinize para veremezsiniz!", thePlayer, 255, 0, 0)
					elseif amount == 0 then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": 0'dan büyük bir miktar girmeniz gerekiyor.", thePlayer, 255, 0, 0)
					elseif (hoursplayed<5) and (amount>50) and not exports.titan_integration:isPlayerTrialAdmin(thePlayer) and not exports.titan_integration:isPlayerTrialAdmin(targetPlayer) and not exports.titan_integration:isPlayerSupporter(thePlayer) and not exports.titan_integration:isPlayerSupporter(targetPlayer) then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": En az 50 TL transfer etmeden önce en az 5 saat oynamanız gerekir.", thePlayer, 255, 0, 0)
					elseif exports.titan_global:hasMoney(thePlayer, amount) then
						if hoursplayed < 5 and not exports.titan_integration:isPlayerTrialAdmin(targetPlayer) and not exports.titan_integration:isPlayerTrialAdmin(thePlayer) and not exports.titan_integration:isPlayerSupporter(targetPlayer) and not exports.titan_integration:isPlayerSupporter(thePlayer) then
							local totalAmount = ( getElementData(thePlayer, "payAmount") or 0 ) + amount
							if totalAmount > 200 then
								outputChatBox( "#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Henüz 200 TL'den fazla ödeme yapamazsınız. Daha fazla miktar aktarmak için admin çağrınız.", thePlayer, 255, 0, 0, true )
								return
							end
							exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "payAmount", totalAmount, false)
							setTimer(
								function(thePlayer, amount)
									if isElement(thePlayer) then
										local totalAmount = ( getElementData(thePlayer, "payAmount") or 0 ) - amount
										exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "payAmount", totalAmount <= 0 and false or totalAmount, false)
									end
								end,
								300000, 1, thePlayer, amount
							)
						end
						--exports.titan_logs:logMessage("[Money Transfer From " .. getPlayerName(thePlayer) .. " To: " .. targetPlayerName .. "] Value: " .. amount .. "$", 5)
						exports.titan_logs:dbLog(thePlayer, 25, targetPlayer, "PAY " .. amount)

						
						if (hoursplayed<5) then
							exports.titan_global:sendMessageToAdmins("AdmWarn: New Player '" .. getPlayerName(thePlayer) .. "' transferred $" .. exports.titan_global:formatMoney(amount) .. " to '" .. targetPlayerName .. "'.")
						end

						-- DEAL!
						exports.titan_global:takeMoney(thePlayer, amount)
						exports.titan_global:giveMoney(targetPlayer, amount)

						local gender = getElementData(thePlayer, "gender")
						local genderm = "his"
						if (gender == 1) then
							genderm = "her"
						end
						triggerEvent('sendAme', thePlayer, " cüzdanını kavrar ve sol eli ile şahısa bir miktar para verir " .. targetPlayerName .. ".")
					--    outputChatBox("#32f200#575757"..exports["titan_pool"]:getServerName()..": #eaeaea" .. targetPlayerName .. " adlı şahısa " .. exports.titan_global:formatMoney(amount) .. "$ para gönderdin.", thePlayer, 255, 0, 0, true)
						exports["titan_infobox"]:addBox(thePlayer, "success", targetPlayerName.. " adlı şahısa "..exports.titan_global:formatMoney(amount).." TL para gönderdin.")
						--outputChatBox("#32f200#575757"..exports["titan_pool"]:getServerName()..": #eaeaea".. getPlayerName(thePlayer) .." adlı şahıs sana " .. exports.titan_global:formatMoney(amount) .. "$ para gönderdi.", targetPlayer, 255, 0, 0, true)
						exports["titan_infobox"]:addBox(targetPlayer, "success", getPlayerName(thePlayer).. " adlı şahıs sana	"..exports.titan_global:formatMoney(amount).." TL para gönderdi.")

						exports.titan_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
					else
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Yeterli paranız bulunmamaktadır.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": Kişiden çok uzaksınız." .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
	end
addCommandHandler("paraver", payPlayer, false, false)

function removeAnimation(thePlayer)
	exports.titan_global:removeAnimation(thePlayer)
end

-- /w(hisper)
function localWhisper(thePlayer, commandName, targetPlayerNick, ...)
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (targetPlayerNick) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
		local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)

				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<3) then
					local name = getPlayerName(thePlayer)
					local message = table.concat({...}, " ")
					--exports.titan_logs:logMessage("[IC: Whisper] " .. name .. " to " .. targetPlayerName .. ": " .. message, 1)
					exports.titan_logs:dbLog(thePlayer, 21, targetPlayer, message)
					message = trunklateText( thePlayer, message )

					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("titan_languages"), "getLanguageName", language)

					message2 = trunklateText( targetPlayer, message2 )
					local message2 = call(getResourceFromName("titan_languages"), "applyLanguage", thePlayer, targetPlayer, message, language)

					triggerEvent('sendAme', thePlayer, "şu kişiye fısıldıyor " .. targetPlayerName .. ".")
					local r, g, b = 255, 255, 255
					local focus = getElementData(thePlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBox("["..realTime.."] " .. name .. " fısıldıyor: " .. message, thePlayer, r, g, b)
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBox("["..realTime.."] " .. name .. " fısıldıyor: " .. message2, targetPlayer, r, g, b)
					for i,p in ipairs(getElementsByType( "player" )) do
						--if (getElementData(p, "duty_admin") == 1) then
							if p ~= targetPlayer and p ~= thePlayer then
								local ax, ay, az = getElementPosition(p)
								if (getDistanceBetweenPoints3D(x, y, z, ax, ay, az)<4) then
									local playerVeh = getPedOccupiedVehicle( thePlayer )
									local targetVeh = getPedOccupiedVehicle( targetPlayer )
									local pVeh = getPedOccupiedVehicle( p )
									if playerVeh then
										if pVeh then
											if pVeh==playerVeh then
												outputChatBox("["..realTime.."] " .. name .. " whispers to " .. getPlayerName(targetPlayer):gsub("_"," ") .. ": " .. message, p, 255, 255, 255)
											end
										end
									else
										outputChatBox("["..realTime.."] " .. name .. " whispers to " .. getPlayerName(targetPlayer):gsub("_"," ") .. ": " .. message, p, 255, 255, 255)
									end
								end
							end
						--end
					end
				else
					outputChatBox("" .. targetPlayerName .. " isimli kişiye çok uzaksın.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("w", localWhisper, false, false)

-- /c(lose)
function localClose(thePlayer, commandName, ...)
	if exports['titan_freecam']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
		local dotCounter = 0
			local doubleDot = ":"
			if dotCounter < 10000 then
				dotCounter = dotCounter + 200
			elseif dotCounter == 10000 then
				dotCounter = 0
			end
			if dotCounter <= 5000 then
				doubleDot = ":"
			else
				doubleDot = " "
			end
				
			local hour, minute = getRealTime()
			time = getRealTime()
			if time.hour >= 0 and time.hour < 10 then
				time.hour = "0"..time.hour
			end

			if time.minute >= 0 and time.minute < 10 then
				time.minute = "0"..time.minute
			end
					
			if time.second >= 0 and time.second < 10 then
				time.second = "0"..time.second
			end

			if time.month >= 0 and time.month < 10 then
				time.month = "0"..time.month+1
			end

			if time.monthday >=0 and time.monthday < 10 then
				time.monthday = "0"..time.monthday
			end
					
			local date = time.monthday.."."..time.month.."."..time.year+1900
			-- local dateWidth = dxGetTextWidth(date, 1, "pricedown")

			local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second
			-- local realTimeWidth = dxGetTextWidth(realTime, 1, "pricedown")
			local affectedElements = { }
			local name = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			--exports.titan_logs:logMessage("[IC: Whisper] " .. name .. ": " .. message, 1)
			message = trunklateText( thePlayer, message )

			local languageslot = getElementData(thePlayer, "languages.current")
			local language = getElementData(thePlayer, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("titan_languages"), "getLanguageName", language)
			local playerCar = getPedOccupiedVehicle(thePlayer)
			for index, targetPlayers in ipairs( getElementsByType( "player" ) ) do
				if getElementDistance( thePlayer, targetPlayers ) < 3 then
					local message2 = message
					if targetPlayers ~= thePlayer then
						message2 = call(getResourceFromName("titan_languages"), "applyLanguage", thePlayer, targetPlayers, message, language)
						message2 = trunklateText( targetPlayers, message2 )
					end
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayers, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					
					local pveh = getPedOccupiedVehicle(targetPlayers)
					if playerCar then
						if not exports['titan_vehicle']:isVehicleWindowUp(playerCar) then
							if pveh then
								if playerCar == pveh then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
									exports.titan_global:applyAnimation( thePlayer, "RIOT", "RIOT_shout", -1, true, false, false)									
									icChatsToVoice(targetPlayers, message2, thePlayer)
								elseif not (exports['titan_vehicle']:isVehicleWindowUp(pveh)) then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
							exports.titan_global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)										
									icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							else
								table.insert(affectedElements, targetPlayers)
							exports.titan_global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)										
								outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
								icChatsToVoice(targetPlayers, message2, thePlayer)
							end
						else
							if pveh then
								if pveh == playerCar then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
							exports.titan_global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)																			
									icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							end
						end
					else
						if pveh then
							if playerCar then
								if playerCar == pveh then
									table.insert(affectedElements, targetPlayers)
									outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
									icChatsToVoice(targetPlayers, message2, thePlayer)
							exports.titan_global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)																			
								end
							elseif not (exports['titan_vehicle']:isVehicleWindowUp(pveh)) then
								table.insert(affectedElements, targetPlayers)
								outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
								icChatsToVoice(targetPlayers, message2, thePlayer)
							exports.titan_global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)																		
							end
						else
							table.insert(affectedElements, targetPlayers)
							outputChatBox( " ["..realTime.."] " .. name .. " sessizce: " .. message2, targetPlayers, r, g, b)
							icChatsToVoice(targetPlayers, message2, thePlayer)
							exports.titan_global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 8000, false, true, false)										
						end
					end
				end
			end
			exports.titan_logs:dbLog(thePlayer, 22, affectedElements, languagename .. " "..message)
		end
	end
end
addCommandHandler("c", localClose, false, false)


-- /startinterview
function StartInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if(getElementData(targetPlayer,"interview"))then
							outputChatBox("This player is already being interviewed.", thePlayer, 255, 0, 0)
						else
							exports.titan_anticheat:changeProtectedElementDataEx(targetPlayer, "interview", true, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName .." has offered you for an interview.", targetPlayer, 0, 255, 0)
							outputChatBox("((Use /i to talk during the interview.))", targetPlayer, 0, 255, 0)
							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("((".. playerName .." has invited " .. targetPlayerName .. " for an interview.))", value, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("interview", StartInterview, false, false)

-- /endinterview
function endInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if not(getElementData(targetPlayer,"interview"))then
							outputChatBox("This player is not being interviewed.", thePlayer, 255, 0, 0)
						else
							exports.titan_anticheat:changeProtectedElementDataEx(targetPlayer, "interview", false, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName .." has ended your interview.", targetPlayer, 255, 0, 0)

							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("((".. playerName .." has ended " .. targetPlayerName .. "'s interview.))", value, 255, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("endinterview", endInterview, false, false)

-- /i
function interviewChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if(getElementData(thePlayer, "interview"))then
			if not(...)then
				outputChatBox("KULLANIM: /" .. commandName .. "[Message]", thePlayer, 255, 194, 14)
			else
				local message = table.concat({...}, " ")
				local name = getPlayerName(thePlayer)

				local finalmessage = "[LSN] Röportaj Konuğu " .. name .." konuşuyor: ".. message
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				if(factionType==6)then -- news faction
					finalmessage = "[LSN] " .. name .." konuşuyor: ".. message
				end

				for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
					if (getElementData(value, "loggedin")==1) then
						if not (getElementData(value, "tognews")==1) then
							outputChatBox(finalmessage, value, 66, 135, 245)
						end
					end
				end
				exports.titan_logs:dbLog(thePlayer, 23, thePlayer, "hTV " .. message)
				exports.titan_global:giveMoney(getTeamFromName("Los Santos Network"), 200)
			end
		end
	end
end
addCommandHandler("i", interviewChat, false, false)

-- /bigears
function bigEars(thePlayer, commandName, targetPlayerNick)
	if exports.titan_integration:isPlayerSeniorAdmin(thePlayer) then
		local current = getElementData(thePlayer, "bigears")
		if not current and not targetPlayerNick then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kullanım: /"..commandName.." [Karakter Adı & ID]")
		elseif current and not targetPlayerNick then
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "bigears", false, false)
			exports["titan_infobox"]:addBox(thePlayer, "error", "Fısıltı dinleme özelliğin başarıyla kapatıldı.")
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				exports["titan_infobox"]:addBox(thePlayer, "success", "Şu anda "..targetPlayerName.." isimli oyuncuyu dinliyorsun.")
				exports.titan_logs:dbLog(thePlayer, 4, targetPlayer, "BIGEARS "..targetPlayerName)
				exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "bigears", targetPlayer, false)
			end
		end
	else
		exports["titan_infobox"]:addBox(thePlayer, "error", "Bu komutu sadece A6 Sunucu Yazılımcıları ve üstü kullanabilir.")
	end
end
addCommandHandler("bigears", bigEars)

function removeBigEars()
	for key, value in pairs( getElementsByType( "player" ) ) do
		if isElement( value ) and getElementData( value, "bigears" ) == source then
			exports.titan_anticheat:changeProtectedElementDataEx( value, "bigears", false, false )
			outputChatBox("Big Ears turned off (Player Left).", value, 255, 0, 0)
			exports["titan_infobox"]:addBox(value, "error", "Fısıltı dinleme devre dışı bırakıldı. (Hedef oyuncu oyundan ayrıldı.)")
		end
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), removeBigEars)

function bigEarsFaction(thePlayer, commandName, factionID)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
		factionID = tonumber( factionID )
		local current = getElementData(thePlayer, "bigearsfaction")
		if not current and not factionID then
			outputChatBox("KULLANIM: /" .. commandName .. " [faction id]", thePlayer, 255, 194, 14)
		elseif current and not factionID then
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "bigearsfaction", false, false)
			outputChatBox("Big Ears turned off.", thePlayer, 255, 0, 0)
		else
			local team = exports.titan_pool:getElement("team", factionID)
			if not team then
				outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
			else
				outputChatBox("Now Listening to " .. getTeamName(team) .. " OOC Chat.", thePlayer, 0, 255, 0)
				exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "bigearsfaction", team, false)
				exports.titan_logs:dbLog(thePlayer, 4, team, "BIGEARSF "..getTeamName(team))
			end
		end
	end
end
addCommandHandler("bigearsf", bigEarsFaction)

function disableMsg(message, player)
	cancelEvent()
	pmPlayer(source, "pm", player, message)
end
addEventHandler("onPlayerPrivateMessage", getRootElement(), disableMsg)


addEventHandler("onPlayerQuit", root,
	function( )
		for k, v in ipairs( getElementsByType( "player" ) ) do
			if v ~= source then
				local focus = getElementData( v, "focus" )
				if focus and focus[source] then
					focus[source] = nil
					exports.titan_anticheat:changeProtectedElementDataEx(v, "focus", focus, false)
				end
			end
		end
	end
)

-- START of /st and /togglest and /togst

function isPlayerStaff(thePlayer)
	if exports.titan_integration:isPlayerSupporter(thePlayer) then return true end
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then return true end
	if exports.titan_integration:isPlayerScripter(thePlayer) then return true end
	if exports.titan_integration:isPlayerVCTMember(thePlayer) then return true end
	if exports.titan_integration:isPlayerMappingTeamMember(thePlayer) then return true
	else
		return false
	end
end

function staffChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and exports.titan_integration:isPlayerHeadAdmin(thePlayer) then
		if not (...) then
			outputChatBox("Kullanım: /".. commandName .. " [Mesajınız]", thePlayer, 255, 194, 14)
		else
			if getElementData(thePlayer, "hideStaffChat") then
				setElementData(thePlayer, "hideStaffChat", false)
				outputChatBox("Staff Chat - SHOWING",thePlayer)
			end
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.titan_pool:getPoolElementsByType("player")
			local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
			local playerid = getElementData(thePlayer, "playerid")
			local accountName = getElementData(thePlayer, "account:username")
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				if logged==1 and isPlayerStaff(arrayPlayer) then
					local hideStaffChat = getElementData(arrayPlayer, "hideStaffChat")
					if hideStaffChat then
						local string = string.lower(message)
						local account = string.lower(getElementData(arrayPlayer, "account:username"))
						if string.find(string, account) then
							table.insert(affectedElements, arrayPlayer)
							triggerClientEvent ( "playNudgeSound", arrayPlayer)
							outputChatBox("Mentionned in /st chat - "..accountName..": "..message, arrayPlayer)
						end
					else
						table.insert(affectedElements, arrayPlayer)
						exports["titan_infobox"]:addBox(arrayPlayer, "aduty", message)
						--outputChatBox("[Staff Duyuru] "..exports.titan_global:getPlayerFullIdentity(thePlayer).."#f9f9f9: "..message, arrayPlayer, 153, 51, 255, true)
					end
				end
			end
			exports.titan_logs:dbLog(thePlayer, 4, affectedElements, "Staff chat - Msg: "..message)
		end
	end
end
addCommandHandler( "st", staffChat, false, false)

function toggleStaffChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if logged==1 and isPlayerStaff(thePlayer) then
		local hideStaffChat = getElementData(thePlayer, "hideStaffChat") or false
		setElementData(thePlayer, "hideStaffChat", not hideStaffChat)
		outputChatBox("Staff Chat - "..(hideStaffChat and "SHOWING" or "HIDDEN").." /"..commandName.." to toggle it.",thePlayer)
	end
end
addCommandHandler("togglestaff", toggleStaffChat, false, false)
addCommandHandler("togst", toggleStaffChat, false, false)
addCommandHandler("togglest", toggleStaffChat, false, false)

----------------------------------------------------------------------------------------------------------

function isThisFreqRestricted()
	return false
end