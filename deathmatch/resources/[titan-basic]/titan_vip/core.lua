
local mysql = exports.titan_mysql
vipPlayers = {}

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadVIP(row.char_id)
				end
			end
		end,
	mysql:getConnection(), "SELECT `char_id` FROM `vipPlayers`")
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in pairs(getElementsByType("player")) do
		local charID = tonumber(getElementData(player, "dbid"))
		if charID then
			saveVIP(charID)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local charID = getElementData(source, "dbid")
	if not charID then return false end
	saveVIP(charID)
end)

function loadVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local vipType = tonumber(row["vip_type"]) or 0
					local endTick = tonumber(row["vip_end_tick"]) or 0
					if vipType > 0 then
						vipPlayers[charID] = {}
						vipPlayers[charID].type = vipType
						vipPlayers[charID].endTick = endTick
						local targetPlayer = exports.titan_global:getPlayerFromCharacterID(charID)
						if targetPlayer then
							setElementData(targetPlayer, "vipver", vipType)
						end
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `vip_type`, `vip_end_tick` FROM `vipPlayers` WHERE char_id='"..charID.."'")
end

function saveVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	if not vipPlayers[charID] then return false end
	
	local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick='"..(vipPlayers[charID].endTick).."' WHERE char_id="..charID.." LIMIT 1")
	if not success then
		return
	end
end

function removeVIP(charID)
	if not vipPlayers[charID] then return false end	
	local query = dbExec(mysql:getConnection(), "DELETE FROM `vipPlayers` WHERE char_id="..charID.." LIMIT 1")
	if query then
		local targetPlayer = exports.titan_global:getPlayerFromCharacterID(charID)
		if targetPlayer then
			setElementData(targetPlayer, "vipver", 0)
			outputChatBox("[-] #ffffffVIP süreniz sona erdi. Yeni VIP satın almak için ( /market )", targetPlayer, 255, 109, 51, true)
		end
		vipPlayers[charID] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for charID, data in pairs(vipPlayers) do
		if (charID and data) then
			if vipPlayers[charID] then
				if vipPlayers[charID].endTick and vipPlayers[charID].endTick <= 0 then

					local success = removeVIP(charID)
					if success then
					end

				elseif vipPlayers[charID].endTick and vipPlayers[charID].endTick > 0 then

					vipPlayers[charID].endTick = math.max(vipPlayers[charID].endTick - (60 * 1000), 0)
					saveVIP(charID)
					
					if vipPlayers[charID].endTick == 0 then
						local success = removeVIP(charID)
						if success then
						end
					end

				end
			end
		end
	end
end
setTimer(checkExpireTime, 60 * 1000, 0)


addCommandHandler("pm",
function(thePlayer,cmd,durum)

	local vip = getElementData(thePlayer,"vipver")

    if durum=="yardim" then
        outputChatBox("#f5d142[-] #f1f1f1/pmd on yazarak Private Message durumunuzu aktif edebilirsiniz.", thePlayer, 255, 126, 0, true)
        outputChatBox("#f5d142[-] #f1f1f1/pmd off yazarak Private Message durumunuzu aktif edebilirsiniz.", thePlayer, 255, 126, 0, true)       
	end

	
	local acik = 0
	local kapat = 1
	
	if durum == "on" then
		if (vip>0) or exports.titan_global:isStaffOnDuty(thePlayer) then
			outputChatBox("[►]#f9f9f9 Artık oyunculardan mesaj alabileceksiniz.", thePlayer, 0, 255, 0,true)
			setElementData(thePlayer, "PMDurumuVIP", tonumber(acik))
			dbExec(mysql:getConnection(), "UPDATE `characters` SET `PMDurumuVIP`="..(acik).." WHERE `id`='"..(getElementData(thePlayer, "dbid")).."'")
		else
			outputChatBox("#f5425d[x] #f1f1f1Bu komutu kullanabilmek için VIP 1 ve üstü satın almalısınız.", thePlayer, 255, 126, 0, true)
		end
	end
	if durum == "off" then
		if (vip>0) or exports.titan_global:isStaffOnDuty(thePlayer) then
			outputChatBox("[►]#f9f9f9 Artık oyunculardan mesaj alamayacaksınız.", thePlayer, 255, 0, 0,true)
			setElementData(thePlayer, "PMDurumuVIP", tonumber(kapat))
			dbExec(mysql:getConnection(), "UPDATE `characters` SET `PMDurumuVIP`="..(kapat).." WHERE `id`='"..(getElementData(thePlayer, "dbid")).."'")
		else
			outputChatBox("#f5425d[x] #f1f1f1Bu komutu kullanabilmek için VIP 1 ve üstü satın almalısınız.", thePlayer, 255, 126, 0, true)
		end
	end
end)

