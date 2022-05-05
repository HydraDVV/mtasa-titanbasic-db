local sx, sy = guiGetScreenSize()
local spotifyGUIs = {}

shownSpotify = false
function toggleSpotify(bool)
	if (bool == true) then
		createSpotifyGUI()
		addEventHandler("onClientGUIClick", root, clickSpotifyFunctions)
		addEventHandler("onClientRender", root, checkMyWaiter)
		shownSpotify = true
	else
		for k,v in ipairs(spotifyGUIs) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		if shownSpotify then
			removeEventHandler("onClientGUIClick", root, clickSpotifyFunctions)
			removeEventHandler("onClientRender", root, checkMyWaiter)
		end
		shownSpotify = false
	end
end

function createSpotifyGUI()
	y = 45
	spotifyGUIs[1] = guiCreateButton(40,384+y,185,30,"",false,wPhoneMenu)
	spotifyGUIs[2] = guiCreateButton(77,340+y,50,30,"",false,wPhoneMenu)
	spotifyGUIs[3] = guiCreateButton(77+58,340+y,50,30,"",false,wPhoneMenu)
	guiSetAlpha(spotifyGUIs[1],0)
	guiSetAlpha(spotifyGUIs[2],0)
	guiSetAlpha(spotifyGUIs[3],0)

	--spotifyGUIs[2] = guiCreateLabel(40, 330+y, 185, 20, "Aktif Spotify Çalışanı: Yükleniyor", false, wPhoneMenu)
	setTimer(
		function()
			local total_spotifys = 0
			for i,v in pairs(getElementData(root, "spotifyPersonels")) do
				total_spotifys = total_spotifys + 1
			end
			--guiSetText(spotifyGUIs[2], "Aktif Spotify Çalışanı: "..total_spotifys)
		end,
	700, 1)
	--spotifyGUIs[3] = guiCreateLabel(40, 355+y, 185, 20, "", false, wPhoneMenu)
end

function checkMyWaiter()
	spotifyTable = getElementData(root, "spotifyWaiters")
	for index, value in pairs(spotifyTable) do
		if localPlayer == index then
			--guiSetText(spotifyGUIs[3], "Spotify kaydın oluşturuldu.")
		else
			--guiSetText(spotifyGUIs[3], "")
		end
	end
end
local radioLink = "https://17703.live.streamtheworld.com/VIRGIN_RADIO.mp3"
local sound = playSound(radioLink)
setSoundVolume(sound, 0)
function clickSpotifyFunctions(state)
	if state == "left" then
		if source == spotifyGUIs[1] then
			if getElementData(localPlayer, "spotify") then
					outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#f9f9f9 Spotify'ı durdurdun.", 122, 222, 100, true)
					setElementData(localPlayer, "spotify", nil)
					setSoundVolume(sound, 0)
				return
			end
			x, y, z = getElementPosition(localPlayer)
			dim, int = getElementDimension(localPlayer), getElementInterior(localPlayer)
			if (tonumber(dim) == 0 and tonumber(int) == 0) then
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#f9f9f9 Başarıyla Spotify otomatik dinlemeyi açtın. Kapatmak için tekrardan bas.", 122, 222, 100, true)
				setElementData(localPlayer, "spotify", true)
				if getElementData(localPlayer, "spotify") then
					setSoundVolume(sound, 0.051)

				end
			end
		elseif source == spotifyGUIs[2] then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#f9f9f9 Spotify oynatma listesini bir geriye aldın. Oynat / Durdur butonuna tıklayarak işlemini onayla.", 122, 222, 100, true)
			radioLink = "https://17703.live.streamtheworld.com/VIRGIN_RADIO.mp3"
			stopSound(sound)
			sound = playSound(radioLink)
		elseif source == spotifyGUIs[3] then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#f9f9f9 Spotify oynatma listesini bir ileriye aldın. Oynat / Durdur butonuna tıklayarak işlemini onayla.", 122, 222, 100, true)
			radioLink = "https://playerservices.streamtheworld.com/api/livestream-redirect/JOY_FM.mp3"
			stopSound(sound)
			sound = playSound(radioLink)
		end
	end
end

