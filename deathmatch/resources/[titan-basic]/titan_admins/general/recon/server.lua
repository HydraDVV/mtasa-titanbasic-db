addEvent( "fixRecon", true )
addEventHandler( "fixRecon", getRootElement( ), 
	function( element )
		setElementDimension( client, getElementDimension( element ) )
		setElementInterior( client, getElementInterior( element ) )
		setCameraInterior( client, getElementInterior( element ) )
	end
)

-- recon fix for interior changing
function interiorChanged()
	for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					setCameraInterior(value, interior)
					setElementInterior(value, interior)
					setElementDimension(value, dimension)
				end
			end
		end
	end
end
addEventHandler("onPlayerInteriorChange", getRootElement(), interiorChanged)

-- stop recon on quit of the player
function removeReconning()
	for key, value in ipairs(exports.titan_pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					reconPlayer(value)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeReconning)

-- RECON
function reconPlayer(thePlayer, commandName, targetPlayer)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")
			
			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox(""..exports["titan_pool"]:getServerName().." Roleplay: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				detachElements(thePlayer)
			
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", nil, false)
				exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "recony", nil, false)
				exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconz", nil, false)
				exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				exports["titan_infobox"]:addBox(thePlayer, "error", "Aktif izlemeyi sonland??rd??n.")
			end
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local freecamEnabled = exports.titan_freecam:isPlayerFreecamEnabled (thePlayer)
			if freecamEnabled then
				toggleFreecam(thePlayer)
			end
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Oyuncu giri?? yapmam????.", thePlayer, 255, 0, 0)
				else
				
					--[[if exports.titan_integration:isPlayerSupporter(thePlayer) then
						if exports.titan_integration:isPlayerTrialAdmin(targetPlayer) or exports.titan_global:getPlayerGameMasterLevel(targetPlayer) >= exports.titan_global:getPlayerGameMasterLevel(thePlayer) or exports.titan_global:getPlayerGameMasterLevel(targetPlayer) == 0 then
							outputChatBox("You can only /recon lower level GMs, tyvm.", thePlayer)
							exports.titan_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " tried reconning " .. targetPlayerName .. " but FAILED (due to GM level).")
							return
						end
					end]] -- Fixed for Finch - Adams
					-- avoid circular reconning
					--local attached = { [thePlayer] = targetPlayer }
					--local a = targetPlayer
					--while true do
					--	local b = getElementAttachedTo(a)
					--	if b then
					--		if attached[b] then
					--			outputChatBox("Unable to attach (circular reference).", thePlayer, 255, 0, 0)
					--			return
					--		end
					--		attached[a] = b
					--	else
					--		-- not attached to anything
					--		break
					--	end
					--end
					setElementAlpha(thePlayer, 0)
					
					if getPedOccupiedVehicle ( thePlayer ) then
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0, false)
						removePedFromVehicle(thePlayer)
					end
					
					if ( not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true ) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", x, false)
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "recony", y, false)
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconz", z, false)
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconrot", rot, false)
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "recondimension", dimension, false)
						exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)
					
					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)
					
					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)
					
					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end
					
					if not (success) then
						outputChatBox("Failed to attach the element.", thePlayer, 0, 255, 0)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("Now reconning " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						
						
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						
						if hiddenAdmin == 0 and not exports.titan_integration:isPlayerAdmin(thePlayer) then
							local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
							exports.titan_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " started reconning " .. targetPlayerName .. ".")
						end
						
					end
				end
			end
		end
	end
end
--addCommandHandler("recon", reconPlayer, false, false)

function fuckRecon(thePlayer, commandName, targetPlayer)
	if (exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
		if true then
			return outputChatBox("Just /recon again to turn off", thePlayer)
		end
		local rx = getElementData(thePlayer, "reconx")
		local ry = getElementData(thePlayer, "recony")
		local rz = getElementData(thePlayer, "reconz")
		local reconrot = getElementData(thePlayer, "reconrot")
		local recondimension = getElementData(thePlayer, "recondimension")
		local reconinterior = getElementData(thePlayer, "reconinterior")
		
		detachElements(thePlayer)
		setCameraTarget(thePlayer, thePlayer)
		setElementAlpha(thePlayer, 255)
		
		if rx and ry and rz then
			setElementPosition(thePlayer, rx, ry, rz)
			if reconrot then
				setPedRotation(thePlayer, reconrot)
			end
			
			if recondimension then
				setElementDimension(thePlayer, recondimension)
			end
			
			if reconinterior then
					setElementInterior(thePlayer, reconinterior)
					setCameraInterior(thePlayer, reconinterior)
			end
		end
		
		exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
		exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "recony", false, false)
		exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconz", false, false)
		exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconrot", false, false)
		outputChatBox("Recon turned off.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("fuckrecon", fuckRecon, false, false)
addCommandHandler("stoprecon", fuckRecon, false, false)

--[[ Deprecated functions. Reworked Hanz / 2015.2.5
-- FREECAM
function toggleFreecam(thePlayer)
	local canFly = getElementData(thePlayer, "canFly")
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) or canFly then
		local reconning = getElementData(thePlayer, "reconx")
		if reconning then
			reconPlayer(thePlayer, "recon")
		end
	
		local enabled = exports.titan_freecam:isPlayerFreecamEnabled (thePlayer)
		local players = exports.titan_pool:getPoolElementsByType("player")
		
		if (enabled) then
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			setElementAlpha(thePlayer, 255)
			setElementFrozen(thePlayer, false)
			exports.titan_freecam:setPlayerFreecamDisabled (thePlayer)
		else
			removePedFromVehicle(thePlayer)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", 0, false)
			setElementAlpha(thePlayer, 0)
			setElementFrozen(thePlayer, true)
			exports.titan_freecam:setPlayerFreecamEnabled (thePlayer)
			if not exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
				exports.titan_global:sendMessageToAdmins("[FREECAM] "..exports.titan_global:getAdminTitle1(thePlayer).." has activated temporary /freecam.")
			end
		end
	end
end
addCommandHandler("freecam", toggleFreecam)

-- DROP ME
function dropOffFreecam(thePlayer)
	local canFly = getElementData(thePlayer, "canFly")
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) or canFly then
		local enabled = exports.titan_freecam:isPlayerFreecamEnabled (thePlayer)
		local players = exports.titan_pool:getPoolElementsByType("player")
		if (enabled) then
			local x, y, z = getElementPosition(thePlayer)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			setElementAlpha(thePlayer, 255)
			setElementFrozen(thePlayer, false)
			exports.titan_freecam:setPlayerFreecamDisabled (thePlayer)
			setElementPosition(thePlayer, x, y, z)
		else
			outputChatBox("This command only works while freecam is on.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("dropme", dropOffFreecam)
]]
-- DISAPPEAR

