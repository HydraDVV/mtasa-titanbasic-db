function showSpeedToAdmins(velocity)
	kph = math.ceil(velocity * 1.609344)
	exports.titan_global:sendMessageToAdmins("[Possible Speedhack/HandlingHack] " .. getPlayerName(client) .. ": " .. velocity .. "Mph/".. kph .." Kph")
end
addEvent("alertAdminsOfSpeedHacks", true)
addEventHandler("alertAdminsOfSpeedHacks", getRootElement(), showSpeedToAdmins)

function showDMToAdmins(kills)
	exports.titan_global:sendMessageToAdmins("AntiHile: " .. getPlayerName(client) .. ": " .. kills .. " kişiyi katletti. <= 2 dakika içerisinde bunları yaptı.")
end
addEvent("alertAdminsOfDM", true)
addEventHandler("alertAdminsOfDM", getRootElement(), showDMToAdmins)

-- Para Hilesi Tespit
function scanMoneyHacks()
	local tick = getTickCount()
	local hackers = { }
	local hackersMoney = { }
	local counter = 0
	
	local players = exports.titan_pool:getPoolElementsByType("player")
	for key, value in ipairs(players) do
		local logged = getElementData(value, "loggedin")
		if (logged==1) then
			if not (exports.titan_integration:isPlayerTrialAdmin(value)) then 
				
				local money = getPlayerMoney(value)
				local truemoney = exports.titan_global:getMoney(value)
				if (money) then
					if (money > truemoney) then
						counter = counter + 1
						hackers[counter] = value
						hackersMoney[counter] = (money-truemoney)
					end
				end
			end
		end
	end
	local tickend = getTickCount()

	local theConsole = getRootElement()
	for key, value in ipairs(hackers) do
		local money = hackersMoney[key]
		local accountID = getElementData(value, "account:id")
		local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
		outputChatBox("Anti Hile: " .. targetPlayerName .. " otomatik olarak sunucudan yasaklandı. Para Abusesi ($" .. tostring(money) .. ")", getRootElement(), 255, 0, 51)
	end
end
setTimer(scanMoneyHacks, 3600000, 0)