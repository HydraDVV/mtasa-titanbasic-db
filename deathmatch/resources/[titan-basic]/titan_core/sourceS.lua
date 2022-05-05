local maxPlayers = tonumber(getServerConfigSetting("maxplayers"))
local disallowedIdNumbers = {}

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		setMapName("Los Santos")
		setGameType("Yeni Roleplay Modu")
		setMaxPlayers(maxPlayers)
		setElementData(resourceRoot, "server.maxPlayers", maxPlayers)

		local players = getElementsByType("player")

		for k = 1, #players do
			local v = players[k]

			if isElement(v) then
				disallowedIdNumbers[k] = v
				setElementData(v, "playerID", k)
				setPlayerNametagShowing(v, false)
			end
		end
	end
)

addEventHandler("onPlayerJoin", getRootElement(),
	function ()
		local freeID = false

		for i = 1, maxPlayers do
			if not disallowedIdNumbers[i] then
				freeID = i
				break
			end
		end

		if freeID and isElement(source) then
			disallowedIdNumbers[freeID] = source
			setElementData(source, "playerID", freeID)
			setPlayerNametagShowing(source, false)
		end
	end
)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		local playerID = getElementData(source, "playerID")

		if playerID then
			disallowedIdNumbers[playerID] = nil
		end
	end
)

function sendMessageToAdmins(message, lvl)
	lvl = lvl or 1

	local players = getElementsByType("player")

	for k = 1, #players do
		local v = players[k]

		if isElement(v) then
			local adminLevel = getElementData(v, "admin_level") or 0

			if adminLevel ~= 0 and adminLevel >= lvl then
				outputChatBox("#d75959>> Yetkililere: #ffffff" .. tostring(message), v, 255, 255, 255, true)
			end
		end
	end
end

function outputErrorText(text, element)
	if text and isElement(element) then
		outputChatBox("#dc143c>> Titan: #ffffff" .. text, element, 0, 0, 0, true)
	end
end

function playSoundForElement(element, path)
	triggerClientEvent(element, "playClientSound", element, path)
end