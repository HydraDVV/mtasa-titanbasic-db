mysql = exports.titan_mysql
-------- server -----
addEvent("BonusPara:ÖdülVer", true)
addEventHandler("BonusPara:ÖdülVer", root, function()
	local vip = getElementData(source,"vipver")
	if vip == 4 then
	exports.titan_global:giveMoney(source, 200+500)
	outputChatBox("#9060f0[-]#f8f8f8 VIP 4 olduğunuz için saatlik bonusunuz uyarısız geldi. ( $700 )", source, 155, 0, 0, true)	
	
	elseif vip == 3 then
	exports.titan_global:giveMoney(source, 200+400)
	outputChatBox("#9060f0[-]#f8f8f8 Tebrikler, başarıyla VIP 3 saatlik bonusunuzu aldınız. ( $600 )", source, 155, 0, 0, true)

	elseif vip == 2 then
	exports.titan_global:giveMoney(source, 200+300)
	outputChatBox("#9060f0[-]#f8f8f8 Tebrikler, başarıyla VIP 2 saatlik bonusunuzu aldınız. ( $500 )", source, 155, 0, 0, true)
	
	elseif vip == 1 then
	exports.titan_global:giveMoney(source, 200+200)
	outputChatBox("#9060f0[-]#f8f8f8 Tebrikler, başarıyla VIP 1 saatlik bonusunuzu aldınız. ( $400 )", source, 155, 0, 0, true)
	
	else
	exports.titan_global:giveMoney(source, 200)
	outputChatBox("#9060f0[-]#f8f8f8 Tebrikler, başarıyla saatlik bonusunuzu aldınız. ( $200 )", source, 155, 0, 0, true)
	end
end)

function test(player)
	dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = hoursplayed+1 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "hoursplayed", tonumber(getElementData(player, "hoursplayed"))+1)
end
addEvent("bonus:saatekle", true)
addEventHandler("bonus:saatekle", root, test)


function viptest(player)
	dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = hoursplayed+2 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "hoursplayed", tonumber(getElementData(player, "hoursplayed"))+2)
	outputChatBox("[-]#f9f9f9 Havalısın, VIP 4 olduğun için sana 2 saat geldi.", player, 255, 194, 14,true)
end
addEvent("bonus:vipsaatekle", true)
addEventHandler("bonus:vipsaatekle", root, viptest)
