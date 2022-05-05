function createLogGUI()
	if isElement(window) then destroyElement(window) guiSetInputEnabled(false) removeEventHandler("onClientGUIClick", root, clickElements) end
	window = guiCreateWindow(0, 0, 760, 481, "Log Kontrol Paneli", false)
	guiWindowSetSizable(window, false)
	exports.titan_global:centerWindow(window)
	guiSetInputEnabled(true)

	tabs = guiCreateTabPanel(9, 24, 741, 402, false, window)

	tab1 = guiCreateTab("Oyuncu Log", tabs)

	grid1 = guiCreateGridList(5, 62, 726, 306, false, tab1)
	edit1 = guiCreateEdit(5, 13, 600, 35, "", false, tab1)
	scan1 = guiCreateButton(656, 14, 75, 34, "Tarat", false, tab1)

	tab2 = guiCreateTab("Silah Log", tabs)

	grid2 = guiCreateGridList(5, 62, 726, 306, false, tab2)
	edit2 = guiCreateEdit(5, 13, 600, 35, "", false, tab2)
	scan2 = guiCreateButton(656, 14, 75, 34, "Tarat", false, tab2)

	tab3 = guiCreateTab("Item Log", tabs)
	
	grid3 = guiCreateGridList(5, 62, 726, 306, false, tab3)
	edit3 = guiCreateEdit(5, 13, 600, 35, "", false, tab3)
	scan3 = guiCreateButton(656, 14, 75, 34, "Tarat", false, tab3)
	
	tab4 = guiCreateTab("WorldItem Log", tabs)
	grid4 = guiCreateGridList(5, 62, 726, 306, false, tab4)
	edit4 = guiCreateEdit(5, 13, 600, 35, "", false, tab4)
	scan4 = guiCreateButton(656, 14, 75, 34, "Tarat", false, tab4)


	guiGridListAddColumn(grid1, "Tarih", 0.2)
	guiGridListAddColumn(grid1, "Olay", 0.3)
	guiGridListAddColumn(grid1, "Durum", 0.3)
	
	guiGridListAddColumn(grid2, "Tarih", 0.2)
	guiGridListAddColumn(grid2, "Olay", 0.3)
	guiGridListAddColumn(grid2, "Durum", 0.9)
	
	guiGridListAddColumn(grid3, "ID", 0.3)
	guiGridListAddColumn(grid3, "Sahip", 0.4)
	guiGridListAddColumn(grid3, "Serial", 0.8)
	
	guiGridListAddColumn(grid4, "ID", 0.3)
	guiGridListAddColumn(grid4, "Item ID", 0.4)
	guiGridListAddColumn(grid4, "Item Value", 0.8)

	close = guiCreateButton(9, 437, 841, 34, "Arayüzü Kapat", false, window)

	addEventHandler("onClientGUIClick", root, clickElements)
end

addCommandHandler("logpanel",
	function(cmd)
		if exports.titan_integration:isPlayerHeadAdmin(localPlayer) then
			createLogGUI()
		end
	end
)

function clickElements(b)
	if (b == "left") then
		if (source == close) then
			destroyElement(window)
			guiSetInputEnabled(false)
			removeEventHandler("onClientGUIClick", root, clickElements)
			return
		elseif (source == scan1) then
			--@trigger
			guiSetEnabled(scan1, false)
			triggerLatentServerEvent("logapi.receiveLogs", localPlayer, localPlayer, {type=1,edittext=edit1.text})
			guiSetText(window, "Yükleniyor")
			return
		elseif (source == scan2) then
			--@trigger
			guiSetEnabled(scan2, false)
			triggerLatentServerEvent("logapi.receiveLogs", localPlayer, localPlayer, {type=2,edittext=edit2.text})
			guiSetText(window, "Yükleniyor")
			return
		elseif (source == scan3) then
			--@trigger
			guiSetEnabled(scan3, false)
			triggerLatentServerEvent("logapi.receiveLogs", localPlayer, localPlayer, {type=3,edittext=edit3.text})
			guiSetText(window, "Yükleniyor")
			return
		elseif (source == scan4) then
			--@trigger
			guiSetEnabled(scan4, false)
			triggerLatentServerEvent("logapi.receiveLogs", localPlayer, localPlayer, {type=4,edittext=edit4.text})
			guiSetText(window, "Yükleniyor")
			return
		elseif (source == scan6) then
			--@trigger
			guiSetEnabled(scan6, false)
			triggerLatentServerEvent("logapi.receiveLogs", localPlayer, localPlayer, {type=6,edittext=edit6.text})
			guiSetText(window, "Yükleniyor")
			return
		end
	end
end

addEvent("logapi.foundSpamRemove", true)
addEventHandler("logapi.foundSpamRemove", root,
	function(type)
		guiSetEnabled(_G["scan"..type], true)
	end
)

addEvent("logapi.updateLogGrid", true)
addEventHandler("logapi.updateLogGrid", root,
	function(type, data, dbid)
		guiSetText(window, "Log Kontrol Paneli")
		if (type == 1) then
			guiSetEnabled(scan1, true)
			grid1:clear()
			for index, value in ipairs(data) do

				local row = guiGridListAddRow(grid1)
				guiGridListSetItemText(grid1, row, 1, value.time, false, false)
				guiGridListSetItemText(grid1, row, 2, value.content, false, false)	
				guiGridListSetItemText(grid1, row, 3, value.affected, false, false)	
			end

			setTimer(guiGridListSetVerticalScrollPosition, 50, 1, grid1, 100) 
		elseif (type == 2) then
			guiSetEnabled(scan2, true)
			grid2:clear()
			for index, value in ipairs(data) do
				local row = guiGridListAddRow(grid2)
				guiGridListSetItemText(grid2, row, 1, value.time, false, false)
				guiGridListSetItemText(grid2, row, 2, value.content, false, false)	
				guiGridListSetItemText(grid2, row, 3, value.affected, false, false)	
			end
			setTimer(guiGridListSetVerticalScrollPosition, 50, 1, grid2, 100)
		elseif (type == 3) then
			guiSetEnabled(scan3, true)
			grid3:clear()
			for index, value in ipairs(data) do
				local row = guiGridListAddRow(grid3)
				guiGridListSetItemText(grid3, row, 1, value.index, false, false)
				guiGridListSetItemText(grid3, row, 2, exports.titan_cache:getCharacterNameFromID(value.owner).." ("..value.owner..")" or value.owner, false, false)
				guiGridListSetItemText(grid3, row, 3, value.itemValue, false, false)
			end
			setTimer(guiGridListSetVerticalScrollPosition, 50, 1, grid3, 100)
		elseif (type == 4) then
			guiSetEnabled(scan4, true)
			grid4:clear()
			for index, value in ipairs(data) do
				local row = guiGridListAddRow(grid4)
				guiGridListSetItemText(grid4, row, 1, value.id, false, false)
				guiGridListSetItemData(grid4, row, 1, {value.x, value.y, value.z, value.dimension, value.interior}, false, false)
				guiGridListSetItemText(grid4, row, 2, value.itemid, false, false)
				guiGridListSetItemText(grid4, row, 3, value.itemvalue, false, false)
			end
			setTimer(guiGridListSetVerticalScrollPosition, 50, 1, grid4, 100)
		elseif (type == 5) then
			for index, value in ipairs(data) do
				local row = guiGridListAddRow(grid5)
				guiGridListSetItemText(grid5, row, 1, value.username, false, false)
				guiGridListSetItemText(grid5, row, 2, value.addedDate, false, false)
				guiGridListSetItemData(grid5, row, 1, value, false, false)
			end
		end
	end
)