local badges = {}
masks = {}

local maxIconsPerLine = 6


function startRes()
	for key, value in ipairs(getElementsByType("player")) do
		setPlayerNametagShowing(value, false)
	end
	
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startRes)


function setNametagOnJoin()
	setPlayerNametagShowing(source, false)
end
addEventHandler("onClientPlayerJoin", getRootElement(), setNametagOnJoin)

function isPlayerMoving(player)
	return (not isPedInVehicle(player) and (getPedControlState(player, "forwards") or getPedControlState(player, "backwards") or getPedControlState(player, "left") or getPedControlState(player, "right") or getPedControlState(player, "accelerate") or getPedControlState(player, "brake_reverse") or getPedControlState(player, "enter_exit") or getPedControlState(player, "enter_passenger")))
end

local lastrot = nil

function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and ( getPedWeapon(localPlayer) == 34 or getPedWeapon(localPlayer) == 43 )
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end

function getPlayerIcons(name, player, forTopHUD, distance)
	distance = distance or 0
	local tinted, masked = false, false
	local icons = {}
		if not forTopHUD then
			if getElementData(player,"hiddenadmin") ~= 1 then
				if getElementData(player,"duty_admin") == 1 then		
					if exports.titan_integration:isPlayerDeveloper(player) then
                        table.insert(icons, "developeradm")						
					elseif exports.titan_integration:isPlayerTrialAdmin(player) and getElementData(player, "admin_level") <= 7  then
						table.insert(icons, "a"..getElementData(player, "admin_level").."_on")				
					end
				end

				if getElementData(player,"duty_supporter") == 1 then		
					if exports.titan_integration:isPlayerSupporter(player) and getElementData(player, "supporter_level") <= 5  then
						table.insert(icons, "r"..getElementData(player, "supporter_level").."_on")				
					end
				end
			end

			if getElementData(player, "afk") then
				table.insert(icons, "afk")
			end
			
			if getElementData(player, "rp+") == 1 then
				table.insert(icons, "rparti")
			end

           
			if getElementData(player,"youtuber") == 1 then
				table.insert(icons, "youtuberEtiketi")
			end

			if getElementData(player,"donatortag") == 1 then
				table.insert(icons, "donatorEtiketi3")
			end

            if getElementData(player, "maske") == 1 then
				name = "Maskeli Şahıs ("..(getElementData(player, "dbid")*1)..")"
				r, g, b = 255, 194, 14
			else
				name = name
            end			
			
		end


		if (getElementData(player, "vipver") or 0) > 0 then
			table.insert(icons, "vip"..getElementData(player, "vipver"))
		end

		if (getElementData(player, "bantli")) then
			table.insert(icons, "bantli")
		end


		if (getElementData(player, "written")) then
			table.insert(icons, "written")
		end
		
		local vehicle = getPedOccupiedVehicle(player)
		local windowsDown = vehicle and getElementData(vehicle, "vehicle:windowstat") == 1

		if vehicle and not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
			local seat0 = getVehicleOccupant(vehicle, 0) == player
			local seat1 = getVehicleOccupant(vehicle, 1) == player
			if seat0 or seat1 then
				if distance > 1.4 then
					name = "Bilinmeyen Kişi (Tint)"
					tinted = true
				end
			else
				name = "Bilinmeyen Kişi (Tint)"
				tinted = true
			end
		end
		for key, value in pairs(masks) do
			if getElementData(player, value[1]) then
				table.insert(icons, value[1])
				if value[4] then
					masked = true
				end
			end
		end
		if not tinted then
			local veh = getPedOccupiedVehicle(player)
			if getElementData(player,"seatbelt") and veh and getVehicleType(veh) ~= "Bike" then
				table.insert(icons, 'seatbelt')
			end

			for k, v in pairs(badges) do
				local title = getElementData(player, k)
				if title then
					if k:find("bandana") then
						table.insert(icons, 'bandana')
						name = "Bilinmeyen Kişi (Bandana)"
						badge = true
					else
						table.insert(icons, "badge1")
						name = title .. "\n" .. name
						badge = true
					end
				end
			end

			if tonumber(getElementData(player, 'cellphoneGUIStateSynced') or 0) > 0 then
				table.insert(icons, 'phone')
			end

			if not forTopHUD then
				local health = getElementHealth( player )
				local tick = math.floor(getTickCount () / 1000) % 2
				if health <= 10 and tick == 0 then
					table.insert(icons, 'bleeding')
				elseif (health <= 30) then
					table.insert(icons, 'lowhp')
				end

				if getElementData(player, "restrain") == 1 then
					table.insert(icons, "handcuffs")
				end
				if getElementData(player, "bandana") == 1 then
					table.insert(icons, "health")
				end				
			end
						if getPedArmor( player ) > 0 then
				table.insert(icons, 'armour')
			end
		end

		if not forTopHUD then
			if windowsDown then
				table.insert(icons, 'window2')
			end
		end
		if masked then
			name = "Bilinmeyen Kişi (#"..(getElementData(player, "dbid"))..")"
		end
	
	return name, icons, tinted, badge
