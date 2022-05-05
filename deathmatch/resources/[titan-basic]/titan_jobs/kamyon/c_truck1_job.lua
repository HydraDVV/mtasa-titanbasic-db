local line, route, m_number, curCpType = nil

local truck1Marker, truck1NextMarker = nil
local truck1Blip, truck1NextBlip = nil
local truck1StopColShape = nil

local truck1 = { [455]=true }

local blip

local truckguy = createPed(16, 2218.48144, -2664.5039, 13.5485, 0, true)
setElementData(truckguy, "talk", 1)
setElementData(truckguy, "name", "Bill Take")
setElementFrozen(truckguy, true)

function truck1JobDisplayGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	

	if (carlicense == 1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Bill Take diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		truck1AcceptGUI(getLocalPlayer())
		return
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Bill Take diyor ki: Ehliyetin olamdığı için bu mesleğe katılamazsın.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("truck1:displayJob", true)
addEventHandler("truck1:displayJob", getRootElement(), truck1JobDisplayGUI)

function truck1AcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Kamyon Şoförlüğü", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			triggerServerEvent("acceptJob", getLocalPlayer(), 11)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Bill Take diyor ki: Yandaki kamyonlardan birini alarak işe başla, tırın dorsesini almayı unutma.", 255, 255, 255, 3, {}, true)
			setTimer(function() exports.titan_hud:sendBottomNotification(getLocalPlayer(), "Kamyon Şoförlüğü", "Yandaki kamyonlardan birini alıp, /kamyon basla yazarak işe başlayabilirsiniz!") end, 500, 1)
			return	
		end
	)
	
	local line = guiCreateLabel(9, 32, 289, 19, "____________________________________________________", false, jobWindow)
	guiLabelSetHorizontalAlign(line, "center", false)
	guiLabelSetVerticalAlign(line, "center")
	local cancelBtn = guiCreateButton(159, 55, 139, 33, "İptal Et", false, jobWindow)
	addEventHandler("onClientGUIClick", cancelBtn, 
		function()
			destroyElement(jobWindow)
			return	
		end
	)
end

function t1cancelJob()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	if pedVeh then
		if pedVehModel == 455 then
			exports.titan_global:fadeToBlack()
			
			if (isElement(blip)) then
				destroyElement(blip)
				removeEventHandler("onClientVehicleEnter", getRootElement(), startTruck1Job)
				blip = nil
			end
		
			if isElement(truck1Marker) then
				destroyElement(truck1Marker)
				truck1Marker = nil
			end
		
			if isElement(truck1Blip) then
				destroyElement(truck1Blip)
				truck1Blip = nil
			end
		
			if isElement(truck1NextMarker) then
				destroyElement(truck1NextMarker)
				truck1NextMarker = nil
			end
		
			if isElement(truck1NextBlip) then
				destroyElement(truck1NextBlip)
				truck1NextBlip = nil
			end
			m_number = 0
			
			triggerServerEvent("trucker1:exitVeh", getLocalPlayer(), getLocalPlayer())
			--removeEventHandler("onClientVehicleStartEnter", getRootElement(), tcantJacked)
			setTimer(function() exports.titan_global:fadeFromBlack() end, 2000, 1)
		end
	end
end


function t1cantExit(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			t1cancelJob()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), t1cantExit)


function resetTruck1Job()
	--local driver = getVehicleOccupant(vehicle)
	--if vehicle and seat == 0 then
		if (isElement(blip)) then
			destroyElement(blip)
			removeEventHandler("onClientVehicleEnter", getRootElement(), startTruck1Job)
			blip = nil
		end
	
		if isElement(truck1Marker) then
			destroyElement(truck1Marker)
			truck1Marker = nil
		end
	
		if isElement(truck1Blip) then
			destroyElement(truck1Blip)
			truck1Blip = nil
		end
	
		if isElement(truck1NextMarker) then
			destroyElement(truck1NextMarker)
			truck1NextMarker = nil
		end
	
		if isElement(truck1NextBlip) then
			destroyElement(truck1NextBlip)
			truck1NextBlip = nil
		end
	
		m_number = 0
		triggerServerEvent("payTruck1Driver", getLocalPlayer(), line, -1)
	--end
end
--addEventHandler("onClientPlayerVehicleExit", getRootElement(), resetTruck1Job )
--addEventHandler("onClientVehicleStartExit", getRootElement(), resetTruck1Job )
--addEventHandler ( "onPlayerWasted", getRootElement(), resetTruck1Job )

function displayTruck1Job()
	blip = createBlip(2193.513671875, -2654.5537109375, 13.546875, 0, 4, 255, 255, 0)  --0 0 1787.1259765625 -1903.591796875 13.394536972046
	exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Haritada sarı işaretli bölgeye giderek kamyon seferine başlayabilirsiniz.")
end

