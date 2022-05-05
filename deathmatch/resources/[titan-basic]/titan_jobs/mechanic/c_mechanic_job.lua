-- Main Mechanic window
wMechanic, bMechanicOne, bMechanicOne, bMechanicThree, bMechanicFour, bMechanicFive, bMechanicSix, bMechanicEight, bMechanicNine, bMechanicClose = nil

-- Tyre change window
wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil

-- Paintjob window
wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil

-- Upgrade window
wUpgrades, gUpgrades, bUpgradesClose = nil

currentVehicle = nil
vehicleWithPaintjob = { [534] = true, [535] = true, [558] = true, [559] = true, [560] = true, [561] = true, [562] = true, [565] = true, [483] = true }

function displayMechanicJob()
	outputChatBox("#FF9933Use the #FF0000right-click menu#FF9933 to view the services you can provide.", 255, 194, 15, true)
end

local noTyres = { Boat = true, Helicopter = true, Plane = true, Train = true }
local noUpgrades = { Boat = true, Helicopter = true, Plane = true, Train = true, BMX = true }

function mechanicWindow(vehicle)
	local job = getElementData(getLocalPlayer(), "job")
	--local playerDimension = getElementDimension(getLocalPlayer())
	local faction = getElementData(getLocalPlayer(), "faction")
	if (job==5) then
	--[[local theTeam = getPlayerTeam(localPlayer)
	local factionType = tonumber(getElementData(theTeam, "type"))
	if factionType == 7 then -- Mechanic Faction / Adams]]
		if not vehicle then
			outputChatBox("Bir araç seçmelisiniz.", 255, 0, 0)
		else
			currentVehicle = vehicle
			-- Window variables
			local Width = 200
			local Height = 450
			local screenwidth, screenheight = guiGetScreenSize()
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			if not (wMechanic) then
				-- Create the window
				wMechanic = guiCreateWindow(X, Y, Width, Height, "Tamirci Paneli ", false )
				
				local y = 0.05
				-- Body work
				--bMechanicOne = guiCreateButton( 0.05, y, 0.9, 0.1, "Bodywork Repair - $50", true, wMechanic )
				--addEventHandler( "onClientGUIClick", bMechanicOne, bodyworkTrigger, false)
				--y = y + 0.1
				
				-- Service
				bMechanicTwo = guiCreateButton( 0.05, y, 0.9, 0.1, "Tamir Et - 1,500$", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicTwo, serviceTrigger, false)
				y = y + 0.1
				
				-- Tyre Change
				if not noTyres[getVehicleType(vehicle)] then
					bMechanicThree = guiCreateButton( 0.05, y, 0.9, 0.1, "Lastikleri Değiştir - $80", true, wMechanic )
					addEventHandler( "onClientGUIClick", bMechanicThree, tyreWindow, false)
					y = y + 0.1
				end
				
				--if (playerDimension > 0) then
				
					-- Recolour
					if faction == 4 or ( tonumber( getElementData(vehicle, "job") or 0 ) == 0 and ( getElementData(vehicle, "faction") == -1 or getElementData(vehicle, "faction") == faction ) ) then
						bMechanicFour = guiCreateButton( 0.05, y, 0.9, 0.1, "Aracı Boya - 1,500$", true, wMechanic )
						
						addEventHandler( "onClientGUIClick", bMechanicFour, paintWindow, false)
						y = y + 0.1
					end
					
					-- Paintjob
					if vehicleWithPaintjob[getElementModel(vehicle)] then
						bMechanicSix = guiCreateButton( 0.05, y, 0.9, 0.1, "Kaplama Yap - $7,500", true, wMechanic )
						addEventHandler( "onClientGUIClick", bMechanicSix, paintjobWindow, false)
						y = y + 0.1
					end
					
					-- Replace lights
					--if vehicleWithPaintjob[getElementModel(vehicle)] then
						bMechanicNine = guiCreateButton( 0.05, y, 0.9, 0.1, "Renkli Farlar - $7,500", true, wMechanic )
						addEventHandler( "onClientGUIClick", bMechanicNine, replaceLightsWindow, false)
						y = y + 0.1
					--end
					
					-- remove NOS for BTR
					if getVehicleUpgradeOnSlot(vehicle, 8) ~= 0 and faction == 4 then
						bMechanicSeven = guiCreateButton( 0.05, y, 0.9, 0.1, "Remove NOS", true, wMechanic )
						addEventHandler( "onClientGUIClick", bMechanicSeven, removeNosFromVehicle, false)
						y = y + 0.1
					end

					-- Add/Remove Tint for BTR
					if faction == 5 then
						if not getElementData(vehicle, "tinted") then
							bMechanicEight = guiCreateButton( 0.05, y, 0.9, 0.1, "Cam Film'i Ekle - $5,500", true, wMechanic )
							addEventHandler( "onClientGUIClick", bMechanicEight, addTintWindow, false)
							y = y + 0.1
						else
							bMechanicEight = guiCreateButton( 0.05, y, 0.9, 0.1, "Cam Film'i Çıkar - $2,000", true, wMechanic )
							addEventHandler( "onClientGUIClick", bMechanicEight, removeTintWindow, false)
							y = y + 0.1
						end
					end
				--end
				
				-- Close
				bMechanicClose = guiCreateButton( 0.05, 0.85, 0.9, 0.1, "Kapat", true, wMechanic )
				addEventHandler( "onClientGUIClick", bMechanicClose, closeMechanicWindow, false )
				
				showCursor(true)
			end
		end
	end
