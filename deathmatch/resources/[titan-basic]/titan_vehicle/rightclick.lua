-- @Hanz

wRightClick = nil
bInventory = nil
bCloseMenu = nil
ax, ay = nil
localPlayer = getLocalPlayer()
vehicle = nil


--[[
function requestInventory(element)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		if isVehicleLocked(vehicle) and vehicle ~= getPedOccupiedVehicle(localPlayer) then
			triggerServerEvent("onVehicleRemoteAlarm", vehicle)
			outputChatBox("Bu araç kilitli.", 255, 0, 0)
		elseif type(getElementData(vehicle, "Impounded")) == "number" and isVehicleImpounded(vehicle) and not exports.titan_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) then
			outputChatBox("Aracı aramak için anahtara ihtiyacın var.", 255, 0, 0)
		elseif (getElementData(vehicle, "owner") ~= getElementData(localPlayer, "dbid")) and not exports.titan_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) then 
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffBu işlemi yapabilmek için aracın anahtarına sahip olmalısınız.", 255, 0, 0, true)
		else
			triggerServerEvent( "openFreakinInventory", localPlayer, vehicle, ax, ay )
		end
	end
end
--]]

function clickVehicle(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if (element) and (getElementType(element)=="vehicle") and (button=="right") and (state=="down") and not (wInventory) then
		local x, y, z = getElementPosition(localPlayer)
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
			ax = absX
			ay = absY
			vehicle = element
			--triggerClientEvent("onGGShell",resourceRoot,player,player,true)
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickVehicle, true)

function isNotAllowedV(theVehicle)
	return false
end

function showVehicleMenu()
	rightclick = exports.titan_rightclick
	--Name
	local vName = exports.titan_global:getVehicleName(vehicle)

	local row = {}
	rcMenu = rightclick:create(vName)
	
	local isLocked = isVehicleLocked(vehicle)
	local inCar = ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) or false

	if exports['titan_vehicle']:hasVehiclePlates(vehicle) and getElementData(vehicle, "show_plate") ~= 0 then -- Addded no plates support
		row.plate = rightclick:addRow(getVehiclePlateText(vehicle), true)
	end

	if (isVehicleImpounded(vehicle)) then
		local days = getRealTime().yearday-getElementData(vehicle, "Impounded")
		row.impounded = rightclick:addRow("Hacizli olduğu süre: "..days.."", false, true)
	end
	
	if (hasVehicleWindows(vehicle)) then
		local windowState = isVehicleWindowUp(vehicle, true) and "Kapalı" or "Açık"
		row.window = rightclick:addRow(" Pencere: "..windowState, false, true)
	end
	
	--y = y + lineH
	
	if ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) or exports.titan_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or (getElementData(localPlayer, "faction") > 0 and getElementData(localPlayer, "faction") == getElementData(vehicle, "faction")) then

		local lockText
		if isLocked then
			lockText = " Kilitli"
		else
			lockText = " Kilit açık"
		end
		row.lock = rightclick:addRow(lockText)
		addEventHandler("onClientGUIClick", row.lock, lockUnlock, false)

		if not isLocked or inCar then --if vehicle is not locked or if player is inside vehicle
			row.inventory = rightclick:addRow(" Bagaj")

			addEventHandler("onClientGUIClick", row.inventory, requestInventory, false)

			-- Cabriolet (Exciter)
			if isCabriolet(vehicle) then
				row.cabriolet = rightclick:addRow("Toggle Roof")
				addEventHandler("onClientGUIClick", row.cabriolet, cabrioletToggleRoof, false)
			end
			
			if exports['titan_items']:hasItem(vehicle, 117) then
				row.ramp = rightclick:addRow("Toggle Ramp")
				addEventHandler("onClientGUIClick", row.ramp, toggleRamp, false)
			end
		end
	end

	--if not isNotAllowedV(vehicle)  then
		if not ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" ) then
			if getElementData(localPlayer, "job") == 5 then -- Mechanic
			--[[local theTeam = getPlayerTeam(localPlayer) 
			local factionType = tonumber(getElementData(theTeam, "type"))
			if factionType == 7 then -- Mechanic Faction / Adams]]
				row.fix = rightclick:addRow(" Tamir et/ Geliştir")
				addEventHandler("onClientGUIClick", row.fix, openMechanicWindow, false)
			end
		end
	--end
	
	local vx,vy,vz = getElementVelocity(vehicle)
	if vx < 0.05 and vy < 0.05 and vz < 0.05 and not getPedOccupiedVehicle(localPlayer) and not isVehicleLocked(vehicle) then -- completely stopped
		local trailers = { [606] = true, [607] = true, [610] = true, [590] = true, [569] = true, [611] = true, [584] = true, [608] = true, [435] = true, [450] = true, [591] = true }
		if trailers[ getElementModel( vehicle ) ] then
			if exports.titan_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) then
				row.park = rightclick:addRow("Park")
				addEventHandler("onClientGUIClick", row.park, parkTrailer, false)
			end
		else
			if exports.titan_global:hasItem(localPlayer, 57) then -- FUEL CAN
				row.fill = rightclick:addRow("Fill Tank")
				addEventHandler("onClientGUIClick", row.fill, fillFuelTank, false)
			end
		end
	end
	
	if (getElementModel(vehicle)==497) then -- HELICOPTER
		local players = getElementData(vehicle, "players")
		local found = false
		
		if (players) then
			for key, value in ipairs(players) do
				if (value==localPlayer) then
					found = true
				end
			end
		end
		
		if not (found) then
			row.sit = rightclick:addRow("Sit")
			addEventHandler("onClientGUIClick", row.sit, sitInHelicopter, false)
		else
			row.sit = rightclick:addRow("Stand Up")
			addEventHandler("onClientGUIClick", row.sit, unsitInHelicopter, false)
		end
	end
	
	local entrance = getElementData( vehicle, "entrance" )
	if entrance and not isPedInVehicle( localPlayer ) then
		row.enter = rightclick:addRow("Enter Interior")
		addEventHandler("onClientGUIClick", row.enter, enterInterior, false)

		row.knock = rightclick:addRow("Knock on Door")
		addEventHandler("onClientGUIClick", row.knock, knockVehicle, false)
	end
	
	if not isLocked then
		local seat = -1
		if vehicle == getPedOccupiedVehicle(localPlayer) then
			for i = 0, (getVehicleMaxPassengers(vehicle) or 0) do
				if getVehicleOccupant(vehicle, i) == localPlayer then
					seat = i
					break
				end
			end
		end
		if #getDoorsFor(getElementModel(vehicle), seat) > 0 then
			row.doorControl = rightclick:addRow(" Kapı Kontrolu")
			addEventHandler("onClientGUIClick", row.doorControl, fDoorControl, false)
		elseif (getVehicleType(vehicle) == "Trailer" or getVehicleNameFromModel( 608 ) == getVehicleName( vehicle )) then -- this is a trailer, zomg. But getVehicleType returns "" CLIENT-SIDE. Fine on the server.
			row.handbrake = rightclick:addRow("Handbrake")
			addEventHandler("onClientGUIClick", row.handbrake, handbrakeVehicle, false)
		end
		
		if (getElementModel(vehicle) == 416) then --Stretcher for ambulance
			row.stretcher = rightclick:addRow("Stretcher")
			addEventHandler("onClientGUIClick", row.stretcher, fStretcher, false)
		elseif(getElementModel(vehicle) == 487 and getElementData(vehicle, "faction") == 2 or getElementModel(vehicle) == 417 and getElementData(vehicle, "faction") == 2) then --air ambulance and SAR heli
			row.stretcher = rightclick:addRow("Stretcher")
			addEventHandler("onClientGUIClick", row.stretcher, fStretcher, false)		
		end
		
		if ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) then
			if (getElementData(vehicle, "dbid") > 0 ) then
				row.look = rightclick:addRow(" Bilgi güncelle")
				addEventHandler("onClientGUIClick", row.look, fLook, false)
			end
		end
	end

	if (exports.titan_integration:isPlayerSeniorAdmin(localPlayer) or exports.integration:isPlayerSupporter(localPlayer) or exports.integration:isPlayerScripter(localPlayer)) then
		if(exports.titan_global:isStaffOnDuty(localPlayer) or exports.titan_integration:isPlayerScripter(localPlayer)) then
			row.respawn = rightclick:addRow(" ADM: Respawn")
			addEventHandler("onClientGUIClick", row.respawn, fRespawn, false)

     	if exports.titan_integration:isPlayerDeveloper(localPlayer) then
				row.textures = rightclick:addRow(" ADM: Textureler")
				addEventHandler("onClientGUIClick", row.textures, fTextures, false)
			end
		end
	end
