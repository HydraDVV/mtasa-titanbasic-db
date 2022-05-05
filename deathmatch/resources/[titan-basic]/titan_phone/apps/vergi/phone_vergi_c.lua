function toggleVergi(Data)
	if Data then
		vergiActive = true
		guiSetInputEnabled(true)
	if not source then
		source = getLocalPlayer()
	end
	local screenW, screenH = guiGetScreenSize()
	local scaleW, scaleH = (screenW/1080), (screenH/700)
    guiWindowSetSizable(wPhoneMenu, false)

    vergiPanelGrid = guiCreateGridList(scaleW * 10, scaleH * 98, scaleW * 132, scaleH * 100, false, wPhoneMenu)
    guiGridListAddColumn(vergiPanelGrid, "ID", 0.1)
    guiGridListAddColumn(vergiPanelGrid, "Marka", 0.5)
    guiGridListAddColumn(vergiPanelGrid, "Miktar", 0.3)
	for i, data in ipairs(Data) do
		local row = guiGridListAddRow(vergiPanelGrid)
		guiGridListSetItemText(vergiPanelGrid, row, 1, data[1], false, true)
		guiGridListSetItemText(vergiPanelGrid, row, 2, data[2],  false, false)
		vergiPara = guiGridListSetItemText(vergiPanelGrid, row, 3, "$" .. exports.titan_global:formatMoney(data[3]), false, false)
	end
    miktarEdit = guiCreateEdit(scaleW * 34, scaleH * 208, scaleW * 80, scaleH * 18, "Bir miktar girin.", false, wPhoneMenu)
    odeBtn = guiCreateButton(scaleW * 37, scaleH * 254, scaleW * 75, scaleH * 20, "Borcu Öde", false, wPhoneMenu)    
	guiSetAlpha(odeBtn, 0)
	
	addEventHandler("onClientGUIClick", guiRoot, 
		function() 
			if source == odeBtn then
				local miktar = guiGetText(miktarEdit) 
				miktar = tonumber(miktar)
				if miktar == 0 or miktar < 0 then 
					outputChatBox("[-] #f0f0f0Ödeyeceğiniz miktar en az 0 TL olmalıdır.", 255, 0, 0, true) 
					return
				end 
				local row, col = guiGridListGetSelectedItem(vergiPanelGrid)
				if row == -1 then
					outputChatBox("[-] #f0f0f0Lütfen listeden bir araç seçin.", 255, 0, 0, true)
					return
				end
				local aracID = guiGridListGetItemText(vergiPanelGrid, row, 1)
				destroyElement(wPhoneMenu)
				triggerServerEvent("phone:payTax", getLocalPlayer(), aracID, miktar)
			end
		end
	)
	else
		guiSetInputEnabled(false)
		vergiActive = false
		if isElement(vergiPanelGrid) then
			destroyElement(vergiPanelGrid)
		end
		if isElement(miktarEdit) then
			destroyElement(miktarEdit)
		end
	end
end
addEvent("phone:taxGUI", true)
addEventHandler("phone:taxGUI", getRootElement(), toggleVergi)

