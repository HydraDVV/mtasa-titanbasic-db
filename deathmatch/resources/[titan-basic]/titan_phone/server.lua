-- Hanz

mysql = exports.titan_mysql
local phoneO = { }

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end


function initiatePhoneGUI(phone, popOutOnPhoneCall)
	if not phone or not tonumber(phone) or string.len(phone) < 5 then
		triggerClientEvent(source, "phone:slidePhoneOut", source)
		return false
	end
	if popOutOnPhoneCall then
		if tonumber(popOutOnPhoneCall) then
			popOutOnPhoneCall = tonumber(popOutOnPhoneCall)
		else
			popOutOnPhoneCall = "popOutOnPhoneCall"
		end
	end
	dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                local phoneSettings = res[1]
                local callerphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
                local callerphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
                local callerphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
                local callerphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
                local callerphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
                local callerphoneBoughtByName = phoneSettings["charactername"] or "Unknown"
                local callerphoneBoughtDate = phoneSettings["bought_date"] or "Unknown"
                local sms_tone = tonumber(phoneSettings["sms_tone"]) or 1
                local keypress_tone = tonumber(phoneSettings["keypress_tone"]) or 1
                local tone_volume = tonumber(phoneSettings['tone_volume']) or 10
                triggerClientEvent(source, "phone:updatePhoneGUI", source, popOutOnPhoneCall or "initiate", {phone, callerphoneIsTurnedOn, callerphoneRingTone, callerphoneIsSecretNumber, callerphonePhoneBook, callerphoneBoughtById, callerphoneBoughtByName, callerphoneBoughtDate, sms_tone, keypress_tone, tone_volume})
            end
        end,
    {source}, mysql:getDBConnection(), "SELECT *, `charactername`, DATE_FORMAT(`bought_date`,'%b %d %Y %h:%i %p') AS `bought_date` FROM `phones` LEFT JOIN `characters` ON `phones`.`boughtby` = `characters`.`id` WHERE `phonenumber`='"..(tostring(phone)).."' LIMIT 1")
    
	
	triggerEvent("phone:applyPhone", source, "phone_in")
	return true
end
addEvent("phone:initiatePhoneGUI", true)
addEventHandler("phone:initiatePhoneGUI", root, initiatePhoneGUI)

addEvent("installApp", true)
addEventHandler("installApp", root,
	function(data)
		player, c_data, phone, dat = unpack(data)

		c_data[dat] = true
		state = toJSON(c_data)
		triggerClientEvent(player, "reloadApps", player, c_data)
		dbExec(mysql:getDBConnection(), "UPDATE phones SET custom_settings='"..state.."' WHERE phonenumber='"..phone.."'")
	end
)

addEvent("fetchApps", true)
addEventHandler("fetchApps", root,
	function(phone)
		local apps =  { ['twitter'] = true, ['safari'] = true, ['vergi'] = true, ['spotify'] = true, ['emails'] = true, ['flappy-bird'] = true }
	
		triggerClientEvent(source, "reloadApps", source, apps)
	end
)

addEvent("receivePhoneSetupCache", true)
addEventHandler("receivePhoneSetupCache", root,
	function(player, phoneNumber)
		instance:query("SELECT * FROM phones WHERE phonenumber = '"..phoneNumber.."'", {player, phoneNumber},
			function(res, rows, err, player, phoneNumber)
				setupCache = res["phoneSetup"]
				setupPassword = res["phonePassword"]
				state = res["phonePasswordActive"]
				triggerClientEvent(player, "phone:createSetup", player, setupCache, setupPassword, state)
			end
		)
	end
)

addEvent("updatePhonePassTable", true)
addEventHandler("updatePhonePassTable", root,
	function(player, state, number)
		if state == true then state = 1 else state = 0 end
		instance:exec("UPDATE phones SET phonePasswordActive='"..state.."' WHERE phonenumber='"..number.."'")
	end
)


