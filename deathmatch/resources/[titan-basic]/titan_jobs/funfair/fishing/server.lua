addEvent("balik:balikVer", true)
addEventHandler("balik:balikVer", getRootElement(),function(balik,fiyat,sira)
	
	if exports.titan_global:hasItem(source, balik) then exports["titan_infobox"]:addBox(source, "warning", "Zaten envanterinizde bir olta var.") return end	
	
	if  exports.titan_global:takeMoney(source, fiyat) then
		if  exports.titan_global:giveItem(source, balik, 1) then
			exports["titan_infobox"]:addBox(source, "buy", "Başarıyla "..fiyat.." $'a bir Balıkçı Oltası satın aldınız.")
			outputChatBox("#00ec38#575757"..exports["titan_pool"]:getServerName()..": #f1f1f1Arka taraftaki kutulardan yem satın alabilirsiniz. [10 TL]", source, 255, 126, 23, true)
		end
	else
		exports["titan_infobox"]:addBox(source, "error", "Olta alabilecek yeterli paran yok.")
	end
end)


