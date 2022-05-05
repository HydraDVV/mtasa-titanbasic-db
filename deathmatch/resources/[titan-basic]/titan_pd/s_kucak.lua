
local kucak = {}

addCommandHandler("kucak", function(thePlayer, cmd, targetPlayer)
	if not targetPlayer then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Kullanım :/"..cmd.." [Karakter Adı & ID]", thePlayer, 255, 194, 14, true)
	return end
		if getElementData(thePlayer, "gelenIstekler") then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Zaten şu anda bir teklifiniz mevcut.", thePlayer, 255, 0, 0, true) return end
		if getElementData(thePlayer, "kucakta") then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Zaten şu anda birini taşıyorsunuz", thePlayer, 255, 0, 0, true) return end
				local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer == thePlayer then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Kendini kucaklayamazsın.", thePlayer, 255, 0, 0, true) return end
		if targetPlayer then
			local x, y, z = getElementPosition(thePlayer)
			local tx, ty, tz = getElementPosition(targetPlayer)
			local targetPlayerName = getPlayerName(targetPlayer)
			local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
			if (distance<=1) then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff "..getPlayerName(targetPlayer).." adlı oyuncuya teklifi yolladınız.", thePlayer, 255, 0, 255, true)
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff "..getPlayerName(thePlayer).." adlı oyuncu sizi kucağına almak istiyor.", targetPlayer, 255, 0, 255, true)
				setElementData(thePlayer, "gelenIstekler", true)
				triggerClientEvent(targetPlayer, "kucak:gui", thePlayer, thePlayer, targetPlayer)
				setTimer(function()
					triggerClientEvent(targetPlayer, "kucak:guiclose", targetPlayer)
					exports["titan_infobox"]:addBox(targetPlayer, "error", "15 saniye geçtiği için arayüzün kapatıldı.")
					if getElementData(thePlayer, "gelenIstekler") then
						setElementData(thePlayer, "gelenIstekler", nil)
					end
				end, 15000, 1)
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Belirttiğiniz şahısa çok uzaksınız.", thePlayer, 255, 0,0,true)
			end
		end
end)

addCommandHandler("kucakindir", function(thePlayer)
		local surukle = getElementData(thePlayer, "kucakta")
		if surukle then
			setElementFrozen(surukle, false)
			detachElements(surukle, thePlayer)
			setElementData(thePlayer, "kucakta", false)
			setElementData(thePlayer, "gelenIstekler", false)
			local targetPlayerName = getPlayerName(surukle)		
			exports.titan_global:sendLocalMeAction(thePlayer, "şahısı yere indirir.", false, true)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahsı kucaklamayı bıraktınız.", thePlayer, 0, 255, 0, true)
			exports.titan_global:applyAnimation( surukle, "CRACK", "crckidle3", -1, false, false, false)

			exports.titan_global:removeAnimation(targetPlayer)
			setElementFrozen(surukle, false)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. getPlayerName(thePlayer).. " isimli şahıs sizi kucaklamayı bıraktı.", surukle, 0, 255, 0, true)
		end
end)

function kucak.kabul (thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		setElementData(thePlayer, "kucakta", targetPlayer)
		attachElements(targetPlayer, thePlayer, 0, 0.4, 1.3)
		setElementData(thePlayer, "kucakta", targetPlayer)
		setElementFrozen(targetPlayer, true)
		setPedAnimation(targetPlayer, "CRACK", "crckidle4", 50, false)
		setPedAnimation(thePlayer, "CARRY", "crry_prtial", 50, false)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff "..getPlayerName(targetPlayer).." adlı oyuncu teklifinizi kabul etti. İndirmek için /kucakindir.", thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Başarıyla gelen teklifi kabul ettiniz.", targetPlayer, 0, 0, 255, true)
	end
end
addEvent("kucak:kabul", true)
addEventHandler("kucak:kabul", root, kucak.kabul)

function kucak.reddet(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Başarıyla gelen teklifi reddettiniz.", targetPlayer, 0, 255, 0, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Karşı taraf teklifinizi reddetti.", thePlayer, 255, 0, 0, true)
		setElementData(thePlayer, "gelenIstekler", nil)
		setElementData(thePlayer, "kucakta", nil)
	end
end
addEvent("kucak:reddet", true)
addEventHandler("kucak:reddet", getRootElement(), kucak.reddet)

function enterVehicle ( player, seat, jacked )
    if getElementData(player, "gelenIstekler") or getElementData(player, "kucakta") then
		cancelEvent()
        outputChatBox ( ""..exports["titan_pool"]:getServerName()..":#f9f9f9 Kucak işlemin devam ettiği için bu işlemi gerçekleştiremezsin.", player, 40, 40, 40, true )
	end
end
addEventHandler ( "onVehicleStartEnter", getRootElement(), enterVehicle )