function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Kullanici oyunda degil.", showPlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end
	
	local isOverlayDisabled = getElementData(showPlayer, "hud:isOverlayDisabled")
	--LICNESES
	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
	--local pilotlicense = getElementData(thePlayer, "license.pilot")
	local fishlicense = getElementData(thePlayer, "license.fish")
	local gunlicense = getElementData(thePlayer, "license.gun")
	local gun2license = getElementData(thePlayer, "license.gun2")
	if (carlicense==1) then
		carlicense = "Evet"
	elseif (carlicense==3) then
		carlicense = "Sürüş testine girmedi."
	else
		carlicense = "Hayir"
	end
	if (bikelicense==1) then
		bikelicense = "Evet"
	elseif (bikelicense==3) then
		bikelicense = "Sürüş testine girmedi."
	else
		bikelicense = "Hayir"
	end
	if (boatlicense==1) then
		boatlicense = "Evet"
	else
		boatlicense = "Hayir"
	end
	
	local pilotLicenses = {}
	local pilotlicense = ""
	local maxShow = 5
	local numAdded = 0
	local numOverflow = 0
	local typeratings = 0
	for k,v in ipairs(pilotLicenses) do
		local licenseID = v[1]
		local licenseValue = v[2]
		local licenseName = v[3]
		if licenseID == 7 then --if typerating
			if licenseValue then
				typeratings = typeratings + 1
			end
		else
			if numAdded >= maxShow then
				numOverflow = numOverflow + 1
			else
				if numAdded == 0 then
					pilotlicense = pilotlicense..tostring(licenseName)
				else
					pilotlicense = pilotlicense..", "..tostring(licenseName)
				end
				numAdded = numAdded + 1
			end
		end
	end
	if(numAdded == 0) then
		pilotlicense = "Hayir"
	else
		if numOverflow > 0 then
			pilotlicense = pilotlicense.." (+"..tostring(numOverflow+typeratings)..")"
		else
			if typeratings > 0 then
				pilotlicense = pilotlicense.." (+"..tostring(typeratings)..")"
			else
				pilotlicense = pilotlicense.."."
			end
		end
	end
	
	if (fishlicense==1) then
		fishlicense = "Evet"
	else
		fishlicense = "Hayir"
	end
	if (gunlicense==1) then
		gunlicense = "Evet"
	else
		gunlicense = "Hayir"
	end
	if (gun2license==1) then
		gun2license = "Evet"
	else
		gun2license = "Hayir"
	end
	--VEHICLES
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	local carids = ""
	local numcars = 0
	local printCar = ""
	for key, value in ipairs(exports.titan_pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
			exports.titan_anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.titan_datetime:now(), true)
		end
	end
	printCar = numcars .. "/" .. getElementData(thePlayer, "maxvehicles")

	-- PROPERTIES
	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		
		if interiorStatus[4] and interiorStatus[4] == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			exports.titan_anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.titan_datetime:now(), true)
		end
	end

	if (properties=="") then properties = "None.  " end
	if (carids=="") then carids = "None.  " end
	--FETCH ABOVE
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	local minutesPlayed = getElementData(thePlayer, "minutesPlayed") or 0
	minutesPlayed2 = 60-minutesPlayed
	local info = {}
	if isOverlayDisabled then
		outputChatBox(getPlayerName(thePlayer):gsub("_", " "), showPlayer , 255, 194, 14)
		outputChatBox(" Araba Ehliyeti: " .. carlicense, showPlayer)
		outputChatBox(" Motor Ehliyeti: " .. bikelicense, showPlayer)
		outputChatBox(" Tekne Lisansi: " .. boatlicense, showPlayer)
		outputChatBox(" Pilot Lisansi: " .. pilotlicense, showPlayer)
		outputChatBox(" Silah Lisansi (1): " .. gunlicense , showPlayer)
		outputChatBox(" Silah Lisansi (2): " .. gun2license , showPlayer)
		outputChatBox(" Avlanma Belgesi: " .. fishlicense, showPlayer)
		outputChatBox(" Araclar (" .. printCar .. "): " .. string.sub(carids, 1, string.len(carids)-2) , showPlayer)
		outputChatBox(" Evler (" .. numproperties .. "/"..(getElementData(thePlayer, "maxinteriors") or 10).."): " .. string.sub(properties, 1, string.len(properties)-2) , showPlayer)
		
		outputChatBox(" Bu karakterinizde '" .. hoursplayed .. " ' saat gecirdiniz." , showPlayer)
		outputChatBox(" Diller: " , showPlayer)
	else
		info = {
			{" "..getPlayerName(thePlayer):gsub("_", " ")},
			{""},
			{" Dogum Tarihi: "..exports.titan_global:getPlayerDoB(thePlayer)},
			{" Araba Ehliyeti: " .. carlicense},
			{" Motor Ehliyeti: " .. bikelicense},
		--	{" Tekne Lisansi: " .. boatlicense},
		--	{" Pilot Lisansi: " .. pilotlicense},
		--	{" Silah Lisansi (1): " .. gunlicense},
		--	{" Silah Lisansi (2): " .. gun2license},
		--	{" Avlanma Belgesi: " .. fishlicense},
			{" Araclar (" .. printCar .. "): " .. string.sub(carids, 1, string.len(carids)-2)},
			{" Evler (" .. numproperties .. "/"..(getElementData(thePlayer, "maxinteriors") or 10).."): " .. string.sub(properties, 1, string.len(properties)-2)},
			{" Karakter Limiti: (" .. #getElementData(thePlayer, "account:characters") .. "/"..(getElementData(thePlayer, "charlimit"))..")"},
			
			{" Bu karakterinizde: " .. hoursplayed .. " saat gecirdiniz."},
		--	{" Bonus almanız  için gereken dakika: " .. minutesPlayed2},
		
		}
	end
	--LANGUAGES
	
	--CAREER
	local job = getElementData(thePlayer, "job") or 0
	if job == 0 then
		if isOverlayDisabled then
			outputChatBox(" Career: Unemployed", showPlayer)
		else
			table.insert(info, {" Career: Unemployed"})
		end
	else
		local jobName = exports["titan_jobs"]:getJobTitleFromID(job)
		local joblevel = getElementData(thePlayer, "jobLevel") or 1
		local jobProgress = getElementData(thePlayer, "jobProgress") or 0
		if isOverlayDisabled then
			outputChatBox(" Career: "..jobName, showPlayer)
			outputChatBox("   - Skill Level: "..joblevel, showPlayer)
			outputChatBox("   - Progress: "..jobProgress, showPlayer)
		else
			table.insert(info, {" "})
			table.insert(info, {" Meslek: "..jobName})
			
		end
	end
	--CARRIED
	local carried = " Taşınan Ağırlık: "..("%.2f/%.2f" ):format( exports["titan_items"]:getCarriedWeight( thePlayer ), exports["titan_items"]:getMaxWeight( thePlayer ) ).." kg(s)"
	if isOverlayDisabled then
		outputChatBox( carried, showPlayer)
	else
		table.insert(info, {carried})
	end
	--FINANCE
	local bakiye = getElementData(thePlayer, "bakiye") or 0
	local bankmoney = getElementData(thePlayer, "bankmoney") or 0
	local money = getElementData(thePlayer, "money") or 0
	
	if not isOverlayDisabled then
		triggerClientEvent(showPlayer, "hudOverlay:drawOverlayTopRight", showPlayer, info ) 
	end
end
addCommandHandler("stats", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)

function exitVehicle ( thePlayer, seat, jacked ) 
	if getElementData(thePlayer, "seatbelt") == true then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Emniyet kemerin bağlıyken araçtan inemezsin.")
			cancelEvent()
		return
	end
end
addEventHandler ( "onVehicleStartExit", getRootElement(), exitVehicle)
