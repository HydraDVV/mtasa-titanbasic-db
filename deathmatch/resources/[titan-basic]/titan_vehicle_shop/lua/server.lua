mysql = exports.titan_mysql
connection = mysql:getConnection()

vehicleShop = {}
ped = {}
addEventHandler("onResourceStart", resourceRoot , function()
	shopUpdate()
	for k,v in ipairs(getShops()) do 
		ped[k] = createPed(118, v.shop_ped[1], v.shop_ped[2], v.shop_ped[3],350)
		ped[k]:setData('alern:carshop:ped', true)
		ped[k]:setData('alern:carshop:ped:name', v.name)
		ped[k]:setData('alern:carshop:ped:id', k)
		ped[k]:setFrozen(true)
	end 
end)

function shopUpdate()
    vehicleShop = {}
    dbQuery(function(qh)
        local res , rows = dbPoll(qh , 0)
        if rows > 0 then
            for key , row in ipairs(res) do 
                vehicleShop[row.id] = {
                    id = row.id,
                    gta = row.vehmtamodel,
                    brand = row.vehbrand,
                    model = row.vehmodel,
                    year  = row.vehyear,
                    price = row.vehprice,
					tax   = row.vehtax,
					spawnto = row.spawnto
                }
            end
        end
    end , connection , "SELECT * FROM `vehicles_shop` WHERE `enabled` = '1' AND `spawnto`!='0'")
end

function open(plr)
        triggerClientEvent(plr , "alern:carshop" , plr , vehicleShop)
end
addEvent("alern:carshop:open" , true)
addEventHandler("alern:carshop:open" , root , open)

setTimer(shopUpdate , 1000*60*60 , 0)

function SmallestID()
	local result = exports.titan_mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
		if result then 
			local id = tonumber(result["nextID"]) or 1
			return id 
		end 
	return false 
end 
addEvent('vehicle:buy', true)
addEventHandler('vehicle:buy', root, function(gta, mta, color, price, spawnto) 
	source = source
	if source then 
		if source:getData('money') < tonumber(price) then  outputChatBox("Bu aracı satın alabilmek için "..exports['titan_global']:formatMoney(price).."₺ miktarda paranız olmalı.", source, 255, 0, 0) return end 
		if not exports.titan_global:canPlayerBuyVehicle(client) then outputChatBox("Araç almak için yeterli yeriniz yok '/market'en araç hakkı alabilirsiniz", source, 255, 0, 0) return end 
		outputChatBox("[-]#ffffff Aracı başarıyla satın aldınız, /park yapmayı unutmayın!", source, 66, 155, 245, true)
						triggerClientEvent(source, 'destroy:window', source)
		local pr = 357 
		local owner = source:getData('dbid')
		local random_sayi = math.random(1,#shops[spawnto].veh_buy)
		local x,y,z = shops[spawnto].veh_buy[random_sayi][1], shops[spawnto].veh_buy[random_sayi][2], shops[spawnto].veh_buy[random_sayi][3]
		local veh = Vehicle(gta, x, y, z)
		setVehicleColor(veh, color[1], color[2], color[3])
		local rx, ry, rz = getElementRotation(veh)
		local var1, var2 = exports['titan_vehicle']:getRandomVariant(gta)
		local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90))
		plate = "34 ".. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
		exports["titan_global"]:takeMoney(source,  price)
		local color1 = toJSON({color[1], color[2], color[3]})
		local color2 = toJSON({color[4], color[5], color[6]})
		local color3 = toJSON({color[7], color[8], color[9]})
		local color4 = toJSON({color[10], color[11], color[12]})
		local interior, dimension = source.interior, source.dimension 
		local tint = 0
		local factionVehicle = -1
		local alernid = SmallestID() 
		local inserted = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id ='"..alernid.."' ,model='" .. (gta) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (pr) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (owner) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (pr) .. "', locked='1', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', tintedwindows='" .. (tint) .. "',variant1='"..var1.."',variant2='"..var2.."', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='"..mta.."' ")
			exports['titan_vehicle']:reloadVehicle(alernid)
			call( getResourceFromName( "titan_items" ), "deleteAll", 3, alernid )
			exports.titan_global:giveItem( source, 3, alernid)
			destroyElement(veh)					
	end 
end)