end

function renderIcons()
	if not isPlayerMapVisible() then
		local lx, ly, lz = getElementPosition(localPlayer)
		local dim = getElementDimension(localPlayer)

		for key, player in ipairs(getElementsByType("player", root, true)) do
			if (isElement(player)) and getElementDimension(player) == dim then
				local logged = getElementData(player, "loggedin")

				if (logged == 1) then
					local rx, ry, rz = getElementPosition(player)
					local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
					local limitdistance = 5
					local reconx = false
					if isElementOnScreen(player) then
						if (aimsAt(player) or distance<limitdistance or reconx) then
							if not getElementData(player, "reconx") and not getElementData(player, "freecam:state") and not (getElementAlpha(player) < 255) then
								local lx, ly, lz = getCameraMatrix()
								local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, getPedOccupiedVehicle(player))
	
								if not (collision) or (reconx) then
								
									local x, y, z = getElementPosition(player)

									local sx, sy = getScreenFromWorldPosition(x, y, z+1.20, 100, false)
									local badge = false
									local tinted = false
									local name = getPlayerName(player):gsub("_", " ")
									
									if (sx) and (sy) then
										distance = distance / 5
										local oldsy = sy
										if (reconx or aimsAt(player)) then distance = 1
										elseif (distance<1) then distance = 1
										elseif (distance>2) then distance = 2 end

										name, icons, tinted, theBadge = getPlayerIcons(name, player, false, distance)

										if not theBadge then theBadge = false end
										picxsize = 50 / 2 --/distance
										picysize = 50 / 2 --/distance
										if theBadge then
											ypos = 32
										else
											ypos = 26
										end
										local xpos = 0

										ypos = ypos - (distance/36)
										
										local expectedIcons = math.min(#icons, maxIconsPerLine)
										local iconsThisLine = 0
										local newY = 0
										local offset = 16 * expectedIcons
										newY = newY/distance
										local alphaq = 150
										if getKeyState("lalt") then
											alphaq = 255
										end
										for k, v in ipairs(icons) do
												dxDrawImage(sx-offset+xpos+10,40+oldsy+newY+ypos/distance,picxsize-2,picysize-2,"components/" .. v .. ".png", 0, 1, -120, tocolor(255, 255, 255))
												iconsThisLine = iconsThisLine + 1
												if iconsThisLine == expectedIcons then
													expectedIcons = math.min(#icons - k, maxIconsPerLine)
													offset = 16 * expectedIcons
													iconsThisLine = 0
													xpos = 0
													ypos = ypos + 32
												else
													xpos = xpos + 30
												end
											end

										if (distance<=2) then
											sy = math.ceil( sy + ( 2 - distance ) * 20 )
										end
										sy = sy + 10

										if (distance<=2) then
											sy = math.ceil( sy - ( 2 - distance ) * 40 )
										end
										sy = sy - 20

										if (sx) and (sy) then
											if (distance < 1) then distance = 1 end
											if (distance > 2) then distance = 2 end
											local offset = 75 / distance
											

											if badge then
												sy = sy - dxGetFontHeight(scale, font) * scale + 2.5
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

	end
end
setTimer(renderIcons, 0, 0)

local afkEDN = "afk"
local ox,oy,oz = getElementPosition(localPlayer)
setTimer(
    function()
        local nx, ny, nz = getElementPosition(localPlayer)
        if math.floor(ox) == math.floor(nx) and math.floor(oy) == math.floor(ny) and math.floor(oz) == math.floor(ny) then
            setElementData(localPlayer, afkEDN, true)
            moveAfk = true
        else
            if moveAfk then
                if not clickAfk and not minimizeAfk then
                    setElementData(localPlayer, afkEDN, false)
                end
            end
        end
        ox,oy,oz = nx,ny,nz
    end, 30 * 1000, 0
)


addEventHandler("onClientCursorMove", getRootElement(),
    function(x, y)
		lastClick = getTickCount()
		if getElementData(localPlayer,afkEDN) and not isMTAWindowActive() then
			setElementData(localPlayer,afkEDN,false)
		end
    end
)


addEventHandler("onClientMinimize", getRootElement(), 
	function()
		setElementData(localPlayer,afkEDN,true)
        minimizeAfk = true
		createTrayNotification( "www.titan-network.com | Seni Bekliyoruz. - "..exports["titan_pool"]:getServerName().." Roleplay", "warning" )
	end
)

addEventHandler("onClientRestore", getRootElement(), 
	function()
		setElementData(localPlayer,afkEDN,false)
        minimizeAfk = false
	end
)