addEvent("completePhoneSetup", true)
addEventHandler("completePhoneSetup", root,
	function(player, phoneNumber, phonePassword)
		exec = dbExec(mysql:getDBConnection(), "UPDATE phones SET phoneSetup=?, phonePassword=? where phonenumber=?",2,phonePassword, phoneNumber)
		if exec then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Telefon kurulumu tamamlandı, şifreniz: "..phonePassword,player,0,255,0,true)
			triggerClientEvent(player, "phone:completeSetup", player)
			--dbFree(exec)
		end
	end
)


function powerOn(phone, state)
	if not phone or not tonumber(phone) or string.len(phone) < 5 then
		triggerClientEvent(source, "phone:powerOn:response", source, false, state)
		return false
	end
	return triggerClientEvent(source, "phone:powerOn:response", source, dbExec(mysql:getDBConnection(), "UPDATE `phones` SET `turnedon`='"..state.."' WHERE `phonenumber`='"..(tostring(phone)).."'"), state)
end
addEvent("phone:powerOn", true)
addEventHandler("phone:powerOn", root, powerOn)

function applyPhone(string, popOutOnPhoneCall)
	if not canPlayerCall(source) and string ~= "phone_out" then
		--return false
	end

	local phonestate = getElementData(source, "phonestate") or 0
	if string == "phone_in" then
		triggerEvent('sendAme', source, "cep telefonunu eline alır.")
		if getElementData(source, "phone_anim") ~= "0" then
			if not isElement(phoneO[source]) then
				phoneO[source] = createObject(330, 0, 0, 0)
			end
			setElementDimension(phoneO[source], getElementDimension(source))
			setElementInterior(phoneO[source], getElementInterior(source))
			exports.titan_bone_attach:attachElementToBone(phoneO[source], source, 12, -0.05, 0.02, 0.02, 20, -90, -10)
		else
			if isElement(phoneO[source]) then
				destroyPhone(source)
			end
			
		end
		if getElementData(source, "cellphoneGUIStateSynced") ~= 1 then
			exports.titan_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", 1 , true)
		end
		exports.titan_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", 1 , true)
	elseif string == "phone_talk" then
		if getElementData(source, "phone_anim") ~= "0" then
			if not isElement(phoneO[source]) then
				phoneO[source] = createObject(330, 0, 0, 0)
			end
			setElementDimension(phoneO[source], getElementDimension(source))
			setElementInterior(phoneO[source], getElementInterior(source))
			exports.titan_bone_attach:attachElementToBone(phoneO[element], source, 12, -0.03, 0.02, 0.02, 20, -90, -10)
			setPedAnimation(source, "ped", string, 1, false)
		else
			if isElement(phoneO[source]) then
				destroyPhone(source)
			end
		end
		if getElementData(source, "cellphoneGUIStateSynced") ~= 1 then
			exports.titan_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", 1 , true)
		end
	elseif string == "phone_out" then
		if phonestate > 0 and not popOutOnPhoneCall then
			triggerEvent("phone:cancelPhoneCall", source)
		end
		--resetPhoneState(source)
		if getElementData(source, "cellphoneGUIStateSynced") then
			if not popOutOnPhoneCall then
				triggerEvent('sendAme', source, "telefon çağrısına son verir.")
			end
			if getElementData(source, "phone_anim") ~= "0" then
				setPedAnimation(source, "ped", string, 1, false)
			end
		end
		exports.titan_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", nil , true)
		if isElement(phoneO[source]) then
			setTimer(destroyPhone, 2000, 1, source)
		
		end

	end
end
addEvent("phone:applyPhone", true)
addEventHandler("phone:applyPhone", root, applyPhone)

function destroyPhone(element)
	if canPlayerCall(element) then
		exports.titan_global:removeAnimation(element) 
	end
	if isElement(phoneO[element]) then
		exports.titan_bone_attach:detachElementFromBone(phoneO[element])
		destroyElement(phoneO[element]) 
		phoneO[element] = nil
	end
