-- Hanz

local usernameCache = {}
local searched = {}
local refreshCacheRate = 10 --Minutes
function getUsername( clue )
	if not clue or string.len(clue) < 1 then
		return false
	end
 
	for i, username in pairs(usernameCache) do
		if username and string.lower(username) == string.lower(clue) then
			return username
		end
	end
	
	for i, player in pairs(getElementsByType("player")) do
		local username = getElementData(player, "account:username")
		if username and string.lower(username) == string.lower(clue) then
			table.insert(usernameCache, username)
			return username
		end
	end
	
	
	if not searched[clue] or getTickCount() - searched[clue] > refreshCacheRate*1000*60 then
		searched[clue] = getTickCount()
		triggerServerEvent("requestUsernameCacheFromServer", resourceRoot, clue) 
	else 
	end
	
	return false
end

function checkUsernameExistance(clue)
	if not clue or string.len(clue) < 1 then
		return false, "Please enter account name."
	end 
	local found = getUsername( clue )
	if found then
		return true, "Account name '"..found.."' is existed and valid!", found
	else
		return false, "Account name '"..clue.."' does not exist."
	end
end

function retrieveUsernameCacheFromServer(clue)
	if clue then
		table.insert(usernameCache, clue)
	end
end
addEvent("retrieveUsernameCacheFromServer", true)
addEventHandler("retrieveUsernameCacheFromServer", root, retrieveUsernameCacheFromServer)