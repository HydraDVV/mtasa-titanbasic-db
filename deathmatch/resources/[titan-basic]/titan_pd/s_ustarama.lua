--
function ustArama(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if getElementData(thePlayer, "ustArama") then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Aynı anda birden fazla kişinin üstünü arayamazsınız!", thePlayer, 255, 0, 0, true)
			return false
		end

		if not (targetPlayer) then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0SÖZDİZİMİ: /" .. cmdName .. " [Kişi Adı / ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer == thePlayer then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Kendi üzerinizi arayamazsınız.", thePlayer, 255, 0, 0, true)
				return
			end
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
			
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=5) then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahsa üst arama isteği gönderilmiştir.", thePlayer, 0, 255, 0, true)
					triggerClientEvent(targetPlayer, "pd:ustAramaOnayGUI", thePlayer, thePlayer, targetPlayer)
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("ustara", ustArama)

function aramaKabul(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		local para = exports.titan_global:getMoney(targetPlayer)
		local pistol, deagle, uzi, tec9, mp5, shotgun, ak47, m4, sniper = false
		
		local silahlar = getPedWeapons(targetPlayer)
		local deagle, uzi, tec9, mp5, shotgun, ak47, m4, sniper = false
		for i, v in ipairs(silahlar) do
			if v == 28 then
				uzi = true
			elseif v == 24 then
				deagle = true
			elseif v == 32 then
				tec9 = true
			elseif v == 29 then
				mp5 = true
			elseif v == 25 then
				shotgun = true
			elseif v == 30 then
				ak47 = true
			elseif v == 31 then
				m4 = true
			elseif v == 34 then
				sniper = true
			end
		end
		
		local marijuana = exports["titan_items"]:countItems(targetPlayer, 38)
		local kokain = exports["titan_items"]:countItems(targetPlayer, 34)
		local mantar = false
		local eroin = exports["titan_items"]:countItems(targetPlayer, 37)
		local ekstazi = exports["titan_items"]:countItems(targetPlayer, 36)
		local meth = exports["titan_items"]:countItems(targetPlayer, 39)
		
		local telefon = exports["titan_items"]:hasItem(targetPlayer, 2)
		local telsiz = exports["titan_items"]:hasItem(targetPlayer, 6)
	
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Para: $" .. exports.titan_global:formatMoney(para), thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Telefon: " .. (telefon and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " - Telsiz:" .. (telsiz and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Pistol: " .. (pistol and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " - Deagle:" .. (deagle and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " UZI:" .. (uzi and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0TEC9: " .. (tec9 and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " - MP5:" .. (mp5 and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " Pompalı:" .. (shotgun and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0AK47: " .. (ak47 and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " - M4:" .. (m4 and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]") .. " Tüfek:" .. (sniper and "[#ff0000VAR#f0f0f0]" or "[#ff0000YOK#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Marijuana: " .. "[" .. marijuana .. "]" .. " - Kokain:" ..  "[" .. kokain .. "]" ..  " Mantar:[0]", thePlayer, 0, 0, 255, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Eroin: [" .. eroin .. "] - Ekstazi: [" .. ekstazi .. "] - Methamorphine: [" .. meth .. "]", thePlayer, 0, 0, 255, true)
	end
end
addEvent("pd:aramaKabul", true)
addEventHandler("pd:aramaKabul", getRootElement(), aramaKabul)

function aramaRed(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Üst arama isteğini başarıyla reddettiniz.", targetPlayer, 0, 255, 0, true)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Üst arama isteğiniz reddedilmiştir.", thePlayer, 255, 0, 0, true)
	end
end
addEvent("pd:aramaRed", true)
addEventHandler("pd:aramaRed", getRootElement(), aramaRed)

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end