function startTruck1Job(cmd, arg)
	if arg == "basla" then
		local job = getElementData(getLocalPlayer(), "job")
		if (job == 11) then
			if blip then
				destroyElement(blip)
				blip = nil
			end
			if truck1Marker then
				exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Zaten bir kamyon seferine başladın.")
			else
				local vehicle = getPedOccupiedVehicle(getLocalPlayer())
				if vehicle and getVehicleController(vehicle) == getLocalPlayer() and truck1[getElementModel(vehicle)] then
					line = math.random( 1, #g_truck1_routes )
					route = g_truck1_routes[line]
					curCpType = 0
					local x, y, z = 2227.8300, -2638.5390, 13.3811 --1811, -1890, 13 -- Depot start point
					truck1Blip = createBlip(x, y, z, 0, 3, 255, 200, 0, 255)
					truck1Marker = createMarker(x, y, z, "checkpoint", 4, 255, 200, 0, 150) -- start marker.
					truck1StopColShape = createColSphere(0, 0, 0, 5)
					
					addEventHandler("onClientMarkerHit", truck1Marker, updateTruck1CheckpointCheck)
					addEventHandler("onClientMarkerLeave", truck1Marker, checkWaitAtStop1)
					addEventHandler("onClientColShapeHit", truck1StopColShape,
						function(element)
							if getElementType(element) == "vehicle" and truck1[getElementModel(element)] then
								setVehicleLocked(vehicle, false)
							end
						end
					)
					addEventHandler("onClientColShapeLeave", truck1StopColShape,
						function(element)
							if getElementType(element) == "vehicle" and truck1[getElementModel(element)] then
								setVehicleLocked(vehicle, true)
							end
						end
					)
					
					local nx, ny, nz = route.points[1][1], route.points[1][2], route.points[1][3]
					if (route.points[1][4]==true) then
						truck1NextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 0, 0, 150) -- small red marker
						truck1NextBlip = createBlip( nx, ny, nz, 0, 2, 255, 0, 0, 255) -- small red blip
					else
						truck1NextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 200, 0, 150) -- small yellow marker
						truck1NextBlip = createBlip( nx, ny, nz, 0, 2, 255, 200, 0, 255) --small  yellow blip
					end
					
					m_number = 0
					triggerServerEvent("payTruck1Driver", getLocalPlayer(), line, 0)
					
					setVehicleLocked(vehicle, true)
					
					exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Kamyon sefer noktalarından geçin, yükleme noktalarında durun. (kırmızı noktalar)")
				else
					exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Kamyon seferine başlamak için meslek aracında bulunmalısınız. (Flatbed)")
				end
			end
		else
			exports.titan_hud:sendBottomNotification(localPlayer, "Bilgilendirme", "Kamyon şoförü değilsiniz, belediyeye giderek mesleğe başvurabilirsiniz.")
		end
	end
end
addCommandHandler("kamyon", startTruck1Job, false, false)

function updateTruck1CheckpointCheck(thePlayer)
	if thePlayer == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		local driver = getVehicleOccupant(vehicle)
		if vehicle and truck1[getElementModel(vehicle)] and driver == thePlayer then
			if curCpType == 3 then
				truck1StopTimer = setTimer(updateTruck1CheckpointAfterStop, 1000, 1, true)
				triggerEvent("hudOverlay:drawOverlayTopRight", thePlayer, { {"Kamyon Şoförü"}, {""}, {"Burası yükleme noktasıdır, mallar yüklenmiştir."}, }, false, false, false, 5)
				--triggerServerEvent("truck1AdNextStop", getLocalPlayer(), line, route.points[m_number][5])
			elseif curCpType == 2 then
				endOfTheLineT()
			elseif curCpType == 1 then
				truck1StopTimer = setTimer(updateTruck1CheckpointAfterStop, 1000, 1, false)
				triggerEvent("hudOverlay:drawOverlayTopRight", thePlayer, { {"Kamyon Şoförü"}, {""}, {"Burası yükleme noktasıdır, mallar yüklenmiştir."}, }, false, false, false, 5)
				--triggerServerEvent("truck1AdNextStop", getLocalPlayer(), line, route.points[m_number][5])
			else
				updateTruck1Checkpoint()
			end
		else
			exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Sefer noktalarından sadece meslek kamyonuyla geçebilirsiniz!") -- Wrong car type.
		end
	end
end