end


function cancelCall(phoneNumbers)
	for _, phoneNumber in ipairs(phoneNumbers) do
		local found, foundElement = searchForPhone(phoneNumber)
		if found and foundElement and isElement(foundElement) then
			local phoneState = getElementData(foundElement, "phonestate")
			
			if (phoneState==0) then
				exports.titan_anticheat:changeProtectedElementDataEx(foundElement, "calling", nil, false)
				exports.titan_anticheat:changeProtectedElementDataEx(foundElement, "called", nil, false)
				exports.titan_anticheat:changeProtectedElementDataEx(foundElement, "call.col", nil, false)
			end
		end
	end
end
--[[
function answerPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.titan_global:hasItem(thePlayer, 2)) then
			local phoneState = getElementData(thePlayer, "phonestate")
			local calling = getElementData(thePlayer, "calling")
			
			if getElementData(thePlayer, "called") then
				outputChatBox("You're the one calling someone else, smart-ass.", thePlayer, 255, 0, 0)
			elseif (calling) then
				if isPedDead(thePlayer) then
					outputChatBox("You're unable to make phone call at the moment.", thePlayer, 255,0,0)
					return false
				end
				
				if (phoneState==0) then
					local found, foundElement = searchForPhone(calling)
					--local target = calling
					outputChatBox("You picked up the phone. (( /p to talk ))", thePlayer)
					if not found then
						outputChatBox("You can't hear anything on the other side of the line", thePlayer)
						executeCommandHandler( "hangup", thePlayer )
					else
						outputChatBox("They picked up the phone.", foundElement)
						triggerEvent('sendAme', thePlayer, "takes out a cell phone.")
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "phonestate", 1, false)
						exports.titan_anticheat:changeProtectedElementDataEx(foundElement, "phonestate", 1, false)
						exports.titan_anticheat:changeProtectedElementDataEx(foundElement, "called", nil, false)
						triggerEvent('sendAme', thePlayer, "answers their cellphone.")

						
						--applyPhone(thePlayer, 2, "phone_talk")
						
						if getElementData(foundElement, "forcedanimation")~=1 and tonumber(getElementData(foundElement, "phone_anim"))==1 then
							setPedAnimation(foundElement, "ped", "phone_talk", 1, false)
						end

						local ownPhoneNo = getElementData(foundElement, "calling")
						exports['titan_logs']:dbLog(thePlayer, 29, { thePlayer, "ph"..tostring(ownPhoneNo), foundElement, "ph"..tostring(calling) }, "**Picked up phone**") 
					end

					triggerClientEvent("stopRinging", thePlayer)
				end
			elseif not (calling) then
				outputChatBox("Your phone is not ringing.", thePlayer, 255, 0, 0)
			elseif (phoneState==1) or (phoneState==2) then
				outputChatBox("Your phone is already in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("pickup", answerPhone)
]]

addEventHandler("savePlayer", root,
	function(reason)
		if reason == "Change Character" then
			triggerEvent("phone:cancelPhoneCall", source)
		end
	end)


addEventHandler( "onColShapeLeave", getResourceRootElement(),
	function( thePlayer )
		if getElementData( thePlayer, "call.col" ) == source then
			executeCommandHandler( "hangup", thePlayer )
		end
	end
)
addEventHandler( "onPlayerQuit", getRootElement(),
	function( )
		local calling = getElementData( source, "calling" )
		if isElement( calling ) then
			executeCommandHandler( "hangup", source )
		end
	end
)


function searchForPhone(phoneNumber)
	phoneNumber = tonumber(phoneNumber)
	if phoneNumber then
		for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
			local logged = tonumber(getElementData(value, "loggedin"))
			if (logged==1) then
				local foundPhone,_,foundPhoneNumber = exports.titan_global:hasItem(value, 2, tonumber(phoneNumber))
				if foundPhone then
					return true, value
				end
			end
		end
	end
	return false, nil
