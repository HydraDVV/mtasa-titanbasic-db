local sx, sy = guiGetScreenSize()
local lineColor = {0, 0, 0}
local clickElement = {false, false, false, false}
local playerX, playerY, playerZ = 0, 0 ,0 
local playersX, playersY, playersZ = 0, 0 ,0 
local lineX, lineY, lineZ = 0, 0, 0
local linesX,linesY,linesZ = 0, 0, 0
local player = localPlayer
local VehicleID = 0
local gallon = 0
local fuel = 0
local element 
local effect = {} 
local vehicle

local font = dxCreateFont(":titan_fonts/files/Roboto.ttf", 10)

local effect = {}
local start 


local fuelprice = 6

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		setElementData(localPlayer, "fuel_gun", false)
		for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
			setElementData(v, "veh_fueling", false)
		end
		
		if fileExists("files/fuelgun.txd") then
			txd = engineLoadTXD("files/fuelgun.txd", 14463 )
			engineImportTXD(txd, 14463)
		end	
		
		if fileExists("files/fuelgun.dff") then
		  dff = engineLoadDFF("files/fuelgun.dff", 14463 )
		  engineReplaceModel(dff, 14463)
		end
	end
)

local alphas = 0
function createEffects(player, _, element )
	if isElement(effect[player]) then 
		destroyElement(effect[player])
	else
		local rotx, roty, rotz = getElementRotation(player)
		effect[player] = createEffect("petrolcan", playerX, playerY, playerZ, 0, roty, rotz)
		exports.titan_bone_attach:attachElementToBone(effect[player], player , 12, -0.25,-0.05, 0.23, rotx, roty, rotz)
	end
end
addEvent("createEffectstoClient", true)
addEventHandler("createEffectstoClient", root, createEffects)

local enabled = {
	[1676] = true,
	[1686] = true,
	[3465] = true,
}

addEventHandler("onClientClick", root, 
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if button == "right" and state == "down" and not isPedInVehicle(localPlayer) then

			if clickedElement and clickedElement.type == "object" and enabled[clickedElement.model] then
				if getElementData(localPlayer, "fuel_gun") or false then
					clickElement[1]  = false
					triggerServerEvent("syncPlayertoFuelGun", localPlayer, localPlayer, true)
					setElementData(localPlayer, "fuel_gun", false)
					toggleControl("fire", true)
					setElementData(localPlayer, "money", getElementData(localPlayer, "money") - math.floor(fuel))
					setElementData(vehicle, "fuel", vehicle_fuel + math.floor(gallon))
					triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elinden gaz pompasını bırakır.")
				else
					clickElement[1] = true
					lineX,lineY,lineZ = getElementPosition(clickedElement)
					toggleControl("fire", false)
					triggerServerEvent("syncPlayertoFuelGun", localPlayer, localPlayer)
					setElementData(localPlayer, "fuel_element", clickedElement)
					setElementData(localPlayer, "fuel_gun", true)
					
					triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "eline gaz pompasını alır.")
				end
			elseif clickedElement and not clickElement[4] then 
				clickElement[4] = true 
			end
		end
	end
)

addEventHandler( "onClientElementStreamIn", root,
	function()
		 if source.type == "player" then
			if source:getData("fuel_gun") or false then 
				linesX,linesY,linesZ = getElementData(source, "fuel_element").position
				fuelGun = createObject(14463,0,0,0)
				exports.titan_bone_attach:attachElementToBone(fuelGun,source,12,0,0,0.06,-180,0,0)
			end
		 end
	end
)

local font = exports.titan_fonts:getFont("RobotoB", 14)

