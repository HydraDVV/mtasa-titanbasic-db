local thePed = createPed(20, -44.634765625, -299.68359375, 5.4296875)
setElementRotation(thePed, 0, 0, 180)
setElementFrozen(thePed, true)
setElementData(thePed, "talk", 1)
setElementData(thePed, "name", "Stephan Nill")

addEvent("tutun:tutunVer", true)
addEventHandler("tutun:tutunVer", getRootElement(),function(tutun,fiyat,sira)
	
	local maxTutun = exports["titan_items"]:countItems(source, 589)
	if maxTutun >= 3 then
		exports["titan_infobox"]:addBox(source, "warning", "Maksimum 3 torba tütün satın alabilirsin.")
	return end
	
	if  exports.titan_global:takeMoney(source, fiyat) then
		if  exports.titan_global:giveItem(source, tutun, 1) then
			exports["titan_infobox"]:addBox(source, "buy", "Başarıyla "..fiyat.." TL'ye bir torba tütün satın aldınız.")
			outputChatBox("#00ec38#575757"..exports["titan_pool"]:getServerName()..": #f1f1f1Arka taraftaki kutulardan yem satın alabilirsiniz. [10 TL]", source, 255, 126, 23, true)
		end
	else
		exports["titan_infobox"]:addBox(source, "error", "Tütün alabilmek için yeterli paran yok.")
	end
end)

local islemeBolge = createColSphere (1934.359296875, -2352.4072265625, 12.841756439209, 1.5, 0, 0)
setElementInterior(islemeBolge,25)
setElementDimension(islemeBolge,2515)
addCommandHandler("sigara", function(player, cmd,komut)

	if (getElementData(player, "hoursplayed") or 0) < 50 then
		exports["titan_infobox"]:addBox(player, "error", "Sigara sarabilmen için 50 saati geçmen gerekiyor.")
	return end

	if not isElementWithinColShape(player, islemeBolge) then
		exports["titan_infobox"]:addBox(player, "error", "Bu alanda sigara saramazsın.")
	return end

	if getElementData(player, "tutun:durum") then
		exports["titan_infobox"]:addBox(player, "warning", "Şu anda zaten bir sigara sarıyorsun.")
	return end

	if not komut then
		exports["titan_infobox"]:addBox(player, "info", "/sigara sar [2 dakika sürer.]")
	return end

	local sigaraPaketi = exports["titan_items"]:countItems(player, 590)
	local toplamTutun = exports["titan_items"]:countItems(player, 589)
	if sigaraPaketi >= 3 then exports["titan_infobox"]:addBox(player, "error", "Şu anda 3 adet sigara paketi toplamışsınız, sattıktan sonra geri dönebilirsiniz.") return end
	
	if komut == "sar" then
		if not exports.titan_global:hasItem(player,589) then exports["titan_infobox"]:addBox(player, "warning", "Tütünün olmadan sigara saramazsın.") return end
		setElementData(player, "tutun:durum", true)
			exports.titan_global:takeItem(player,589)
			exports["titan_infobox"]:addBox(player, "info", "2 dakika içerisinde bir paket sigara saracaksınız.")
			setElementFrozen ( player, true )
			exports["titan_progressbar"]:drawProgressBar("Sigara", "Sigara sarılıyor...",player, 255, 255, 255, 120000)
			
			exports.titan_global:applyAnimation(player, "BD_FIRE", "wash_up", -1, true, false, false)		
			setTimer(function()
			exports.titan_global:removeAnimation(player)
			setElementFrozen ( player, false )			
			exports["titan_infobox"]:addBox(player, "success", "Başarıyla sigaranı sardın.")
			exports.titan_global:giveItem(player,590,1)		
				setElementData(player, "tutun:durum", nil)
			end, 120000, 1)
	end
end)


local satmaBolge = createColSphere( 2859.7314453125, 2570.83203125, 10.8203125, 3.5, 0, 0)


addCommandHandler("kacaksigarasat", function(player)
	local sigaraPaketi = exports["titan_items"]:countItems(player, 590)
	if sigaraPaketi < 3 then
		exports["titan_infobox"]:addBox(player, "error", "Sigara paketiniz eksik, 3 tane sigara paketinizin olması gerekiyor.")
	else
		if isElementWithinColShape(player, satmaBolge) then
			if exports.titan_global:hasItem(player, 590) then
				exports["titan_items"]:takeItem(player, 590)
				exports["titan_items"]:takeItem(player, 590)
				exports["titan_items"]:takeItem(player, 590)
				exports["titan_infobox"]:addBox(player, "buy", "Tüm sigara paketlerini sattınız, toplam 1.500 TL kazandın.")
				exports["titan_global"]:giveMoney(player, 1500)
			else
				exports["titan_infobox"]:addBox(player, "error", "Kaçak sigaranız olmadan sigara satışı yapamazsınız.")
			end
		else
			exports["titan_infobox"]:addBox(player, "error", "Bu alanda kaçak sigaralarını satamazsın.")
		end
	end
end)