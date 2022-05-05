local drivers = {}
local blips = {}
local acCheck = { }

function updateTruck1Blips(line)
	local driversonline = 0
	for k, v in ipairs(drivers[line]) do
		driversonline = driversonline + #v
	end
	
	if driversonline > 0 then
		for k, v in ipairs(drivers[line]) do
			if #(drivers[line][k-1] or {}) + #v > 0 then
				setBlipColor( blips[line][k], 127, 255, 63, 127 )
			else
				setBlipColor( blips[line][k], 255, 255, 63, 127 )
			end
		end
	else
		for k, v in ipairs(blips[line]) do
			setBlipColor( v, 255, 63, 63, 127 )
		end
	end
end

function t1stopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	
	setElementPosition(thePlayer, 2211.9882, -2635.4384, 13.5468)
	setElementRotation(thePlayer, 0, 0, 180)
end
addEvent("trucker1:exitVeh", true)
addEventHandler("trucker1:exitVeh", getRootElement(), t1stopJob)

function removeDriver()
	for k, v in ipairs(drivers) do
		for key, value in ipairs(v) do
			for i, player in pairs(value) do
				if player == source then
					table.remove(value, i)
				end
			end
		end
	end
end

function removeDriverOnAllLines()
	removeDriver()
	for line, v in pairs(drivers) do
		updateTruck1Blips(line)
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), removeDriverOnAllLines )
addEventHandler("onCharacterLogin", getRootElement(), removeDriverOnAllLines )

--[[
function doPay(client)
	--local hours = tonumber(getElementData(client, "hoursplayed"))
	--local rate = 50
	--local hoursrate = math.floor(hours*(rate*0.03))

	--if hours>=10 then
		--rate = rate-hoursrate
		--if rate < 10 then
			--rate = 10
		--end
	--end
	--local rate = 160
end]]

function payTruck1Driver(line, stop)
	local seat = getPedOccupiedVehicleSeat(client)
	if not seat or seat ~= 0 then
		return
	end
	
	if (acCheck[client] == stop) and (stop ~= -1) then
		triggerTruck1CheatDetection(client,stop)
	end
	
	acCheck[client] = stop
	if stop == -2 then
		removeDriver()
		exports.titan_global:giveMoney(client, 1200) 
	elseif stop == -1 then
		removeDriverOnAllLines()
		return
	elseif stop == 0 then
		table.insert( drivers[line][1], client )
	else
		exports.titan_global:giveMoney(client, 1200) 

		if drivers[line][stop+1] then
			removeDriver()
			table.insert( drivers[line][stop+1], client )
		end
	end
	updateTruck1Blips(line)
end
addEvent("payTruck1Driver",true)
addEventHandler("payTruck1Driver", getRootElement(), payTruck1Driver)

function triggerTruck1CheatDetection(thePlayer,stop)
	exports.titan_logs:logMessage("[payTruck1Driver]".. getPlayerName(thePlayer) .. " " .. getPlayerIP(thePlayer) .. " used the same stop twice ("..stop..")" , 32)
end

function ejectPlayerFromTruck1()
	exports.titan_anticheat:changeProtectedElementDataEx(source, "realinvehicle", 0, false)
	removePedFromVehicle(source)
end
addEvent("removePlayerFromTruck1", true)
addEventHandler("removePlayerFromTruck1", getRootElement(), ejectPlayerFromTruck1)

-- BUS ROUTES BLIPS
function createTruck1Blips( )
	for routeID, route in ipairs( g_truck1_routes ) do
		blips[routeID] = {}
		drivers[routeID] = {}
		for pointID, point in ipairs( route.points ) do
			if point[4] and #route.points ~= pointID then
				local stop = #blips[routeID]+1
				blips[routeID][stop] = createBlip( point[1], point[2], point[3], 0, 1, 255, 63, 63, 127, -5, 65 )
				drivers[routeID][stop] = {}
			end
		end
	end
end
addEventHandler( "onResourceStart", getResourceRootElement(), createTruck1Blips )