end
addEvent("openMechanicFixWindow")
addEventHandler("openMechanicFixWindow", getRootElement(), mechanicWindow)

function removeNosFromVehicle()
	triggerServerEvent( "removeNOS", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function addTintWindow()
	triggerServerEvent("tintedWindows", getLocalPlayer(), currentVehicle, 1)
	closeMechanicWindow()
end

function removeTintWindow()
	triggerServerEvent("tintedWindows", getLocalPlayer(), currentVehicle, 2)
	closeMechanicWindow()
end

function tyreWindow()
	-- Window variables
	local Width = getVehicleType(currentVehicle) == "Bike" and 100 or 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wTyre) then
		-- Create the window
		wTyre = guiCreateWindow(X+100, Y, Width, Height, "Değişecek Olan Tekeri Seçiniz.", false )
		
		if getVehicleType(currentVehicle) ~= "Bike" then
			-- Front left
			bTyreOne = guiCreateButton( 0.05, 0.1, 0.45, 0.35, "Sol Ön", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreOne, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 1)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- Back left
			bTyreTwo = guiCreateButton( 0.05, 0.5, 0.45, 0.35, "Sol Arka.", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreTwo, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 2)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- front right
			bTyreThree = guiCreateButton( 0.5, 0.1, 0.45, 0.35, "Sağ Ön", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreThree, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 3)
					closeMechanicWindow()
					
				end
			end, false)
			
			-- back right
			bTyreFour = guiCreateButton( 0.5, 0.5, 0.45, 0.35, "Sağ Arka", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreFour, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 4)
					closeMechanicWindow()
					
				end
			end, false)
		else
			-- Front
			bTyreOne = guiCreateButton( 0.05, 0.1, 0.9, 0.35, "Ön", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreOne, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 1)
					closeMechanicWindow()
					
				end
			end, false)
		
			-- back right
			bTyreThree = guiCreateButton( 0.05, 0.5, 0.9, 0.35, "Arka", true, wTyre )
			addEventHandler( "onClientGUIClick", bTyreThree, function(button, state)
				if(button == "left" and state == "up") then
					
					triggerServerEvent( "tyreChange", getLocalPlayer(), currentVehicle, 2)
					closeMechanicWindow()
					
				end
			end, false)
		end
		-- Close
		bTyreClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Kapat", true, wTyre )
		addEventHandler( "onClientGUIClick", bTyreClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bTyreOne)
				if bTyreTwo then
					destroyElement(bTyreTwo)
				end
				destroyElement(bTyreThree)
				if bTyreFour then
					destroyElement(bTyreFour)
				end
				destroyElement(bTyreClose)
				destroyElement(wTyre)
				wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
				
			end
		end, false)
	end
