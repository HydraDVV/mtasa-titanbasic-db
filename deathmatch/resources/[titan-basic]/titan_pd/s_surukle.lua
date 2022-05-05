addCommandHandler("surukle",
	function(thePlayer, commandName, targetPlayerNick)
		local logged = getElementData(thePlayer, "loggedin")
	
		if (logged==1) then
			if getElementData(thePlayer, "surukle") then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Aynı anda birden fazla kişi sürükleyemezsiniz!", thePlayer, 255, 0, 0, true)
				return false
			end
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
		
			if (factionType==2) or (factionType == 3) then
				if not (targetPlayerNick) then
					outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
				else
					local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
					if targetPlayer then
						if getElementData(thePlayer, "isleme:durum") or getElementData(thePlayer, "kazma:durum") or getElementData(thePlayer, "tutun:durum") then
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bu durumdayken bu komutu kullanamazsınız.", thePlayer, 255, 0, 0, true)
						return end
							if getElementData(targetPlayer, "isleme:durum") or getElementData(targetPlayer, "kazma:durum") or getElementData(targetPlayer, "tutun:durum") then
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Geçmiş olsun kardeşim, adminlere bildirildin. Kendini zeki zannediyorsun.", thePlayer, 255, 0, 0, true)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Geçmiş olsun kardeşim, adminlere bildirildin. Kendini zeki zannediyorsun.", targetPlayer, 255, 0, 0, true)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 10.000 TL'ne sistem tarafından el konuldu.", targetPlayer, 255, 0, 0, true)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 10.000 TL'ne sistem tarafından el konuldu.", thePlayer, 255, 0, 0, true)
							exports.titan_global:takeMoney(thePlayer, 10000)
							exports.titan_global:takeMoney(targetPlayer, 10000)
							exports.titan_global:sendMessageToAdmins("[BUG UYARI] '" .. getPlayerName(thePlayer) .. "' isimli oyuncu maden mesleğinde, '"..getPlayerName(targetPlayer).."' isimli oyuncuya /surukle yapmaya çalıştı!")
						return end
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						
						if (distance<=10) then
							exports.titan_global:applyAnimation( targetPlayer, "CRACK", "crckidle4", -1, false, false, false)
							attachElements(targetPlayer, thePlayer, 0, 1, 0)
							setElementData(thePlayer, "surukle", targetPlayer)
							setElementFrozen(targetPlayer, true)
							exports.titan_global:sendLocalMeAction(thePlayer, "sağ ve sol eli ile şahsın kelepçesinden tutarak çekiştirir.", false, true)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahsı sürüklemektesiniz. Sürüklemeyi bırakmak için /suruklemeyibirak", thePlayer, 0, 255, 0, true)
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. getPlayerName(thePlayer) .. " isimli şahıs sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
						else
							outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
						end
					end
				end
			end
		end
	end
)

addCommandHandler("suruklemeyibirak",
	function(thePlayer)
		local surukle = getElementData(thePlayer, "surukle")
		if surukle then
			detachElements(surukle, thePlayer)
			setElementFrozen(surukle, false)
			setElementData(thePlayer, "surukle", false)
			local targetPlayerName = getPlayerName(surukle)
			exports.titan_global:sendLocalMeAction(thePlayer, "sağ ve sol elini şahsın kelepçesinden çeker.", false, true)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. targetPlayerName .. " isimli şahsı sürüklemeyi bıraktınız.", thePlayer, 0, 255, 0, true)
			exports.titan_global:removeAnimation(surukle)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. getPlayerName(thePlayer).. " sizi sürüklemeyi bıraktı.", surukle, 0, 255, 0, true)
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Şu anda hiçkimseyi sürüklememektesiniz.", thePlayer, 255, 0, 0, true)
		end
	end
)

