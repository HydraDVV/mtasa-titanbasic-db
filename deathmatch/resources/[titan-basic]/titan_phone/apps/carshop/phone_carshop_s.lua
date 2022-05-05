mysql = exports.titan_mysql

function phoneBuyVeh(vehid, brandid, rgb, balance, vehname, plateState, plateEditText)
	local player = source



	local r, g, b = unpack(rgb)
	if tonumber(vehid) and tonumber(brandid) then
		if exports.titan_global:takeMoney(player, balance) then
			outputChatBox("[-]#ffffff Başarıyla aracının siparişini verdin. Şimdi Vers Otomotiv'den aracını teslim al.", player, 66, 155, 245, true)
			outputChatBox("[-]#ffffff "..vehname.." isimli aracın siparişine toplam "..balance.." TL ödedin.", player, 30, 230, 35, true)

			local hours = getRealTime().hour
			local minutes = getRealTime().minute
			local seconds = getRealTime().second
			local day = getRealTime().monthday
			local month = getRealTime().month+1
			local year = getRealTime().year+1900
			exports.titan_global:sendMessageToAdmins("[PHONE CARSHOP] '" .. getPlayerName(player) .. "' isimli oyuncu "..vehname.." isimli aracı satın aldı.")
		
			local pr = getPedRotation(player)
			local dbid = getElementData(player, "dbid")
			local x, y, z = getElementPosition(player)
			x = x + ( ( math.cos ( math.rad ( pr ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( pr ) ) ) * 5 )
			local model = vehid
			local veh = createVehicle(model, x,y,z)
			setVehicleColor(veh, r,g,b)
			local rx, ry, rz = getElementRotation(veh)
			local var1, var2 = exports['titan_vehicle']:getRandomVariant(vehid)
			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90))

			if plateEditText == "" then
				plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
			else
				plate = plateEditText
			end
			local color1 = toJSON( {r,g,b} )
			local color2 = toJSON( {0, 0, 0} )
			local color3 = toJSON( {0, 0, 0} )
			local color4 = toJSON( {0, 0, 0} )
			local interior, dimension = getElementInterior(player), getElementDimension(player)
			local tint = 0
			local factionVehicle = -1
			local inserted = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET model='" .. (vehid) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (pr) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (pr) .. "', locked='1', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', tintedwindows='" .. (tint) .. "',variant1='"..var1.."',variant2='"..var2.."', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='"..brandid.."' ")
			if inserted then
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							local insertid = res[1].id
							if not insertid then
								exports.global:giveMoney(player, balance)
								exports.titan_global:sendMessageToAdmins("[PHONE CARSHOP] '" .. getPlayerName(player) .. "' isimli oyuncu "..vehname.." marka aldığı araç işlenemediği için parası iade edildi.")
								outputChatBox("Aldığın araç veritabanına işlenemediği için paran iade edildi!", player, 255,0,0)
								return false
							end
							call( getResourceFromName( "titan_items" ), "deleteAll", 3, insertid )
							exports.titan_global:giveItem( player, 3, insertid )
							--setElementData(veh, "dbid", insertid)
							destroyElement(veh)
							exports['titan_vehicle']:reloadVehicle(insertid)
						end
					end,
				mysql:getConnection(), "SELECT id FROM vehicles WHERE id=LAST_INSERT_ID() LIMIT 1")
			end
		else
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bu aracı sipariş verebilmen için yeterli paran yok.", player, 255, 0, 0, true)
		end
	end
end
addEvent("phone->buyCar", true)
addEventHandler("phone->buyCar", root, phoneBuyVeh)


function serverTax(thePlayer)
	if thePlayer then
		source = thePlayer
	end
	local playerID = getElementData(source, "dbid")
	local factID = getElementData(source, "faction")
	dbQuery(
		function(qh, thePlayer)
			local res, rows, err = dbPoll(qh, 0)
			local playerVehs = {}
			if rows > 0 then
				
				for index, row in ipairs(res) do
				
					--local vehicle = exports.titan_pool:getElement("vehicle", row.id)
					--local brand = getElementData(vehicle, "brand") or ""
					--local model = getElementData(vehicle, "model") or ""
					--local year = getElementData(vehicle, "year") or ""
					--local price = getElementData(vehicle, "price") or 100
					--table.insert(playerVehs, { row.id, year.." "..brand.." "..model, tonumber(price) })
				end
				
			end
			triggerClientEvent(thePlayer, "carshop:vehGUI", thePlayer, playerVehs)
		end,
	{source}, mysql:getConnection(), "SELECT * FROM `vehicles_shop` WHERE `enabled` = '1'")

	
end
addEvent("carshop:serverTax", true)
addEventHandler("carshop:serverTax", root, serverTax)

