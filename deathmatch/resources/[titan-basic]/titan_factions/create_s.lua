mysql = exports.titan_mysql

local birlikCol = createColSphere(1380.8447265625, -1088.904296875, 27.384355545044, 1.5)
local birlikPickup = createPickup ( 1380.8447265625, -1088.904296875, 27.384355545044, 3, 1314, 1)

function birlikKurTrigger(thePlayer, cmd)
	local playerTeam = getElementData(thePlayer, "faction")
	
	if playerTeam ~= -1 then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFZaten bir birliğiniz var!", thePlayer, 255, 0, 0, true)
		return
	end
	
	if (isElementWithinColShape(thePlayer, birlikCol)) then
		triggerClientEvent(thePlayer,"birlikKurGUI", thePlayer)
	end
end
addCommandHandler("birlikkur", birlikKurTrigger)

local MekanikCol = createColSphere(2072.818359375, -1831.1611328125, 13.546875, 2)
local MekanikPickup = createPickup ( 2072.818359375, -1831.1611328125, 13.546875, 3, 1313, 1)
function MekanikOl(thePlayer, cmd)
	local playerJob = getElementData(thePlayer, "job")
		
	if playerJob == 5 then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFZaten mekanik satın almışsın.", thePlayer, 255, 0, 0, true)
		return
	end
		
	if (isElementWithinColShape(thePlayer, MekanikCol)) then
		if exports.titan_global:takeMoney(thePlayer, 50000) then
			triggerEvent("acceptJob", thePlayer, 5)
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBaşarı ile Mekanik oldun!", thePlayer, 255, 0, 0, true)
		else
			outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9 Mekanik olabilmek için yeterli paraya sahip değilsin. -$50.000", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("mekanikol", MekanikOl)

function birlikSeviyeTrigger(thePlayer, cmd)
	if isElementWithinColShape(thePlayer, birlikCol) then
		local oyuncu_birlik = getPlayerTeam(thePlayer)
		local oyuncu_birlik_isim = getTeamName(oyuncu_birlik)
		local birlik_seviye = getElementData(oyuncu_birlik, "birlik_level")
		local birlikLider = getElementData(thePlayer, "factionleader")
		if birlik_seviye == 6 then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirliğiniz son seviyedir!", thePlayer, 255, 0, 0, true)
			return
		end
	
		if (oyuncu_birlik) and (birlikLider > 0) then
			triggerClientEvent(thePlayer,"birlikSeviyeGUI", thePlayer, oyuncu_birlik_isim, tostring(birlik_seviye))
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFHerhangi bir birliğin lideri değilsiniz!", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("birlikseviye", birlikSeviyeTrigger)

function birlikYardim(thePlayer, cmd)
	if isElementWithinColShape(thePlayer, birlikCol) then
		outputChatBox("------------------------------ [[ Birlik Yardım ]] -------------------------------", thePlayer, 200, 20, 20)
		outputChatBox("-------- [[ Birlik kurmak için /birlikkur", thePlayer, 200, 200, 200)
		outputChatBox("-------- [[ Birlik seviyesini yükseltmek için /birlikseviye", thePlayer, 200, 200, 200)
		outputChatBox("--------------------------------------------------------------------------------------", thePlayer, 200, 20, 20)
	end
end
addCommandHandler("birlikyardim", birlikYardim)

