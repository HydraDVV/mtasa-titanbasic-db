--
function bantla(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (targetPlayer) then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Kullanım: /" .. cmdName .. " [Karakter Adı & ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if getElementData(thePlayer, "bantli") then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bantlı durumdayken birini bantlayamazsınız.", thePlayer, 255, 0, 0, true) return end
			if getElementData(thePlayer, "gidenIstek") then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Zaten bir istek göndermişsiniz.", thePlayer, 255, 0, 0, true) return end
			if targetPlayer == thePlayer then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Kendinizi bantlayamazsınız.", thePlayer, 255, 0, 0, true)
				return
			end
			if exports.titan_global:hasItem(thePlayer, 588) then 
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					local targetPlayerName = getPlayerName(targetPlayer)
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=2) then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahısa bantlama isteği gönderilmiştir.", thePlayer, 0, 255, 0, true)
						exports.titan_global:sendLocalMeAction(thePlayer, "yavaşça "..targetPlayerName.. " isimli şahısın ağzını bantlamaya çalışır.")
						setElementData(thePlayer, "gidenIstek", true)
						triggerClientEvent(targetPlayer, "bant:bantbantlamaOnayGUI", thePlayer, thePlayer, targetPlayer)
					else
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli kişiden çok uzaksınız.", thePlayer, 255, 0, 0, true)
					end
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Yeterli bantınız yok.", thePlayer, 255, 0, 0, true) 
			end
		end
	end
end
addCommandHandler("bantla", bantla)

function bantlamaKabul(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		if exports.titan_global:takeItem(thePlayer, 588) then
			setElementData(targetPlayer, "bantli", true)
			local bantlayan = getPlayerName(thePlayer)
			local bantlanan = getPlayerName(targetPlayer)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 "..bantlayan.." isimli kişi ağzınızı bantladı.", targetPlayer, 255, 0, 0, true)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 "..bantlanan.." isimli kişinin ağzını bantladınız.", thePlayer, 255, 0, 0, true)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bantı çıkartmak için /bantcikar yazınız veya sağ tıklayıp 'Bantı Çıkar' butonuna basınız.", thePlayer, 255, 0, 0, true)
			exports.titan_global:takeItem(thePlayer, 588, 1)
			setElementData(thePlayer, "gidenIstek", nil)
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Yeteli bantınız yok.", thePlayer, 255, 0, 0, true)
		end
	end
end
addEvent("bant:bantlamaKabul", true)
addEventHandler("bant:bantlamaKabul", getRootElement(), bantlamaKabul)

function bantlamaRed(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		    
		local dotCounter = 0
		local doubleDot = ":"
		if dotCounter < 10000 then
			dotCounter = dotCounter + 200
		elseif dotCounter == 10000 then
			dotCounter = 0
		end
		if dotCounter <= 5000 then
			doubleDot = ":"
		else
			doubleDot = " "
		end
		
		local hour, minute = getRealTime()
		time = getRealTime()
		if time.hour >= 0 and time.hour < 10 then
			time.hour = "0"..time.hour
		end

		if time.minute >= 0 and time.minute < 10 then
			time.minute = "0"..time.minute
		end
			
		local realTime = time.hour..doubleDot..time.minute..doubleDot..time.second

		setElementData(thePlayer, "gidenIstek", nil)

		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Bantlanma isteğini reddettiniz.", targetPlayer, 0, 255, 0, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Bantlama isteğiniz reddedilmiştir.", thePlayer, 255, 0, 0, true)
		exports.titan_global:sendLocalMeAction(targetPlayer, "yavaşça kendini geri çeker.")
		exports.titan_global:sendLocalText(targetPlayer, " ["..realTime.."] "..getPlayerName(targetPlayer).." diyor ki : Senin amacın ne?", 230,230,230,5,nil,true)

	end
end
addEvent("bant:bantlamaRed", true)
addEventHandler("bant:bantlamaRed", getRootElement(), bantlamaRed)

function bantCikart(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPlayer) then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Kullanım: /" .. cmdName .. " [Karakter Adı & ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not getElementData(targetPlayer, "bantli") then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Şahıs zaten bantlı değil.", thePlayer, 255, 0, 0, true) return end
			if targetPlayer == thePlayer then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Kendinizin bantını çıkartamazsınız.", thePlayer, 255, 0, 0, true)
				return
			end
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				local targetPlayerName = getPlayerName(targetPlayer)
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=5) then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahısın ağzındaki bantı çıkarttınız.", thePlayer, 0, 255, 0, true)
					exports.titan_global:sendLocalMeAction(thePlayer, "yavaşça "..targetPlayerName.. " isimli şahısın ağzındaki bandı çıkartır.")
					setElementData(targetPlayer, "bantli", nil)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 "..getPlayerName(thePlayer).." isimli şahıs ağzınızdaki bandı çıkarttı.", targetPlayer, 255, 0, 255, true)
					exports.titan_global:giveItem(thePlayer, 588, 1)
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli kişiden çok uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("bantcikar", bantCikart)