mysql = exports.titan_mysql

local smallRadius = 5 --units

-- /fingerprint
function fingerprintPlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						local fingerprint = getElementData(targetPlayer, "fingerprint")
						outputChatBox(targetPlayerName .. "'s Fingerprint: " .. tostring(fingerprint) .. ".", thePlayer, 255, 194, 14)
					else
						outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fingerprint", fingerprintPlayer, false, false)

-- /ticket
function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		local factionID = getElementData(theTeam, "id")
		
		if (factionID==1 or factionID==78) then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick] [Amount] [Reason]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						amount = tonumber(amount)
						local reason = table.concat({...}, " ")
						
						local money = exports.titan_global:getMoney(targetPlayer)
						local bankmoney = getElementData(targetPlayer, "bankmoney")
						
						local takeFromCash = math.min( money, amount )
						local takeFromBank = amount - takeFromCash
						exports.titan_global:takeMoney(targetPlayer, takeFromCash)
							
							
						-- Distribute money between the PD and Government
						local tax = exports.titan_global:getTaxAmount()
								
						exports.titan_global:giveMoney( theTeam, math.ceil((1-tax)*amount) )
						exports.titan_global:giveMoney( getTeamFromName("Government of Los Santos"), math.ceil(tax*amount) )
						
						outputChatBox("You ticketed " .. targetPlayerName .. " for " .. exports.titan_global:formatMoney(amount) .. ". Reason: " .. reason .. ".", thePlayer)
						outputChatBox("You were ticketed for " .. exports.titan_global:formatMoney(amount) .. " by " .. getPlayerName(thePlayer) .. ". Reason: " .. reason .. ".", targetPlayer)
						if takeFromBank > 0 then
							outputChatBox("Since you don't have enough money with you, $" .. exports.titan_global:formatMoney(takeFromBank) .. " have been taken from your bank account.", targetPlayer)
							exports.titan_anticheat:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney - takeFromBank, false)
						end
						exports.titan_logs:logMessage("[PD/TICKET] " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a ticket. Amount: $".. exports.titan_global:formatMoney(amount).. " Reason: "..reason , 30)
					else
						outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("ticket", ticketPlayer, false, false)

function takeLicense(thePlayer, commandName, targetPartialNick, licenseType, hours)

	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
	
		if (ftype==2) or exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
			if not (targetPartialNick) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
			else
				hours = tonumber(hours)
				if not (licenseType) or not (hours) or hours < 0 or (hours > 10 and not exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
					outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
				else
					local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPartialNick)
					if targetPlayer then
						local name = getPlayerName(thePlayer)
						
						if (tonumber(licenseType)==1) then
							if(tonumber(getElementData(targetPlayer, "license.car")) == 1) then
								dbExec(mysql:getConnection(), "UPDATE characters SET car_license='" .. (-hours) .. "' WHERE id=" ..(getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name.." has revoked your driving license.", targetPlayer, 255, 194, 14)
								outputChatBox("You have revoked " .. targetPlayerName .. "'s driving license.", thePlayer, 255, 194, 14)
								exports.titan_anticheat:changeProtectedElementDataEx(targetPlayer, "license.car", -hours, true)
								exports.titan_logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their driving license for  "..hours.." hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a driving license.", thePlayer, 255, 0, 0)
							end
						elseif (tonumber(licenseType)==2) then
							if(tonumber(getElementData(targetPlayer, "license.gun")) == 1) then
								dbExec(mysql:getConnection(), "UPDATE characters SET gun_license='" .. (-hours) .. "' WHERE id=" .. (getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name.." has revoked your weapon license.", targetPlayer, 255, 194, 14)
								outputChatBox("You have revoked " .. targetPlayerName .. "'s weapon license.", thePlayer, 255, 194, 14)
								exports.titan_anticheat:changeProtectedElementDataEx(targetPlayer, "license.gun", -hours, true)
								exports.titan_logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their gun license for  "..hours.." hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a weapon license.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("License type not recognised.", thePlayer, 255, 194, 14)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("takelicense", takeLicense, false, false)

function tellNearbyPlayersVehicleStrobesOn()
	for _, nearbyPlayer in ipairs(exports.titan_global:getNearbyElements(source, "player", 300)) do
		triggerClientEvent(nearbyPlayer, "forceElementStreamIn", source)
	end
end
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), tellNearbyPlayersVehicleStrobesOn)