end

-- Paint window
wPaint, iColour1, iColour2, iColour3, iColour4, colourChart, bPaintSubmit, bPaintClose, currentColor = nil
r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = nil
local savedPaintColors = {}
function paintColor( colorIndex )
	if exports.titan_colorblender:isPickerOpened("paintjob") then
		outputChatBox("You're still editing another colour, fool.", 255, 0 ,0)
		return
	end
	local r, g, b = 0,0 ,0
	r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true )
	if colorIndex == 1 then
		r = r1
		g = g1
		b = b1
	elseif colorIndex == 2 then
		r = r2
		g = g2
		b = b2
	elseif colorIndex == 3 then
		r = r3
		g = g3
		b = b3
	elseif colorIndex == 4 then
		r = r4
		g = g4
		b = b4
	end
	currentColor = colorIndex
	exports.titan_colorblender:openPicker("paintjob", string.format("#%02X%02X%02X", r, g, b) , "Pick a color for your vehicle:")
end

addEventHandler("onColorPickerChange", root, 
 function(element, hex, r, g, b)
	if element == "paintjob" and currentColor then
		-- Its for us!
		local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
		if currentColor == 1 then
			r1 = r
			g1 = g
			b1 = b
		elseif currentColor == 2 then
			r2 = r
			g2 = g
			b2 = b
		elseif currentColor == 3 then
			r3 = r
			g3 = g
			b3 = b
		elseif currentColor == 4 then
			r4 = r
			g4 = g
			b4 = b
		end
		
		triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, {r1, g1, b1}, {r2, g2, b2}, {r3, g3, b3}, {r4, g4, b4})
	elseif element == "headlights" then
		triggerServerEvent( "headlightPreview", localPlayer, currentVehicle, r, g, b)
	end
end)

--

addEventHandler("onColorPickerOK", root,
	function(id, hex, r, g, b)
		if id == 'paintjob' and currentColor then
			savedPaintColors[currentColor] = {r, g, b}
			triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, unpack(savedPaintColors))
		elseif id == 'headlights' then
			triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
			triggerServerEvent( "editVehicleHeadlights", localPlayer, currentVehicle, r, g, b)
		end
	end)

--

addEventHandler("onColorPickerCancel", root,
	function(id, hex, r, g, b)
		if id == 'paintjob' then
			triggerServerEvent( "colorPreview", getLocalPlayer(), currentVehicle, unpack(savedPaintColors))
		elseif id == 'headlights' then
			triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
		end
	end)

--

function paintWindow()

	local windowWidth = 400
	local windowHeight = 300
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowX = (screenWidth - windowWidth)/2
	local windowY = (screenHeight - windowHeight)/2

	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
	savedPaintColors = { { r1, g1, b1 }, { r2, g2, b2 }, { r3, g3, b3 }, { r4, g4, b4 } }

	if not (wPaint) then
		wPaint = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Araç Boyası", false )
		bPaintColor1 = guiCreateButton( 0.05, 0.1, 0.45, 0.2, "Ana Kaporta", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor1,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 1 )
			end
		end, false)	 
		bPaintColor2 = guiCreateButton( 0.55, 0.1, 0.45, 0.2, "Koltuk Rengi", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor2,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 2 )
			end
		end, false)	
		bPaintColor3 = guiCreateButton( 0.05, 0.4, 0.45, 0.2, "Jant Rengi", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor3,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 3 )
			end
		end, false)	
		bPaintColor4 = guiCreateButton( 0.55, 0.4, 0.45, 0.2, "2.Kaporta", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintColor4,  function(button, state)
			if(button == "left" and state == "up") then
				paintColor( 4 )
			end
		end, false)	
		
		bPaintSubmit = guiCreateButton( 0.05, 0.75, 0.90, 0.1, "Kaydet", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintSubmit,  function(button, state)
			if(button == "left" and state == "up") then
				local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)	
				triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
				triggerServerEvent( "repaintVehicle", getLocalPlayer(), currentVehicle, {r1, g1, b1}, {r2, g2, b2}, {r3, g3, b3}, {r4, g4, b4})
				
				exports.titan_colorblender:closePicker("paintjob")
				closeMechanicWindow()
			end
		end, false)
		
		bPaintClose = guiCreateButton( 0.05, 0.85, 0.90, 0.1, "Kapat", true, wPaint )
		addEventHandler( "onClientGUIClick", bPaintClose,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wPaint)
				wPaint = nil
				triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
				exports.titan_colorblender:closePicker("paintjob")
				guiSetInputEnabled(false)
			end
		end, false)	 
	end
