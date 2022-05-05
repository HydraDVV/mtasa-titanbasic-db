local spam = {}
local zaman = {}
local spamkapatsure = 500

function komutkullandi( commandName )
if not exports.titan_integration:isPlayerDeveloper(source) then
if getElementData(source, "komutkullanimikapat") == false or getElementData(source, "komutkullanimikapat") == 0 then
spam[source] = tonumber(spam[source] or 0) + 1
		if spam[source] >= 2 then
			local playerName = getPlayerName( source ):gsub('_', ' ')
			outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9 Lütfen işlemlerinizi yavaş gerçekleştirin.", source, 35, 35, 35, true)
			exports.titan_anticheat:changeProtectedElementDataEx(source, "komutkullanimikapat", true)
			setElementData(source, "komutkullanimikapat", true)
		   cancelEvent()
		end
	
		if isTimer(zaman[source]) then
			killTimer(zaman[source])
		end
	
		zaman[source] = setTimer(	function (source)
			spam[source] = 0
			
			if isElement(source) and getElementData(source, "komutkullanimikapat") == true or getElementData(source, "komutkullanimikapat") then
				exports.titan_anticheat:changeProtectedElementDataEx(source, "komutkullanimikapat", false)
				setElementData(source, "komutkullanimikapat", false)
			end
		end, spamkapatsure, 1, source)
	else
		cancelEvent()
	end
end
end
addEventHandler('onPlayerCommand', root, komutkullandi)