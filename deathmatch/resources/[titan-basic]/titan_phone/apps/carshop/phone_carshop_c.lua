
aracListesi = {
	-- vehname, price, model, owlmodel, maxspeed, tax
	{"Audi A8", 250000, 487, 413, 340, 0},
	{"Tofaş Şahin", 150000, 502, 881, 340, 0},
	{"Hanz Sistem Deneme", 7250, 503, 1033, 320, 0}
}

function getPrivateSettings(booling)
	if (booling == "vehicle") then
		return aracListesi
	end
end
function toggleCarshop(Data)
	if Data then
		carshopActive = true
		guiSetInputEnabled(true)
	if not source then
		source = getLocalPlayer()
	end
	local screenW, screenH = guiGetScreenSize()
	local scaleW, scaleH = (screenW/1080), (screenH/700)
    guiWindowSetSizable(wPhoneMenu, false)
    vehList = guiCreateGridList(scaleW * 10, scaleH * 98, scaleW * 132, scaleH * 100, false, wPhoneMenu)
	guiGridListSetSortingEnabled(vehList, false)
	guiGridListAddColumn(vehList, "İsim", 0.65)
	guiGridListAddColumn(vehList, "Fiyat", 0.24)
	for index, value in ipairs(aracListesi) do
		local row = guiGridListAddRow(vehList)
		guiGridListSetItemText(vehList, row, 1, value[1], false, false)
		guiGridListSetItemText(vehList, row, 2, value[2].." $", false, false)
	end
	
	-- preview 3D CARSHOP @Hanz
	vehObject = createVehicle(503, 0, 0, 0)

	setElementData(vehObject, "alpha", 255)
	setElementDimension(vehObject, math.random(100,300))

	vehElement = exports["titan_opreview"]:createObjectPreview(vehObject, 0, 0, 410, 0.854, 0.517, 0.14, 0.10, true, false)	
	exports["titan_opreview"]:setRotation(vehElement,0, 0, 155 + 0 * 360)

	----------------------

    odeBtn = guiCreateButton(scaleW * 17, scaleH * 254, scaleW * 120, scaleH * 20, "Satın Al", false, wPhoneMenu)    
	guiSetAlpha(odeBtn, 100)
		test = guiCreateLabel(scaleW * 10, scaleH * 98, scaleW * 132, scaleH * 100, "Araç Fiyatı:", true, wPhoneMenu)

	addEventHandler("onClientGUIClick", guiRoot, 
		function() 
			local secilenAracListesi = guiGridListGetSelectedItem(vehList)
			secilenAracListesi = secilenAracListesi + 1
			secilenArac = aracListesi[secilenAracListesi] or false
			setElementModel(vehObject, secilenArac[3])
			guiSetText(infoLabel, "Araç Fiyatı: "..secilenArac[2].. " TL")
			if source == odeBtn then
			
				local selectedVehID = guiGridListGetSelectedItem(vehList)
				
				if selectedVehID == -1 then
					outputChatBox("[-] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
					return false
				end
				selectedVehID = selectedVehID + 1
				exportedTable = aracListesi[selectedVehID] or false	-- vehname, price, model, owlmodel, maxspeed, tax

				if exportedTable then
					bakiye = exports.titan_global:formatMoney(localPlayer)
					alincakMiktar = exportedTable[2]

					playerteState = false
					alincakMiktar = exportedTable[2]
					plateText = ""

					
					showCursor(false)
					guiSetInputEnabled(false)

					--fonksiyon çıktısı: player, araçid, owlid, renk, kesilcek bakiye
					rgbTble = getElementData(localPlayer,"vehDonateColorTable")
					triggerServerEvent("phone->buyCar", localPlayer, exportedTable[3], exportedTable[4], rgbTble or {255, 255, 255}, alincakMiktar, exportedTable[1], plateState, plateText)
				else
					outputChatBox("[-] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
				end
				
		end
		end
	)
	else
		guiSetInputEnabled(false)
		carshopActive = false
		if isElement(vehList) then
			destroyElement(vehList)
		end
		if isElement(odeBtn) then
			destroyElement(odeBtn)
		end
		if isElement(vehObject) then
			destroyElement(vehObject)
			if vehElement then
				exports["titan_opreview"]:destroyObjectPreview(vehElement)
			end	
		end		
	end
end
addEvent("carshop:vehGUI", true)
addEventHandler("carshop:vehGUI", getRootElement(), toggleCarshop)