function updateTruck1Checkpoint()
	-- Find out which marker is next.
	local max_number = #route.points
	local newnumber = m_number+1
	local nextnumber = m_number+2
	local x, y, z = nil
	local nx, ny, nz = nil
	
	x = route.points[newnumber][1]
	y = route.points[newnumber][2]
	z = route.points[newnumber][3]
	
	if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
		setElementPosition(truck1Marker, x, y, z)
		setElementPosition(truck1Blip, x, y, z)
		
		if (route.points[newnumber][4]==true) then -- If it is a stop.
			curCpType = 3
			setMarkerColor(truck1Marker, 255, 0, 0, 150)
			setBlipColor(truck1Blip, 255, 0, 0, 255)
			setElementPosition(truck1StopColShape, x, y, z)
		else -- it is just a route.
			curCpType = 2
			setMarkerColor(truck1Marker, 255, 200, 0, 150)
			setBlipColor(truck1Blip, 255, 200, 0, 255)
		end
		
		nx, ny, nz = 2221.4414, -2634.2714, 13.3856 --1811, -1890, 13 -- Depot start point
		setElementPosition(truck1NextMarker, nx, ny, nz)
		setElementPosition(truck1NextBlip, nx, ny, nz)
		setMarkerColor(truck1NextMarker, 255, 0, 0, 150)
		setBlipColor(truck1NextBlip, 255, 0, 0, 255)
		setMarkerIcon(truck1NextMarker, "finish")
	else
		nx = route.points[nextnumber][1]
		ny = route.points[nextnumber][2]
		nz = route.points[nextnumber][3]
		
		setElementPosition(truck1Marker, x, y, z)
		setElementPosition(truck1Blip, x, y, z)
		
		setElementPosition(truck1NextMarker, nx, ny, nz)
		setElementPosition(truck1NextBlip, nx, ny, nz)
		
		if (route.points[newnumber][4]==true) then -- If it is a stop.
			curCpType = 1
			setMarkerColor(truck1Marker, 255, 0, 0, 150)
			setBlipColor(truck1Blip, 255, 0, 0, 255)
			setElementPosition(truck1StopColShape, x, y, z)
		else -- it is just a route.
			curCpType = 0
			setMarkerColor(truck1Marker, 255, 200, 0, 150)
			setBlipColor(truck1Blip, 255, 200, 0, 255)
		end
		
		if (route.points[nextnumber][4] == true) then
			setMarkerColor(truck1NextMarker, 255, 0, 0, 150)
			setBlipColor(truck1NextBlip, 255, 0, 0, 255)
		else
			setMarkerColor(truck1NextMarker, 255, 200, 0, 150)
			setBlipColor(truck1NextBlip, 255, 200, 0, 255)
		end
	end
	m_number = m_number + 1
end

function checkWaitAtStop1(thePlayer)
	if thePlayer == getLocalPlayer() then
		if truck1StopTimer then
			exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Yükleme noktasında beklemediniz!")
			if isTimer(truck1StopTimer) then
				killTimer(truck1StopTimer)
				truck1StopTimer = nil
			end
		end
	end
end

function updateTruck1CheckpointAfterStop(endOfLineT)
	if isTimer(truck1StopTimer) then
		killTimer(truck1StopTimer)
		truck1StopTimer = nil
	end
	local stopNumber = route.points[m_number][5]
	triggerServerEvent("payTruck1Driver", getLocalPlayer(), line, stopNumber)
	if endOfLineT then
		endOfTheLineT(getLocalPlayer())
	else
		updateTruck1Checkpoint(getLocalPlayer())
	end
end

function endOfTheLineT()
	if truck1NextBlip then
		destroyElement(truck1NextBlip)
		destroyElement(truck1NextMarker)
		truck1NextBlip = nil
		truck1NextMarker = nil
		
		if truck1StopColShape then
			destroyElement(truck1StopColShape)
			truck1StopColShape = nil
		end
		
		local x, y, z = 2221.4414, -2634.2714, 13.3856 --1811, -1890, 13 -- Depot start point
		setElementPosition(truck1Marker, x, y, z)
		setElementPosition(truck1Blip, x, y, z)
		setMarkerColor(truck1Marker, 255, 0, 0, 150)
		setBlipColor(truck1Blip, 255, 0, 0, 255)
		setMarkerIcon(truck1Marker, "finish")
		curCpType = 2
	else
		if truck1Blip then
			-- Remove the old marker.
			destroyElement(truck1Blip)
			destroyElement(truck1Marker)
			truck1Blip = nil
			truck1Marker = nil
		end
		triggerServerEvent("payTruck1Driver", getLocalPlayer(), line, -2)
		setVehicleLocked(vehicle, false)
		exports.titan_hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Kamyon seferiniz sona erdi, tekrar başlamak için /kamyonbasla yazınız.") --if line is finished
	end
end

function startEnterTruck1(thePlayer, seat)
	if seat == 0 and truck1[getElementModel(source)] then
		if getVehicleController(source) then -- if someone try to jack the driver stop him
			cancelEvent()
			if thePlayer == getLocalPlayer() then
				exports.titan_hud:sendBottomNotification(localPlayer, "Uyarı", "Bu işlemi gerçekleştiremezsiniz.")
			end
		else
			setVehicleLocked(source, false)
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), startEnterTruck1)


function trashAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 455 and vehicleJob == 11 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 11 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBu araca binmek için Kamyon Şoförlüğü mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), trashAntiYabanci)

function onPlayerQuit()
	if getElementData(source, "job") == 11 then
		vehicle = getPedOccupiedVehicle(source)
		if vehicle and truck1[getElementModel(vehicle)] and getVehicleOccupant(vehicle) == source then
			setVehicleLocked(vehicle, false)
		end
	end
end
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)