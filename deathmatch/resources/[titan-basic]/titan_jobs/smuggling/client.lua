local sx,sy = guiGetScreenSize()
local pg,pu = 300,240
local x,y = (sx-pg)/2, (sy-pu)/2

local bolG = createMarker(  2859.6845703125, 2570.8203125, 10.8203125, "cylinder", 1, 255, 255, 255, 0)
local sarma_bolgesi = createMarker(1934.359296875, -2352.4072265625, 12.841756439209, "cylinder", 1.5, 255, 255, 255, 255)
setElementDimension(sarma_bolgesi, 2515)
setElementInterior(sarma_bolgesi, 25)
local Font = dxCreateFont(":titan_fonts/files/Roboto.ttf", 16)


setTimer( function()
       local x, y, z = getElementPosition( bolG )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 10 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +0.2, 0.07 )
           local WorldPositionX2, WorldPositionY2 = getScreenFromWorldPosition( x, y, z +0.08, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("Kaçak Sigara Satma Bölgesi\n/kacaksigarasat", WorldPositionX - 2, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0,0,0, 255), 1.0, Font, "center", "center", false, false, false, true, false)
			    dxDrawText("Kaçak Sigara Satma Bölgesi\n/kacaksigarasat", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255,255,255, 255), 1.0, Font, "center", "center", false, false, false, true, false)
            end
      end
end,
0,0)

tutunler = { 
	--{"tutunisim", fiyat, itemID}
	{"Torba Tütün",20,589},
}


tutunGUI = guiCreateWindow(x, y, pg,pu, "Tütün Mağazası - "..exports["titan_pool"]:getServerName().." Roleplay", false)
guiWindowSetSizable(tutunGUI, false)
guiSetVisible(tutunGUI, false)

labelKor = guiCreateLabel(185, 115, 15, 15, "", false, tutunGUI)
tutunListe = guiCreateGridList(10, 28, 317, 169, false, tutunGUI)
tutunAd = guiGridListAddColumn(tutunListe, "Ürün", 0.5)
tutunFiyat = guiGridListAddColumn(tutunListe, "Fiyatlandırma", 0.4)

satinalgui = guiCreateButton(35, 204, 100, 23, "Satın Al", false, tutunGUI)
closegui = guiCreateButton(135+20, 204, 100, 23, "Arayüzü Kapat", false, tutunGUI)

function addList()
	guiGridListClear(tutunListe)
	for i,v in pairs(tutunler) do
		local isim,fiyat,item = unpack(v)
		local row =  guiGridListAddRow(tutunListe)
		guiGridListSetItemText(tutunListe, row, tutunAd, isim, false, false)
		guiGridListSetItemText(tutunListe, row, tutunFiyat, fiyat.." $", false, false)
		guiGridListSetItemData(tutunListe, row, tutunAd, {item,fiyat,i})
	end	
end


addEventHandler("onClientGUIClick", resourceRoot, function()
	if source == satinalgui then
		if tutunSecilimi() then
			local tutun,fiyat,sira = tutunSecilimi()
			triggerServerEvent("tutun:tutunVer", localPlayer,tonumber(tutun),tonumber(fiyat),tonumber(sira))
		else
			outputChatBox("Lütfen bir ürün seç.",255,0,0)
		end
	elseif source == closegui then
		guiSetVisible(tutunGUI, not guiGetVisible(tutunGUI))
		showCursor(guiGetVisible(tutunGUI))
	else
	end
end)

addEvent("tutun:panel", true)
addEventHandler("tutun:panel", getRootElement(), function()
	guiSetVisible(tutunGUI, not guiGetVisible(tutunGUI))
	showCursor(guiGetVisible(tutunGUI))
	if guiGetVisible(tutunGUI) then
		addList()
	end
end) 


function tutunSecilimi()
	local row,col = guiGridListGetSelectedItem(tutunListe) 
	if row  then
		local tutun,fiyat,sira = unpack(guiGridListGetItemData(tutunListe, row, 1))
		return tutun, fiyat, sira
	else
		return false
	end
end

