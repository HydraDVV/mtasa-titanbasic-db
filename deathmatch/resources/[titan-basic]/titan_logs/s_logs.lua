local lastLogType = -1
local lastData = ""
local lastLogsource = getRootElement()
local mysql = exports.titan_mysql

local allowedLog = {
	[3] = true,
	[4] = true,
	[15] = true,
	[25] = true,
	[31] = true,
	[39] = true,
	[40] = true,
	[34] = true
	
}

function dbLog(logSource, actionID, affected, data)
	lastLogType = actionID
	lastData = data
	lastLogsource = logSource
	if not allowedLog[actionID] then return end
	-- Check the source
	if logSource == nil then 
--		outputDebugString("logs:dbLog: No logSource on "..tostring(actionID))
		return false
	end
	
	local sourceStr = dbLogDetectTypeSource(logSource)
	if sourceStr == false then
--		outputDebugString("logs:dbLog: No sourceStr on"..tostring(actionID))
		return false
	end
	
	-- Check the action
	if actionID == nil then
--		outputDebugString("logs:dbLog: No actionID")
		return false
	end
	if not tonumber(actionID) then
--		outputDebugString("logs:dbLog: actionID is not numeric")
		return false
	end
	local actionStr = tostring(actionID)
	
	-- check affected people
	if affected == nil then 
--		outputDebugString("logs:dbLog: No affected")
		return false
	end
	local affectedStr = dbLogDetectTypeSource(affected)
	if affectedStr == false then
--		outputDebugString("logs:dbLog: No affectedStr")
		return false 
	end
	affectedStr = affectedStr .. ";"
	
	-- Check data
	if not data then
		data = "N/A"
	end
	
	local r = getRealTime()
	
	local timeString = ("%04d-%02d-%02d %02d:%02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute, r.second)
	
	local timeString = ("%04d-%02d-%02d %02d:%02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute, r.second)
	dbExec(mysql:getConnection(), "INSERT INTO `logs` VALUES ('"..timeString.."', '".. (actionStr) .."', '".. (sourceStr).."', '".. (affectedStr).."', '".. (data).."')") 
	return true
end

function dbLogDetectTypeSource( theElement )
	local sourceType = type(theElement)
	if sourceType == 'string' then
		return theElement
	elseif sourceType == 'userdata' then -- an Element
		local possibleResult = getElementLogID( theElement )
		if not possibleResult then
--			outputDebugString("logs:dbLog: Unknown element theElement on "..tostring(lastLogType) .. ":"..tostring(lastLogsource))
--			outputDebugString(tostring(data))
			return
		end
		return possibleResult
	elseif sourceType == 'table' then
		local returnStr = ''
		for _, tableValue in pairs( theElement ) do
			local tableValueResult = dbLogDetectTypeSource(tableValue)
			if tableValueResult then
				if returnStr ~= '' then
					returnStr = returnStr .. ";" .. tableValueResult 
				else
					returnStr = tableValueResult 
				end
			end
		end
		if returnStr ~= '' then
			return returnStr
		end
	end
	return false
end

function getElementLogID( theElement )
	if isElement(theElement) then
		local elementType = getElementType(theElement)
		if (elementType == 'player') then
			local dbid = getElementData(theElement, "dbid")
			if dbid then
				return "ch".. tostring(dbid)
			end
		elseif (elementType == 'vehicle') then
			local dbid = getElementData(theElement, "dbid")
			if dbid then
				return "ve".. tostring(dbid)
			end
		elseif (elementType == 'team') then
			local dbid = getElementData(theElement, "id")
			if dbid then
				return "fa".. tostring(dbid)
			end
		elseif (elementType == 'ped') then
			local dbid = getElementData(theElement, "ped:type")
			if dbid then
				return "pe".. tostring(dbid)
			end
		elseif (elementType == 'interior') then
			local dbid = getElementData(theElement, "dbid")
			if dbid then
				return "in".. tostring(dbid)
			end
		elseif (elementType == 'object') then
			local dbid = getElementData(theElement, "id")
			if dbid then
				return "ob".. tostring(dbid)
			end
		else
--			outputDebugString("Log type mismatch: " .. getElementType(theElement))
		end
	end
	return false
end

function logMessage(message, type)
	return true
end