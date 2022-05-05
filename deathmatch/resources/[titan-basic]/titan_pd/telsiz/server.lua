local r = 50
local g = 104
local b = 241

function yakaTelsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==1   then -- Kodun Uygulanacağı Fact ID'ı
		
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end
		
		if not (...) then
			outputChatBox("KOMUT: /yt [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[YAKA TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, r, g, b, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("yt", yakaTelsiz, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Telsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==1   then -- Kodun Uygulanacağı Fact ID'ı
		
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
		
		if not (...) then
			outputChatBox("KOMUT: /t [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, r, g, b, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("t", Telsiz, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function yakaTelsiz2(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==23   then -- Kodun Uygulanacağı Fact ID'ı
		
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
				
		if not (...) then
			outputChatBox("KOMUT: /yt [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==23 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[YAKA TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, 51, 82, 213, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("yt", yakaTelsiz2, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Telsiz41(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==23  then -- Kodun Uygulanacağı Fact ID'ı
		
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
				
		
		if not (...) then
			outputChatBox("KOMUT: /t [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==23 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, 75, 200, 854, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("t", Telsiz41, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function yakaTelsiz3(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==2   then -- Kodun Uygulanacağı Fact ID'ı

		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
				
		
		if not (...) then
			outputChatBox("KOMUT: /yt [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Başakşehir Devlet Hastanesi"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==2 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[YAKA TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, 255, 20, 147, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("yt", yakaTelsiz3, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Telsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==2   then -- Kodun Uygulanacağı Fact ID'ı
		
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
				
		
		if not (...) then
			outputChatBox("KOMUT: /t [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Başakşehir Devlet Hastanesi"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==2 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, 75, 200, 854, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("t", Telsiz, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Telsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==3   then -- Kodun Uygulanacağı Fact ID'ı
		
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
				
		
		if not (...) then
			outputChatBox("KOMUT: /t [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Government"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==3 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, 75, 200, 854, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					else
			end
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
addCommandHandler("t", Telsiz, false, false)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function TelsizOp(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        local fact = getElementData(thePlayer, "factionrank")
		if fact > 9 then
        if (logged==1)  then -- Kodun Uygulanacağı Fact ID'ı
		local restrained 	= getElementData(thePlayer, "restrain")
		local death 		= getElementData(thePlayer, "dead")

		if restrained == 1 or death == 1 then 
			exports["titan_infobox"]:addBox(thePlayer, "error", "Kelepçeli veya baygın durumdayken telsizi kullanamazsınız.")
		return end		
		
		
		if not (...) then
			outputChatBox("KOMUT: /t [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
				-- if getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[OPERATOR] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, arrayPlayer, r, g, b, true)
					triggerClientEvent (arrayPlayer, "playRadioSound", getRootElement())
					-- else
						 -- else
			-- outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #ffffffMalesef, Los Santos Police Department üyesi değilsiniz.!", thePlayer, 0, 255, 0, true)
		end
		end
	end
end
end
addCommandHandler("op", TelsizOp, false, false)