function toggleInvisibility(thePlayer)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) then
		local enabled = getElementData(thePlayer, "invisible")
		if (enabled == true) then
			setElementAlpha(thePlayer, 255)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			outputChatBox("You are now visible.", thePlayer, 255, 0, 0)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "invisible", false, false)
			exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "DISAPPEAR DISABLED")
		elseif (enabled == false or enabled == nil) then
			setElementAlpha(thePlayer, 0)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", true, false)
			outputChatBox("You are now invisible.", thePlayer, 0, 255, 0)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "invisible", true, false)
			exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "DISAPPEAR ENABLED")
		else
			outputChatBox("Please disable recon first.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("disappear", toggleInvisibility)

					
-- TOGGLE NAMETAG

function toggleMyNametag(thePlayer)
	local visible = getElementData(thePlayer, "reconx")
	local username = getElementData(thePlayer, "account:username")
	if exports.titan_integration:isPlayerSeniorAdmin(thePlayer) then
		if (visible == true) then
			setPlayerNametagShowing(thePlayer, false)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			outputChatBox("Your nametag is now visible.", thePlayer, 255, 0, 0)
		elseif (visible == false or visible == nil) then
			setPlayerNametagShowing(thePlayer, false)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "reconx", true, false)
			outputChatBox("Your nametag is now hidden.", thePlayer, 0, 255, 0)
		else
			outputChatBox("Please disable recon first.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togmytag", toggleMyNametag)

-- RP SUPERVISE

function roleplaySupervise(thePlayer)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer) then
		if exports.titan_global:isStaffOnDuty(thePlayer) then
			local enabled = getElementData(thePlayer, "supervising")
			if (enabled == true) then
				setElementAlpha(thePlayer, 255)
				outputChatBox("You are now no longer in supervisor state.", thePlayer, 255, 0, 0)
				exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "RP SUPERVISOR DISABLED")
				exports.titan_global:sendWrnToStaff("[AdmCmd] "..getElementData(thePlayer, "account:username").." has disabled RP supervisor mode.")

				setElementData(thePlayer, "supervising", false)
			elseif (enabled == false or enabled == nil) then
				setElementAlpha(thePlayer, 100)
				outputChatBox("You are now in supervisor state.", thePlayer, 0, 255, 0)
				exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "RP SUPERVISOR ENABLED")
				exports.titan_global:sendWrnToStaff("[AdmCmd] "..getElementData(thePlayer, "account:username").." has enabled RP supervisor mode.")

				setElementData(thePlayer, "supervising", true)
			else
				outputChatBox("Please disable recon first.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("supervise", roleplaySupervise)

-- MAXIME's reworks
function asyncReconActivate(cur)
	local target = exports.titan_pool:getElement("player", cur.target)
	if not target then
		triggerClientEvent(source, "admin:recon", source)
		return 
	end
	removePedFromVehicle(source)
	if exports.titan_freecam:isEnabled(source) then
		triggerEvent("freecam:asyncDeactivateFreecam", source)
	end
	setElementData(source, "reconx", true , false)
	setElementCollisionsEnabled ( source, false )
	setElementAlpha(source, 0)
	setPedWeaponSlot(source, 0)
	
	local t_int = getElementInterior(target)
	local t_dim = getElementDimension(target)

	setElementDimension(source, t_dim)
	setElementInterior(source, t_int)
	setCameraInterior(source, t_int)

	local x1, y1, z1 = getElementPosition(target)
	attachElements(source, target, 0, 0, 5)
	setElementPosition(source, x1, y1, z1+5)
	setCameraTarget(source,target)
end
addEvent("admin:recon:async:activate", true)
addEventHandler("admin:recon:async:activate", root, asyncReconActivate)

function asyncReconDeactivate(cur)
	if exports.titan_freecam:isEnabled(source) then
		triggerEvent("freecam:asyncDeactivateFreecam", source)
	end
	removePedFromVehicle(source)
	detachElements(source)
	setElementData(source, "reconx", false, false)

	setElementPosition(source, cur.x, cur.y, cur.z)
	setElementRotation(source, cur.rx, cur.ry, cur.rz)

	setElementDimension(source, cur.dim)
	setElementInterior(source, cur.int)
	setCameraInterior(source,cur.int)
	
	setCameraTarget(source, nil)
	setElementAlpha(source, 255)
	setElementCollisionsEnabled ( source, true )
end
addEvent("admin:recon:async:deactivate", true)
addEventHandler("admin:recon:async:deactivate", root, asyncReconDeactivate)
