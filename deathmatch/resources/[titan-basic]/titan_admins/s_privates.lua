mysql = exports.titan_mysql

function rpVerme(thePlayer, commandName, targetPlayer, rp)
	if (exports.titan_integration:isPlayerLeadAdmin(thePlayer)) then
	if (not tonumber(rp)) then
		outputChatBox("[!] #ffffffBirşey yazmadınız. /rpver <oyuncu id> <rp seviyesi>", thePlayer, 255, 0, 0, true)
	else
		if tonumber(rp) < 2 and tonumber(rp) > -1 then
		local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		local dbid = getElementData(targetPlayer, "account:character:id")

		if tonumber(rp) == 1 then
		if targetPlayer then
			local dbid = getElementData(targetPlayer, "account:character:id")

			outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla [RP+] verdiniz", thePlayer, 0, 255, 0, true)
			outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili size [RP+] verdi.", targetPlayer, 0, 255, 0, true)
			setElementData(targetPlayer, "rp+", tonumber(rp))
			dbExec(mysql:getConnection(),"UPDATE `characters` SET `rp+`="..rp.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
			exports.titan_global:updateNametagColor(targetPlayer)

		end
	else
 		outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncunun [RP+]'sini başarıyla aldınız.", thePlayer, 0, 255, 0, true)
		outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili sizin [RP+]'ınızı aldı.", targetPlayer, 255, 0, 0, true)
		setElementData(targetPlayer, "rp+", tonumber(rp))
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `rp+`="..rp.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		exports.titan_global:updateNametagColor(targetPlayer)
	end
		else
			outputChatBox("[!]#ffffff 0 veya 1 degerini giriniz.", thePlayer, 255, 0, 0, true)
		end
	end
	else
		outputChatBox("[!]#ffffffBu işlemi yapabilmek için admin olmalısın.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("rpver",rpVerme)