setTimer(
	function()
		for i, player in ipairs(getElementsByType("player")) do 
			if player and getElementData(player, "fuel_gun") or false and getElementData(player, "fuel_element") and player ~= localPlayer then 
				linesX,linesY,linesZ = getElementPosition(getElementData(player, "fuel_element"))
				playersX, playersY, playersZ = getPedBonePosition(player, 25)
				dxDrawLine3D(linesX,linesY,linesZ, playersX, playersY, playersZ, tocolor ( 0,0,0,255 ), 1.5)

				if clickElement[1] and getDistanceFromElement(player, getElementData(player, "fuel_element")) < 4 then
					for _, vehicle in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
						local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
						if getDistanceFromElement(player, vehicle) < 4 then
							local x,y,z = getVehicleComponentPosition(vehicle,vehicle_Table[getElementModel(vehicle)][1],"world")
							if getDistanceBetweenPoints3D(x, y, z, playersX, playersY, playersZ) < 1 and clickElement[1] and getElementData(localPlayer, "fuel_gun") then
								if vehicle and not getVehicleEngineState(vehicle) then
									vehicle_fuel = getElementData(vehicle, "fuel")
								
									dxDrawText("Yakıt doldurmak için 'E' tuşuna basılı tutun.", 2, 100, sx, sy-50, tocolor(0, 0, 0), 1, font, "center", "bottom")
									dxDrawText("Yakıt doldurmak için 'E' tuşuna basılı tutun.", 0, 100, sx, sy-50, tocolor(225, 225, 225), 1, font, "center", "bottom")
									if gallon > 0 then
										dxDrawText("Doldurulan Yakıt: "..math.floor(gallon).." lt\nYakıt Durumu: "..getElementData(vehicle,"fuel").."/"..getMaxFuel(vehicle).." lt", 2, 100, sx, sy-70, tocolor(0, 0, 0), 1, font, "center", "bottom")
										dxDrawText("Doldurulan Yakıt: "..math.floor(gallon).." lt\nYakıt Durumu: "..getElementData(vehicle,"fuel").."/"..getMaxFuel(vehicle).." lt", 0, 100, sx, sy-70, tocolor(225, 225, 225), 1, font, "center", "bottom")
									end
									if getKeyState("e") then 
										if not clickElement[3] then 
											triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, "SWORD", "sword_IDLE")
											triggerServerEvent("syncPlayereffect", localPlayer, localPlayer, false)
											if isElement(start) then 
												stopSound(start)
											end
											start = playSound("files/fuelling.mp3", true)
										end
										clickElement[3] = true 
										setElementData(vehicle, "veh_fueling", true)
										gallon = gallon + 0.05

										fuel = math.floor(gallon) * fuelprice
										if getElementData(localPlayer, "money") >= math.floor(fuel) then
										--	setElementData(localPlayer, "money", getElementData(localPlayer, "money") - math.floor(fuel))
										--	setElementData(vehicle, "fuel", vehicle_fuel + math.floor(gallon))
											triggerServerEvent("vehicle_fuel:takeMoneyGiveFuel", localPlayer, localPlayer, vehicle, fuel, gallon)
											gallon = 0
											fuel = 0
										else
											outputChatBox(""..exports["titan_pool"]:getServerName()..": Yeterli paran yok.", 255, 255, 255, true)
											if clickElement[3] then 
												triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
												if isElement(effect[localPlayer]) then 
													destroyElement(effect[localPlayer])
												end
												if isElement(start) then 
													stopSound(start)
												end
											end
											gallon = 0
											fuel = 0
											setElementData(vehicle, "veh_fueling", false)
											clickElement[1]  = false
											clickElement[2] = false 
											clickElement[3] = false 
											triggerServerEvent("syncPlayertoFuelGun", localPlayer, localPlayer, true)
											setElementData(localPlayer, "fuel_gun", false)
											triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elinden gaz pompasını bırakır.")
											if isElement(start) then 
												stopSound(start)
											end
										end
										if math.floor(vehicle_fuel) >= getMaxFuel(vehicle) then 
											outputChatBox(""..exports["titan_pool"]:getServerName()..": Aracının yakıt bölümü zaten dolu.", 255, 255, 255, true)
											if clickElement[3] then 
												triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
												triggerServerEvent("syncPlayereffect", localPlayer, localPlayer, false)
											end
											setElementData(vehicle, "veh_fueling", false)
											clickElement[1]  = false
											clickElement[2] = false 
											clickElement[3] = false 
											gallon = 0
											fuel = 0
											triggerServerEvent("syncPlayertoFuelGun", localPlayer, localPlayer, true)
											setElementData(localPlayer, "fuel_gun", false)
											triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elinden gaz pompasını bırakır.")
											if isElement(start) then 
												stopSound(start)
											end
										else
											if gallon >= (getMaxFuel(vehicle) - vehicle_fuel) then 
												if clickElement[3] then 
													triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
													triggerServerEvent("syncPlayereffect", localPlayer, localPlayer, false)
												end
												--setElementData(localPlayer, "money", getElementData(localPlayer, "money") - math.floor(fuel))
												--setElementData(vehicle, "fuel", vehicle_fuel + math.floor(gallon))
												triggerServerEvent("vehicle_fuel:takeMoneyGiveFuel", localPlayer, localPlayer, vehicle, fuel, gallon)
												clickElement[1]  = false
												clickElement[2] = false 
												gallon = 0
												fuel = 0
												clickElement[3] = false 
												triggerServerEvent("syncPlayertoFuelGun", localPlayer, localPlayer, true)
												setElementData(localPlayer, "fuel_gun", false)
												exports.titan_chat:sendLocalMeMessage(localPlayer, "elinden pompayı bırakır.")
												if isElement(start) then 
													stopSound(start)
												end
											end
										end
									else
										if clickElement[3] then 
											triggerServerEvent("playerAnimationToServer", localPlayer, localPlayer, nil, nil)
											triggerServerEvent("syncPlayereffect", localPlayer, localPlayer, false)
											gallon = 0
											fuel = 0
											if isElement(start) then 
												stopSound(start)
											end
										end
										clickElement[3] = false 
									end
								else
									dxDrawText("Önce aracınızın motorunu söndürün!", 2, 52, sx, sy-50, tocolor(0, 0, 0), 1, font, "center", "bottom")
									dxDrawText("Önce aracınızın motorunu söndürün!", 0, 50, sx, sy-50, tocolor(231, 76, 60), 1, font, "center", "bottom")
								end
							end
						end
					end
				else
					if getElementData(localPlayer, "fuel_gun") then
						clickElement[1]  = false
						triggerServerEvent("syncPlayertoFuelGun", localPlayer, localPlayer, true)

						triggerServerEvent("sendLocalMeAction", localPlayer, localPlayer, "elinden gaz pompasını düşürür.")
						setElementData(localPlayer, "fuel_gun", false)
					end
				end
			end
		end
	end,
0, 0)

function getDistanceFromElement(from, to)
	if not from or not to then return end
	local x, y, z = getElementPosition(from)
	local x1, y1, z1 = getElementPosition(to)
	return getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isbox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end


function isbox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end