end

function replaceLightsWindow()
	if exports.titan_colorblender:isPickerOpened("paintjob") then
		outputChatBox("You're still editing another colour, fool.", 255, 0 ,0)
		return
	end

	local r, g, b = getVehicleHeadLightColor( currentVehicle )
	exports.titan_colorblender:openPicker("headlights", string.format("#%02X%02X%02X", r, g, b) , "Pick a color for the lights:")
end

function paintjobWindow()
	-- Window variables
	local Width = 200
	local Height = 300
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wPaintjob) then
		oldPaintjob = getVehiclePaintjob( currentVehicle )
		oldColors = { getVehicleColor( currentVehicle ) }
		
		-- Create the window
		wPaintjob = guiCreateWindow(X+100, Y, Width, Height, "Yeni Bir Kaplama Seç.", false )
		
		-- Paintjob 1
		bPaintjob1 = guiCreateButton( 0.05, 0.1, 0.9, 0.17, "Kaplama 1", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob1, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 0)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob1, function()
			if source == bPaintjob1 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 0)
			end
		end)
		
		-- Paintjob 2
		bPaintjob2 = guiCreateButton( 0.05, 0.3, 0.9, 0.17, "Kaplama 2", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob2, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 1)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob2, function()
			if source == bPaintjob2 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 1)
			end
		end)
		
		-- Paintjob 3
		bPaintjob3 = guiCreateButton( 0.05, 0.5, 0.9, 0.17, "Kaplama 3", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob3, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 2)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob3, function()
			if source == bPaintjob3 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 2)
			end
		end)
		
		-- Paintjob 4
		bPaintjob4 = guiCreateButton( 0.05, 0.7, 0.9, 0.17, "Kaplama 4", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjob4, function(button, state)
			if(button == "left" and state == "up") then
				
				triggerServerEvent( "paintjobChange", getLocalPlayer(), currentVehicle, 3)
				closeMechanicWindow()
				
			end
		end, false)
		addEventHandler( "onClientMouseEnter", bPaintjob4, function()
			if source == bPaintjob4 then
				triggerServerEvent( "paintjobPreview", getLocalPlayer(), currentVehicle, 3)
			end
		end)
		
		function restorePaintjob()
			triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
		end
		
		addEventHandler( "onClientMouseLeave", bPaintjob1, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob2, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob3, restorePaintjob)
		addEventHandler( "onClientMouseLeave", bPaintjob4, restorePaintjob)
		
		-- Close
		bPaintjobClose = guiCreateButton( 0.05, 0.9, 0.9, 0.1, "Kapat", true, wPaintjob )
		addEventHandler( "onClientGUIClick", bPaintjobClose,  function(button, state)
			if(button == "left" and state == "up") then
				
				destroyElement(bPaintjob1)
				destroyElement(bPaintjob2)
				destroyElement(bPaintjob3)
				destroyElement(bPaintjob4)
				destroyElement(bPaintjobClose)
				destroyElement(wPaintjob)
				wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil
				triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
				
			end
		end, false)
	end
