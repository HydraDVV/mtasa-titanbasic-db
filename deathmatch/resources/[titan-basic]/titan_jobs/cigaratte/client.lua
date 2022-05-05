local badguy2 = createPed(220, -83.0537109375, -1203.0810546875, 2.890625)
setElementData(badguy2, "talk", 345)
setElementData(badguy2, "name", "Daniel Tylor")
setElementFrozen(badguy2, true)

local AcceptCigar = {
	"Bana uyar, ahbap.",
	"Huh, güzel teklif.",
	"Ne zaman başlıyorum?",
}

local RejectCigar = {
	"İşim olmaz, adamım.",
	"Daha önemli işlerim var.",
	"Meşgulüm, ahbap.",
}

function cigarJobDisplayGUI(thePlayer)
	local faction = getPlayerTeam(thePlayer)
	local ftype = getElementData(faction, "type")

	if (ftype) and (ftype == 0) or (ftype == 1) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Daniel Tylor fısıldar: Hey, elimde bir iş var. Ne dersin, ha?", 255, 255, 255, 3, {}, true)
		cigarAcceptGUI(thePlayer)
		return
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Daniel Tylor diyor ki: Seninle bir işim yok. Derhal toz ol buradan.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("cigar:displayJob", true)
addEventHandler("cigar:displayJob", getRootElement(), cigarJobDisplayGUI)

function cigarAcceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Tütün Nakliye", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			triggerServerEvent("acceptJob", getLocalPlayer(), 6)
			destroyElement(jobWindow)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. AcceptCigar[math.random(#AcceptCigar)], 255, 255, 255, 3, {}, true)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Daniel Tylor diyor ki: Yandaki vanlardan birini alarak işe başla, araçlar yüklü ve yola çıkmaya hazır. Bol şanslar, ahbap.", 255, 255, 255, 3, {}, true)
			setTimer(function() exports.titan_hud:sendBottomNotification(getLocalPlayer(), "Tütün Nakliye", "Yandaki beyaz kamyonlardan birini alıp, /tutun basla yazarak işe başlayabilirsiniz!") end, 500, 1)
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
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. RejectCigar[math.random(#RejectCigar)], 255, 255, 255, 3, {}, true)
			return	
		end
	)
end

-- ROTA --
local cigarMarker = 0
local cigarOldMarker = {}
local cigarRoutes = {
{-114.49465179443,-1186.79296875,2.6953125, false},
{-112.19498443604,-1169.4426269531,2.7027721405029, false},
{-102.2827835083,-1148.8840332031,1.5732288360596, false},
{-85.792633056641,-1113.3483886719,1.5992064476013, false},
{-77.519973754883,-1064.0037841797,15.888703346252, false},
{-82.476821899414,-1041.5933837891,22.529544830322, false},
{-126.7233581543,-981.74542236328,26.009941101074, false},
{-155.09228515625,-956.39471435547,29.29959487915, false},
{-228.83857727051,-905.44171142578,42.021419525146, false},
{-294.43048095703,-871.52789306641,46.838928222656, false},
{-367.87786865234,-840.20526123047,47.263954162598, false},
{-409.53427124023,-825.19354248047,48.076011657715, false},
{-474.7509765625,-851.60113525391,51.039119720459, false},
{-547.22149658203,-918.64117431641,57.486518859863, false},
{-605.90740966797,-972.92608642578,64.043304443359, false},
{-663.34979248047,-1000.1393432617,69.796752929688, false},
{-737.59912109375,-1004.1301269531,75.88892364502, false},
{-812.28955078125,-1005.8860473633,82.319274902344, false},
{-840.41436767578,-1021.4868164063,86.144332885742, false},
{-874.21612548828,-1075.4228515625,93.943153381348, false},
{-889.37994384766,-1139.275390625,100.95502471924, false},
{-897.12371826172,-1234.1995849609,110.51597595215, false},
{-907.13903808594,-1343.02734375,121.02468109131, false},
{-935.72833251953,-1396.1260986328,127.66303253174, false},
{-1018.7720336914,-1369.4478759766,130.337890625, false},
{-1079.8905029297,-1342.7830810547,129.390625, false},
{-1174.2282714844,-1335.3299560547,125.57144927979, false},
{-1296.9986572266,-1371.9635009766,116.85340118408, false},
{-1373.3426513672,-1404.4764404297,109.35481262207, false},
{-1421.7918701172,-1407.0540771484,103.06609344482, false},
{-1433.3154296875,-1388.2016601563,101.28830718994, false},
{-1440.8958740234,-1335.541015625,100.49620819092, false},
{-1450.4552001953,-1291.6689453125,100.88082885742, false},
{-1443.6923828125,-1251.8917236328,106.86122131348, false},
{-1445.6302490234,-1167.5555419922,104.67364501953, false},
{-1470.9243164063,-1140.6711425781,116.12271118164, false},
{-1510.0832519531,-1102.869140625,131.55009460449, false},
{-1541.8800048828,-1057.9359130859,136.84422302246, false},
{-1540.8531494141,-1004.1017456055,154.20962524414, false},
{-1520.1614990234,-978.93585205078,171.53741455078, false},
{-1501.494140625,-998.61462402344,174.78492736816, false},
{-1468.7290039063,-1028.4829101563,168.46673583984, false},
{-1349.5552978516,-1030.3936767578,175.75492858887, false},
{-1339.5482177734,-1007.1594848633,185.5514831543, false},
{-1353.1115722656,-975.06726074219,195.46794128418, false},
{-1386.0266113281,-967.25238037109,197.34918212891, false},
{-1411.6418457031,-967.38177490234,199.83609008789, false},
{-1432.0367431641,-950.60809326172,200.96035766602, true},
{-1411.7532958984,-967.27166748047,199.87936401367, false},
{-1386.1899414063,-967.34674072266,197.35675048828, false},
{-1352.34765625,-975.19476318359,195.22958374023, false},
{-1339.7025146484,-1006.5814819336,185.74673461914, false},
{-1349.1723632813,-1029.8575439453,176.01553344727, false},
{-1468.6146240234,-1028.4368896484,168.44152832031, false},
{-1501.1873779297,-998.84942626953,174.75650024414, false},
{-1519.5736083984,-979.17974853516,171.80619812012, false},
{-1540.9162597656,-1003.6073608398,154.38117980957, false},
{-1541.8865966797,-1057.2884521484,137.01934814453, false},
{-1510.4490966797,-1102.6228027344,131.54627990723, false},
{-1472.0718994141,-1139.541015625,116.63223266602, false},
{-1445.2802734375,-1168.5529785156,104.69702148438, false},
{-1443.6329345703,-1250.6199951172,106.78244018555, false},
{-1457.7955322266,-1305.8737792969,100.5055847168, false},
{-1447.6728515625,-1334.5355224609,100.49033355713, false},
{-1439.943359375,-1387.615234375,101.17250061035, false},
{-1405.4558105469,-1417.3842773438,105.49856567383, false},
{-1372.4495849609,-1411.0174560547,109.20426940918, false},
{-1294.2062988281,-1377.9561767578,116.86572265625, false},
{-1216.521484375,-1349.7517089844,122.93788146973, false},
{-1173.380859375,-1341.1928710938,125.58958435059, false},
{-1082.4532470703,-1348.1032714844,129.36772155762, false},
{-1021.3653564453,-1375.0969238281,130.34156799316, false},
{-960.59234619141,-1404.9056396484,129.53224182129, false},
{-914.32690429688,-1383.5466308594,125.19774627686, false},
{-897.40258789063,-1324.8599853516,119.11064147949, false},
{-891.669921875,-1251.0277099609,112.09815216064, false},
{-886.31427001953,-1174.7586669922,104.6813583374, false},
{-880.29486083984,-1123.1578369141,98.891479492188, false},
{-863.90826416016,-1065.7408447266,92.416831970215, false},
{-811.30114746094,-1012.2733764648,82.43864440918, false},
{-733.177734375,-1010.3696899414,75.533256530762, false},
{-664.92456054688,-1006.4586181641,70.074333190918, false},
{-598.59716796875,-975.09820556641,63.642230987549, false},
{-549.17059326172,-929.66326904297,58.194156646729, false},
{-517.35467529297,-894.70062255859,54.77925491333, false},
{-461.45074462891,-849.22900390625,50.365985870361, false},
{-385.62515258789,-837.84783935547,47.227939605713, false},
{-335.81060791016,-861.28515625,46.922298431396, false},
{-297.68878173828,-876.85815429688,46.654418945313, false},
{-266.84689331055,-890.82196044922,45.056438446045, false},
{-213.658203125,-921.5,38.876094818115, false},
{-161.46769714355,-959.05267333984,29.723209381104, false},
{-114.30629730225,-973.11389160156,24.701683044434, false},
{-85.313583374023,-919.67315673828,18.416944503784, false},
{-39.135272979736,-823.2021484375,11.731194496155, false},
{-2.9379198551178,-745.89123535156,7.4806365966797, false},
{21.220180511475,-686.84338378906,4.5849690437317, false},
{42.419380187988,-625.81939697266,3.2687795162201, false},
{52.477809906006,-550.65850830078,9.9032382965088, false},
{32.752876281738,-509.15731811523,9.9565839767456, false},
{-16.996322631836,-463.2966003418,2.5974123477936, false},
{-64.60994720459,-433.78887939453,1.078125, false},
{-105.58114624023,-407.86181640625,1.078125, false},
{-124.71557617188,-386.08670043945,1.4296875, false},
{-119.10194396973,-371.44287109375,1.4296875, false},
{-88.854187011719,-360.84906005859,1.4296875, false},
{-61.587097167969,-352.17727661133,1.2050491571426, false},
{-37.838890075684,-339.92547607422,1.9278607368469, false},
{-27.468152999878,-314.3837890625,5.4296875, false},
{-15.147527694702,-277.53469848633,5.4296875, true},
{-26.968524932861,-313.48867797852,5.4296875, false},
{-37.936660766602,-339.50015258789,1.9462195634842, false},
{-61.650856018066,-351.98977661133,1.2051115036011, false},
{-88.945388793945,-360.70724487305,1.4296875, false},
{-119.06707763672,-371.43991088867,1.4296875, false},
{-124.75164031982,-385.92425537109,1.4296875, false},
{-112.22258758545,-411.71890258789,1.078125, false},
{-74.518348693848,-436.32693481445,1.078125, false},
{-22.032121658325,-468.0500793457,2.6429841518402, false},
{26.806625366211,-511.98587036133,10.301424026489, false},
{45.670963287354,-551.73858642578,10.17586517334, false},
{43.136821746826,-600.57849121094,4.4125785827637, false},
{24.29002571106,-662.65637207031,3.6085648536682, false},
{8.33131980896,-703.37634277344,5.4588861465454, false},
{-9.8506641387939,-745.49658203125,7.5969543457031, false},
{-37.682159423828,-806.59063720703,10.931030273438, false},
{-63.838024139404,-861.71624755859,14.102255821228, false},
{-90.133697509766,-916.18737792969,18.278650283813, false},
{-114.4801940918,-962.52709960938,23.96284866333, false},
{-123.06188964844,-978.22271728516,25.91544342041, false},
{-118.47534179688,-996.25360107422,25.205825805664, false},
{-99.849166870117,-1023.8392333984,24.079319000244, false},
{-83.767311096191,-1063.5612792969,16.619567871094, false},
{-90.707252502441,-1108.5354003906,2.2462043762207, false},
{-108.12310028076,-1146.6884765625,1.5085282325745, false},
{-117.61325073242,-1166.025390625,2.6745805740356, false},
{-124.98164367676,-1181.9835205078,2.6953125, false},
{-107.19205474854,-1188.4367675781,2.4607791900635, false},
{-88.119834899902,-1186.9831542969,1.75, true, true}

}

function cstartJob(cmd, arg)
	if arg == "basla" then
		if not cigarBlip then --not routeMarker then
			local faction = getPlayerTeam(getLocalPlayer())
			local factionType = getElementData(faction, "type")
			local veh = getPedOccupiedVehicle(getLocalPlayer())
			local vehModel = getElementModel(veh)
			local jobVehicle = 459
			
			if (factionType == 0) or (factionType == 1) then
				if vehModel == jobVehicle then
					cupdateRoutes()
					cigarBlip = createBlip(2482.03125, -2629.1064453125, 13.53261089325, 0, 3, 255, 0, 0, 255)
					addEventHandler("onClientMarkerHit", resourceRoot, cigarRoutesMarkerHit)
				end
			end
		else
			exports.titan_hud:sendBottomNotification(localPlayer, "Tütün Nakliye", "Zaten bir sefere başladınız.")
		end
	end
end
addCommandHandler("tutun", cstartJob)

function cupdateRoutes()
	cigarMarker = cigarMarker + 1
	for i,v in ipairs(cigarRoutes) do
		if i == cigarMarker then
			if not v[4] == true then
				crouteMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				if cigarBlip then
					setElementPosition(cigarBlip, v[1], v[2], v[3])
					setBlipColor(cigarBlip, 255, 0, 0, 255)
				end
				table.insert(cigarOldMarker, { crouteMarker, false })
			elseif v[4] == true and v[5] == true then 
				cfMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				destroyElement(cigarBlip)
				table.insert(cigarOldMarker, { cfMarker, true, true })	
			elseif v[4] == true then
				cpMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(cigarBlip, v[1], v[2], v[3])
				setBlipColor(cigarBlip, 255, 255, 0, 255)
				table.insert(cigarOldMarker, { cpMarker, true, false })			
			end
		end
	end
end

function cigarRoutesMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 459 then
				for _, marker in ipairs(cigarOldMarker) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							cupdateRoutes()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							cigarMarker = 0
							triggerServerEvent("cigar:pay", hitPlayer, hitPlayer)
							exports.titan_hud:sendBottomNotification(hitPlayer, "Tütün Nakliye", "Aracınıza yeni mallar yükleniyor, lütfen bekleyiniz.")
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									exports.titan_hud:sendBottomNotification(thePlayer, "Tütün Nakliye", "Aracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.")
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
							exports.titan_hud:sendBottomNotification(hitPlayer, "Tütün Nakliye", "Aracınızdaki mallar indiriliyor, lütfen bekleyiniz.")
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									exports.titan_hud:sendBottomNotification(hitPlayer, "Tütün Nakliye", "Aracınızdaki mallar indirilmiştir, geri dönebilirsiniz.")
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
		if pedVehModel == 459 then
			exports.titan_global:fadeToBlack()
			for i,v in ipairs(cigarOldMarker) do
				destroyElement(v[1])
			end
			cigarOldMarker = {}
			cigarMarker = 0
			if cigarBlip then
				destroyElement(cigarBlip)
				cigarBlip = nil
			end
			triggerServerEvent("cigar:exitVeh", getLocalPlayer(), getLocalPlayer())
			removeEventHandler("onClientMarkerHit", resourceRoot, cigarRoutesMarkerHit)
			removeEventHandler("onClientVehicleStartEnter", getRootElement(), trashAntiYabanci)
			setTimer(function() exports.titan_global:fadeFromBlack() end, 2000, 1)
		end
	end
end

function trashAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 459 and vehicleJob == 6 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 6 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBu araca binmek için Tütün Nakliyesi mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
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