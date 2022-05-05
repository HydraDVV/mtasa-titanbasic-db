



local kenevirbolge = createColSphere (-18.7841796875, -30.2978515625, 3.1171875, 15, 3, 81)  --ToplamaYeri
local paketlemebolge = createColSphere (95.3154296875, -164.658203125, 2.59375, 6, 3, 81) --PaketlemeYeri
local kenevirsatbolge = createColSphere (2457.7734375, -1968.1416015625, 13.510054588318, 4) --Satışyeri


function kenevirTopla(localPlayer, cmd)

	    local uye = #getPlayersInTeam(exports.titan_factions:getTeamFromFactionID(1))
        local aktifPolis = 0 --Polis sayısı değiştire bilirsiniz.
        if uye >= aktifPolis then
        else
        outputChatBox("[!]#FFFFFF Kenevir toplamak için "..aktifPolis.." aktif polis olması gerek. ( Kenevir )",localPlayer,255,0,0,true) return end
 
   local theVehicle = getPedOccupiedVehicle (localPlayer)
   if theVehicle then
   outputChatBox("[!] #FFFFFFAraçtayken bu işlemi yapamazsınız.",localPlayer,255,0,0,true)
   return end -- burada bitti


    if getElementData(localPlayer, "kenevir:toplaniyor") then
	    outputChatBox("[Titan]: #FFFFFFHenüz kenevir toplama işlemini tamamlamadınız.",localPlayer,255,0,0,true)
    return end

	if not isElementWithinColShape(localPlayer, kenevirbolge) then
		outputChatBox("[Titan]: #FFFFFFKenevir toplama bölgesinde değilsiniz.",localPlayer,255,0,0,true)
	else
		if cmd == "kenevirtopla" then
		    setElementData(localPlayer, "kenevir:toplaniyor", true)
	        outputChatBox("[Titan]: #FFFFFFKenevir toplamaya başladınız.",localPlayer,255,0,0,true)
	        setElementFrozen( localPlayer, true )
	        exports.titan_global:applyAnimation(localPlayer, "bomber", "bom_plant_loop", -1, true, false, false)
            setTimer(function()
            	exports.titan_global:removeAnimation(localPlayer)		
                outputChatBox("[Titan]:#FFFFFFBaşarı ile 1 adet kenevir topladınız.",localPlayer,255,0,0,true)
                setElementFrozen( localPlayer, false )
                setElementData(localPlayer, "kenevir:toplaniyor", nil)
                exports["titan_items"]:giveItem(localPlayer,38,1)
            end, 15000, 1)
        end
    end
end
addCommandHandler("kenevirtopla", kenevirTopla)

function kenevirPaketle(localPlayer, cmd)
	    if getElementData(localPlayer, "kenevir:paketleme") then
	    outputChatBox("[Titan]: #FFFFFFHenüz kenevir paketleme işlemini tamamlamadınız.",localPlayer,255,0,0,true)
    return end

	if not exports.titan_global:hasItem(localPlayer,38) then 
		outputChatBox("[Titan]: #FFFFFFÜzerinizde paketlenecek kenevir bulunmamaktadır.",localPlayer,255,0,0,true)
    return end

	if not isElementWithinColShape(localPlayer, paketlemebolge) then
		outputChatBox("[Titan]: #FFFFFFKenevir paketleme bölgesinde değilsiniz.",localPlayer,255,0,0,true)
	else
	    if cmd == "kenevirpaketle" then
	    		        local uye = #getPlayersInTeam(exports.titan_factions:getTeamFromFactionID(1))
        local aktifPolis = 0 --Polis sayısı değiştire bilirsiniz.
        if uye >= aktifPolis then
        else
        outputChatBox("[!]#FFFFFF Kenevir toplamak için "..aktifPolis.." aktif polis olması gerek. ( Kenevir )",localPlayer,255,0,0,true) return end
 
        local theVehicle = getPedOccupiedVehicle (localPlayer)
        if theVehicle then
      outputChatBox("[!] #FFFFFFAraçtayken bu işlemi gerçekleştiremediniz.",localPlayer,255,0,0,true)
     return end

		    setElementData(localPlayer, "kenevir:paketleme", true)
	        outputChatBox("[Titan]: #FFFFFFKenevir paketlemeye başladınız.",localPlayer,255,0,0,true)
	        setElementFrozen( localPlayer, true )
	        exports.titan_global:applyAnimation(localPlayer, "bomber", "bom_plant_loop", -1, true, false, false)
	        exports["titan_items"]:takeItem(localPlayer,38,1)
            setTimer(function()
            	exports.titan_global:removeAnimation(localPlayer)
                outputChatBox("[Titan]:#FFFFFFTebrikler başarılı bir şekilde 1 adet kenevir paketlediniz!",localPlayer,255,0,0,true)
                --outputChatBox("[Titan]:#FFFFFFPaketleme ücreti:1 adet paketlenmiş kenevir kazandınız!",localPlayer,255,0,0,true)
                setElementFrozen( localPlayer, false )
                setElementData(localPlayer, "kenevir:paketleme", nil)
				exports["titan_items"]:giveItem(localPlayer,182,1)
            end, 3000, 1)
        end
    end
