wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu, bInformation, bBlindfold, bStabilize = nil
sent = false
ax, ay = nil
player = nil
gotClick = false
closing = false

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if (element) and (getElementType(element)=="player") and (button=="right") and (state=="down") and (sent==false) then
		local x, y, z = getElementPosition(getLocalPlayer())
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=5) then
			if (wRightClick) then
				hidePlayerMenu()
			end
			--showCursor(true)
			ax = absX
			ay = absY
			player = element
			sent = true
			closing = false
			
			if(element == getLocalPlayer()) then
				showPlayerSelfMenu()
			else
				--showPlayerMenu(player, isFriendOf(getElementData(player, "account:id")))
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPlayer, true)

function showPlayerSelfMenu()
	local row = {}
	local rcMenu
	local playerid = tonumber(getElementData(getLocalPlayer(), "playerid")) or 0

	if getElementData(getLocalPlayer(), "realism:stretcher:hasStretcher") then
		if not rcMenu then
			rcMenu = exports['titan_rightclick']:create("Me ("..tostring(playerid)..")")
		end
		row.stretcher = exports['titan_rightclick']:addRow("Leave stretcher")
		addEventHandler("onClientGUIClick", row.stretcher, leaveStretcher, false)
	end
	sent = false
end

function showPlayerMenu(targetPlayer, friend)
	local row = {}
	local rcMenu
	local playerid = tonumber(getElementData(targetPlayer, "playerid")) or 0
	rcMenu = exports.titan_rightclick:create(string.gsub(exports.titan_global:getPlayerName(targetPlayer), "_", " ").." ("..tostring(playerid)..")")
	
	if not friend then
		bAddAsFriend = exports['titan_rightclick']:addRow("Add as friend")
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = exports['titan_rightclick']:addRow("Remove as friend")
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end

	-- FRISK
	bFrisk = exports['titan_rightclick']:addRow("Frisk")
	addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	
	-- RESTRAIN
	local cuffed = getElementData(player, "restrain")
	if cuffed == 0 then
		bRestrain = exports['titan_rightclick']:addRow("Restrain")
		addEventHandler("onClientGUIClick", bRestrain, crestrainPlayer, false)
	else
		bRestrain = exports['titan_rightclick']:addRow("Unrestrain")
		addEventHandler("onClientGUIClick", bRestrain, cunrestrainPlayer, false)
		-- FRISK
		bFrisk = exports['titan_rightclick']:addRow("Frisk")
		addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	end
	
	-- BLINDFOLD
	local blindfold = getElementData(player, "blindfold")
	if (blindfold) and (blindfold == 1) then
		bBlindfold = exports['titan_rightclick']:addRow("Remove blindfold")
		addEventHandler("onClientGUIClick", bBlindfold, cremoveBlindfold, false)
	else
		bBlindfold = exports['titan_rightclick']:addRow("Blindfold")
		addEventHandler("onClientGUIClick", bBlindfold, cBlindfold, false)
	end
	
	-- STABILIZE
	if exports.titan_global:hasItem(getLocalPlayer(), 70) and getElementData(player, "injuriedanimation") then
		bStabilize = exports['titan_rightclick']:addRow("Stabilize")
		addEventHandler("onClientGUIClick", bStabilize, cStabilize, false)
	end

	-- Stretcher system
	local stretcherElement = getElementData(getLocalPlayer(), "realism:stretcher:hasStretcher") 
	if stretcherElement then
		local stretcherPlayer = getElementData( stretcherElement, "realism:stretcher:playerOnIt" )
		if stretcherPlayer and stretcherPlayer == player then
			bStabilize = exports['titan_rightclick']:addRow("Take from stretcher")
			addEventHandler("onClientGUIClick", bStabilize, fTakeFromStretcher, false)
		end
		if not stretcherPlayer then
			bStabilize = exports['titan_rightclick']:addRow("Lay on stretcher")
			addEventHandler("onClientGUIClick", bStabilize, fLayOnStretcher, false)
		end
	end
	
	bInformation = exports['titan_rightclick']:addRow("Information")
	addEventHandler("onClientGUIClick", bInformation, showPlayerInfo, false)

	sent = false
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

function fTakeFromStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:takePedFromStretcher", getLocalPlayer(), player)
		hidePlayerMenu()
	end
end

function fLayOnStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:movePedOntoStretcher", getLocalPlayer(), player)
		hidePlayerMenu()
	end
end

function leaveStretcher()
	triggerServerEvent("stretcher:leaveStretcher", getLocalPlayer())
end

function showPlayerInfo(button, state)
		triggerServerEvent("social:look", player)
		hidePlayerMenu()
end


--------------------
--   STABILIZING  --
--------------------