function adminBirlikKur(thePlayer, birlikName, birlikType)
	
	if string.len(birlikName) < 4 then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirlik ismi en az 4 karakterden oluşmalıdır!", thePlayer, 255, 0, 0, true)
		return false
	elseif string.len(birlikName) > 36 then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirlik ismi en fazla 36 karakterden oluşmalıdır!", 255, 0, 0, true)
		return false
	end
	
		factionName = birlikName
		factionType = tonumber(birlikType)
		for index, value in ipairs(getElementsByType("team")) do
			if getElementData(value, "name") == factionName then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMaalesef, birlik ismi kullanımda!", thePlayer, 255, 0, 0, true)
				return false
			end
		end

		
		local theTeam = createTeam(tostring(factionName))
		if theTeam then
			if dbExec(mysql:getConnection(), "INSERT INTO factions SET name='" .. tostring(factionName) .. "', bankbalance='0', type='" .. (factionType) .. "', level='1'") then
				dbQuery(
					function(qh, thePlayer, theTeam, factionName, factionType)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for index, value in ipairs(res) do
								id = value["id"]
								exports.titan_pool:allocateElement(theTeam, id)

								dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 1, faction_id = " .. id .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id = " .. getElementData(thePlayer, "dbid"))
								
								setElementData(thePlayer, "faction", id, true)
								setElementData(theTeam, "type", tonumber(factionType))
								setElementData(theTeam, "id", tonumber(id))
								setElementData(theTeam, "birlik_level", 1)
								setElementData(theTeam, "birlik_onay", 0)
								setElementData(theTeam, "money", 0)
								setElementData(theTeam, "name", factionName)

								setPlayerTeam(thePlayer, theTeam)
								if id > 0 then
									setElementData(thePlayer, "faction", id, true)
									setElementData(thePlayer, "factionrank", 1, true)
									setElementData(thePlayer, "factionphone", nil, true)
									setElementData(thePlayer, "factionleader", 1, true)
									triggerEvent("duty:offduty", thePlayer)
									
									triggerEvent("onPlayerJoinFaction", thePlayer, theTeam)
								end
								
								setElementData(theTeam, "note", "", false)
								setElementData(theTeam, "fnote", "", false)
								setElementData(theTeam, "phone", nil, false)
								setElementData(theTeam, "max_interiors", 20, false, true) --Don't sync at all / Hanz
						
								dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='#1', rank_2='#2', rank_3='#3', rank_4='#4', rank_5='#5', rank_6='#6', rank_7='#7', rank_8='#8', rank_9='#9', rank_10='#10', rank_11='#11', rank_12='#12', rank_13='#13', rank_14='#14', rank_15='#15', rank_16='#16', rank_17='#17', rank_18='#18', rank_19='#19', rank_20='#20',  motd='', note = '' WHERE id='" .. id .. "'")
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFF'" .. factionName .. "' isimli birliğiniz başarıyla oluşturuldu! ID #" .. id .. ".", thePlayer, 0, 255, 0, true)
								setElementData(theTeam, "type", tonumber(factionType))
								setElementData(theTeam, "id", tonumber(id))
								setElementData(theTeam, "money", 0)
									
								local factionRanks = {}
								local factionWages = {}
								for i = 1, 20 do
									factionRanks[i] = "#" .. i
									factionWages[i] = 100
								end
								setElementData(theTeam, "ranks", factionRanks, false)
								setElementData(theTeam, "wages", factionWages, false)
								setElementData(theTeam, "motd", "Birliğe hoş geldiniz.", false)
								setElementData(theTeam, "note", "", false)
								exports.titan_logs:dbLog(thePlayer, 4, theTeam, "MAKE FACTION")
								exports.titan_global:sendMessageToAdmins("AdmWarn: " .. getPlayerName(thePlayer) .. " yeni birlik oluşturdu! (/makefaction) Birlik Ismi: '" .. factionName .. "' Birlik ID #" .. id)
							end
						end
					end,
				{thePlayer, theTeam, factionName, factionType}, mysql:getConnection(), "SELECT * FROM factions WHERE id = LAST_INSERT_ID()")
			else
				destroyElement(theTeam)
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirliğinizi oluştururken bir hata meydana geldi.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFF'" .. tostring(factionName) .. "' isimli birlik zaten var.", thePlayer, 255, 0, 0, true)
		end
end
addEvent("adminBirlikKur", true)
addEventHandler("adminBirlikKur", getRootElement(), adminBirlikKur)