end

function lockUnlock(element, state)
		if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		if getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle then
			triggerServerEvent("lockUnlockInsideVehicle", localPlayer, vehicle)
		elseif exports.titan_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or (getElementData(localPlayer, "faction") > 0 and getElementData(localPlayer, "faction") == getElementData(vehicle, "faction")) then
			triggerServerEvent("lockUnlockOutsideVehicle", localPlayer, vehicle)
		end
	end
end

function fStretcher(element, state)
	if (element) and (getElementType(element)=="vehicle") then
	vehicle = element
		if not (isVehicleLocked(vehicle)) then
			triggerServerEvent("stretcher:createStretcher", getLocalPlayer(), false, vehicle)
		end
	end
end

function fLook(element, state)
	if (element) and (getElementType(element)=="vehicle") then
	vehicle = element
		triggerEvent("editdescription", getLocalPlayer())
	end
end

function fDoorControl(element, state)
	if (element) and (getElementType(element)=="vehicle") then
	vehicle = element
		openVehicleDoorGUI( vehicle )
	end
end

function parkTrailer(button, state)
	if (button=="left") then
		triggerServerEvent("parkVehicle", localPlayer, vehicle)
	end
end

function fillFuelTank(element, state)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		local _,_, value = exports.titan_global:hasItem(localPlayer, 57)
		if value > 0 then
			triggerServerEvent("fillFuelTankVehicle", localPlayer, vehicle, value)
		else
			outputChatBox("This fuel can is empty...", 255, 0, 0)
		end
	end
end

function openMechanicWindow(element, state)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		triggerEvent("openMechanicFixWindow", localPlayer, vehicle)
	end
end

function toggleRamp(button)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		triggerServerEvent("vehicle:control:ramp", localPlayer, vehicle)
	end
end

function sitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("sitInHelicopter", localPlayer, vehicle)
	end
end

function unsitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("unsitInHelicopter", localPlayer, vehicle)
	end
end

function enterInterior()
	triggerServerEvent( "enterVehicleInterior", getLocalPlayer(), vehicle )
end

function knockVehicle()
	triggerServerEvent("onVehicleKnocking", getLocalPlayer(), vehicle)
end

function handbrakeVehicle()
	triggerServerEvent("vehicle:handbrake", vehicle)
end

function cabrioletToggleRoof()
	triggerServerEvent("vehicle:toggleRoof", getLocalPlayer(), vehicle)
end

function fRespawn(element)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
	triggerServerEvent("vehicle-manager:respawn", getLocalPlayer(), vehicle)
end
end

function fTextures(element)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
	triggerEvent("item-texture:vehtex", localPlayer, vehicle)
end
end