function checkForMeSpotify(player)
	spotifyTable = getElementData(root, "spotifyWaiters")
	for index, value in pairs(spotifyTable) do
		if player == index then
			return true--already spotify
		else
			return false
		end
	end
	return false
end


local sx, sy = guiGetScreenSize()
local uStaff, uWaiters = {}
local shownPanel = false
local w,h = 262/1.4, 552/1.4
local selectedWaiter = -1
local activeMenu = 1
local totalPrice = 0
local currentTotalPrice = 50

addEvent("spotify-system:showSpotifyPanel", true)
addEventHandler("spotify-system:showSpotifyPanel", root,
	function(staff,waiters)
		uStaff, uWaiters = staff,waiters
		shownPanel = not shownPanel
		if shownPanel then
			window = guiCreateWindow(15,sy-h-30,w,h,"",false)
			guiSetAlpha(window, 0)
			activeMenu = 1
			outputChatBox("[>] #ffffffYön tuşları ile Spotify Yönetim paneli içinde gezinebilirsiniz.", 0, 255, 0, true)
			bindKey("arrow_l", "down", MenuChangerLeft)
			bindKey("arrow_r", "down", MenuChangerRight)
		else
			destroyElement(window)
			activeMenu = 1
			selectedWaiter = -1
			unbindKey("arrow_l", "down", MenuChangerLeft)
			unbindKey("arrow_r", "down", MenuChangerRight)
		end
	end
)

addEvent("spotify-system:updateTable", true)
addEventHandler("spotify-system:updateTable", root,
	function(staff,waiters)
		uStaff, uWaiters = staff,waiters
	end
)

addEvent("spotify-system:createNavigation", true)
addEventHandler("spotify-system:createNavigation", root,
	function(x,y,z)
		exports["titan_ed_irp_navigation"]:findBestWay(x,y,z)
	end
)

function MenuChangerLeft()
	if activeMenu > 1 then
		activeMenu = activeMenu - 1
	end
end

function MenuChangerRight()
	if activeMenu < 2 then
		activeMenu = activeMenu + 1
	end
end

