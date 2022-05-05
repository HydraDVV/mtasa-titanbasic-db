local backupColours = {
	{ 255, 0, 0, "EKİP-1(Kırmızı)", false },
	{ 0, 255, 0, "EKİP-2(Yeşil)", false },
	{ 0, 0, 255, "EKİP-3(Mavi)", false },
	{ 255, 255, 0, "EKİP-4(Sarı)", false },
	{ 255, 0, 255, "EKİP-5(Pembe)", false },
	{ 0, 255, 255, "EKİP-6(Koyu Mavi)", false },
	{ 255, 255, 255, "EKİP-7(Beyaz)", false }
}

local allowedFactionTypes = {
	[2] = true,
	[3] = true,	
	[4] = true
}

local vehiclesDashboardRadio = { [596] = true,[597] = true, [598] = true, [599] = true, [601] = true, [427] = true, [407] = true, [416] = true, [528] = true, [523] = true }

function startBackup(thePlayer) 
	local theTeam = getPlayerTeam(thePlayer)
	local duty = tonumber(getElementData(thePlayer, "duty"))
	local factionType = getElementData(theTeam, "type")
	local factionShortName = ""
	if (allowedFactionTypes[factionType]) and (duty > 0) then
	--if getPedOccupiedVehicle(thePlayer) then
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local model = getElementModel(veh)
			if veh and vehiclesDashboardRadio[model] then
				exports.titan_global:sendLocalMeAction(thePlayer, "araç GPS üzerinde lokasyon belirtem düğmesine basar.")
				else
				exports.titan_global:sendLocalMeAction(thePlayer, "araç GPS üzerinde lokasyon belirtem düğmesine basar.")
				end
			else
			exports.titan_global:sendLocalMeAction(thePlayer, "araç GPS üzerinde lokasyon belirtem düğmesine basar.")
		end
		
		for a, b in ipairs(split(getTeamName(theTeam), ' ')) do 
			factionShortName = factionShortName .. b:sub( 1, 1) 
		end
	
		local availableColourIndex = false
		local alreadyUsingOne = false
		for index, colorarray in ipairs(backupColours) do
			-- See if there is one available, and if the player is already using one.
			if (backupColours[index][5] == false) and (availableColourIndex == false) then
				availableColourIndex = index
			elseif (backupColours[index][5] == thePlayer) then
				alreadyUsingOne = true
				availableColourIndex = index
			end			
		end
		
		if alreadyUsingOne then
			backupColours[availableColourIndex][5] = false
			for keyValue, theArrayPlayer in ipairs( getElementsByType("player") ) do
				local pTheTeam = getPlayerTeam(theArrayPlayer)
				if pTheTeam then
					local pFactionType = getElementData(pTheTeam, "type")
					if allowedFactionTypes[pFactionType]  then
						local duty = tonumber(getElementData(theArrayPlayer, "duty"))
						if (duty > 0) then
							triggerClientEvent(theArrayPlayer, "destroyBackupBlip", thePlayer, availableColourIndex)
							outputChatBox("#FF0000#575757"..exports["titan_pool"]:getServerName()..":#FFFFFF'".. backupColours[availableColourIndex][4]  .."' ekibi destek talebini geri çekti, devriyeye devam edebilirsin.", theArrayPlayer, 0, 0, 0, true)
						end
					end	
				end
			end	
		elseif availableColourIndex then
			backupColours[availableColourIndex][5] = thePlayer
			for keyValue, theArrayPlayer in ipairs( getElementsByType("player") ) do
				local pTheTeam = getPlayerTeam(theArrayPlayer)
				if pTheTeam then
					local pFactionType = getElementData(pTheTeam, "type")
					if allowedFactionTypes[pFactionType]  then
						local duty = tonumber(getElementData(theArrayPlayer, "duty"))
						if (duty > 0) then
							triggerClientEvent(theArrayPlayer, "createBackupBlip", thePlayer, availableColourIndex, backupColours[availableColourIndex])
							outputChatBox("#FF0000#575757"..exports["titan_pool"]:getServerName()..":#FFFFFF'" .. backupColours[availableColourIndex][4]  .. " destek talebi açtı, acilen belirtilen lokasyona doğru hareket edin.", theArrayPlayer, 0, 0, 0, true)
						end
					end	
				end
			end		
		else
			outputChatBox("All the backup beacons are already in use.", thePlayer, 255, 194, 14)
		end
	--end
	end
end
addCommandHandler("destek", startBackup)

function destroyBlips(thePlayer)
	local availableColourIndex = false
	local factionShortName = ""
	for index, colorarray in ipairs(backupColours) do
		if (backupColours[index][5] == thePlayer) then
			availableColourIndex = index
		end		
	end
	
	if availableColourIndex then
		for a, b in ipairs(split(getTeamName(getPlayerTeam(thePlayer)), ' ')) do 
			factionShortName = factionShortName .. b:sub( 1, 1) 
		end
		backupColours[availableColourIndex][5] = false
		for keyValue, theArrayPlayer in ipairs( getElementsByType("player") ) do
			local pTheTeam = getPlayerTeam(theArrayPlayer)
			if pTheTeam then
				local pFactionType = getElementData(pTheTeam, "type")
				if allowedFactionTypes[pFactionType]  then
					triggerClientEvent(theArrayPlayer, "destroyBackupBlip", theArrayPlayer, availableColourIndex)
					local duty = tonumber(getElementData(theArrayPlayer, "duty"))
					if (duty > 0) then
						outputChatBox("#FF0000#575757"..exports["titan_pool"]:getServerName()..":#FFFFFF'".. backupColours[availableColourIndex][4]  .."' unit (" .. factionShortName ..")  ekibi destek talebini geri çekti, devriyeye devam edebilirsin.", theArrayPlayer, 0, 0, 0, true)
					end
				end	
			end
		end	
	end
end
addEventHandler("onPlayerQuit", getRootElement(), function() destroyBlips(source) end)
addEventHandler("savePlayer", getRootElement(), function() destroyBlips(source) end)

function syncBlips(thePlayer)
	destroyBlips(thePlayer)

	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	local duty = tonumber(getElementData(thePlayer, "duty"))
	if (allowedFactionTypes[factionType]) and (duty > 0) then
		for index, colorarray in ipairs(backupColours) do
			if (backupColours[index][5] ~= false) and (isElement(backupColours[index][5])) then
				triggerClientEvent(thePlayer, "createBackupBlip", backupColours[index][5], index, backupColours[index])
			end			
		end
	end
end
addEventHandler("onCharacterLogin", getRootElement(), function() setTimer(syncBlips, 2500, 1, source) end)
addEventHandler("onPlayerDuty", getRootElement(),  function() setTimer(syncBlips, 500, 1, source) end)
