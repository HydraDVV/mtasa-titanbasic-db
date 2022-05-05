local mysql = exports.titan_mysql

function infoRolDersi(thePlayer)
	if (exports.titan_integration:isPlayerAdminI(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
		exports["titan_infobox"]:addBox(thePlayer, "info", "Sohbete bakınız.")
		outputChatBox("-#f9f9f9 /rdonayla [Karakter Adı & ID] - Rol dersi almış kişiyi doğrular.", thePlayer, 230, 30, 30, true)
		outputChatBox("-#f9f9f9 /rdeksik [Karakter Adı & ID] - Rol dersi almış kişinin rol bilgisini eksik işaretler.", thePlayer, 230, 30, 30, true)		
		outputChatBox("-#f9f9f9 /rdalabilecekler - 50 saat ve altı rol dersi alması gereken oyuncuları gösterir.", thePlayer, 230, 30, 30, true)
		outputChatBox("-#f9f9f9 /rdkontrol [Karakter Adı & ID] - Rol dersi kontrolü.", thePlayer, 230, 30, 30, true)
		outputChatBox("-#f9f9f9 /rdeksikler - Rol dersi testini geçememiş kişileri görüntüler.", thePlayer, 230, 30, 30, true)
	end
end
addCommandHandler("roldersi", infoRolDersi)

function giveRolDersi(thePlayer, commandName, targetPlayer, ...)
	if (exports.titan_integration:isPlayerAdminI(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
	    local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)	
		if targetPlayer then
				if getElementData(targetPlayer, "roldersi") == 1 then exports["titan_infobox"]:addBox(thePlayer, "error", "Bu şahısın zaten rol dersi onaylanmış.") return end
		    local affectedElements = { }
			exports['titan_admins']:addAdminHistory(targetPlayer, thePlayer, "Rol Dersini Geçti", 8, 1)
			setElementData(targetPlayer, "roldersi", 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET roldersi=1 WHERE id=" .. (getElementData(targetPlayer, "dbid")))	
			setElementData(thePlayer, "rdstats", getElementData(thePlayer, "rdstats")+1)
			dbExec(mysql:getConnection(), "UPDATE accounts SET rdstats="..(getElementData(thePlayer, "rdstats")+1).." WHERE id=" .. (getElementData(thePlayer, "dbid")))			
			exports["titan_infobox"]:addBox(thePlayer, "success", getPlayerName(targetPlayer).." adlı oyuncunun rol bilgisinin olduğunu doğruladınız.")
			exports["titan_infobox"]:addBox(targetPlayer, "success", "Rol bilginizin yeterli olduğu bir yetkili tarafından doğrulandı.")
			exports.titan_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun rol bilgisini doğruladı.")
		else
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kullanımı: /rdonayla [Karakter Adı & ID]")
		end
	end
end
addCommandHandler("rdonayla", giveRolDersi)

function takeRolDersi(thePlayer, commandName, targetPlayer, ...)
	if (exports.titan_integration:isPlayerAdminI(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
	    local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)				
		if targetPlayer then
				if getElementData(targetPlayer, "roldersi") == 2 then exports["titan_infobox"]:addBox(thePlayer, "error", "Bu şahısın zaten rol dersi eksik olarak girilmiş.") return end
		    local affectedElements = { }
			exports['titan_admins']:addAdminHistory(targetPlayer, thePlayer, "Rol Dersini Geçemedi", 8, 0)
			setElementData(targetPlayer, "roldersi", 2)
			dbExec(mysql:getConnection(),  "UPDATE characters SET roldersi=2 WHERE id=" .. (getElementData(targetPlayer, "dbid")))

			dbExec(mysql:getConnection(), "UPDATE accounts SET rdstats=1 WHERE id="..getElementData(thePlayer, "dbid"))
			exports["titan_infobox"]:addBox(thePlayer, "success", getPlayerName(targetPlayer).." adlı oyuncunun rol bilgisinin eksik olduğunu doğruladınız.")
			exports["titan_infobox"]:addBox(targetPlayer, "error", "Rol dersi testini geçemediniz, rol bilginiz: eksik.")
			exports.titan_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun rol bilgisini 'Eksik' olarak girdi.")
		else
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kullanımı: /rdeksik [Karakter Adı & ID]")
		end
	end
end
addCommandHandler("rdeksik", takeRolDersi)

function infoRdSuccess(thePlayer, cmd) 
	if (exports.titan_integration:isPlayerAdminI(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
		exports["titan_infobox"]:addBox(thePlayer, "info", "Sohbette rol dersi almaya müsait kişiler listelendi.")
		for _, player in ipairs(exports.titan_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
			    if getElementData(player, "roldersi") == 0 or getElementData(player, "roldersi") == false or not getElementData(player, "roldersi") then
				    if getElementData(player, "hoursplayed") < 50 then -- 50 saati geçmeyenleri göster
					    outputChatBox("- #999fffID: #ffffff"..getElementData(player, "playerid").. "#999fff | Kişinin Adı: #ffffff"..getPlayerName(player).."#999fff | Toplam Saati: #ffffff"..getElementData(player, "hoursplayed").." saat.", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end
addCommandHandler("rdalabilecekler", infoRdSuccess)

function eksikRD(thePlayer, cmd) 
	if (exports.titan_integration:isPlayerAdminI(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
		exports["titan_infobox"]:addBox(thePlayer, "info", "Sohbette rol dersi eksik olan kişiler listelendi.")
		for _, player in ipairs(exports.titan_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
			    if getElementData(player, "roldersi") == 2 then
					   outputChatBox("- #f54242ID: #ffffff"..getElementData(player, "playerid").. "#f54242 | Kişinin Adı: #ffffff"..getPlayerName(player).."#f54242 | Rol Dersi:#ffffff Eksik", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("rdeksikler", eksikRD)

function controlRd(thePlayer, cmd, targetPlayer, ...) 
	if (exports.titan_integration:isPlayerAdminI(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer)) then
	    local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)				
		local rd = getElementData(targetPlayer, "roldersi")
		
		if getElementData(targetPlayer, "loggedin") == 1 then
			if rd == 0 then
				exports["titan_infobox"]:addBox(thePlayer, "info", getPlayerName(targetPlayer).." isimli oyuncu rol dersi almamış.")
			elseif rd == 1 then
				exports["titan_infobox"]:addBox(thePlayer, "info", getPlayerName(targetPlayer).." isimli oyuncu rol dersini geçmiş.")
			elseif rd == 2 then
				exports["titan_infobox"]:addBox(thePlayer, "info", getPlayerName(targetPlayer).." isimli oyuncu rol dersini eksik tamamlamış.")
			end
		end
		
	end
end
addCommandHandler("rdkontrol", controlRd)


function moneyFarmingControl(thePlayer, cmd) 
	if (exports.titan_integration:isPlayerAdminI(thePlayer)) then
		exports["titan_infobox"]:addBox(thePlayer, "info", "70 saatten az oynayıp 20.000 TL'den fazla parası olan kişiler listelendi.")
		for _, player in ipairs(exports.titan_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
				local para = getElementData(player, "money")
				local banka = getElementData(player, "bankmoney")
				local toplam = para + banka
			    if getElementData(player, "hoursplayed") <= 70 and toplam > 20000 then
					   outputChatBox("- #ff825cKişi: #ffffff"..getPlayerName(player).." ("..getElementData(player, "playerid")..")#ff825c | Toplam Parası:#ffffff "..(getElementData(player, "money") + getElementData(player, "bankmoney")).. " TL#ff825c | Saati:#ffffff "..getElementData(player, "hoursplayed").. " saat.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("moneyfarmings", moneyFarmingControl)

function gaciControl(thePlayer, cmd) 
	if (exports.titan_integration:isPlayerAdminI(thePlayer)) then
		exports["titan_infobox"]:addBox(thePlayer, "info", "Gacıler sohbette listelendi.")
		for _, player in ipairs(exports.titan_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
			    if getElementData(player, "gender") == 1 then
					   outputChatBox("- #ff825cGacının Adı: #ffffff"..getPlayerName(player).." ("..getElementData(player, "playerid")..")#ff825c | Saati:#ffffff "..getElementData(player, "hoursplayed").. " saat.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("gacilar", gaciControl)