addEventHandler("onClientRender", root,
	function()
		if shownPanel then
			w,h = 262/1.4, 552/1.4
			x,y = guiGetPosition(window, false)
			dxDrawImage(x,y,w,h,"components/images/iphone_front.png",0,0,0,tocolor(255,255,255))
			dxDrawImage(x,y,w,h,"components/images/iphone_front_spotifyadmin.png",0,0,0,tocolor(255,255,255))
			w = w-30
			x = x + 15
			y = y + 170
			if activeMenu == 1 then

				icount = 0
				for index, value in pairs(uWaiters) do
					icount = icount +1
					if selectedWaiter == index then
						dxDrawRectangle(x,y+(icount*24),w,20, tocolor(70,70,70,210))
					else
						dxDrawRectangle(x,y+(icount*24),w,20, tocolor(70,70,70,140))
					end
					if isInBoxHover(x,y+(icount*24),w,20) and getKeyState("mouse1") then
						selectedWaiter = index
					end
				--	dxDrawText(value[1]:gsub("_", " ").." - "..getZoneName(value[2],value[3],value[4]),x+10,y+(icount*24),w,20+(y+(icount*24)), tocolor(255,255,255), 1, "default-bold", "left", "center")
				end

				--okayButton
				if isInBoxHover(x+5,y+h-270,w-10,25) then
					dxDrawRectangle(x+5,y+h-270,w-10,25,tocolor(220,220,220,140))
					dxDrawText("Kişiyi Al", x+5,y+h-270,w-10+(x+5),25+(y+h-270), tocolor(0,0,0), 1, "default-bold", "center", "center")
				else
					dxDrawRectangle(x+5,y+h-270,w-10,25,tocolor(70,70,70,140))
					dxDrawText("Kişiyi Al", x+5,y+h-270,w-10+(x+5),25+(y+h-270), tocolor(255,255,255), 1, "default-bold", "center", "center")
				end
			elseif activeMenu == 2 then

				--oturum sıfırla
				if isInBoxHover(x+5,y+h-270,w-10,25) then
					dxDrawRectangle(x+5,y+h-270,w-10,25,tocolor(220,220,220,140))
					dxDrawText("Oturum Kazancını Sıfırla", x+5,y+h-270,w-10+(x+5),25+(y+h-270), tocolor(0,0,0), 1, "default-bold", "center", "center")
				else
					dxDrawRectangle(x+5,y+h-270,w-10,25,tocolor(70,70,70,140))
					dxDrawText("Oturum Kazancını Sıfırla", x+5,y+h-270,w-10+(x+5),25+(y+h-270), tocolor(255,255,255), 1, "default-bold", "center", "center")
				end

				--oturum kazancı
				if isInBoxHover(x+5,y+h-300,w-10,25) then
					dxDrawRectangle(x+5,y+h-300,w-10,25,tocolor(220,220,220,140))
					dxDrawText("Toplam Oturum Kazancı: $"..totalPrice, x+5,y+h-300,w-10+(x+5),25+(y+h-300), tocolor(0,0,0), 1, "default-bold", "center", "center")
				else
					dxDrawRectangle(x+5,y+h-300,w-10,25,tocolor(70,70,70,140))
					dxDrawText("Toplam Oturum Kazancı: $"..totalPrice, x+5,y+h-300,w-10+(x+5),25+(y+h-300), tocolor(255,255,255), 1, "default-bold", "center", "center")
				end


				--taksimetre
				veh = getPedOccupiedVehicle(localPlayer)
				local clockState = tonumber(getElementData(veh, "Taxi->clockState") or 0)
				if clockState == 0 then
					if isInBoxHover(x+5,y+h-400,w-10,25) then
						dxDrawRectangle(x+5,y+h-400,w-10,25,tocolor(220,220,220,140))
						dxDrawText("Taksimetre başlat ("..currentTotalPrice.."$/km)", x+5,y+h-400,w-10+(x+5),25+(y+h-400), tocolor(0,0,0), 1, "default-bold", "center", "center")
					else
						dxDrawRectangle(x+5,y+h-400,w-10,25,tocolor(70,70,70,140))
						dxDrawText("Taksimetre başlat", x+5,y+h-400,w-10+(x+5),25+(y+h-400), tocolor(255,255,255), 1, "default-bold", "center", "center")
					end
				else
					local miles = yardToMile(tonumber(getElementData(veh, "Taxi->traveledMeters") or 0))
					if isInBoxHover(x+5,y+h-400,w-10,25) then
						dxDrawRectangle(x+5,y+h-400,w-10,25,tocolor(220,220,220,140))
						dxDrawText("Taksimetre durdur", x+5,y+h-400,w-10+(x+5),25+(y+h-400), tocolor(0,0,0), 1, "default-bold", "center", "center")
					else
						dxDrawRectangle(x+5,y+h-400,w-10,25,tocolor(70,70,70,140))
						dxDrawText("Taksimetre durdur", x+5,y+h-400,w-10+(x+5),25+(y+h-400), tocolor(255,255,255), 1, "default-bold", "center", "center")
					end
				
					dxDrawText(math.ceil(miles*currentTotalPrice).."$", x+5,y+h-370,w-10+(x+5),25+(y+h-370), tocolor(255,255,255), 1, "default-bold", "center", "center")
				end

				--[[
				--taksimetre $ ayarlama:
				if isInBoxHover(x+5,y+h-270,w-10,25) then
					dxDrawRectangle(x+5,y+h-270,w-10,25,tocolor(220,220,220,140))
					dxDrawText("Ücret ayarla:", x+15,y+h-270,w-10+(x+5),25+(y+h-270), tocolor(0,0,0), 1, "default-bold", "left", "center")
				else
					dxDrawRectangle(x+5,y+h-270,w-10,25,tocolor(70,70,70,140))
					dxDrawText("Ücret ayarla:", x+15,y+h-270,w-10+(x+5),25+(y+h-270), tocolor(255,255,255), 1, "default-bold", "left", "center")
				end]]--
			end
		end
	end
)

