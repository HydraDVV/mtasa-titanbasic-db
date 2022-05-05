local mysql = exports.titan_mysql

addCommandHandler("vipver", function(thePlayer, cmdName, idOrNick, vipRank, days)
	if exports.titan_integration:isPlayerHeadAdmin(thePlayer) then
		if (not idOrNick or not tonumber(vipRank) or not tonumber(days) or (tonumber(vipRank) < 0 or tonumber(vipRank) > 4)) then
			outputChatBox("► #ffffffKullanım: /"..cmdName.." <oyuncu id> <vip rank (1-2-3-4)> <gün>", thePlayer, 250, 85, 85, true)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
				end
				
				local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
				if not isPlayerVIP(charID) then
					local id = SmallestID()
					
					local success = dbExec(mysql:getConnection(), "INSERT INTO `vipPlayers` (`id`, `char_id`, `karakterIsmi`, `vip_type`, `vip_end_tick`) VALUES ('"..id.."', '"..charID.."', '"..getPlayerName(targetPlayer).."', '"..(vipRank).."', '"..(endTick).."')") or false
					if not success then
						return
					end
				
					outputChatBox("► #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla "..days.." günlük VIP verdiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("► #ffffff"..getPlayerName(thePlayer).." isimli yetkili size "..days.." günlük VIP ["..vipRank.."] verdi.", targetPlayer, 0, 255, 0, true)
				
					--exports.titan_global:updateNametagColor(targetPlayer)
					loadVIP(charID)
				else
					local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + "..endTick.." WHERE char_id="..charID.." and vip_type="..vipRank.." LIMIT 1")
					if not success then
						return
					end
					
					outputChatBox("► #ffffff"..targetPlayerName.." isimli oyuncunun VIP süresine "..days.." gün eklediniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("► #ffffff"..getPlayerName(thePlayer).." isimli yetkili VIP ["..vipRank.."] sürenizi "..days.." gün uzattı.", targetPlayer, 0, 255, 0, true)
					
					loadVIP(charID)
				end
			else
				outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
			end
		end
	else 
		outputChatBox("► #ffffffBu özelliği kullanabilmek için yeterli yetkiniz yok.", thePlayer, 250, 85, 85, true)
	end
end)

addCommandHandler(""..exports["titan_pool"]:getServerName().."vipver", function(thePlayer, cmdName)
	if exports.titan_integration:isPlayerDeveloper(thePlayer) then
		Async:foreach(getElementsByType("player"), function(player)
			if getElementData(player, "loggedin") == 1 and (tonumber(getElementData(player, "vipver")) or 0) <= 3 then
				local charID = tonumber(getElementData(player, "dbid"))
				if not isPlayerVIP(charID) then
					addVIP(player, 3, 3) -- 3 gün VIP VER
					exports["titan_infobox"]:addBox(player, "success", "Tebrikler, etkinlik tarafından 3 günlük VIP [3] kazandınız!")
				elseif isPlayerVIP(charID) and tonumber(getElementData(player, "vipver")) == 3 then
					addVIP(player, 3, 3) -- 3 gün ekle
					exports["titan_infobox"]:addBox(player, "success", "Tebrikler, etkinlik tarafından VIP [3] sürenize 3 gün daha eklendi.")
				elseif tonumber(getElementData(player, "vipver")) == 1 then
					local remaining = vipPlayers[charID].endTick/1000
					local vipDays = math.floor ( remaining /86400 )
			
					if tonumber(vipDays) <= 3 then
						removeVIP(charID)
						addVIP(player, 3, 3)
						exports["titan_infobox"]:addBox(player, "success", "VIP 1'iniz 3 günden az olduğu için silindi ve 3 günlük VIP [3] fırsatından yararlandınız.")
					end
				end
			end
		end)
		exports["titan_infobox"]:addBox(thePlayer, "success", "Tüm oyunculara 3 günlük VIP 3 verildi.")
	else
		exports["titan_infobox"]:addBox(thePlayer, "error", "Bu komutu kullanmaya izniniz yok.")
	end
end)

addCommandHandler("vipal", function(thePlayer, cmdName, idOrNick)
	if exports.titan_integration:isPlayerHeadAdmin(thePlayer) then
		if (not idOrNick) then
			outputChatBox("► #ffffffKullanım: /"..cmdName.." <oyuncu id/isim>", thePlayer, 250, 85, 85, true)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
				end
				
				if isPlayerVIP(charID) then
					local success = removeVIP(charID)
					if success then
						outputChatBox("► #ffffff"..targetPlayerName.." adlı oyuncunun VIP üyeliğini aldınız.", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("► #ffffffOyuncunun VIP üyeliği yok.", thePlayer, 250, 85, 85, true)
				end
			else
				outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
			end
		end
	else 
		outputChatBox("► #ffffffBu özelliği kullanabilmek için yeterli yetkiniz yok.", thePlayer, 250, 85, 85, true)
	end
end)

addCommandHandler("vipsure", function(thePlayer, cmd, id)
	if id then
	local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, id)
	local id = getElementData(targetPlayer, "dbid")
		if (exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
			if vipPlayers[id] then
				local vipType = vipPlayers[id].type
				local remaining = vipPlayers[id].endTick
				local remainingInfo = secondsToTimeDesc(remaining/1000)
	
				return outputChatBox("► #ffffff"..getPlayerName(targetPlayer).." adlı karakterin kalan VIP ["..vipType.."]süresi: "..remainingInfo, thePlayer, 235, 199, 82, true)
			end
			return outputChatBox("► #ffffff"..getPlayerName(targetPlayer).." adlu karakterin VIP üyeliği bulunmamaktadır.", thePlayer, 250, 85, 85, true)
		end
	end

	local charID = getElementData(thePlayer, "dbid")
	if not charID then return false end

	if vipPlayers[charID] then
		local vipType = vipPlayers[charID].type
		local remaining = vipPlayers[charID].endTick
		local remainingInfo = secondsToTimeDesc(remaining/1000)

		outputChatBox("[-] #ffffffKalan VIP ["..vipType.."] süreniz: "..remainingInfo, thePlayer, 235, 199, 82, true)
		outputChatBox("► #ffffffVIP Seviyeniz: "..vipType.."", thePlayer, 230, 118, 245, true)
		outputChatBox("► #ffffffKalan VIP Süreniz: "..remainingInfo, thePlayer, 70, 184, 161, true)
	else
		outputChatBox("► #ffffffVIP sürenizi görebilmek için öncelikle /market'ten VIP satın almalısınız.", thePlayer, 250, 85, 85, true)
	end
end)

function addVIP(targetPlayer, vipRank, days)
	if targetPlayer and vipRank and days then
		local charID = tonumber(getElementData(targetPlayer, "dbid"))
		if not charID then
			return false
		end
		
		local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
		if not isPlayerVIP(charID) then
			local id = SmallestID()
			local success = dbExec(mysql:getConnection(), "INSERT INTO `vipPlayers` (`id`, `char_id`, `karakterIsmi`, `vip_type`, `vip_end_tick`) VALUES ('"..id.."', '"..charID.."', '"..getPlayerName(targetPlayer).."', '"..(vipRank).."', '"..(endTick).."')") or false
			if not success then
				return
			end
			loadVIP(charID)
		else
		
			local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + "..endTick.." WHERE char_id="..charID.." and vip_type="..vipRank.." LIMIT 1")
			if not success then
				return
			end
			
			loadVIP(charID)
		end
	end
end

