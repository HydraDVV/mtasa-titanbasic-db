function ustAramaOnayGUI(arayan, aranan)
	local screenW, screenH = guiGetScreenSize()
    ustAramaSorWindow = guiCreateWindow((screenW - 455) / 2, (screenH - 141) / 2, 455, 141, ""..exports["titan_pool"]:getServerName().." Roleplay - Üst Arama Sistemi v1.0 - Hanz", false)
    guiWindowSetSizable(ustAramaSorWindow, false)

    aramaTheLabel = guiCreateLabel(12, 25, 433, 40, getPlayerName(arayan) .. " isimli kişi üzerinizi aramak istiyor, kabul ediyor musunuz?", false, ustAramaSorWindow)
    guiLabelSetHorizontalAlign(aramaTheLabel, "center", true)
    guiLabelSetVerticalAlign(aramaTheLabel, "center")
    aramaKabulEtSorBtn = guiCreateButton(12, 75, 215, 50, "Evet", false, ustAramaSorWindow)
    guiSetProperty(aramaKabulEtSorBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", aramaKabulEtSorBtn, function() destroyElement(ustAramaSorWindow) triggerServerEvent("pd:aramaKabul", arayan, arayan, aranan) end)
    aramaReddetBtn = guiCreateButton(235, 75, 210, 50, "Hayır", false, ustAramaSorWindow)
    guiSetProperty(aramaReddetBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", aramaReddetBtn, function() destroyElement(ustAramaSorWindow) triggerServerEvent("pd:aramaRed", arayan, arayan, aranan) end)
end
addEvent("pd:ustAramaOnayGUI", true)
addEventHandler("pd:ustAramaOnayGUI", root, ustAramaOnayGUI)