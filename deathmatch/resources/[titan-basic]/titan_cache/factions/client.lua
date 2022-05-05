-- Hanz
local factionNameCache = {}
local searched = {}
local refreshCacheRate = 10 --Minutes
function getFactionNameFromId( id )
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if factionNameCache[id] then
		return factionNameCache[id]
	end
	
	local faction = exports.titan_factions:getTeamFromFactionID(id)
	if faction then
		factionNameCache[id] = getTeamName(faction)
		return factionNameCache[id]
	end

	if not searched[id] or getTickCount() - searched[id] > refreshCacheRate*1000*60 then
		searched[id] = getTickCount()
		triggerServerEvent("requestFactionNameCacheFromServer", localPlayer, id)
	else 
		return false
	end

	return "Loading.."
end

function retrieveFactionNameCacheFromServer(factionName, id)
	if factionName and id then
		factionNameCache[id] = factionName
	end
end
addEvent("retrieveFactionNameCacheFromServer", true)
addEventHandler("retrieveFactionNameCacheFromServer", root, retrieveFactionNameCacheFromServer)