end

function fetchFirstPhoneNumber(target)
	local foundPhone,_,foundPhoneNumber = exports.titan_global:hasItem(target, 2, tonumber(phoneNumber))
	return foundPhoneNumber
end

function setEDX(thePlayer, index, newvalue, sync, nosyncatall)
	return exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
end

function cleanUp()
	for i, player in pairs(getElementsByType("player")) do
		cleanUpOnePlayer(player)
	end
end
addEventHandler("onResourceStop", resourceRoot, cleanUp)

function cleanUpOnePlayer(player)
	--if source then player = source end
	resetPhoneState(player)
	exports.titan_anticheat:changeProtectedElementDataEx(player, "cellphoneGUIStateSynced", nil, true)
end
--addEventHandler("accounts:characters:change", root, cleanUpOnePlayer)


addEvent("phone:konumAt",true)
addEventHandler("phone:konumAt",root,function(player,bendekiNo,gidenNo,text,state)

	--triggerEvent("phone:sendSMS", player, bendekiNo, gidenNo, "(Haritada blip işareti ve marker işaretlendi)", true)

	x,y,z = getElementPosition(player)
	otherPlayer = findToNumber(player,gidenNo)

	
	
	if getElementData(player,"konum->attigiKisi") == otherPlayer then
		outputChatBox("Zaten bu kullanıcıya konum atmışsın, işlemin devamı gerçekleşmeyecek!",player,255,0,0)
		return
	end
	triggerEvent("phone:sendSMS", player, bendekiNo, gidenNo, text, true)
	setElementData(player,"konum->attigiKisi",otherPlayer)
	if otherPlayer then
		--p,x,y,z
		triggerClientEvent(otherPlayer,"konum:markerAc",otherPlayer,player,otherPlayer,x,y,z)
	end
end)


function findToNumber(player,number)
	found = 0
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"loggedin") == 1 then
			if exports["titan_global"]:hasItem(v,2,number) then
				found = found + 1
				if found == 1 then
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff "..getPlayerName(player):gsub("_", " ").." adlı kullanıcı sana konum yolladı!",v,0,255,0,true)
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff SMS ile konum gönderildi, gitmek istediğin alan blip ile işaretlenecek.",v,0,255,0,true)
					return v
				else
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Konum atmak istediğiniz oyuncu oyunda olmadığı için yalnızca SMS gönderildi!",player,255,0,0,true)
					return false
				end
			end
		end
	end
end

local ads = { }
local AD_MESSAGE = 1
local AD_SENDERNAME = 2
local AD_SENDERELEMENT = 3
local AD_COST = 4
local AD_PHONENUMER = 5
local AD_CREATIONTIME = 6
local AD_EDITTIME = 7
local AD_FROZEN = 8
local AD_AIRED = 9

local adTimer = 1

function SAN_doesAdExist(message)
	local message = message:lower()
	for k, v in ipairs(ads) do
		if v[AD_MESSAGE]:lower() == message and not v[AD_AIRED] and not v[AD_FROZEN] then
			return true
		end
	end
	return false
end

function SAN_newAdvert(message, sourceName, sourceElement, theCost, outboundPhoneNumber)
	table.insert(ads, { message, sourceName, sourceElement, theCost, outboundPhoneNumber or 0, getRealTime().timestamp, getRealTime().timestamp, false, false } )
	
	local advertID = -1
	local advertMsg = ""
	for adIndex, adTable in ipairs (ads) do
		advertID = adIndex
		advertMsg = adTable[AD_MESSAGE]
	end
	exports.titan_global:sendMessageToSupporters("[ADVERT] ID#"..advertID .. " ("..advertMsg..") created by "..sourceName..".")
	
	if not adTimer then
		adTimer = setTimer(SAN_runAdverts, math.random(1000, 1500), 1)
	end
