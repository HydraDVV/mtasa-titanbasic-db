
self = {
    tab = {},
    window = {},
    tabpanel = {},
    gridlist = {}
}



	

        self.window[1] = guiCreateWindow(434, 125, 393, 770, ""..exports["titan_pool"]:getServerName().." Roleplay Jail Süreleri", false)
        guiWindowSetSizable(self.window[1], false)
		guiSetVisible(self.window[1], false)

        self.tabpanel[1] = guiCreateTabPanel(9, 24, 374, 700, false, self.window[1])
		test = guiCreateLabel  ( 0.02,0.96,0.94,0.92, "Arayüzü kapatmak için tekrardan /jailsure yazabilirsin.", true, self.window[1])
		guiLabelSetHorizontalAlign(test,"center")
        self.tab[1] = guiCreateTab("İşlemler", self.tabpanel[1])
        self.tab[2] = guiCreateTab("Diğer", self.tabpanel[1])
		guiSetEnabled(self.tab[2], false)

        self.gridlist[1] = guiCreateGridList(8, 8, 356, 650, false, self.tab[1])

        guiGridListAddColumn(self.gridlist[1], "İşlemler", 0.9)
        for i = 1, 30 do
            guiGridListAddRow(self.gridlist[1])
        end
        guiGridListSetItemText(self.gridlist[1], 0, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 1, 1, "Kısaltılmış Sözcük: 15DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 2, 1, "Hatalı Emote Kullanımı: 15DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 3, 1, "OOC Hakaret: 30-400DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 4, 1, "OOC Spam: 30DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 5, 1, "Bug Kullanımı: 15DK-300DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 6, 1, "Aktif Rolde /q: 180DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 7, 1, "Troll: 60-90DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 8, 1, "Refuse RP: 90DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 9, 1, "Retarted RP: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 10, 1, "Fear RP: 90DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 11, 1, "Power Gaming: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 12, 1, "Mix: 150DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 13, 1, "MetaGame: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 14, 1, "GBI: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 15, 1, "NON-RP Sürüş: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 16, 1, "Off Road: 45DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 17, 1, "Ninja Jack: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 18, 1, "Car Ramming: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 19, 1, "Korna Spam: 15DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 20, 1, "Car Surfing: 30DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 21, 1, "Emotesiz Silah Çekimi: 100DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 22, 1, "Bug: 120DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 23, 1, "DM: 180DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 24, 1, "S-DM: 2000DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 25, 1, "Noob DM: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 26, 1, "Revenge Kill: 60DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 27, 1, "Drive-By (Sürücü): 120DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 28, 1, "OOC Kin: 90DK", false, false)
        guiGridListSetItemText(self.gridlist[1], 29, 1, "Car Ramming: 60DK", false, false)

		exports.titan_global:centerWindow(self.window[1])

addCommandHandler("jailsure", function()
			guiSetVisible(self.window[1], not guiGetVisible(self.window[1]))
			showCursor(guiGetVisible(self.window[1]))
	if guiGetVisible(self.window[1]) then
			guiSetInputMode("no_binds_when_editing")
		end	

end)