function birlikKur(thePlayer, birlikName, birlikType)
	local para = exports.titan_global:getMoney(thePlayer)	
	
	if string.len(birlikName) < 4 then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirlik ismi en az 4 karakterden oluşmalıdır!", thePlayer, 255, 0, 0, true)
		return false
	elseif string.len(birlikName) > 36 then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirlik ismi en fazla 36 karakterden oluşmalıdır!", 255, 0, 0, true)
		return false
	end
	
	if para >= 10000 then
		factionName = birlikName
		factionType = tonumber(birlikType)
		for index, value in ipairs(getElementsByType("team")) do
			if getElementData(value, "name") == factionName then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMaalesef, birlik ismi kullanımda!", thePlayer, 255, 0, 0, true)
				return false
			end
		end

		
		local theTeam = createTeam(tostring(factionName))
		if theTeam then
			if dbExec(mysql:getConnection(), "INSERT INTO factions SET name='" .. tostring(factionName) .. "', bankbalance='0', type='" .. (factionType) .. "', level='1'") then
				dbQuery(
					function(qh, thePlayer, theTeam, factionName, factionType)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for index, value in ipairs(res) do
								id = value["id"]
								exports.titan_pool:allocateElement(theTeam, id)

								dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 1, faction_id = " .. id .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id = " .. getElementData(thePlayer, "dbid"))
								
								setElementData(thePlayer, "faction", id, true)
								setElementData(theTeam, "type", tonumber(factionType))
								setElementData(theTeam, "id", tonumber(id))
								setElementData(theTeam, "birlik_level", 1)
								setElementData(theTeam, "birlik_onay", 0)
								setElementData(theTeam, "money", 0)
								setElementData(theTeam, "name", factionName)

								setPlayerTeam(thePlayer, theTeam)
								if id > 0 then
									setElementData(thePlayer, "faction", id, true)
									setElementData(thePlayer, "factionrank", 1, true)
									setElementData(thePlayer, "factionphone", nil, true)
									setElementData(thePlayer, "factionleader", 1, true)
									triggerEvent("duty:offduty", thePlayer)
									
									triggerEvent("onPlayerJoinFaction", thePlayer, theTeam)
								end
								
								setElementData(theTeam, "note", "", false)
								setElementData(theTeam, "fnote", "", false)
								setElementData(theTeam, "phone", nil, false)
								setElementData(theTeam, "max_interiors", 20, false, true) --Don't sync at all / Hanz
						
								dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='#1', rank_2='#2', rank_3='#3', rank_4='#4', rank_5='#5', rank_6='#6', rank_7='#7', rank_8='#8', rank_9='#9', rank_10='#10', rank_11='#11', rank_12='#12', rank_13='#13', rank_14='#14', rank_15='#15', rank_16='#16', rank_17='#17', rank_18='#18', rank_19='#19', rank_20='#20',  motd='', note = '' WHERE id='" .. id .. "'")
								outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFF'" .. factionName .. "' isimli birliğiniz başarıyla oluşturuldu! ID #" .. id .. ".", thePlayer, 0, 255, 0, true)
								setElementData(theTeam, "type", tonumber(factionType))
								setElementData(theTeam, "id", tonumber(id))
								setElementData(theTeam, "money", 0)
									
								local factionRanks = {}
								local factionWages = {}
								for i = 1, 20 do
									factionRanks[i] = "#" .. i
									factionWages[i] = 100
								end
								setElementData(theTeam, "ranks", factionRanks, false)
								setElementData(theTeam, "wages", factionWages, false)
								setElementData(theTeam, "motd", "Birliğe hoş geldiniz.", false)
								setElementData(theTeam, "note", "", false)
								exports.titan_logs:dbLog(thePlayer, 4, theTeam, "MAKE FACTION")
								exports.titan_global:takeMoney(thePlayer, 10000)
								exports.titan_global:sendMessageToAdmins("AdmWarn: " .. getPlayerName(thePlayer) .. " yeni birlik oluşturdu! Birlik Ismi: '" .. factionName .. "' Birlik ID #" .. id)
							end
						end
					end,
				{thePlayer, theTeam, factionName, factionType}, mysql:getConnection(), "SELECT * FROM factions WHERE id = LAST_INSERT_ID()")
			else
				destroyElement(theTeam)
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirliğinizi oluştururken bir hata meydana geldi.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFF'" .. tostring(factionName) .. "' isimli birlik zaten var.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFMaalesef, birlik kuracak paranız yok.", thePlayer, 255, 0, 0, true)
	end
end
addEvent("birlikKur", true)
addEventHandler("birlikKur", getRootElement(), birlikKur)

