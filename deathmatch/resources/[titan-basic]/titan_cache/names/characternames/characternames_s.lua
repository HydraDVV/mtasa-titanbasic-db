local mysql = exports.titan_mysql
local characterNameCache = {}
local searched = {}
local refreshCacheRate = 60 --Minutes
function getCharacterNameFromID( id )
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if characterNameCache[id] then
		return characterNameCache[id]
	end
	
	for i, player in pairs(exports.titan_pool:getPoolElementsByType('player')) do
		if id == getElementData(player, "dbid") then
			characterNameCache[id] = exports.titan_global:getPlayerName(player)
			return characterNameCache[id]
		end
	end
	
	if searched[id] then
		return false
	end
	searched[id] = true
	setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate*1000*60, 1)
	
	local row = exports.titan_global:getCache("characters", id, "id")
	if row then
		return row.charactername
	end
	return false
end

function requestCharacterNameCacheFromServer(id)
	local found = getCharacterNameFromID( id )
	triggerClientEvent(client, "retrieveCharacterNameCacheFromServer", client, found, id)
end
addEvent("requestCharacterNameCacheFromServer", true)
addEventHandler("requestCharacterNameCacheFromServer", root, requestCharacterNameCacheFromServer)