end
addCommandHandler("kenevirpaketle", kenevirPaketle)

function kenevirsat(localPlayer, cmd)
	if getElementData(localPlayer, "kenevir:paketleme") then
	outputChatBox("[Titan]: #FFFFFFHenüz kenevir satma işlemini tamamlamadınız.",localPlayer,255,0,0,true)
return end

if not exports.titan_global:hasItem(localPlayer,182) then 
	outputChatBox("[Titan]: #FFFFFFÜzerinizde satılacak paketlenmiş kenevir bulunmamaktadır.",localPlayer,255,0,0,true)
return end

if not isElementWithinColShape(localPlayer, kenevirsatbolge) then
	outputChatBox("[Titan]: #FFFFFFSatma bölgesinde değilsiniz.",localPlayer,255,0,0,true)
else
	if cmd == "kenevirsat" then
		setElementData(localPlayer, "kenevir:paketleme", true)
		outputChatBox("[Titan]: #FFFFFFKenevir satılıyor..",localPlayer,255,0,0,true)
		setElementFrozen( localPlayer, true )
		exports.titan_global:applyAnimation(localPlayer, "casino", "cards_loop", -1, true, false, false)
		exports["titan_items"]:takeItem(localPlayer,182,1)
		setTimer(function()
			exports.titan_global:removeAnimation(localPlayer)
			outputChatBox("[Titan]:#FFFFFFTebrikler 1 adet paketlenmiş kenevir Sattınız.",localPlayer,255,0,0,true)
			outputChatBox("[Titan]:#FFFFFFSattığın 1 adet paketlenmiş kenevirden 3,000TL Kazandın!",localPlayer,255,0,0,true)
			setElementFrozen( localPlayer, false )
			setElementData(localPlayer, "kenevir:paketleme", nil)
			exports.titan_global:giveMoney(localPlayer,3000)
		end, 500, 1)
	end
end
end
addCommandHandler("kenevirsat", kenevirsat)

function kenevirYardim(localPlayer, cmd)
	if cmd == "keneviryardim" then
		outputChatBox("[Titan]:#FFFFFF/kenevirtopla --- Belirlenmiş alandan kenevir toplamanızı sağlar.",localPlayer,255,0,0,true)
		outputChatBox("[Titan]:#FFFFFF/kenevirpaketle --- Belirlenmiş alandan toplanan keneviri paketlemenizi sağlar.",localPlayer,255,0,0,true)
		outputChatBox("[Titan]:#FFFFFF/kenevirsat --- Belirlenmiş alandan toplanan keneviri satma işlemenizi sağlar.",localPlayer,255,0,0,true)
	end
end
addCommandHandler("keneviryardim", kenevirYardim)


print("Basarili bir sekilde sistem aktif edildi @ Hanz")