end
addEvent("sanAdvert", true)
addEventHandler("sanAdvert", root, SAN_newAdvert)

function SAN_runAdverts()
	local didAirSomething = false
	local removeIDs = { }
	for adIndex, adTable in ipairs (ads) do
		if adTable[ AD_AIRED ] then -- remove from list
			table.insert(removeIDs, adIndex)
		elseif adTable[ AD_FROZEN ] then
			local currentTime = getRealTime().timestamp
			if (currentTime - adTable [ AD_EDITTIME ]) > 5 then
				table.insert(removeIDs, adIndex)
				exports.titan_global:sendMessageToSupporters("[ADS] Removing ad "..adIndex.." due being 10 minutes frozen. (`"..adTable[AD_MESSAGE].."`, `"..adTable[AD_SENDERNAME].."`)")
			end
		elseif ( not didAirSomething ) and not (adTable[AD_EDITTIME] == adTable[AD_CREATIONTIME] ) then
			
		
			didAirSomething = true
			
			exports.titan_logs:logMessage("ADVERT: " .. adTable[AD_MESSAGE] .. " ((".. adTable[AD_SENDERNAME].." ))", 2)
			for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
				if getElementData(value, "loggedin")==1 then
					local hasTogAd, togAdState = exports.titan_donators:hasPlayerPerk(value, 2)
					if hasTogAd and tonumber(togAdState) == 1 then
						--donothing
					else
						if exports.titan_integration:isPlayerSupporter(value) or exports.titan_integration:isPlayerTrialAdmin(value) then
							outputChatBox("   [iTV] " .. adTable[AD_MESSAGE] .. " (( ".. adTable[AD_SENDERNAME].." ))", value, 0, 255, 64)
						else
							outputChatBox("   [iTV] " .. adTable[AD_MESSAGE], value, 0, 255, 64)
						end
						outputChatBox("   [iTV] İletişim: " .. adTable[AD_PHONENUMER] .. " // " .. adTable[AD_SENDERNAME]:gsub("_", " "), value, 0, 255, 64)
					end
				end
			end
			--table.insert(removeIDs, adIndex)
			ads[adIndex][AD_AIRED] = true
		end
		
		if adTable[AD_EDITTIME] == adTable[AD_CREATIONTIME] then
			ads[adIndex][AD_EDITTIME] = getRealTime().timestamp
		end
	end
	
	local offset = 0
	for _, removeID in ipairs (removeIDs) do
		table.remove(ads, removeID - offset)
		offset = offset + 1
	end
	
	
	if #ads > 0 then
		local timer = (120 / (#ads + 1)) * 100
		adTimer = setTimer(SAN_runAdverts, timer, 1)
	else
		adTimer = nil
	end
end

function SAN_listAdverts(thePlayer)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer) then
		outputChatBox("Current adverts list", thePlayer)
		for adIndex, adTable in ipairs (ads) do
			local msg = " "..adIndex..". "..adTable[AD_MESSAGE].." /-/ "..adTable[AD_SENDERNAME].." /-/ "
			
			if (adTable[AD_AIRED]) then
				msg = msg.."Already aired"
			elseif (adTable[AD_FROZEN]) then
				msg = msg.."Frozen by "..adTable[AD_FROZEN]
			else
				msg = msg.."In queue"
			end
			
			outputChatBox(msg, thePlayer)
		end
		outputChatBox("--- Commands: /freezead /unfreezead /deletead", thePlayer)
	end
end
addCommandHandler("listadverts", SAN_listAdverts)
addCommandHandler("listads", SAN_listAdverts)
addCommandHandler("adverts", SAN_listAdverts)
addCommandHandler("ads", SAN_listAdverts)

function SAN_freezeAdvert(thePlayer, commandHandler, advertID)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer) then
		if not advertID or not tonumber(advertID) then
			outputChatBox("Syntax: /"..commandHandler.." <advertID>", thePlayer)
			return
		end
		
		advertID = tonumber(advertID)
		
		if not ads[advertID] then
			outputChatBox("Invalid ad", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_FROZEN] then
			outputChatBox("Ad is already frozen by `"..ads[advertID][AD_FROZEN].."`.", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_AIRED] then
			outputChatBox("Ad is already aired", thePlayer, 255, 0 ,0)
			return
		end
		
		ads[advertID][AD_FROZEN] = getPlayerName(thePlayer)
		ads[advertID][AD_EDITTIME] = getRealTime().timestamp
		exports.titan_global:sendMessageToSupporters("[AD] "..getPlayerName(thePlayer).." froze advert "..advertID .. ".")
	end
