local thePed = createPed(58, 1878.3740234375, -2457.583984375, 13.579086303711)
setElementRotation(thePed,  0, 0, 90)
setElementInterior(thePed, 27)
setElementDimension(thePed, 157)
setElementFrozen(thePed, true)
setElementData(thePed, "talk", 1)
setElementData(thePed, "name", "Slayer Crown")
setPedAnimation(thePed, "GANGS", "leanIDLE", 1, true, false, false)


local marker = exports.titan_marker:createCustomMarker(1872.85546875, -2458.99609375, 12.549086303711, "cylinder", 1, 156, 194, 255)
setElementInterior(marker, 27)
setElementDimension(marker, 157)
	addEventHandler("onClientMarkerHit", marker, function(element)
		if element == localPlayer then
			exports["titan_infobox"]:addBox("info", "İpucu: /yemal")
		end
	end)


local sx,sy = guiGetScreenSize()
local pg,pu = 300,240
local x,y = (sx-pg)/2, (sy-pu)/2

baliklar = { 
	--{"balikisim", fiyat, itemID}
	{"Balık Oltası",100,49},

}


panel = guiCreateWindow(x, y, pg,pu, "Balık Mağazası - "..exports["titan_pool"]:getServerName().." Roleplay", false)
guiWindowSetSizable(panel, false)
guiSetVisible(panel, false)

labelKor = guiCreateLabel(185, 115, 15, 15, "", false, panel)
balikListe = guiCreateGridList(10, 28, 317, 169, false, panel)
balikAd = guiGridListAddColumn(balikListe, "Ürün", 0.5)
balikFiyat = guiGridListAddColumn(balikListe, "Fiyatlandırma", 0.4)

satinal = guiCreateButton(35, 204, 100, 23, "Satın Al", false, panel)
kapat = guiCreateButton(135+20, 204, 100, 23, "Arayüzü Kapat", false, panel)

function listeyeEkle()
	guiGridListClear(balikListe)
	for i,v in pairs(baliklar) do
		local isim,fiyat,item = unpack(v)
		local row =  guiGridListAddRow(balikListe)
		guiGridListSetItemText(balikListe, row, balikAd, isim, false, false)
		guiGridListSetItemText(balikListe, row, balikFiyat, fiyat.." $", false, false)
		guiGridListSetItemData(balikListe, row, balikAd, {item,fiyat,i})
	end	
end


addEventHandler("onClientGUIClick", resourceRoot, function()
	if source == satinal then
		if balikSecilimi() then
			local balik,fiyat,sira = balikSecilimi()
			triggerServerEvent("balik:balikVer", localPlayer,tonumber(balik),tonumber(fiyat),tonumber(sira))
		else
			outputChatBox("Lütfen bir olta seç.",255,0,0)
		end
	elseif source == kapat then
		guiSetVisible(panel, not guiGetVisible(panel))
		showCursor(guiGetVisible(panel))
	else
	end
end)

addEvent("balik:panel", true)
addEventHandler("balik:panel", getRootElement(), function()
	guiSetVisible(panel, not guiGetVisible(panel))
	showCursor(guiGetVisible(panel))
	if guiGetVisible(panel) then
		listeyeEkle()
	end
end) 


function balikSecilimi()
	local row,col = guiGridListGetSelectedItem(balikListe) 
	if row  then
		local balik,fiyat,sira = unpack(guiGridListGetItemData(balikListe, row, 1))
		return balik, fiyat, sira
	else
		return false
	end
end

