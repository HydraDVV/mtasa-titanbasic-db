-- Hanz
local mysql = exports.titan_mysql
local refreshCacheRate = 10
local usernameCache = {}
local searched = {}
function getUsername( clue )
	if not clue or string.len(clue) < 1 then
		return false
	end
	
	for i, username in pairs(usernameCache) do
		if username and string.lower(username) == string.lower(clue) then
			return username
		end
	end
	
	for i, player in pairs(exports.titan_pool:getPoolElementsByType("player")) do
		local username = getElementData(player, "account:username")
		if username and string.lower(username) == string.lower(clue) then
			usernameCache[getElementData(player, "account:id")] = username
			return username
		end
	end
	
	if not searched[clue] then
		local value = exports.titan_global:getCache("accounts", clue, "username")
		if value then
		usernameCache[tonumber(value["id"])] = value["username"]
			return value["username"]
		end
		
		searched[clue] = true
		setTimer(function()
			local index = clue
			searched[index] = nil
		end, refreshCacheRate*1000*60, 1)
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
		return true, "Account name '"..found.."' is existed and valid!"
	else
		return false, "Account name '"..clue.."' does not exist."
	end
end

function requestUsernameCacheFromServer(clue)
	local found = getUsername( clue )
	triggerClientEvent(client, "retrieveUsernameCacheFromServer", source, found)
end
addEvent("requestUsernameCacheFromServer", true)
addEventHandler("requestUsernameCacheFromServer", root, requestUsernameCacheFromServer)

function getUsernameFromId(id)
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if usernameCache[id] then
		return usernameCache[id]
	end
	
	for i, player in pairs(exports.titan_pool:getPoolElementsByType("player")) do
		if id == getElementData(player, "account:id") then
			usernameCache[id] = getElementData(player, "account:username")
			return usernameCache[id]
		end
	end
	
	if searched[id] then
		return false
	end
	searched[id] = true

	local accounts, characters = exports.titan_account:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.id == id then
			usernameCache[tonumber(value["id"])] = value["username"]
			return value["username"]
		end
	end

	setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	return false
end

local accountCache = {}
local accountCacheSearched = {}
function getAccountFromCharacterId(id)
	if id and tonumber(id) then
		id = tonumber(id)
	else
		return false
	end
	if accountCache[id] then
		return accountCache[id]
	end
	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "dbid") == id then
			accountCache[id] = {id = getElementData(player, "account:id"), username = getElementData(player, "account:username")}
			return accountCache[id]
		end
	end

	if accountCacheSearched[id] then
		return false
	end
	accountCacheSearched[id] = true

	local accounts, characters = exports.titan_account:getTableInformations()
	for index, value in ipairs(characters) do
		if value.account == id then
			usernameCache[tonumber(value["id"])] = value["username"]
			accountCache[id] = {id = tonumber(value.id), username = value.username}
			return accountCache[id]
		end
	end

	setTimer(function()
		local index = id
		accountCacheSearched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	return false
end