end
addCommandHandler("freezead", SAN_freezeAdvert)


function SAN_unfreezeAdvert(thePlayer, commandHandler, advertID)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer) then
		if not advertID or not tonumber(advertID) then
			outputChatBox("Syntax: /"..commandHandler.." <advertID>", thePlayer)
			return
		end
		
		advertID = tonumber(advertID)
		
		if not ads[advertID] then
			outputChatBox("Invalid ad", thePlayer, 255, 0 ,0)
			return
		end
		
		if not ads[advertID][AD_FROZEN] then
			outputChatBox("Ad is not frozen.", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_AIRED] then
			outputChatBox("Ad is already aired", thePlayer, 255, 0 ,0)
			return
		end
		
		ads[advertID][AD_FROZEN] = false
		ads[advertID][AD_EDITTIME] = getRealTime().timestamp
		exports.titan_global:sendMessageToSupporters("[AD] "..getPlayerName(thePlayer).." unfroze advert "..advertID .. ".")
		outputChatBox("Unfroze ad "..advertID, thePlayer, 0, 255 ,0)
	end
end
addCommandHandler("unfreezead", SAN_unfreezeAdvert)


function SAN_deleteAdvert(thePlayer, commandHandler, advertID)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer) then
		if not advertID or not tonumber(advertID) then
			outputChatBox("Syntax: /"..commandHandler.." <advertID>", thePlayer)
			return
		end
		
		advertID = tonumber(advertID)
		
		if not ads[advertID] then
			outputChatBox("Invalid ad", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_AIRED] then
			outputChatBox("Ad is already aired", thePlayer, 255, 0 ,0)
			return
		end
		
		ads[advertID][AD_AIRED] = true
		exports.titan_global:sendMessageToSupporters("[AD] "..getPlayerName(thePlayer).." marked advert "..advertID .. " as aired.")
	end
end
addCommandHandler("deletead", SAN_deleteAdvert)
addCommandHandler("delad", SAN_deleteAdvert)

-- @Hanz
addEvent("phone:requestShowPhoneGUI", true)
function requestPhoneGUI(itemValue, newSource)
end
addEventHandler("phone:requestShowPhoneGUI", getRootElement(), requestPhoneGUI)
--

function getContacts(fromNumber)
    return {}, 50
end
function requestContacts(fromNumber)
    local contacts = {}
    dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    table.insert(contacts, row)
                end
                triggerClientEvent(source, "phone:receiveContacts", source, contacts, 50)
            end
        end,
    {source}, mysql:getDBConnection(), "SELECT * from `phone_contacts` WHERE `phone`='".. ( fromNumber ) .."' ORDER BY `entryName`")
end
addEvent("phone:requestContacts", true)
addEventHandler("phone:requestContacts", root, requestContacts)

function forceUpdateContactList(player, fromPhone)
	if player then
		source = player
    end
    local contacts = {}
    dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    table.insert(contacts, row)
                end
                triggerClientEvent(source, "phone:forceUpdateContactList", source, contacts, 50)
            end
        end,
    {source}, mysql:getDBConnection(), "SELECT * from `phone_contacts` WHERE `phone`='".. ( fromPhone ) .."' ORDER BY `entryName`")
