mysql = exports.titan_mysql

function playerDeath(totalAmmo, killer, killerWeapon)
	if getElementData(source, "dbid") then
		if getElementData(source, "adminjailed") then
			local team = getPlayerTeam(source)
			spawnPlayer(source, 232.3212890625, 160.5693359375, 1003.0234375, 270) --, team)
			
			setElementModel(source,getElementModel(source))
			setPlayerTeam(source, team)
			setElementInterior(source, 9)
			setElementDimension(source, 3)
			
			setCameraInterior(source, 9)
			setCameraTarget(source)
			fadeCamera(source, true)
			
			exports.titan_logs:dbLog(source, 34, source, "died in admin jail")
		elseif getElementData(source, "jailed") then
			exports["titan_prison"]:checkForRelease(source)
			
		else
			local affected = { }
			table.insert(affected, source)
			local killstr = ' died'
			if (killer) then
				killstr = ' got killed by '..getPlayerName(killer).. ' ('..getWeaponNameFromID ( killerWeapon )..')'
				table.insert(affected, killer)
			end
			outputChatBox("Bayıldınız, ayılmayı bekleyin!", source,255,255,255)
			setElementData(source, "baygin", true)
			-- Remove seatbelt if theres one on
			if (getElementData(source, "seatbelt") == true) then
				setElementData(source, "seatbelt", false, true)
			end
			
			-- Hanz
			setElementData(source, "dead", 1)
			local x,y,z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			local team = getPlayerTeam(source)
			local rotx, roty, rotz = getElementRotation(source)
			local skin = getElementModel(source)
			
			spawnPlayer(source, x, y, z, rotz, skin, int, dim, team)
			
			setElementFrozen(source, true)
			setPedHeadless(source, false)
			setCameraInterior(source, int)
			setCameraTarget(source, source) 

			setPlayerTeam(source, team)
			setElementInterior(source, int)
			setElementDimension(source, dim)
			
			setElementHealth(source, 5)
			exports.titan_global:applyAnimation( source, "ped", "FLOOR_hit_f", 0, false, true, true)
			--setPedAnimation(source, "ped", "FLOOR_hit_f", 0, true, true, true)
			
			triggerClientEvent(source, "playerdeath", source)

			setElementData(source, "lastdeath", " [KILL] "..getPlayerName(source):gsub("_", " ") .. killstr, true)
		end
	end
end
addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

-- Hanz
function changeDeathView(source, victimDropItem)
	if isPedDead(source) then
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		setCameraMatrix(source, x+6, y+6, z+3, x, y, z)
		triggerClientEvent(source,"es-system:showRespawnButton",source, victimDropItem)
	end
end
addEvent("changeDeathView", true)
addEventHandler("changeDeathView", getRootElement(), changeDeathView)


function acceptDeath(thePlayer, victimDropItem)
	if getElementData(thePlayer, "dead") == 1 then		
		fadeCamera(thePlayer, true)
		setElementData(thePlayer, "baygin", nil)

		setElementHealth(thePlayer, 100)
		setElementData(thePlayer, "poop", 20)
		setElementData(thePlayer, "pee", 20)
		setElementData(thePlayer, "hunger", 20)
		setElementData(thePlayer, "thirst", 20)
		setElementFrozen(thePlayer, false)
		setElementData(thePlayer, "dead", 0)
		exports.titan_global:removeAnimation(thePlayer)
		--respawnPlayer(thePlayer, victimDropItem)
--	else
--		outputChatBox("You aren't dead!", thePlayer, 255, 0, 0)
	end
end
addEvent("es-system:acceptDeath", true)
addEventHandler("es-system:acceptDeath", getRootElement(), acceptDeath)
--addCommandHandler("acceptdeath", acceptDeath)
--addCommandHandler("spawn", acceptDeath)