addCommandHandler("telsiz",
	function(thePlayer, cmd, ...)
		local playerFaction = getPlayerTeam(thePlayer)
		if playerFaction == getTeamFromName("Istanbul Emniyet Mudurlugu") then
			if exports["titan_items"]:hasItem(thePlayer, 241) then
				if not (...) then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0SÖZDİZİMİ: /" .. cmd .. " [Mesaj]", thePlayer, 255, 0, 0, true)
					return
				end
				local message = table.concat( { ... }, " " )
				if message ~= "" then
					local ranks = getElementData(playerFaction, "ranks")
					local playerRank = getElementData(thePlayer, "factionrank")
					local rutbeValue = ranks[playerRank] or ""
					for _, player in ipairs(getPlayersInTeam(getTeamFromName("Istanbul Emniyet Mudurlugu"))) do
						if player ~= thePlayer then
							outputChatBox("[TELSIZ] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, player, 0, 102, 255, true)
							--exports.titan_global:sendLocalText(player, "[TELSIZ] " .. getPlayerName(player):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { player }, false, true )
						end
					end
					outputChatBox("[TELSIZ] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, thePlayer, 0, 102, 255, true)
					--local _, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[TELSIZ] " .. getPlayerName(thePlayer):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { thePlayer }, false, true )
					--exports.titan_logs:dbLog(source, 9, affectedElements, ( "TELSIZ - " .. getPlayerName(thePlayer) .. " ") ..languagename.." "..message)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Konuşmak için bir telsiziniz yok.", thePlayer, 255, 0, 0, true)
			end
		end
	end
)
addCommandHandler("telsiz",
	function(thePlayer, cmd, ...)
		local playerFaction = getPlayerTeam(thePlayer)
		if playerFaction == getTeamFromName("Los Santos Country Sheriff Department") then
			if exports["titan_items"]:hasItem(thePlayer, 241) then
				if not (...) then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0SÖZDİZİMİ: /" .. cmd .. " [Mesaj]", thePlayer, 255, 0, 0, true)
					return
				end
				local message = table.concat( { ... }, " " )
				if message ~= "" then
					local ranks = getElementData(playerFaction, "ranks")
					local playerRank = getElementData(thePlayer, "factionrank")
					local rutbeValue = ranks[playerRank] or ""
					for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Country Sheriff Department"))) do
						if player ~= thePlayer then
							outputChatBox("[TELSIZ] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, player, 0, 102, 255, true)
							--exports.titan_global:sendLocalText(player, "[TELSIZ] " .. getPlayerName(player):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { player }, false, true )
						end
					end
					outputChatBox("[TELSIZ] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, thePlayer, 0, 102, 255, true)
					--local _, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[TELSIZ] " .. getPlayerName(thePlayer):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { thePlayer }, false, true )
					--exports.titan_logs:dbLog(source, 9, affectedElements, ( "TELSIZ - " .. getPlayerName(thePlayer) .. " ") ..languagename.." "..message)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Konuşmak için bir telsiziniz yok.", thePlayer, 255, 0, 0, true)
			end
		end
	end)
	
addCommandHandler("op",
	function(thePlayer, cmd, ...)
		local playerFaction = getPlayerTeam(thePlayer)
		if playerFaction == getTeamFromName("Istanbul Emniyet Mudurlugu") and getElementData(thePlayer, "factionrank") >= 8 then
				if exports["titan_items"]:hasItem(thePlayer, 241) then
					if not (...) then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0SÖZDİZİMİ: /" .. cmd .. " [Mesaj]", thePlayer, 255, 0, 0, true)
					return
				end
				local message = table.concat( { ... }, " " )
				if message ~= "" then
					local ranks = getElementData(playerFaction, "ranks")
					local playerRank = getElementData(thePlayer, "factionrank")
					local rutbeValue = ranks[playerRank] or ""
					for _, player in ipairs(getPlayersInTeam(getTeamFromName("Istanbul Emniyet Mudurlugu"))) do
						if player ~= thePlayer then
							outputChatBox("[OPERATOR] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, player, 0, 102, 255, true)
							--exports.titan_global:sendLocalText(player, "[OPERATOR] " .. getPlayerName(player):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { player }, false, true )
						end
					end
					outputChatBox("[OPERATOR] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, thePlayer, 0, 102, 255, true)
					--local _, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[TELSIZ] " .. getPlayerName(thePlayer):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { thePlayer }, false, true )
					--exports.titan_logs:dbLog(source, 9, affectedElements, ( "OPERATOR - " .. getPlayerName(thePlayer) .. " ") ..languagename.." "..message)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Konuşmak için bir telsiziniz yok.", thePlayer, 255, 0, 0, true)
			end
		end
	end
)

addCommandHandler("op",
	function(thePlayer, cmd, ...)
		local playerFaction = getPlayerTeam(thePlayer)
		if playerFaction == getTeamFromName("Los Santos Country Sheriff Department") and getElementData(thePlayer, "factionrank") >= 8 then
				if exports["titan_items"]:hasItem(thePlayer, 241) then
					if not (...) then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0SÖZDİZİMİ: /" .. cmd .. " [Mesaj]", thePlayer, 255, 0, 0, true)
					return
				end
				local message = table.concat( { ... }, " " )
				if message ~= "" then
					local ranks = getElementData(playerFaction, "ranks")
					local playerRank = getElementData(thePlayer, "factionrank")
					local rutbeValue = ranks[playerRank] or ""
					for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Country Sheriff Department"))) do
						if player ~= thePlayer then
							outputChatBox("[OPERATOR] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, player, 0, 102, 255, true)
							--exports.titan_global:sendLocalText(player, "[OPERATOR] " .. getPlayerName(player):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { player }, false, true )
						end
					end
					outputChatBox("[OPERATOR] " .. rutbeValue .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. message, thePlayer, 0, 102, 255, true)
					--local _, affectedElements = exports.titan_global:sendLocalText(thePlayer, "[TELSIZ] " .. getPlayerName(thePlayer):gsub("_", " ") .. " Kişisinin Telsizi: " .. message, 0, 102, 255, 10, { thePlayer }, false, true )
					--exports.titan_logs:dbLog(source, 9, affectedElements, ( "OPERATOR - " .. getPlayerName(thePlayer) .. " ") ..languagename.." "..message)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Konuşmak için bir telsiziniz yok.", thePlayer, 255, 0, 0, true)
			end
		end
	end
)