end
addEvent("phone:forceUpdateContactList", true)
addEventHandler("phone:forceUpdateContactList", root, forceUpdateContactList)

addEvent("phone:deleteContact", true)
function deletePhoneContact(name, number, phoneBookPhone)
	if (client) then
		if not phoneBookPhone then
			return
		end
		
		if not exports.titan_global:hasItem(client,2, tonumber(phoneBookPhone)) then
			return
		end
		if name and number then
			if tonumber(number) then
				local result = dbExec(mysql:getDBConnection(), "DELETE FROM `phone_contacts` WHERE `phone`='" ..  (phoneBookPhone).."' AND `entryName`='".. (name) .."' AND `entryNumber`='".. (number) .."'")
				if result then
					requestPhoneGUI(phoneBookPhone, client)
					return
				end
			end
		end
		outputChatBox("Error, please try it again.", client, 255,0,0)
	end
end
addEventHandler("phone:deleteContact", getRootElement(), deletePhoneContact)

function saveCurrentRingtone(itemValue, phoneBookPhone)
	if client and itemValue then
		if not phoneBookPhone then
			outputChatBox("one")
			return
		end
		
		if not exports.titan_global:hasItem(client,2, tonumber(phoneBookPhone)) then
			--outputChatBox("two")
			return
		end
		
		if not tonumber(itemValue) then
			outputChatBox("three")
			return
		end

		local result = dbExec(mysql:getDBConnection(), "UPDATE `phones` SET `ringtone`='" ..  (itemValue).."' WHERE `phonenumber`='"..(phoneBookPhone).."'")
		if not result then
			outputChatBox("Error, please try it again.", client, 255,0,0)
			return
		end
	end
end
addEvent("saveRingtone", true)
addEventHandler("saveRingtone", getRootElement(), saveCurrentRingtone)

addEventHandler( "onResourceStart", getResourceRootElement( ),
    function( )
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        local id = tonumber(row["id"])
					
                        local x = tonumber(row["x"])
                        local y = tonumber(row["y"])
                        local z = tonumber(row["z"])
                            
                        local dimension = tonumber(row["dimension"])
                        
                        local shape = createColSphere(x, y, z, 1)
                        exports.titan_pool:allocateElement(shape)
                        setElementDimension(shape, dimension)
                        exports.titan_anticheat:changeProtectedElementDataEx(shape, "dbid", id, false)
                    end
                end
            end,
        mysql:getDBConnection(), "SELECT id, x, y, z, dimension FROM publicphones")
	end
)

