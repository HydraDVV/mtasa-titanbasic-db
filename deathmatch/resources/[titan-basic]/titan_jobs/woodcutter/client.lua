local steven = createPed(220, 1987.0927734375, -2488.2265625, 13.606507301331, 90)
setElementData(steven, "talk", 1)
setElementInterior(steven, 26)
setElementDimension(steven, 155)
setElementData(steven, "name", "Steven Pattybird")
setElementFrozen(steven, true)
setPedAnimation(steven, "BLOWJOBZ", "BJ_Couch_Loop_P", 1, true, false, false)


local AcceptWooder = {
	"Bana uyar, ahbap.",
	"Huh, güzel teklif.",
	"Ne zaman başlıyorum?",
}

local RejectWooder = {
	"İşim olmaz, adamım.",
	"Daha önemli işlerim var.",
	"Meşgulüm, ahbap.",
}

function wooderJobDisplayGUI(thePlayer)
	local carlicense = getElementData(getLocalPlayer(), "license.car")
	
	if (carlicense == 1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Steven Pattybird fısıldar: Ah kakamı yapıyordum.", 255, 255, 255, 3, {}, true)
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Steven Pattybird fısıldar: Neyse, ehliyetin varsa şu dışardaki kamyonlardan bir tanesini al. Başla.", 255, 255, 255, 3, {}, true)
		wooderAcceptGUI(thePlayer)
		return
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Steven Pattybird diyor ki: Hem ehliyetin yok, hem de şu an kakamı yapıyorum, görmüyor musun!", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("wooder:displayJob", true)
addEventHandler("wooder:displayJob", getRootElement(), wooderJobDisplayGUI)

function wooderAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Odunculuk", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			triggerServerEvent("acceptJob", getLocalPlayer(), 8)
			destroyElement(jobWindow)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. AcceptWooder[math.random(#AcceptWooder)], 255, 255, 255, 3, {}, true)
			setTimer(function() exports.titan_hud:sendBottomNotification(getLocalPlayer(), "Odunculuk", "Dışarıdaki kamyonlardan birini alıp, /oduncu basla yazarak işe başlayabilirsiniz!") end, 500, 1)
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
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. RejectWooder[math.random(#RejectWooder)], 255, 255, 255, 3, {}, true)
			return	
		end
	)
end

local wooderMarker = 0
local wooderOldMarker = {}
local wooderRoutes = {
{-373.30874633789,-1053.3381347656,59.21556854248, false},
{-395.05227661133,-1060.5655517578,59.214603424072, false},
{-399.49066162109,-1083.8697509766,60.731941223145, false},
{-366.22595214844,-1113.4561767578,69.643692016602, false},
{-304.57348632813,-1066.9714355469,46.461948394775, false},
{-225.72923278809,-1012.2762451172,22.837924957275, false},
{-159.78311157227,-1013.4946899414,0.93919372558594, false},
{-181.79440307617,-1090.3382568359,2.707558631897, false},
{-246.66937255859,-1178.4150390625,7.3896770477295, false},
{-317.02142333984,-1242.0701904297,21.262235641479, false},
{-332.04891967773,-1302.6661376953,15.354406356812, false},
{-364.07861328125,-1395.4604492188,21.27685546875, false},
{-438.60745239258,-1411.5140380859,21.313911437988, false},
{-468.29681396484,-1447.2631835938,17.514625549316, false},
{-496.8967590332,-1630.8784179688,8.7226276397705, false},
{-473.5576171875,-1677.25,12.105425834656, false},
{-405.85809326172,-1685.1162109375,16.373891830444, false},
{-351.00640869141,-1668.6364746094,27.122276306152, false},
{-297.68041992188,-1676.5977783203,14.862935066223, false},
{-337.86376953125,-1796.15625,18.776391983032, false},
{-371.65451049805,-1993.7738037109,28.178346633911, false},
{-319.22476196289,-2222.2155761719,28.773178100586, false},
{-178.71630859375,-2410.0358886719,35.346851348877, false},
{-54.366870880127,-2561.6938476563,42.354789733887, false},
{-70.189575195313,-2777.7885742188,39.550521850586, false},
{-188.20516967773,-2822.7194824219,42.794178009033, false},
{-337.56457519531,-2792.5866699219,59.938884735107, false},
{-495.42181396484,-2753.3461914063,65.980598449707, false},
{-692.1318359375,-2750.7041015625,72.121536254883, false},
{-876.68615722656,-2819.7973632813,70.369148254395, false},
{-1090.2497558594,-2848.0366210938,67.71875, false},
{-1239.7076416016,-2857.7416992188,65.982276916504, false},
{-1438.806640625,-2852.0874023438,48.413158416748, false},
{-1592.5931396484,-2750.8559570313,48.516777038574, false},
{-1726.9384765625,-2615.5588378906,48.243076324463, false},
{-1804.3094482422,-2543.0141601563,54.596691131592, false},
{-1930.6740722656,-2541.70703125,38.907211303711, false},
{-1973.8197021484,-2541.3352050781,37.533142089844, false},
{-2013.6519775391,-2501.2336425781,32.806861877441, false},
{-1989.0224609375,-2483.7280273438,31.24835395813, false},
{-1961.1569824219,-2476.6206054688,30.625, false},
{-1944.5255126953,-2444.2353515625,30.625, true}, -- bu
{-1933.7305908203,-2440.1127929688,30.625, false},
{-1889.59765625,-2428.2958984375,32.756454467773, false},
{-1833.4865722656,-2460.3112792969,27.316505432129, false},
{-1767.2982177734,-2504.3166503906,8.1245536804199, false},
{-1723.9975585938,-2562.8935546875,12.215344429016, false},
{-1657.8856201172,-2616.3171386719,44.182018280029, false},
{-1568.6907958984,-2635.3166503906,53.573223114014, false},
{-1483.6697998047,-2635.4279785156,44.715850830078, false},
{-1386.0659179688,-2633.1003417969,31.285488128662, false},
{-1324.8492431641,-2631.3879394531,16.832674026489, false},
{-1224.2528076172,-2637.546875,9.5275211334229, false},
{-1174.7884521484,-2638.6396484375,11.7578125, false},
{-1115.9483642578,-2662.1977539063,17.766372680664, false},
{-1058.0302734375,-2676.9509277344,38.503967285156, false},
{-973.18621826172,-2676.0180664063,65.701148986816, false},
{-874.66632080078,-2668.6745605469,97.237525939941, false},
{-787.29772949219,-2687.5170898438,84.974708557129, false},
{-694.82006835938,-2575.4963378906,60.339729309082, false},
{-663.26141357422,-2484.4841308594,35.391914367676, false},
{-578.03112792969,-2371.6069335938,28.311531066895, false},
{-490.3092956543,-2273.9780273438,38.140838623047, false},
{-357.79287719727,-2254.8879394531,42.550140380859, false},
{-311.78314208984,-2226.7734375,29.350173950195, false},
{-294.23550415039,-2176.3820800781,28.387411117554, false},
{-333.1178894043,-2035.8742675781,26.387769699097, false},
{-335.13552856445,-1899.0567626953,23.583194732666, false},
{-283.38064575195,-1747.1746826172,14.850732803345, false},
{-326.34799194336,-1670.2338867188,19.574413299561, false},
{-460.79605102539,-1682.1418457031,12.040199279785, false},
{-503.28778076172,-1644.1774902344,10.607465744019, false},
{-473.35632324219,-1471.2193603516,16.307872772217, false},
{-418.52532958984,-1409.1052246094,23.411624908447, false},
{-338.53991699219,-1338.357421875,13.358424186707, false},
{-321.53656005859,-1246.4650878906,22.49388885498, false},
{-167.94218444824,-1078.6694335938,2.2965178489685, false},
{-165.38404846191,-1007.126953125,0.86130142211914, false},
{-237.43128967285,-1020.0317382813,27.221111297607, false},
{-355.86065673828,-1112.1994628906,68.557281494141, false},
{-406.8056640625,-1078.6016845703,59.557247161865, false},
{-413.62680053711,-1068.1489257813,56.447658538818, false},
{-397.6123046875,-1061.4047851563,59.504112243652, false},
{-368.25082397461,-1052.2716064453,59.310840606689, false},
{-362.83660888672,-1032.7447509766,59.472164154053, true, true}

}

function cstartJob(cmd, arg)
	if arg == "basla" then
		if not wooderBlip then
			local faction = getPlayerTeam(getLocalPlayer())
			local factionType = getElementData(faction, "type")
			local veh = getPedOccupiedVehicle(getLocalPlayer())
			local vehModel = getElementModel(veh)
			local jobVehicle = 478
			
			if vehModel == jobVehicle then
				cupdateRoutes()
				wooderBlip = createBlip(2482.03125, -2629.1064453125, 13.53261089325, 0, 3, 255, 0, 0, 255)
				addEventHandler("onClientMarkerHit", resourceRoot, wooderRoutesMarkerHit)
			end
		else
			exports.titan_hud:sendBottomNotification(localPlayer, "Odunculuk", "Zaten bir sefere başladınız.")
		end
	end
end
addCommandHandler("oduncu", cstartJob)

function cupdateRoutes()
	wooderMarker = wooderMarker + 1
	for i,v in ipairs(wooderRoutes) do
		if i == wooderMarker then
			if not v[4] == true then
				crouteMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				if wooderBlip then
					setElementPosition(wooderBlip, v[1], v[2], v[3])
					setBlipColor(wooderBlip, 255, 0, 0, 255)
				end
				table.insert(wooderOldMarker, { crouteMarker, false })
			elseif v[4] == true and v[5] == true then 
				cfMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				destroyElement(wooderBlip)
				table.insert(wooderOldMarker, { cfMarker, true, true })	
			elseif v[4] == true then
				cpMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(wooderBlip, v[1], v[2], v[3])
				setBlipColor(wooderBlip, 255, 255, 0, 255)
				table.insert(wooderOldMarker, { cpMarker, true, false })			
			end
		end
	end
end

function wooderRoutesMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 478 then
				for _, marker in ipairs(wooderOldMarker) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							cupdateRoutes()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							wooderMarker = 0
							triggerServerEvent("wooder:pay", hitPlayer, hitPlayer)
							exports.titan_hud:sendBottomNotification(hitPlayer, "Odunculuk", "Aracınıza yeni odunlar yükleniyor, lütfen bekleyiniz.")
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									exports.titan_hud:sendBottomNotification(thePlayer, "Odunculuk", "Aracınıza yeni odunlar yüklenmiştir. Gidebilirsiniz.")
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									cupdateRoutes()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							exports.titan_hud:sendBottomNotification(hitPlayer, "Odunculuk", "Aracınızdaki odunlar indiriliyor, lütfen bekleyiniz.")
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									exports.titan_hud:sendBottomNotification(hitPlayer, "Odunculuk", "Aracınızdaki odunlar indirilmiştir, geri dönebilirsiniz.")
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									cupdateRoutes()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function ccancelJob()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	if pedVeh then
		if pedVehModel == 478 then
			exports.titan_global:fadeToBlack()
			for i,v in ipairs(wooderOldMarker) do
				destroyElement(v[1])
			end
			wooderOldMarker = {}
			wooderMarker = 0
			if wooderBlip then
				destroyElement(wooderBlip)
				wooderBlip = nil
			end
			triggerServerEvent("wooder:exitVeh", getLocalPlayer(), getLocalPlayer())
			removeEventHandler("onClientMarkerHit", resourceRoot, wooderRoutesMarkerHit)
			removeEventHandler("onClientVehicleStartEnter", getRootElement(), trashAntiYabanci)
			setTimer(function() exports.titan_global:fadeFromBlack() end, 2000, 1)
		end
	end
end

function trashAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 478 and vehicleJob == 8 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 8 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBu araca binmek için Odunculuk mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), trashAntiYabanci)

function ccantExit(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			ccancelJob()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), ccantExit)