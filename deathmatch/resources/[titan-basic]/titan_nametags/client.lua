local badges = {}
masks = {}
local font =  exports.titan_fonts:getFont("AwesomeFont", 9)

local maxIconsPerLine = 6


function startRes()
	for key, value in ipairs(getElementsByType("player")) do
		setPlayerNametagShowing(value, false)
	end
	
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startRes)

function initStuff(res)
	if (res == getThisResource() and getResourceFromName("titan_items")) or getResourceName(res) == "titan_items" then
		for key, value in pairs(exports['titan_items']:getBadges()) do
			badges[value[1]] = { value[4][1], value[4][2], value[4][3], value[5], value.bandana or false }
		end

		masks = exports['titan_items']:getMasks()
	end
end
addEventHandler("onClientResourceStart", getRootElement(), initStuff)

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

function getBadgeColor(player)
	for k, v in pairs(badges) do
		if getElementData(player, k) then
			return unpack(badges[k])
		end
	end
end

function getPlayerIcons(name, player, forTopHUD, distance)
	distance = distance or 0
	local tinted, masked = false, false
	local icons = {}
		if not forTopHUD then
			if getElementData(player,"hiddenadmin") ~= 1 then
				if getElementData(player,"duty_admin") == 1 then -- and getElementData(player, "admin_level") <= 5
					if exports.titan_integration:isPlayerDeveloper(player) then
						table.insert(icons, "developeradm")
					elseif exports.titan_integration:isPlayerTrialAdmin(player) and getElementData(player, "admin_level") <= 6  then
						table.insert(icons, "a"..getElementData(player, "admin_level").."_on")
					end
				end

				if exports.titan_integration:isPlayerSupporter(player) and getElementData(player,"duty_supporter") == 1 then
					table.insert(icons, 'rehber_on')
				end
			end

			if getElementData(player, "afk") then
				table.insert(icons, "afk")
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
					name = "Bilinmeyen Ki??i (Tint)"
					tinted = true
				end
			else
				name = "Bilinmeyen Ki??i (Tint)"
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
							name = "Bilinmeyen Ki??i (Bandana)"
							badge = true
						else
							table.insert(icons, "badge1")
							name = title .. " - " .. name
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
			name = "Bilinmeyen Ki??i (#"..(getElementData(player, "playerid"))..")"
		end
	
	return name, icons, tinted, badge
end


local oldMoney = getElementData(localPlayer, "money")
function renderNametags()
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

										if not theBadge then theBadge = false end
										picxsize = 50 / 2 --/distance
										picysize = 50 / 2 --/distance
										if theBadge then
											ypos = 40
										else
											ypos = 34
										end
										local xpos = 0

										ypos = ypos - (distance/36)
										
										local newY = 0
										local offset = 16
										newY = newY/distance
										local alphaq = 0
										if getKeyState("lalt") then
											alphaq = 255
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
											local r, g, b = getBadgeColor(player)
											if not r or tinted then
												r, g, b = getPlayerNametagColor(player)
											end
											local id = getElementData(player, "playerid")
													name, icons, tinted, theBadge = getPlayerIcons(name, player, false, distance)
								

											if badge then
												sy = sy - dxGetFontHeight(scale, font) * scale + 2.5
											end
											
											local afkstate = getElementData(player, "afk")
											if (afkstate) then
												name = "[AFK] ".. name		
												r, g, b = 145, 145, 145
											end	
											
											local afkstate = getElementData(player, "dead")
											if (afkstate==1) then
												name = "[Bayg??n] ".. name	
												r, g, b = 255, 0, 0
											end												
											if getElementData(player, "gasmask") then
												name = name
											else
												name = name.." ("..id..")"
											end											
											local sy = sy - distance*3
											local tx, ty, tw, th = sx-offset, sy, (sx-offset)+150 / distance, sy+112 / distance
											dxDrawText("??? "..name, tx+2, ty+1, tw+1, th+1, tocolor(0, 0, 0), 1, font, "center", "center", false, false, false, true, false)
											dxDrawText("??? "..name, tx+1, ty+1, tw+1, th+1, tocolor(0, 0, 0), 1, font, "center", "center", false, false, false, true, false)		
											dxDrawText("??? "..name, tx, ty, tw, th, tocolor(r, g, b,255), 1, font, "center", "center", false, false, false, true, false)
											local sy = sy - distance*3
											local tx, ty, tw, th = sx-offset, sy, (sx-offset)+150 / distance, sy+150 / distance
											dxDrawText("??? HP: %"..math.floor(getElementHealth(player)), tx+2, ty+1, tw+1, th+1, tocolor(0, 0, 0), 1, font, "center", "center", false, false, false, true)
											dxDrawText("??? HP: %"..math.floor(getElementHealth(player)), tx+1, ty+1, tw+1, th+1, tocolor(0, 0, 0), 1, font, "center", "center", false, false, false, true)
											dxDrawText("??? HP: #00ff00%"..math.floor(getElementHealth(player)), tx, ty, tw, th, tocolor(255, 255, 255), 1, font, "center", "center", false, false, false, true)
											local sy = sy - distance*3
											local tx, ty, tw, th = sx-offset, sy, (sx-offset)+150 / distance, sy+185 / distance
											dxDrawText("??? Armor: %"..math.floor(getPedArmor(player)), tx+2, ty+1, tw+1, th+1, tocolor(0, 0, 0), 1, font, "center", "center", false, false, false, true)
											dxDrawText("??? Armor: %"..math.floor(getPedArmor(player)), tx+1, ty+1, tw+1, th+1, tocolor(0, 0, 0), 1, font, "center", "center", false, false, false, true)
											dxDrawText("??? Armor: #5e6063%"..math.floor(getPedArmor(player)), tx, ty, tw, th, tocolor(255, 255, 255), 1, font, "center", "center", false, false, false, true)
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
setTimer(renderNametags, 0, 0)

function RemoveHEXColorCode( s )
	if tonumber(s) then return end
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end

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
	end
)

addEventHandler("onClientRestore", getRootElement(), 
	function()
		setElementData(localPlayer,afkEDN,false)
        minimizeAfk = false
	end
)