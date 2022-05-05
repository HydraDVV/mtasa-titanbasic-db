local copguy = createPed(16, 1673.3251953125, -1882.83984375, 13.546875,85, true)
setElementData(copguy, "talk", 1)
setElementData(copguy, "name", "Tommy Willson")
setElementFrozen(copguy, true)

function copJobDisplayGUI()
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense==1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Tommy Willson diyor ki: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		copAcceptGUI(getLocalPlayer())
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Tommy Willson diyor ki: La genç, senin ehliyetin yok? Şu karşıdan alıverip öyle gel hadi bakayim.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("cop:displayJob", true)
addEventHandler("cop:displayJob", getRootElement(), copJobDisplayGUI)

function copAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Çöp Taşımacılığı", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			triggerServerEvent("acceptJob", getLocalPlayer(), 3)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Tommy Willson diyor ki: Yandaki çöp arabalarından birini alarak işe başla, dikkatli olmayı unutma.", 255, 255, 255, 3, {}, true)
			setTimer(function() exports.titan_hud:sendBottomNotification(getLocalPlayer(), "Çöp Taşımacılığı", "Yandaki çöp arabalarından birini alıp, /copculukbasla yazarak işe başlayabilirsiniz!") end, 500, 1)
			return	
		end
	)
	
	local line = guiCreateLabel(9, 32, 289, 19, "____________________________________________________", false, jobWindow)
	guiLabelSetHorizontalAlign(line, "center", false)
	guiLabelSetVerticalAlign(line, "center")
	local cancelBtn = guiCreateButton(159, 55, 139, 33, "İptal Et", false, jobWindow)
	addEventHandler("onClientGUIClick", cancelBtn, 
		function()
			destroyElement(jobWindow)
			return	
		end
	)
end

local trashMarker = 0
local trashCreatedMarkers = {}
-- false devam
-- true bekle
-- true, true bitiş
local trashRota = {
	{ 1668.1923828125, -1873.7958984375, 13.3828125, false },
	{ 1691.705078125, -1842.99609375, 13.3828125, false },
	{ 1691.90625, -1776.7666015625, 13.3828125, false },
	{ 1691.849609375, -1659.4599609375, 13.3828125, false },
	{ 1679.4033203125, -1589.7724609375, 13.3828125, false },
	{ 1533.53125, -1590.09765625, 13.3828125, false },
	{ 1440.130859375, -1589.8828125, 13.3828125, false },
	{ 1437.3623046875, -1541.154296875, 13.373303413391, false },

	{ 1455.5791015625, -1488.0126953125, 13.546875, true }, -- 1

	{ 1463.5322265625, -1443.591796875, 13.3828125, false },
	{ 1620.4716796875, -1442.693359375, 13.3828125, false },
	{ 1685.568359375, -1442.15625, 13.929169654846, false },
	{ 1768.8994140625, -1449.7744140625, 13.378098487854, false },
	{ 1906.421875, -1467.1953125, 13.3828125, false },
	{ 1989.298828125, -1466.314453125, 13.390625, false },
	{ 2094.2568359375, -1466.7265625, 23.7998046875, false },
    { 2110.5712890625, -1528.015625, 23.853000640869, false },
	
	{ 2110.0185546875, -1670.1103515625, 13.882961273193, true }, -- 2
	
	{ 2084.30078125, -1772.6650390625, 13.3828125, false },
	{ 2079.0654296875, -1862.958984375, 13.3828125, false },
	{ 2078.80078125, -1926.15234375, 13.294109344482, false },
	{ 2017.759765625, -1929.513671875, 13.328641891479, false },
	{ 1962.2734375, -1929.849609375, 13.3828125, false },
	{ 1959.3876953125, -1995.837890625, 13.390586853027, false },
    { 1959.43359375, -2111.6181640625, 13.3828125, false },
	{ 1919.96484375, -2164.2900390625, 13.3828125, false },
	{ 1872.384765625, -2164.1396484375, 13.3828125, false },
	{ 1798.3330078125, -2164.7197265625, 13.3828125, false },
	{ 1742.8095703125, -2163.8642578125, 13.3828125, false },
	{ 1647.3583984375, -2159.751953125, 21.809825897217, false },
	{ 1558.2685546875, -2097.740234375, 33.807006835938, false },
	{ 1531.9853515625, -2007.9228515625, 26.854488372803, false },
	{ 1531.669921875, -1954.87890625, 19.900289535522, false },
	{ 1532.0166015625, -1875.29296875, 13.390607833862, false },
	
	{ 1505.962890625, -1870.251953125, 13.3828125, false },
	{ 1447.9033203125, -1870.0908203125, 13.390607833862, false },
	
    { 1391.1435546875, -1869.162109375, 13.390600204468, false },
	{ 1390.6953125, -1764.322265625, 13.3828125, true }, -- 3
	
	 { 1415.1865234375, -1734.408203125, 13.390607833862, false },
	 { 1528.2568359375, -1734.876953125, 13.3828125, false },
	 { 1567.052734375, -1768.0458984375, 13.3828125, false },
	  { 1566.876953125, -1839.1943359375, 13.3828125, false },
	{ 1585.998046875, -1874.6328125, 13.3828125, false },
	
	{ 1627.478515625, -1874.53515625, 13.3828125, true,true },

}

function trashBasla(cmd)
	if not getElementData(getLocalPlayer(), "trashSoforlugu") then
		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 408
		
		if oyuncuArac and getVehicleController(oyuncuArac) == getLocalPlayer() then
		if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "trashSoforlugu", true)
			updatetrashRota()
			addEventHandler("onClientMarkerHit", resourceRoot, trashRotaMarkerHit)
			end
			else
		exports.titan_hud:sendBottomNotification(localPlayer, "Çöp Şöförlüğü", "Çöp seferine başlamak için meslek aracında bulunmalısınız. (Çöpçülük)")
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("copculukbasla", trashBasla)

function updatetrashRota()
	trashMarker = trashMarker + 1
	for i,v in ipairs(trashRota) do
		if i == trashMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(trashCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(trashCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(trashCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function trashRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 408 then
				for _, marker in ipairs(trashCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatetrashRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							trashMarker = 0
							triggerServerEvent("trashparaVer", hitPlayer, hitPlayer)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /trashbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetrashRota()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updatetrashRota()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function trashBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local trashSoforlugu = getElementData(getLocalPlayer(), "trashSoforlugu")
	if pedVeh then
		if pedVehModel == 408 then
			if trashSoforlugu then
				exports.titan_global:fadeToBlack()
				setElementData(getLocalPlayer(), "trashSoforlugu", false)
				for i,v in ipairs(trashCreatedMarkers) do
					destroyElement(v[1])
				end
				trashCreatedMarkers = {}
				trashMarker = 0
				triggerServerEvent("trashBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, trashRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), trashAntiYabanci)
				setTimer(function() exports.titan_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("copculukbitir", trashBitir)

function trashAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 408 and vehicleJob == 3 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 3 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBu araca binmek için trash Şoförlüğü mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), trashAntiYabanci)

function trashAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			trashBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), trashAntiAracTerketme)