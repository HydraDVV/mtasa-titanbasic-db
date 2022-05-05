
general = {
    tab = {},
    window = {},
    tabpanel = {},
    gridlist = {}
}



	

        general.window[1] = guiCreateWindow(434, 125, 393, 428, ""..exports["titan_pool"]:getServerName().." VIP Özellikleri", false)
        guiWindowSetSizable(general.window[1], false)
		guiSetVisible(general.window[1], false)

        general.tabpanel[1] = guiCreateTabPanel(9, 24, 374, 377, false, general.window[1])
		test = guiCreateLabel  ( 0.02,0.94,0.94,0.92, "Arayüzü kapatmak için tekrardan /vip yazabilirsin.", true, general.window[1])
		guiLabelSetHorizontalAlign(test,"center")
        general.tab[1] = guiCreateTab("VIP 1", general.tabpanel[1])

        general.gridlist[1] = guiCreateGridList(8, 8, 356, 340, false, general.tab[1])

        guiGridListAddColumn(general.gridlist[1], "Özellikleri", 0.9)
        for i = 1, 18 do
            guiGridListAddRow(general.gridlist[1])
        end
        guiGridListSetItemText(general.gridlist[1], 0, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[1], 1, 1, "İsminin altında bulunan VIP 1 iconu.", false, false)
        guiGridListSetItemText(general.gridlist[1], 2, 1, "Mesleklerde fazladan gelir.", false, false)
        guiGridListSetItemText(general.gridlist[1], 3, 1, "Saatlik + $100 para bonusu.", false, false)
        guiGridListSetItemText(general.gridlist[1], 4, 1, "Bandana takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[1], 5, 1, "Kar Maskesi takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[1], 6, 1, "Araç getirme otoparkından ücretsiz araç çıkartma.", false, false)
        guiGridListSetItemText(general.gridlist[1], 7, 1, "Silah Kasasında +10% yüksek silah çıkartma olasılığı.", false, false)
        guiGridListSetItemText(general.gridlist[1], 8, 1, "Çadır kurabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[1], 9, 1, "Özel Animasyonları kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[1], 10, 1, "Mermi fabrikasında %10 indirim.", false, false)
        guiGridListSetItemText(general.gridlist[1], 11, 1, "PM Kapatma & Açma.", false, false)
        guiGridListSetItemText(general.gridlist[1], 12, 1, "Hızlı /reklam özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[1], 13, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[1], 14, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[1], 15, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[1], 16, 1, "Aylık: 20 TL", false, false)
        guiGridListSetItemText(general.gridlist[1], 17, 1, "Bakiye yüklemek için: "..exports["titan_pool"]:getServerName().."roleplay.com/market", false, false)

        general.tab[2] = guiCreateTab("VIP 2 ", general.tabpanel[1])

        general.gridlist[2] = guiCreateGridList(8, 8, 356, 340, false, general.tab[2])
        guiGridListAddColumn(general.gridlist[2], "Özellikleri", 0.9)
        for i = 1, 18 do
            guiGridListAddRow(general.gridlist[2])
        end
        guiGridListSetItemText(general.gridlist[2], 0, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[2], 1, 1, "İsminin altında bulunan VIP 2 iconu.", false, false)
        guiGridListSetItemText(general.gridlist[2], 2, 1, "Mesleklerde fazladan gelir.", false, false)
        guiGridListSetItemText(general.gridlist[2], 3, 1, "Saatlik + $200 para bonusu..", false, false)
        guiGridListSetItemText(general.gridlist[2], 4, 1, "Bandana takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[2], 5, 1, "Kar Maskesi takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[2], 6, 1, "Araç getirme otoparkından ücretsiz araç çıkartma.", false, false)
        guiGridListSetItemText(general.gridlist[2], 7, 1, "Silah Kasasında +15% yüksek silah çıkartma olasılığı.", false, false)
        guiGridListSetItemText(general.gridlist[2], 8, 1, "Çadır kurabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[2], 9, 1, "Özel Animasyonları kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[2], 10, 1, "AK-47 silahını kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[2], 11, 1, "Mermi fabrikasında %20 indirim.", false, false)
        guiGridListSetItemText(general.gridlist[2], 12, 1, "PM Kapatma & Açma.", false, false)
        guiGridListSetItemText(general.gridlist[2], 13, 1, "Hızlı /reklam özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[2], 14, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[2], 15, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[2], 16, 1, "Aylık: 40 TL", false, false)
        guiGridListSetItemText(general.gridlist[2], 17, 1, "Bakiye yüklemek için: "..exports["titan_pool"]:getServerName().."roleplay.com/market", false, false)

        general.tab[3] = guiCreateTab("VIP 3", general.tabpanel[1])

        general.gridlist[3] = guiCreateGridList(8, 8, 356, 340, false, general.tab[3])
        guiGridListAddColumn(general.gridlist[3], "Özellikleri", 0.9)
        for i = 1, 20 do
            guiGridListAddRow(general.gridlist[3])
        end
        guiGridListSetItemText(general.gridlist[3], 0, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[3], 1, 1, "İsminin altında bulunan VIP 3 iconu.", false, false)
        guiGridListSetItemText(general.gridlist[3], 2, 1, "Mesleklerde fazladan gelir.", false, false)
        guiGridListSetItemText(general.gridlist[3], 3, 1, "Saatlik + $300 para bonusu.", false, false)
        guiGridListSetItemText(general.gridlist[3], 4, 1, "Bandana takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 5, 1, "Kar Maskesi takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 6, 1, "Araç getirme otoparkından ücretsiz araç çıkartma.", false, false)
        guiGridListSetItemText(general.gridlist[3], 7, 1, "Silah Kasasında +25% yüksek silah çıkartma olasılığı.", false, false)
        guiGridListSetItemText(general.gridlist[3], 8, 1, "Çadır kurabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 9, 1, "Özel Animasyonları kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 10, 1, "AK-47 silahını kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 11, 1, "Mermi fabrikasında %40 indirim.", false, false)
        guiGridListSetItemText(general.gridlist[3], 12, 1, "PM Kapatma & Açma.", false, false)
        guiGridListSetItemText(general.gridlist[3], 13, 1, "M4 silahını kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 14, 1, "Hızlı /reklam özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[3], 15, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[3], 16, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[3], 17, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[3], 18, 1, "Aylık: 60 TL", false, false)
        guiGridListSetItemText(general.gridlist[3], 19, 1, "Bakiye yüklemek için: "..exports["titan_pool"]:getServerName().."roleplay.com/market", false, false)

        general.tab[4] = guiCreateTab("VIP 4", general.tabpanel[1])

        general.gridlist[4] = guiCreateGridList(8, 8, 356, 340, false, general.tab[4])
        guiGridListAddColumn(general.gridlist[4], "Özellikleri", 0.9)
        for i = 1, 21 do
            guiGridListAddRow(general.gridlist[4])
        end
        guiGridListSetItemText(general.gridlist[4], 0, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[4], 1, 1, "İsminin altında bulunan VIP 4 iconu.", false, false)
        guiGridListSetItemText(general.gridlist[4], 2, 1, "Mesleklerde fazladan gelir.", false, false)
        guiGridListSetItemText(general.gridlist[4], 3, 1, "Saatlik + $400 para bonusu.", false, false)
        guiGridListSetItemText(general.gridlist[4], 4, 1, "Bandana takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 5, 1, "Kar Maskesi takabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 6, 1, "Araç getirme otoparkından ücretsiz araç çıkartma.", false, false)
        guiGridListSetItemText(general.gridlist[4], 7, 1, "Silah Kasasında +30% yüksek silah çıkartma olasılığı.", false, false)
        guiGridListSetItemText(general.gridlist[4], 8, 1, "Çadır kurabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 9, 1, "Özel Animasyonları kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 10, 1, "AK-47 silahını kullanabilme özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 11, 1, "Mermi fabrikasında %50 indirim.", false, false)
        guiGridListSetItemText(general.gridlist[4], 12, 1, "PM Kapatma & Açma.", false, false)
        guiGridListSetItemText(general.gridlist[4], 13, 1, "M4 silahını kullanabilme özelliği", false, false)
        guiGridListSetItemText(general.gridlist[4], 14, 1, "Hızlı /reklam özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 15, 1, "Onay kodu gerektirmeyen saatlik bonus özelliği.", false, false)
        guiGridListSetItemText(general.gridlist[4], 17, 1, "Sınırsız Tamir Kiti Kullanımı (/tamirkit komutu)", false, false)
        guiGridListSetItemText(general.gridlist[4], 18, 1, "", false, false)
        guiGridListSetItemText(general.gridlist[4], 19, 1, "Aylık: 80 TL", false, false)
        guiGridListSetItemText(general.gridlist[4], 20, 1, "Bakiye yüklemek için: "..exports["titan_pool"]:getServerName().."roleplay.com/market", false, false)    
		exports.titan_global:centerWindow(general.window[1])

addCommandHandler("vip", function()
			guiSetVisible(general.window[1], not guiGetVisible(general.window[1]))
			showCursor(guiGetVisible(general.window[1]))
	if guiGetVisible(general.window[1]) then
			guiSetInputMode("no_binds_when_editing")
		end	
end)