function birlikSeviye(thePlayer, birlikIsmi, birlikSeviye, birlikFiyat)
	local para = exports.titan_global:getMoney(thePlayer)
	if para >= birlikFiyat then
		if birlikIsmi and birlikSeviye then
			local theTeam = getTeamFromName(birlikIsmi)
			local birlikLevelArttir = setElementData(theTeam, "birlik_level", birlikSeviye, false)
			local result = dbExec(mysql:getConnection(),"UPDATE factions SET level='" .. birlikSeviye .. "' WHERE name='" .. birlikIsmi .. "'")
			if not result then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirliğinizin seviyesini arttırırken bir hata meydana geldi.", thePlayer, 255, 0, 0, true)
			end
			
			if result and birlikLevelArttir then
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFBirliğinizin seviyesi başarıyla arttırılmıştır!", thePlayer, 0, 255, 0, true)
				exports.titan_global:takeMoney(thePlayer, birlikFiyat)
			end
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFYeterli paranız yok.", thePlayer, 255, 0, 0, true)
	end
end
addEvent("birlikSeviye", true)
addEventHandler("birlikSeviye", getRootElement(), birlikSeviye)

function aracimiBirligeVer(thePlayer, cmd, vehID)
	if vehID then
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.titan_pool:getElement("vehicle", vehID)
		local vehOwner = getElementData(vehElement, "owner")
		local vehFaction = getElementData(vehElement, "faction")
		if vehFaction == -1 then
			if vehOwner == playerID then
				local playerBirlik = getElementData(thePlayer, "faction")
				if playerBirlik then
					local elementSet = setElementData(vehElement, "faction", playerBirlik)
					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET faction='" .. playerBirlik .. "', loadstate='1' WHERE id='" .. vehID .. "'")
					if elementSet and query then
						exports["titan_items"]:deleteAll(3, vehID)
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Aracınız başarıyla birliğe verilmiştir!", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Bir birlikte değilsiniz.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Araç size ait değil.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Araç zaten bir birliğe ait.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0/"..cmd.." [Araç ID]", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("abv", aracimiBirligeVer)
addCommandHandler("aracimibirligever", aracimiBirligeVer)

function aracimiBirlikGeriVer(thePlayer, cmd, vehID)
	if vehID then
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.titan_pool:getElement("vehicle", vehID)
		local vehOwner = getElementData(vehElement, "owner")
		local vehFaction = getElementData(vehElement, "faction")
		local factionLeader = getElementData(thePlayer, "factionleader")
		local playerBirlik = getElementData(thePlayer, "faction")
		if playerBirlik then
			if playerBirlik == vehFaction then
				if factionLeader == 1 then
					local elementSet = setElementData(vehElement, "faction", -1)
					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET faction='-1', loadstate='0' WHERE id='" .. vehID .. "'")
					if elementSet and query then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Aracınız başarıyla sahibine geri verilmiştir!", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Aracı sahibine geri verebilmek için birlik lideri olmalısınız.", thePlayer, 255, 0, 0, true)
				end
			end
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Bir birlikte değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0/"..cmd.." [Araç ID]", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("abg", aracimiBirlikGeriVer)
addCommandHandler("aracisahibinever", aracimiBirlikGeriVer)

function aracBirlikYonetim(thePlayer, cmd, vehID, rankID)
	if not (vehID or rankID) then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0/"..cmd.." [Araç ID] [Rank ID]", thePlayer, 255, 0, 0, true)
	else
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.titan_pool:getElement("vehicle", vehID)
		local vehOwner = getElementData(vehElement, "owner")
		local vehFaction = getElementData(vehElement, "faction")
		local vehFactRank = getElementData(vehElement, "factionrank")
		local factionLeader = getElementData(thePlayer, "factionleader")
		local playerBirlik = getElementData(thePlayer, "faction")
		if playerBirlik then
			if playerBirlik == vehFaction then
				if factionLeader == 1 then
					local elementSet = setElementData(vehElement, "factionrank", rankID)
					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET factionrank='" .. rankID .. "' WHERE id='" .. vehID .. "'")
					if elementSet and query then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Araç başarıyla ayarlanmıştır!", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Aracı yönetebilmek için birlik lideri olmalısınız.", thePlayer, 255, 0, 0, true)
				end
			end
		else
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Bir birlikte değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("aby", aracBirlikYonetim)
addCommandHandler("aracbirlikyonetim", aracBirlikYonetim)