function logMe( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports.titan_global:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function logMeNoWrn( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("Recent kill list:", thePlayer, 205, 201, 165)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer, 205, 201, 165, true)
		end
		outputChatBox("  END", thePlayer, 205, 201, 165)
	end
end
addCommandHandler("showkills", readLog)

function respawnPlayer(thePlayer, victimDropItem)
	if (isElement(thePlayer)) then
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.titan_global:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer):gsub("_", " ").." died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
		
		local cost = math.random(175, 500)		
		local tax = exports.titan_global:getTaxAmount()
		
		exports.titan_global:giveMoney( getTeamFromName("Los Santos Medical Department"), math.ceil((1-tax)*cost) )
		exports.titan_global:takeMoney( getTeamFromName("Government of Los Santos"), math.ceil((1-tax)*cost) )
			
		dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. (getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)

		outputChatBox("You have recieved treatment from Los Santos Medical Department.", thePlayer, 255, 255, 0)
		
		-- take all drugs
		local count = 0
		for i = 30, 43 do
			while exports.titan_global:hasItem(thePlayer, i) do
				local number = exports['titan_items']:countItems(thePlayer, i)
				exports.titan_global:takeItem(thePlayer, i)
				exports.titan_logs:logMessage("[SFES Death] " .. getElementData(thePlayer, "account:username") .. "/" .. getPlayerName(thePlayer) .. " lost "..number.."x item "..tostring(i), 28)
				exports.titan_logs:dbLog(thePlayer, 34, thePlayer, "lost "..number.."x item "..tostring(i))
				count = count + 1
			end
		end
		if count > 0 then
			outputChatBox("SFES Employee: We handed your drugs over to the SFPD.", thePlayer, 255, 194, 14)
		end
		
		-- take guns
		local removedWeapons = nil
		if not victimDropItem then
			local gunlicense = tonumber(getElementData(thePlayer, "license.gun"))
			local gunlicense2 = tonumber(getElementData(thePlayer, "license.gun2"))
			local team = getPlayerTeam(thePlayer)
			local factiontype = getElementData(team, "type")
			local items = exports['titan_items']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
			
			local formatedWeapons
			local correction = 0
			for itemSlot, itemCheck in ipairs(items) do
				if (itemCheck[1] == 115) or (itemCheck[1] == 116) then -- Weapon
					-- itemCheck[2]: [1] = gta weapon id, [2] = serial number/Amount of bullets, [3] = weapon/ammo name
					local itemCheckExplode = exports.titan_global:explode(":", itemCheck[2])
					local weapon = tonumber(itemCheckExplode[1])
					local ammountOfAmmo
					if (((weapon >= 16 and weapon <= 40 and (gunlicense == 0 and gunlicense2 == 0)) or (weapon == 29 or weapon == 30 or weapon == 32 or weapon ==31 or weapon == 34) and (gunlicense2 == 0)) and factiontype ~= 2) or (weapon >= 35 and weapon <= 38)  then -- (weapon == 4 or weapon == 8)
						exports['titan_items']:takeItemFromSlot(thePlayer, itemSlot - correction)
						correction = correction + 1
						
						if (itemCheck[1] == 115) then
							exports.titan_logs:dbLog(thePlayer, 34, thePlayer, "lost a weapon (" ..  itemCheck[2] .. ")")
							
							for k = 1, 12 do
								triggerEvent("createWepObject", thePlayer, thePlayer, k, 0, getSlotFromWeapon(k))
							end
						else
							exports.titan_logs:dbLog(thePlayer, 34, thePlayer, "lost a magazine of ammo (" ..  itemCheck[2] .. ")")
							local splitArray = split(itemCheck[2], ":")
							ammountOfAmmo = splitArray[2]
						end
						
						if (removedWeapons == nil) then
							if ammountOfAmmo then
								removedWeapons = ammountOfAmmo .. " " .. itemCheckExplode[3]
								formatedWeapons = ammountOfAmmo .. " " .. itemCheckExplode[3]
							else
								removedWeapons = itemCheckExplode[3]
								formatedWeapons = itemCheckExplode[3]
							end
						else
							if ammountOfAmmo then
								removedWeapons = removedWeapons .. ", " .. ammountOfAmmo .. " " .. itemCheckExplode[3]
								formatedWeapons = formatedWeapons .. "\n" .. ammountOfAmmo .. " " .. itemCheckExplode[3]
							else
								removedWeapons = removedWeapons .. ", " .. itemCheckExplode[3]
								formatedWeapons = formatedWeapons .. "\n" .. itemCheckExplode[3]
							end
						end
					end
				end
			end
		end
		if (removedWeapons~=nil) then
			if gunlicense == 0 and factiontype ~= 2 then
				outputChatBox("SFES Employee: We have taken away weapons which you did not have a license for. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			else
				outputChatBox("SFES Employee: We have taken away weapons which you are not allowed to carry. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			end
		end
		
		local death = getElementData(thePlayer, "lastdeath")
		if removedWeapons ~= nil then
			logMe(death)
			exports.titan_global:sendMessageToAdmins("/showkills to view lost weapons.")
			logMeNoWrn("#FF0033 Lost Weapons: " .. removedWeapons)
		else
			logMe(death)
		end
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		 
		spawnPlayer(thePlayer, 1176.892578125, -1323.828125, 14.04377746582, 275)--, theTeam)
		setElementModel(thePlayer,theSkin)
		setPlayerTeam(thePlayer, theTeam)
		setElementInterior(thePlayer, 0)
		setElementDimension(thePlayer, 0)
				
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
	end
end

function recoveryPlayer(thePlayer, commandName, targetPlayer, duration)
	if not (targetPlayer) or not (duration) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick / ID] [Hours]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			local logged = getElementData(thePlayer, "loggedin")
	
			if (logged==1) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				
				if (factionType==4) or (exports.titan_integration:isPlayerTrialAdmin(thePlayer) == true) then
					--if (targetPlayer == thePlayer) then
						local dimension = getElementDimension(thePlayer)
						--if (dimesion==9) then
							totaltime = tonumber(duration)
							if totaltime < 12 then
								local money = exports.titan_bank:takeBankMoney(targetPlayer, 100*totaltime)
								if not money then
									outputChatBox("This player does not have enough money in their bank to be placed in recovery.", thePlayer, 255, 0, 0)
									return 
								end
								exports.titan_global:giveMoney( getTeamFromName("Los Santos Fire Department"), 100*totaltime )
								local dbid = getElementData(targetPlayer, "dbid")
								dbExec(mysql:getConnection(), "UPDATE characters SET recovery='1' WHERE id = " .. dbid)
								setElementFrozen(targetPlayer, true)
								outputChatBox("You have successfully put " .. targetPlayerName .. " in recovery for " .. duration .. " hour(s) and charged $".. 100*totaltime ..".", thePlayer, 255, 0, 0)
								exports.titan_global:sendMessageToAdmins("AdmWrn: " .. targetPlayerName .. " was put in recovery for " .. duration .. " hour(s) by " .. getPlayerName(thePlayer):gsub("_"," ") .. ".")
								outputChatBox("You were put in recovery by " .. getPlayerName(thePlayer) .. " for " .. duration .. " hour(s) and charged $".. 100*totaltime ..".", targetPlayer, 255, 0, 0)
								local r = getRealTime()
								if r.hour + duration >= 24 then
									local timeString = ("%04d%02d%02d%02d%02d%02d"):format(r.year+1900, r.month + 1, r.monthday + 1, r.hour + duration - 24,r.minute, r.second)
									dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime='" ..timeString.. "' WHERE id = " .. dbid)
								else
									local timeString = ("%04d%02d%02d%02d%02d%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour + duration,r.minute, r.second)
									dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime='" ..timeString.. "' WHERE id = " .. dbid) 
								end
							else
								outputChatBox("You cannnot put someone in recovery for that much time.", thePlayer, 255, 0, 0)
							end
						--[[else
							outputChatBox("You must be in the hospital to do this command.", thePlayer, 255, 0, 0)
						end]]
					--[[else
						outputChatBox("You cannot recover yourself.", thePlayer, 255, 0, 0)
					end]]
				else
					outputChatBox("You have no basic medic skills, contact the ES.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("The player is not logged in.", thePlayer, 255,0,0)
			end
		end
	end
end
addCommandHandler("recovery", recoveryPlayer)

function prescribe(thePlayer, commandName, ...)
    local team = getPlayerTeam(thePlayer)
	if (getTeamName(team)=="Los Santos Fire Department") then
		if not (...) then
			outputChatBox("SYNTAX /" .. commandName .. " [prescription value]", thePlayer, 255, 184, 22)
		else
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue
			if not(itemValue=="") then
				exports.titan_global:giveItem( thePlayer, 132, itemValue )
				outputChatBox("The prescription '" .. itemValue .. "' has been processed.", thePlayer, 0, 255, 0)
				exports.titan_global:sendMessageToAdmins(getPlayerName(thePlayer):gsub("_"," ") .. " has made a prescription with the value of: " .. itemValue .. ".")
				exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "PRESCRIPTION " .. itemValue)
			end
		end
	end
end
addCommandHandler("prescribe", prescribe)

-- /revive
function revivePlayerFromPK(thePlayer, commandName, targetPlayer)
	if (exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Kullanım: /" .. commandName .. " [Karakter Adı & ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if getElementData(targetPlayer, "dead") == 1 then
					triggerClientEvent(targetPlayer,"es-system:closeRespawnButton",targetPlayer)
					--fadeCamera(thePlayer, true)
					--outputChatBox("Respawning...", thePlayer)
					
					local x,y,z = getElementPosition(targetPlayer)
					local int = getElementInterior(targetPlayer)
					local dim = getElementDimension(targetPlayer)
					local skin = getElementModel(targetPlayer)
					local team = getPlayerTeam(targetPlayer)
					setElementData(targetPlayer, "baygin", nil)
					
					setPedHeadless(targetPlayer, false)
					setCameraInterior(targetPlayer, int)
					setCameraTarget(targetPlayer, targetPlayer)
					setElementData(targetPlayer, "dead", 0)	 
					spawnPlayer(targetPlayer, x, y, z, 0)--, team)
					
					setElementModel(targetPlayer,skin)
					setPlayerTeam(targetPlayer, team)
					setElementInterior(targetPlayer, int)
					setElementDimension(targetPlayer, dim)
					acceptDeath(targetPlayer)
					triggerClientEvent(targetPlayer, "bayilmaRevive", targetPlayer)
					triggerEvent("updateLocalGuns", targetPlayer)
					local adminTitle = tostring(exports.titan_global:getPlayerAdminTitle(thePlayer))
					
					--outputChatBox("[-] "..tostring(exports.titan_global:getPlayerAdminTitle(thePlayer)).." "..tostring(getPlayerName(thePlayer):gsub("_"," ")).." tarafından canlandırıldınız.", targetPlayer, 0, 255, 0, true)
					--outputChatBox("[-] "..tostring(getPlayerName(targetPlayer):gsub("_"," ")).." isimli oyuncuyu canlandırdınız.", thePlayer, 0, 255, 0, true)
					exports["titan_infobox"]:addBox(targetPlayer, "success", tostring(exports.titan_global:getPlayerAdminTitle(thePlayer)).." "..tostring(getPlayerName(thePlayer):gsub("_"," ")).." tarafından canlandırıldınız.")
					exports["titan_infobox"]:addBox(thePlayer, "success", tostring(getPlayerName(targetPlayer):gsub("_"," ")).." isimli oyuncuyu canlandırdınız.")
					exports.titan_global:sendMessageToAdmins("AdmCmd: "..tostring(exports.titan_global:getPlayerAdminTitle(thePlayer)).." "..getPlayerName(thePlayer).." isimli yetkili "..tostring(getPlayerName(targetPlayer)).." isimli oyuncuyu canlandırdı.")
					exports.titan_logs:dbLog(thePlayer, 4, targetPlayer, "REVIVED from PK")
				else
					exports["titan_infobox"]:addBox(thePlayer, "error", tostring(getPlayerName(targetPlayer):gsub("_"," ")).." bu oyuncu baygın değil.")
				end
			end
		end
	end
end
addCommandHandler("revive", revivePlayerFromPK, false, false)

addEvent('sync-animation', true)
addEventHandler('sync-animation', root,
	function(player, progress)
		if tonumber(progress) then
			setPedAnimationProgress(player, "car_crawloutrhs", progress)
		else
			setPedAnimation(player, "ped", "car_crawloutrhs")
		end
	end
)



local tedaviyeri = createColSphere (  1592.5322265625, 1798.630859375, 2083.376953125, 6)
setElementInterior(tedaviyeri, 10)
setElementDimension(tedaviyeri, 180)


function tedaviOlma(thePlayer)

	local vip = getElementData(thePlayer,"vipver")
	local health = 100
	
	if isElementWithinColShape(thePlayer, tedaviyeri) then
		if getElementData(thePlayer,"money") <= 200 then
				exports["titan_infobox"]:addBox(thePlayer, "warning", "Fakir olduğunuz için devlet sizin tedavi masraflarınızı karşıladı.")
				setElementHealth(thePlayer, tonumber(health))
		return end
			if (vip >= 1) then
				exports["titan_infobox"]:addBox(thePlayer, "success", "VIP olduğunuz için devlet size ücretsiz tedavi sağladı.")
				setElementHealth(thePlayer , tonumber(health))		
			else
				exports["titan_infobox"]:addBox(thePlayer, "success", "$200 ücret karşılığında başarıyla tedavi oldunuz.")
				exports.titan_global:takeMoney(thePlayer, 200)
				setElementHealth(thePlayer , tonumber(health))
			end
	else
		outputChatBox("#f58473[-] #f9f9f9Bu alanda tedavi olamazsın.",thePlayer,114, 175, 232,true)
		outputChatBox("#f58473[-] #f9f9f9Tedavi olmak için 'Los Santos Medical Department' konumuna gitmelisin.",thePlayer,114, 175, 232,true)	
	end
end

addCommandHandler("tedaviol",tedaviOlma)