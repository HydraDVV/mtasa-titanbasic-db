mysql = exports.titan_mysql --
local thePed = createPed(186, 1478.48046875, -1772.4150390625, 158.03689575195)
setElementDimension(thePed, 175)
setElementInterior(thePed, 0)
setElementRotation(thePed,  0, 0, 0)
setElementFrozen(thePed, true)
setElementData(thePed, "talk", 1)
setElementData(thePed, "name", "Christian Cylar")


function setVergi(thePlayer, cmd, miktar)
if exports.titan_integration:isPlayerDeveloper(thePlayer) then
	 local vehicle = getPedOccupiedVehicle(thePlayer)
	 if vehicle then

		 setElementData(vehicle, "faizkilidi", true)
	 end
 end
 end
 addCommandHandler("setvergi", setVergi)

 function setVergi2(thePlayer, cmd, miktar)
if exports.titan_integration:isPlayerDeveloper(thePlayer) then
	 local veh = getPedOccupiedVehicle(thePlayer)
	 if veh then
		 setElementData(veh, "faizkilidi", false)
	 end
 end
 end
 addCommandHandler("vergikaldir", setVergi2)

function sVergiGUI(thePlayer)
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
					local vehicle = exports.titan_pool:getElement("vehicle", row.id)
					local brand = getElementData(vehicle, "brand") or ""
					local model = getElementData(vehicle, "model") or ""
					local year = getElementData(vehicle, "year") or ""
					local vergi = getElementData(vehicle, "toplamvergi") or 0
					table.insert(playerVehs, { row.id, year.." "..brand.." "..model, tonumber(vergi) })
				end
				
			end
			triggerClientEvent(thePlayer, "vergi:VergiGUI", thePlayer, playerVehs)
		end,
	{source}, mysql:getConnection(), "SELECT * FROM vehicles WHERE owner = '"..playerID.."' AND deleted=0")

	
end
addEvent("vergi:sVergiGUI", true)
addEventHandler("vergi:sVergiGUI", root, sVergiGUI)

function VergiOde(aracID, miktar)
	if aracID and miktar then
		local arac = exports.titan_pool:getElement("vehicle", aracID)
		if arac then
			local vergi = getElementData(arac, "toplamvergi")
			if miktar > vergi then
				exports["titan_infobox"]:addBox(source, "warning", "Ödemeye çalıştığınız miktar, aracın vergi borcundan fazla.")
				return false
			end
			-- if miktar < vergi then
				-- outputChatBox("[-] #f0f0f0Ödemeye çalıştığınız miktar aracın vergi borcuna yetmiyor.", source, 255, 0, 0, true)
				-- return false
			-- end
			local playerMoney = getElementData(source, "money")
			if not exports.titan_global:hasMoney(source, miktar) then
			exports["titan_infobox"]:addBox(source, "error", "Yeterli paranız yok.")
				return false			
			end
			local kalanvergi = vergi - miktar
			if getElementData(arac, "faizkilidi") then -- eğer faizkilidi varsa
				if kalanvergi <= 0 then -- eğer kalan vergi 0 isElement
					setElementData(arac, "faizkilidi", false) -- faiz kaldır
				end
			end	
			setElementData(arac, "toplamvergi", kalanvergi)
			
			exports.titan_global:takeMoney(source, miktar)
			dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `ceza`='"..tonumber(kalanvergi).."' WHERE `id`='"..aracID.."' ")	
			dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `vergi`='"..tonumber(kalanvergi).."' WHERE `id`='"..aracID.."' ")	
			exports["titan_infobox"]:addBox(source, "success", "Başarıyla $" .. exports.titan_global:formatMoney(miktar) .. " karşılığında araç verginizi ödediniz. Kalan Vergi: $" .. exports.titan_global:formatMoney(kalanvergi))
		
			triggerEvent("saveVehicle", arac, arac)
		end
	end
end
addEvent("vergi:VergiOde", true)
addEventHandler("vergi:VergiOde", root, VergiOde)

function vergiBonus()
		for _, vehicle in ipairs(exports.titan_pool:getPoolElementsByType("vehicle")) do
		local vehicleID = getElementData(vehicle, "dbid")
		local vehOwner = getElementData(vehicle, "owner")
		local vehFact = getElementData(vehicle, "faction")
		if vehicleID > 0 and vehOwner > 0 and vehFact ~= 1 then
			local toplamVergi = getElementData(vehicle, "toplamvergi") or 0
			local faizKilidi = getElementData(vehicle, "faizkilidi")
			local vehShopID = getElementData(vehicle, "vehicle_shop_id")
			local carShopDetails = exports["titan_vehicle_manager"]:getInfoFromVehShopID(vehShopID)
			if carShopDetails then
				local vergiMiktari = carShopDetails.vehtax
				local vergiSiniri = math.ceil((carShopDetails.vehprice / 100) * 20)
				setElementData(vehicle, "toplamvergi", toplamVergi + vergiMiktari)
				dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `vergi`='"..toplamVergi + vergiMiktari.."' WHERE `id`='"..vehicleID.."' ")						
				local yeniVergi = getElementData(vehicle, "toplamvergi")
				if yeniVergi >= vergiSiniri then
					setElementData(vehicle, "faizkilidi", true)
					setVehicleEngineState(vehicle, false)
					setVehicleLocked(vehicle, true)
					setElementData(vehicle, "enginebroke", 1)
				end
			end
		end
	end
end
setTimer(vergiBonus, 10800000, 0)
