local sudakPara = 45
local denizPara = 35
local derePara = 25
local dagPara = 15


local yemx, yemy, yemz = 1872.322265625, -2459.1513671875, 13.579086303711
local yemCol = createColSphere(yemx, yemy, yemz, 2)
setElementInterior(yemCol, 27)
setElementDimension(yemCol, 157)
local balikCol = createColPolygon(360.2646484375, -2047.708984375, 346.84375, -2047.708984375, 347.8466796875, -2094.7978515625, 415.24609375, -2094.7978515625, 415.25390625, -2047.7099609375, 399.392578125, -2047.7099609375, 399.513671875, -2048.248046875, 408.4306640625, -2048.2607421875, 408.322265625, -2087.6474609375, 350.8984375, -2087.5585937, 350.7744140625, -2048.453125, 360.427734375, -2048.681640625, 360.2431640625, -2047.709960937)

function balikYardim(thePlayer)
	if isElementWithinColShape(thePlayer, yemCol) then
		outputChatBox("----------------------------------------------------------------------------------", thePlayer, 230, 30, 30)
		outputChatBox("==>#f9f9f9 Yem Almak İçin /yemal --",thePlayer,255,240,240, true)
		outputChatBox("==>#f9f9f9 Balık Satmak İçin /baliksat --",thePlayer,255,240,240, true)
		outputChatBox("==>#f9f9f9 Yem ve Balık Bilgileriniz İçin /balikdurum --",thePlayer,255,240,240, true)
		outputChatBox("----------------------------------------------------------------------------------", thePlayer, 230, 30, 30)
	end
end
addCommandHandler("balikyardim", balikYardim)

addCommandHandler("baliktut", 
	function(thePlayer, cmd)
		if isElementWithinColShape(thePlayer, balikCol) then
			
			if not exports.titan_global:hasItem(thePlayer, 49) then exports["titan_infobox"]:addBox(thePlayer, "error", "Oltanız olmadan balık tutamazsınız.") return end

			if (not getElementData(thePlayer, "balikTutuyor")) then
				local toplamyem = getElementData(thePlayer, "toplamyem") or 0
				if toplamyem > 0 then
					triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
					setElementFrozen(thePlayer, true)
					exports.titan_global:applyAnimation(thePlayer, "SWORD", "sword_IDLE", -1, false, true, true, false)
					setElementData(thePlayer, "balikTutuyor", true)
					exports.titan_global:sendLocalMeAction(thePlayer, "oltasını denize doğru sallar.", false, true)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffBalık tutuyorsunuz, lütfen bekleyin!", thePlayer, 30, 230, 30, true)
					setElementData(thePlayer, "toplamyem", toplamyem - 1)
					setTimer(function(thePlayer) 
						--local toplambalik = getElementData(thePlayer, "toplambalik") or 0
						setElementFrozen(thePlayer, false)
						local rastgeleSayi = math.random(1,2)
						if rastgeleSayi == 1 then
							local balikTipi1 = yuzdelikOran(50)
							local balikTipi2 = yuzdelikOran(50)
							local balikTipi3 = yuzdelikOran(50)
							local balikTipi4 = yuzdelikOran(50)
							
							if balikTipi3 then
								exports["titan_items"]:giveItem(thePlayer, 290, 1) -- SUDAK BALIĞI
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffTebrikler, bir adet 'Albino' tuttunuz!", thePlayer, 0, 255, 0, true)					
							elseif balikTipi2 then
								exports["titan_items"]:giveItem(thePlayer, 291, 1) -- DAĞ ALABALIĞI
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffTebrikler, bir adet 'Dağ Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)
							elseif balikTipi1 then
								exports["titan_items"]:giveItem(thePlayer, 292, 1) -- DENİZ ALABALIĞI
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffTebrikler, bir adet 'Dere Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
							elseif balikTipi4 then
								exports["titan_items"]:giveItem(thePlayer, 555, 1) -- İSTİRİDYE
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffTebrikler, bir adet 'İstiridye' tuttunuz!", thePlayer, 0, 255, 0, true)		
							else -- Hiçbiri Vurmazsa, (Değeri en düşük balık.)
								exports["titan_items"]:giveItem(thePlayer, 293, 1) -- DERE ALABALIĞI
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffTebrikler, bir adet 'Deniz Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
							end
							--setElementData(thePlayer, "toplambalik", toplambalik + 1)
						elseif rastgeleSayi >= 2 then
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, balık tutamadınız.", thePlayer, 230, 30, 30, true)
						end
						exports.titan_global:removeAnimation(thePlayer)
						triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
						setElementData(thePlayer, "balikTutuyor", false)
					end, 18000, 1, thePlayer)
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, üzerinizde yem kalmadı.", thePlayer, 230, 30, 30, true)
				end
			end
		end
	end
)


