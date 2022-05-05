mysql = exports.titan_mysql

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
					local vehicle = exports.titan_pool:getElement("vehicle", row.id)
					local brand = getElementData(vehicle, "brand") or ""
					local model = getElementData(vehicle, "model") or ""
					local year = getElementData(vehicle, "year") or ""
					local vergi = getElementData(vehicle, "toplamvergi") or 0
					table.insert(playerVehs, { row.id, year.." "..brand.." "..model, tonumber(vergi) })
				end
				
			end
			triggerClientEvent(thePlayer, "phone:taxGUI", thePlayer, playerVehs)
		end,
	{source}, mysql:getConnection(), "SELECT * FROM vehicles WHERE owner = '"..playerID.."' AND deleted=0")

	
end
addEvent("phone:serverTax", true)
addEventHandler("phone:serverTax", root, serverTax)

function payTax(aracID, miktar)
	if aracID and miktar then
		local arac = exports.titan_pool:getElement("vehicle", aracID)
		if arac then
			local vergi = getElementData(arac, "toplamvergi")
			if miktar > vergi then
				exports["titan_infobox"]:addBox(source, "warning", "Ödemeye çalıştığınız miktar, aracın vergi borcundan fazla.")
				return false
			end
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
			exports["titan_infobox"]:addBox(source, "success", "Başarıyla $" .. exports.titan_global:formatMoney(miktar) .. " karşılığında araç verginizi ödediniz. Kalan Vergi: $" .. exports.titan_global:formatMoney(kalanvergi).."")
		
			triggerEvent("saveVehicle", arac, arac)
		end
	end
end
addEvent("phone:payTax", true)
addEventHandler("phone:payTax", root, payTax)