function kucakGUI(alan, alinan)
	local screenW, screenH = guiGetScreenSize()
    arkaplan = guiCreateWindow((screenW - 455) / 2, (screenH - 141) / 2, 455, 141, ""..exports["titan_pool"]:getServerName().." Roleplay - Kucak Sistemi", false)
    guiWindowSetSizable(arkaplan, false)

    label = guiCreateLabel(12, 25, 433, 40, getPlayerName(alan) .. " isimli kişi sizi kucağına almak istiyor. \nKabul ediyor musunuz?", false, arkaplan)
    guiLabelSetHorizontalAlign(label, "center", true)
    guiLabelSetVerticalAlign(label, "center")
    kabul = guiCreateButton(12, 75, 215, 50, "Evet", false, arkaplan)
    guiSetProperty(kabul, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", kabul, function() destroyElement(arkaplan) triggerServerEvent("kucak:kabul", alan, alan, alinan) end)
    reddet = guiCreateButton(235, 75, 210, 50, "Hayır", false, arkaplan)
    guiSetProperty(reddet, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", reddet, function() destroyElement(arkaplan) triggerServerEvent("kucak:reddet", alan, alan, alinan) end)
end
addEvent("kucak:gui", true)
addEventHandler("kucak:gui", root, kucakGUI)

function kucakGUIC(alan, alinan)
	destroyElement(arkaplan)
end
addEvent("kucak:guiclose", true)
addEventHandler("kucak:guiclose", root, kucakGUIC)