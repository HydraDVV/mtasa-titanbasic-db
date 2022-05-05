local ids = { }

function playerJoin()
	local slot = nil
	
	for i = 1, 5000 do
		if (ids[i]==nil) then
			slot = i
			break
		end
	end
	
	ids[slot] = source
	exports.titan_anticheat:changeProtectedElementDataEx(source, "playerid", slot)
	exports.titan_pool:allocateElement(source, slot)
	idforname = ""..exports["titan_pool"]:getServerName().."Roleplay-" .. getElementData(source, "playerid") .. ""
	setPlayerName (source, idforname)
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)

function playerQuit()
	local slot = getElementData(source, "playerid")
	
	if (slot) then
		ids[slot] = nil
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)

function resourceStart()
	local players = exports.titan_pool:getPoolElementsByType("player")
	
	for key, value in ipairs(players) do
		ids[key] = value
		exports.titan_anticheat:changeProtectedElementDataEx(value, "playerid", key)
		exports.titan_pool:allocateElement(value, key)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)


function fakeMyID()
	local slot = nil
	for i = 1, 5000 do
		if (ids[i]==nil) then
			slot = i
			break
		end
	end
	
	local slotOld = getElementData(source, "playerid")
	
	if (slotOld) then
		ids[slotOld] = nil
	end
	
	ids[slot] = source
	exports.titan_anticheat:changeProtectedElementDataEx(source, "playerid", slot)
	exports.titan_pool:allocateElement(source, slot)
end
addEvent("fakemyid", true)
addEventHandler("fakemyid", getRootElement(), fakeMyID)