function addPhone(thePlayer, commandName)
	if (exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		
		local query = dbExec(mysql:getDBConnection(), "INSERT INTO publicphones SET x="  .. (x) .. ", y=" .. (y) .. ", z=" .. (z) .. ", dimension=" .. (dimension))
		
		if (query) then
			dbQuery(
                function(qh)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        local id = res[1].id
                        local shape = createColSphere(x, y, z, 1)
                        exports.titan_pool:allocateElement(shape)
                        setElementDimension(shape, dimension)
                        exports.titan_anticheat:changeProtectedElementDataEx(shape, "dbid", id, false)
                        
                        outputChatBox("Public Phone spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
                    end
                end,
            mysql:getDBConnection(), "SELECT id FROM publicphones WHERE id=LAST_INSERT_ID()")
            
			
		else
			outputChatBox("Error 200001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("addphone", addPhone, false, false)

function getNearbyPhones(thePlayer, commandName)
	if (exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Phones:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			local x, y = getElementPosition(theColshape)
			local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
			if (distance<=20) then
				local dbid = getElementData(theColshape, "dbid")
				outputChatBox("   Public Phone with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyphones", getNearbyPhones, false, false)

function delPhone(thePlayer, commandName, id)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
		local id = tonumber(id)
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14 )
		else
			local colShape = nil
			
			for key, value in ipairs(getElementsByType("colshape", getResourceRootElement())) do
				if getElementData(value, "dbid") == id then
					colShape = value
				end
			end
			
			if (colShape) then
				local id = getElementData(colShape, "dbid")
				local result = dbExec(mysql:getDBConnection(), "DELETE FROM publicphones WHERE id=" .. (id))
				
				outputChatBox("Phone #" .. id .. " deleted.", thePlayer)
				destroyElement(colShape)
			else
				outputChatBox("You are not in a Pay n Spray.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delphone", delPhone, false, false)

-- @Hanz
local phoneLogs = {}

function writeCellphoneLog(thePlayer, theOtherPlayer, type, message, starting )
	if starting or (message and string.len(message) > 0) and type then

		local charId1 = nil
		local number1 = nil
		local number2Test = nil

		local charId2 = nil
		local number2 = nil
		local number1Test = nil

		if thePlayer and getElementData(thePlayer, "cellphone_log") ~= "0" then
			charId1 = getED(thePlayer, "dbid")
			number1 = getED(thePlayer, "callingwith")
			number2Test = getED(thePlayer, "calling")

		end

		if tonumber(charId1) and tonumber(number1) and tonumber(number2Test) then

			if not phoneLogs[charId1] then
				phoneLogs[charId1] = {}
			end

			if not phoneLogs[charId1][number1] then
				phoneLogs[charId1][number1] = {}
			end
			if not phoneLogs[charId1][number1][type] then
				phoneLogs[charId1][number1][type] = {}
			end
			if not phoneLogs[charId1][number1][type][number2Test] then 
				phoneLogs[charId1][number1][type][number2Test] = {}
			end

			local message1 = ""
			if starting then
				message1 = "\nOUTGOING "..(type == "Calls" and "CALL" or "SMS").." FROM #"..number1.." ("..string.upper(exports.titan_global:getPlayerName(thePlayer))..") TO #"..number2Test.." ("..(theOtherPlayer and string.upper(exports.titan_global:getPlayerName(theOtherPlayer)) or string.upper(isNumberAHotline(number2Test)))..") AT ".. getCurrentDateTimeText()..":"
			else
				message1 = "-> "..message
			end
			table.insert(phoneLogs[charId1][number1][type][number2Test], message1)

			if theOtherPlayer and getElementData(theOtherPlayer, "cellphone_log") ~= "0" then
				charId2 = getED(theOtherPlayer, "dbid")
				number2 = getED(theOtherPlayer, "callingwith")
				number1Test = getED(theOtherPlayer, "calling")
			end

			if tonumber(charId2) and tonumber(number2) and tonumber(number1Test) and tonumber(number1Test) == tonumber(number1) and tonumber(number2Test) == tonumber(number2) then
				
				if not phoneLogs[charId2] then
					phoneLogs[charId2] = {}
				end

				if not phoneLogs[charId2][number2] then
					phoneLogs[charId2][number2] = {}
				end

				if not phoneLogs[charId2][number2][type] then
					phoneLogs[charId2][number2][type] = {}
				end

				if not phoneLogs[charId2][number2][type][number1] then
					phoneLogs[charId2][number2][type][number1] = {}
				end

				local message2 = ""
				if starting then
					message2 = "\nINCOMING "..(type == "Calls" and "CALL" or "SMS").." FROM #"..number1.." ("..string.upper(exports.titan_global:getPlayerName(thePlayer))..") TO #"..number2Test.." ("..string.upper(exports.titan_global:getPlayerName(theOtherPlayer))..") AT ".. getCurrentDateTimeText()..":"
				else
					message2 = "<- "..message
				end
				table.insert(phoneLogs[charId2][number2][type][number1], message2)
			end
		end
	end
end


function getCurrentDateTimeText()
	local time = getRealTime()
	yearday = time.yearday
	hour = time.hour
	local timeResult = ( "%02d:%02d %02d/%02d/%04d" ):format(time.hour, time.minute, time.monthday, time.month + 1, time.year + 1900 )
	return timeResult
end