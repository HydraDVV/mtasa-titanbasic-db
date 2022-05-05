local characters = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local komuts = split (characters, ",")
local bonusRenkler = {
	{0, 255, 0},
	{204, 255, 0},
	{255, 0, 0}
}

local saat,dakika = 0,0
local dakikaTick = getTickCount()
local odulAl = false
local komut = nil

addEventHandler("onClientRender", root, function()
	local suan = getTickCount()
	if suan - dakikaTick >= 1000*60 and not odulAl then 
		dakika = dakika + 1
		dakikaTick = suan
		if dakika >= 60 then
			dakika = 0 
			saat = saat +1
			odulAl = true 
			oduluVer() 
		end	
	end	
end)

function oduluVer() 
local sesler = {
	setTimer(odulGeriSayim, 1000*60,1) 
	}
end

function odulGeriSayim()
	komut = nil
	odulAl = false
end

function VergiGUI(Data)
	if not source then
		source = getLocalPlayer()
	end
	local screenW, screenH = guiGetScreenSize()
	local scaleW, scaleH = (screenW/1366), (screenH/768)
    vergiPanelWindow = guiCreateWindow(scaleW * 426, scaleH * 205, scaleW * 513, scaleH * 359, ""..exports["titan_pool"]:getServerName().." Roleplay - Araç Vergi Arayüzü", false)
    guiWindowSetSizable(vergiPanelWindow, false)

    vergiPanelGrid = guiCreateGridList(scaleW * 10, scaleH * 28, scaleW * 493, scaleH * 220, false, vergiPanelWindow)
    guiGridListAddColumn(vergiPanelGrid, "Araç ID", 0.1)
    guiGridListAddColumn(vergiPanelGrid, "Araç Markası", 0.5)
    guiGridListAddColumn(vergiPanelGrid, "Vergi Miktarı", 0.4)
	for i, data in ipairs(Data) do
		local row = guiGridListAddRow(vergiPanelGrid)
		guiGridListSetItemText(vergiPanelGrid, row, 1, data[1], false, true)
		guiGridListSetItemText(vergiPanelGrid, row, 2, data[2],  false, false)
		vergiPara = guiGridListSetItemText(vergiPanelGrid, row, 3, "$" .. exports.titan_global:formatMoney(data[3]), false, false)
	end
    miktarLbl = guiCreateLabel(scaleW * 10, scaleH * 258, scaleW * 107, scaleH * 26, "Ödenecek Miktar:", false, vergiPanelWindow)
    guiLabelSetVerticalAlign(miktarLbl, "center")
    miktarEdit = guiCreateEdit(scaleW * 117, scaleH * 258, scaleW * 386, scaleH * 26, "", false, vergiPanelWindow)
    kapatBtn = guiCreateButton(scaleW * 10, scaleH * 294, scaleW * 245, scaleH * 50, "Paneli Kapat", false, vergiPanelWindow)
	 guiSetProperty (kapatBtn, "NormalTextColour", "FFFF0000")
    odeBtn = guiCreateButton(scaleW * 265, scaleH * 294, scaleW * 238, scaleH * 50, "Borcu Öde", false, vergiPanelWindow)    
		 guiSetProperty (odeBtn, "NormalTextColour", "FF00FF00")
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
				destroyElement(vergiPanelWindow)
				triggerServerEvent("vergi:VergiOde", getLocalPlayer(), aracID, miktar)
				--triggerServerEvent("vergi:faizCikar", getLocalPlayer(), aracID, miktar)
			elseif source == kapatBtn then
				destroyElement(vergiPanelWindow)
			end
		end
	)
end
addEvent("vergi:VergiGUI", true)
addEventHandler("vergi:VergiGUI", getRootElement(), VergiGUI)