addEventHandler("onClientClick", root,
	function(b,s,_,_,_,_,_,element)
		if shownPanel then
			if ((b == "left") and (s == "down")) then
				if activeMenu == 1 then
					if isInBoxHover(x+5,y+h-270,w-10,25) then--ok
						if selectedWaiter ~= -1 then
							vehicle = getPedOccupiedVehicle(localPlayer)
							if vehicle then
								x,y,z = getElementPosition(selectedWaiter)
								triggerServerEvent("spotify-system:receiveWaiterPersonel", localPlayer, localPlayer, selectedWaiter, x, y, z)
							else
								outputChatBox("Navigasyonu alabilmek için araca binmen gerekiyor!", 255, 0, 0)
							end
						else
							outputChatBox("Bir seçim yapmanız gerekiyor!", 255, 0, 0)
						end
					end
				elseif activeMenu == 2 then
					if isInBoxHover(x+5,y+h-270,w-10,25) then
						totalPrice = 0
						outputChatBox("Oturum kazancı sıfırlandı!", 0, 255, 0)
					elseif isInBoxHover(x+5,y+h-400,w-10,25) then
						veh = getPedOccupiedVehicle(localPlayer)
						local clockState = tonumber(getElementData(veh, "Taxi->clockState") or 0)
						if clockState == 0 then
							setElementData(veh, "Taxi->traveledMeters", 0)
							setElementData(veh, "Taxi->clockState", 1)
							taxiCounter(true, veh)
							taxi_veh_startX, taxi_veh_startY, taxi_veh_startZ = getElementPosition(veh)
						else
							local miles = yardToMile(tonumber(getElementData(veh, "Taxi->traveledMeters") or 0))
							totalPrice = totalPrice + math.ceil(miles*currentTotalPrice)
							print(totalPrice)
							setElementData(veh, "Taxi->clockState", 0)
							taxiCounter(false, veh)
						end
					end
				end
			end
		end
	end
)

local taxiTimer
local oldX, oldY, oldZ = -1, -1, -1
function taxiCounter(state, veh)
	if state then
		if not isTimer(taxiTimer) then
			taxiTimer = setTimer(function()
				if getElementSpeed(veh, "mph") > 0 then
					local current_veh_x, current_veh_y, current_veh_z = getElementPosition(veh)
					if oldX == -1 then
						oldX, oldY, oldZ = current_veh_x, current_veh_y, current_veh_z
					end
					local distance = getDistanceBetweenPoints3D(oldX, oldY, oldZ, current_veh_x, current_veh_y, current_veh_z)
				
					setElementData(veh, "Taxi->traveledMeters", math.ceil(getElementData(veh, "Taxi->traveledMeters") + math.abs(distance)))
					oldX, oldY, oldZ = current_veh_x, current_veh_y, current_veh_z
				end
			end, 1000,0)
		end
	else
		if isTimer(taxiTimer) then
			killTimer(taxiTimer)
		end
	end
end

function getElementSpeed(element, unit)
	if (unit == nil) then
		unit = 0
	end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)

		if (unit == "mph" or unit == 1 or unit == '1') then
			return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100)
		else
			return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100 * 1.609344)
		end
	else
		return false
	end
end

function conditionToShow()
	local vehicle = getPedOccupiedVehicle(localPlayer)
    if isPedInVehicle(localPlayer) and vehicle then
		return true
	end
	return false
end

function yardToMile(yard)
	if yard then
		yard = (yard * 0.000568181818) -- 1 yard = 0.000568181818 miles
	end
	return yard
end


function isInBoxHover(dX, dY, dSZ, dM)
	if isCursorShowing() then
		local cX ,cY = getCursorPosition()
		cX,cY = cX*sx , cY*sy
	    if(cX >= dX and cX <= dX+dSZ and cY >= dY and cY <= dY+dM) then
	        return true, cX, cY
	    else
	        return false
	    end
	end
end

-- spotify-system // add new personal
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if getElementData(localPlayer, "job") == 20 then triggerServerEvent("spotify-system:addNewPerson", localPlayer, localPlayer) end
	end
)

addEventHandler("onClientElementDataChange", root,
	function(dataName, oldValue, newValue)
		if (source == localPlayer) then
			if (dataName == "job") then
				local value = getElementData(source, dataName)
				if tonumber(value) == 20 then
					triggerServerEvent("spotify-system:addNewPerson", source, source)
				elseif tonumber(value) ~= 20 and oldValue == 4 then
					triggerServerEvent("spotify-system:removePerson", source, source)
				end
			end
		end
	end
)