function cStabilize(button, state)
	if button == "left" and state == "up" then
		if (exports.titan_global:hasItem(getLocalPlayer(), 70)) then -- Has First Aid Kit?
			local knockedout = getElementData(player, "injuriedanimation")
			
			if not knockedout then
				outputChatBox("This player is not knocked out.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("stabilizePlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("You do not have a First Aid Kit.", 255, 0, 0)
		end
	end
end

--------------------
--  BLINDFOLDING  --
-------------------
function cBlindfold(button, state, x, y)
	if (button=="left") then
		if (exports.titan_global:hasItem(getLocalPlayer(), 66)) then -- Has blindfold?
			local blindfolded = getElementData(player, "blindfold")
			local restrained = getElementData(player, "restrain")
			
			if (blindfolded==1) then
				outputChatBox("This player is already blindfolded.", 255, 0, 0)
				hidePlayerMenu()
			elseif (restrained==0) then
				outputChatBox("This player must be restrained in order to blindfold them.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("blindfoldPlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("You do not have a blindfold.", 255, 0, 0)
		end
	end
end

function cremoveBlindfold(button, state, x, y)
	if (button=="left") then
		local blindfolded = getElementData(player, "blindfold")
		if (blindfolded==1) then
			triggerServerEvent("removeBlindfold", getLocalPlayer(), player)
			hidePlayerMenu()
		else
			outputChatBox("This player is not blindfolded.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end
function crestrainPlayer(element, state, x, y)
	if (element) and (getElementType(element)=="player") then
		player = element
		if (exports.titan_global:hasItem(getLocalPlayer(), 45) or exports.titan_global:hasItem(getLocalPlayer(), 46)) then
			local restrained = getElementData(player, "restrain")
			
			if (restrained==1) then
				outputChatBox("Bu oyuncu zaten kelepçeli.", 255, 0, 0)
				hidePlayerMenu()
			else
				local restrainedObj
				
				if (exports.titan_global:hasItem(getLocalPlayer(), 45)) then
					restrainedObj = 45
				elseif (exports.titan_global:hasItem(getLocalPlayer(), 46)) then
					restrainedObj = 46
				end
					
				triggerServerEvent("restrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			end
		else
			outputChatBox("Kelepçeniz bulunmuyor.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

function cunrestrainPlayer(element, state, x, y)
	if (element) and (getElementType(element)=="player") then
		player = element
		local restrained = getElementData(player, "restrain")
		
		if (restrained==0) then
			outputChatBox("Bu karakter kelepçeli değil.", 255, 0, 0)
			hidePlayerMenu()
		else
			local restrainedObj = getElementData(player, "restrainedObj")
			local dbid = getElementData(player, "dbid")
			
			if (exports.titan_global:hasItem(getLocalPlayer(), 47, dbid)) or (restrainedObj==46) then -- has the keys, or its a rope
				triggerServerEvent("unrestrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			else
				outputChatBox("Bu kelepçenin anahtarına sahip değilsin.", 255, 0, 0)
			end
		end
	end
end
--------------------
--    FRISKING    --
--------------------

gx, gy, wFriskItems, bFriskTakeItem, bFriskClose, gFriskItems, FriskColName = nil
function cfriskPlayer(element, state, x, y)
	if (element) and (getElementType(element)=="player") then
		player = element
		destroyElement(wRightClick)
		wRightClick = nil
		
		local restrained = getElementData(player, "restrain")
		local injured = getElementData(player, "baygin")
		
		if restrained ~= 1 and not injured then
			outputChatBox("[-]#f9f9f9 Bu karakter baygın yada kelepçeli değil.", 255, 0, 0, true)
			hidePlayerMenu()
		--[[elseif getElementHealth(getLocalPlayer()) < 50 then
			outputChatBox("You need at least half health to frisk someone.", 255, 0, 0)
			hidePlayerMenu()]]--
		else
			gx = x
			gy = y
			
			triggerServerEvent("friskShowItems", getLocalPlayer(), player)
			triggerEvent("friskShowItems", getLocalPlayer(), player)
		end
	end
end

function friskShowItems(items)
	if wFriskItems then
		destroyElement( wFriskItems )
	end
	

		local playerName = string.gsub(getPlayerName(source), "_", " ")
	triggerServerEvent("sendLocalMeAction", getLocalPlayer(), getLocalPlayer(), "elleri ile şahısın üstünü kontrol etmeye başlar.")
	

end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)
--------------------
--  END FRISKING  --
--------------------

function caddFriend()
	triggerServerEvent("addFriend", getLocalPlayer(), player)
	hidePlayerMenu()
end

function cremoveFriend()
	triggerServerEvent("social:remove", getLocalPlayer(), getElementData(player, "account:id"))
	hidePlayerMenu()
end

function hidePlayerMenu()
	if (isElement(bAddAsFriend)) then
		destroyElement(bAddAsFriend)
	end
	bAddAsFriend = nil
	
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if (isElement(wFriskItems)) then
		destroyElement(wFriskItems)
	end
	wFriskItems = nil
	
	ax = nil
	ay = nil
	
	description = nil
	age = nil
	weight = nil
	height = nil
	
	if player then
		removeEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
	end
	
	sent = false
	player = nil
	
	showCursor(false)
end

function checkMenuWasted()
	if source == getLocalPlayer() or source == player then
		hidePlayerMenu()
	end
end

addEventHandler("onClientPlayerWasted", getRootElement(), checkMenuWasted)