end

function serviceTrigger()
	triggerServerEvent( "serviceVehicle", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function bodyworkTrigger()
	triggerServerEvent( "repairBody", getLocalPlayer(), currentVehicle )
	closeMechanicWindow()
end

function closeMechanicWindow()
	if exports.titan_colorblender:closePicker("headlights") then
		triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
	end
	
	if(wTyre)then
		destroyElement(bTyreOne)
		if bTyreTwo then
			destroyElement(bTyreTwo)
		end
		destroyElement(bTyreThree)
		if bTyreFour then
			destroyElement(bTyreFour)
		end
		destroyElement(bTyreClose)
		destroyElement(wTyre)
		wTyre, bTyreOne, bTyreTwo, bTyreThree, bTyreFour, bTyreClose = nil
	end
	
	if(wPaint)then
		if isElement(iColour1) then
			destroyElement(iColour1)
		end
		if isElement(iColour2) then
			destroyElement(iColour2)
		end
		if isElement(iColour3) then
			destroyElement(iColour3)
		end
		if isElement(iColour4) then
			destroyElement(iColour4)
		end
		if isElement(lcol1) then
			destroyElement(lcol1)
		end
		if isElement(lcol2) then
			destroyElement(lcol2)
		end
		if isElement(lcol3) then
			destroyElement(lcol3)
		end
		if isElement(lcol4) then
			destroyElement(lcol4)
		end
		if isElement(colourChart) then
			destroyElement(colourChart)
		end
		if isElement(bPaintClose) then
			destroyElement(bPaintClose)
		end
		destroyElement(wPaint)
		wPaint, iColour1, iColour2, iColour3, iColour4, lcol1, lcol2, lcol3, lcol4, colourChart, bPaintClose = nil
		triggerServerEvent( "colorEndPreview", getLocalPlayer(), currentVehicle)
		guiSetInputEnabled(false)
	end
	
	if wPaintjob then
		destroyElement(bPaintjob1)
		destroyElement(bPaintjob2)
		destroyElement(bPaintjob3)
		destroyElement(bPaintjob4)
		destroyElement(bPaintjobClose)
		destroyElement(wPaintjob)
		wPaintjob, bPaintjob1, bPaintjob2, bPaintjob3, bPaintjob4, bPaintjobClose = nil
		triggerServerEvent( "paintjobEndPreview", getLocalPlayer(), currentVehicle)
	end
	
	if wUpgrades then
		destroyElement(bUpgradesClose)
		destroyElement(gUpgrades)
		destroyElement(wUpgrades)
		wUpgrades, gUpgrades, bUpgradesClose = nil
		
		if oldUpgradeSlot then
			triggerServerEvent( "upgradeEndPreview", getLocalPlayer(), currentVehicle, oldUpgradeSlot)
			oldUpgradeSlot = nil
		end
	end
	
	if bMechanicOne then
		destroyElement(bMechanicOne)
	end
	if bMechanicTwo then
		destroyElement(bMechanicTwo)
	end
	if bMechanicThree then
		destroyElement(bMechanicThree)
	end
	if bMechanicFour then
		destroyElement(bMechanicFour)
	end
	if bMechanicFive then
		destroyElement(bMechanicFive)
	end
	if bMechanicSix then
		destroyElement(bMechanicSix)
	end
	if bMechanicEight then
		destroyElement(bMechanicEight)
	end
	if bMechanicClose then
		destroyElement(bMechanicClose)
	end
	destroyElement(wMechanic)
	wMechanic, bMechanicOne, bMechanicOne, bMechanicClose, bMechanicThree, bMechanicFour, bMechanicFive, bMechanicSix, bMechanicEight = nil
	
	currentVehicle = nil
	exports.titan_colorblender:closePicker("paintjob")
	showCursor(false)
end