addCommandHandler("balikdurum", 
	function(thePlayer, cmd)
		local yem = getElementData(thePlayer, "toplamyem") or 0
		--local balik = getElementData(thePlayer, "toplambalik") or 0
		local toplamBalik = exports["titan_items"]:countItems(thePlayer, 236, 1) + exports["titan_items"]:countItems(thePlayer, 237, 1) + exports["titan_items"]:countItems(thePlayer, 238, 1) + exports["titan_items"]:countItems(thePlayer, 239, 1)
		outputChatBox("-----------------------------------------", thePlayer, 230, 30, 30)
		outputChatBox("==> Toplam Balık: " .. tostring(toplamBalik), thePlayer, 255, 240, 240)
		outputChatBox("==> Toplam Yem: " .. tostring(yem), thePlayer, 255, 240, 240)
		outputChatBox("-----------------------------------------", thePlayer, 230, 30, 30)
	end
)

function yemAl(thePlayer, cmd)
	local para = exports.titan_global:getMoney(thePlayer)
	if para >= 50 then
		if isElementWithinColShape(thePlayer, yemCol) then
			local toplamyem = getElementData(thePlayer, "toplamyem") or 0
			if toplamyem >= 20 then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffff20 taneden fazla yem alamazsınız.", thePlayer, 230, 30, 30, true)
				return
			elseif toplamyem <= 20 then
				exports.titan_global:takeMoney(thePlayer, 5)
				if (toplamyem + 10) <= 20 then
					setElementData(thePlayer, "toplamyem", toplamyem + 10)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffff10 adet yem satın aldınız.", thePlayer, 30, 230, 30, true)
				elseif (toplamyem + 10) >= 20 then
					alinamayanYem = toplamyem + 10 - 20
					alinanYem = 10 - alinamayanYem
					setElementData(thePlayer, "toplamyem", 20)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffff" .. tostring(alinanYem) .. " Adet yem aldınız.", thePlayer, 30, 230, 30, true)
				end
			end
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffYem fiyatları arttı, yemler artık $50 ahbap.", thePlayer, 230, 30, 30, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffYem almak için yeterli paranız yok.", thePlayer, 230, 30, 30, true)
	end
end
addCommandHandler("yemal", yemAl)

function balikSat(thePlayer, cmd)
	local denizMiktar = exports["titan_items"]:countItems(thePlayer, 292, 1)
	local dagMiktar = exports["titan_items"]:countItems(thePlayer, 291, 1)
	local dereMiktar = exports["titan_items"]:countItems(thePlayer, 293, 1)
	local sudakMiktar = exports["titan_items"]:countItems(thePlayer, 290, 1)
	
	if isElementWithinColShape(thePlayer, yemCol) then
		local toplambalik = denizMiktar + dagMiktar + dereMiktar + sudakMiktar
		if toplambalik <= 0 then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffSatacak balığınız yok!", thePlayer, 230, 30, 30, true)
			return
		else
			verilecekPara = (denizMiktar * denizPara) + (dagMiktar * dagPara) + (dereMiktar * derePara) + (sudakMiktar * sudakPara)
			exports.titan_global:giveMoney(thePlayer, verilecekPara)
			for i = 0, denizMiktar do
				exports["titan_items"]:takeItem(thePlayer, 292, 1)
			end
			for i = 0, dagMiktar do
				exports["titan_items"]:takeItem(thePlayer, 291, 1)
			end
			for i = 0, dereMiktar do
				exports["titan_items"]:takeItem(thePlayer, 293, 1)
			end
			for i = 0, sudakMiktar do
				exports["titan_items"]:takeItem(thePlayer, 290, 1)
			end
			exports["titan_infobox"]:addBox(thePlayer, "buy", "Satışlardan toplam $"..tostring(verilecekpara).." kazandın.")
			outputChatBox("[-] #ffffffTuttuğunuz Balıklar;", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(sudakMiktar) .. "' Albino Balığı $" .. tostring(sudakMiktar * sudakPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(dereMiktar) .. "' Dere Alabalığından $" .. tostring(dereMiktar * derePara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(denizMiktar) .. "' Deniz Alabalığından $" .. tostring(denizMiktar * denizPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			outputChatBox("✹ #ffffff '" .. tostring(dagMiktar) .. "' Dağ Alabalığından $" .. tostring(dagMiktar * dagPara) .. " kazandınız.", thePlayer, 0, 0, 255, true)
			
			--setElementData(thePlayer, "toplambalik", 0)
		end
	end
end
addCommandHandler("baliksat", balikSat)

function yuzdelikOran (percent)
	assert(percent >= 0 and percent <= 100) 
	return percent >= math.random(1, 100)
end